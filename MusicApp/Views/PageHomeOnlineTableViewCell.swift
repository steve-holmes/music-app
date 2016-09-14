//
//  PageHomeOnlineTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 8/29/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class PageHomeOnlineTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(pageCollectionView)
        contentView.addSubview(pageControl)
        
        setupConstraints()
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
    }

    fileprivate var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.isPagingEnabled = true
        
        collectionView.register(PageHomeOnlineCollectionViewCell.self, forCellWithReuseIdentifier: CellsIdentifier.PageHomeOnlineCollectionCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    fileprivate var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    fileprivate func setupConstraints() {
        setupConstraintsForPageCollectionView()
        setupConstraintsForPageControl()
    }
    
    fileprivate func setupConstraintsForPageCollectionView() {
        let heightConstraint = NSLayoutConstraint(
            item: pageCollectionView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 150
        )
        
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(8)-[pageCollectionView]-(8)-|",
            options: [],
            metrics: nil,
            views: ["pageCollectionView": pageCollectionView]
        )
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[pageCollectionView]|",
            options: [],
            metrics: nil,
            views: ["pageCollectionView": pageCollectionView]
        )
        
        pageCollectionView.addConstraint(heightConstraint)
        contentView.addConstraints(horizontalConstraints)
        contentView.addConstraints(verticalConstraints)
    }
    
    fileprivate func setupConstraintsForPageControl() {
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[pageControl]|",
            options: [],
            metrics: nil,
            views: ["pageControl": pageControl]
        )
        
        let bottomConstraint = NSLayoutConstraint(
            item: pageControl,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        
        let heightConstraint = NSLayoutConstraint(
            item: pageControl,
            attribute: .height,
            relatedBy: .equal,
            toItem: pageCollectionView,
            attribute: .height,
            multiplier: 1/3,
            constant: 0
        )
        
        contentView.addConstraints(horizontalConstraints)
        contentView.addConstraints([bottomConstraint, heightConstraint])
    }

}

extension PageHomeOnlineTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifier.PageHomeOnlineCollectionCell, for: indexPath)
        
        if let pageCell = cell as? PageHomeOnlineCollectionViewCell {
            pageCell.image = UIImage(named: "background")
        }
        
        return cell
    }
    
}

extension PageHomeOnlineTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension PageHomeOnlineTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === pageCollectionView else { return }
        
        let offsetX = scrollView.contentOffset.x
        pageControl.currentPage = Int(offsetX / pageCollectionView.bounds.size.width)
    }
    
}
