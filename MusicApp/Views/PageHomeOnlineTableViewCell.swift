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

    private var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .Horizontal
        collectionViewLayout.sectionInset = UIEdgeInsetsZero
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsetsZero
        collectionView.pagingEnabled = true
        
        collectionView.registerClass(PageHomeOnlineCollectionViewCell.self, forCellWithReuseIdentifier: CellsIdentifier.PageHomeOnlineCollectionCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private func setupConstraints() {
        setupConstraintsForPageCollectionView()
        setupConstraintsForPageControl()
    }
    
    private func setupConstraintsForPageCollectionView() {
        let heightConstraint = NSLayoutConstraint(
            item: pageCollectionView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Height,
            multiplier: 1,
            constant: 150
        )
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(8)-[pageCollectionView]-(8)-|",
            options: [],
            metrics: nil,
            views: ["pageCollectionView": pageCollectionView]
        )
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[pageCollectionView]|",
            options: [],
            metrics: nil,
            views: ["pageCollectionView": pageCollectionView]
        )
        
        pageCollectionView.addConstraint(heightConstraint)
        contentView.addConstraints(horizontalConstraints)
        contentView.addConstraints(verticalConstraints)
    }
    
    private func setupConstraintsForPageControl() {
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[pageControl]|",
            options: [],
            metrics: nil,
            views: ["pageControl": pageControl]
        )
        
        let bottomConstraint = NSLayoutConstraint(
            item: pageControl,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0
        )
        
        let heightConstraint = NSLayoutConstraint(
            item: pageControl,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: pageCollectionView,
            attribute: .Height,
            multiplier: 1/3,
            constant: 0
        )
        
        contentView.addConstraints(horizontalConstraints)
        contentView.addConstraints([bottomConstraint, heightConstraint])
    }

}

extension PageHomeOnlineTableViewCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellsIdentifier.PageHomeOnlineCollectionCell, forIndexPath: indexPath)
        
        if let pageCell = cell as? PageHomeOnlineCollectionViewCell {
            pageCell.image = UIImage(named: "background")
        }
        
        return cell
    }
    
}

extension PageHomeOnlineTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}

extension PageHomeOnlineTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard scrollView === pageCollectionView else { return }
        
        let offsetX = scrollView.contentOffset.x
        pageControl.currentPage = Int(offsetX / pageCollectionView.bounds.size.width)
    }
    
}
