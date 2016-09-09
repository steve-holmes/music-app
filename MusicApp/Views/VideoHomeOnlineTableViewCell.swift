//
//  VideoHomeOnlineTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 8/29/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class VideoHomeOnlineTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 0, left: itemPadding, bottom: 0, right: itemPadding)
        
        collectionView.backgroundColor = ColorConstants.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.addConstraint(NSLayoutConstraint(
            item: collectionView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Height,
            multiplier: 1,
            constant: (layout?.itemSize.height ?? 0) * 2
        ))
    }
    
    private let itemPadding: CGFloat = 8
    private let itemRatio: CGFloat = 1

}

extension VideoHomeOnlineTableViewCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellsIdentifier.VideoHomeOnlineCollectionCell, forIndexPath: indexPath)
        
        if let videoCell = cell as? VideoHomeOnlineCollectionViewCell {
            videoCell.videoName = "Gui Anh Xa Nho"
            videoCell.singerName = "Bich Phuong"
            videoCell.videoImage = UIImage(named: "background")
        }
        
        return cell
    }
    
}

extension VideoHomeOnlineTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.size.width - itemPadding * 3) / 2
        let itemHeight = itemRatio * itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemPadding
    }
    
}