//
//  PlaylistHomeOnlineTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 8/29/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class PlaylistHomeOnlineTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = collectionView.collectionViewLayout as? PlaylistHomeOnlineCollectionViewLayout
        layout?.delegate = self
        
        collectionView.backgroundColor = ColorConstants.backgroundColor
        
        let itemSize = (collectionView.bounds.size.width - itemPadding * 4) / 3
        let height = itemSize * 3 + itemPadding * 2
        
        collectionView.addConstraint(NSLayoutConstraint(
            item: collectionView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Height,
            multiplier: 1,
            constant: height
        ))
        
        collectionView.dataSource = self
    }
    
    private let itemPadding: CGFloat = 8

}

extension PlaylistHomeOnlineTableViewCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellsIdentifier.PlaylistHomeOnlineCollectionCell, forIndexPath: indexPath)
        
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellsIdentifier.MorePlaylistHomeOnlineCollectionCell, forIndexPath: indexPath)
        }
        
        if let playlistCell = cell as? PlaylistHomeOnlineCollectionViewCell {
            playlistCell.playlistName = "Gui Anh Xa Nho"
            playlistCell.singerName = "Bich Phuong"
            playlistCell.playlistImage = UIImage(named: "background")
        }
        
        return cell
    }
    
}

extension PlaylistHomeOnlineTableViewCell: PlaylistHomeOnlineCollectionViewLayoutDelegate {
    
    func itemSizeForCollectionView(collectionView: UICollectionView) -> CGFloat {
        return (self.collectionView.bounds.size.width - 4 * self.itemPadding) / 3
    }
    
    func itemPaddingForCollectionView(collectionView: UICollectionView) -> CGFloat {
        return self.itemPadding
    }
    
}