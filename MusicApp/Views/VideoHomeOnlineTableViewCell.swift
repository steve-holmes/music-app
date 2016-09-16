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
        
        collectionView.backgroundColor = ColorConstants.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.addConstraint(NSLayoutConstraint(
            item: collectionView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: (layout?.itemSize.height ?? 0) * 2
        ))
    }
    
    fileprivate let itemPadding: CGFloat = 8
    fileprivate let itemRatio: CGFloat = 1

}

extension VideoHomeOnlineTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifier.videoHomeOnlineCollection, for: indexPath)
        
        if let videoCell = cell as? VideoHomeOnlineCollectionViewCell {
            videoCell.videoName = "Gui Anh Xa Nho"
            videoCell.singerName = "Bich Phuong"
            videoCell.videoImage = UIImage(named: "background")
        }
        
        return cell
    }
    
}

extension VideoHomeOnlineTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.size.width - itemPadding * 3) / 2
        let itemHeight = itemRatio * itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
}
