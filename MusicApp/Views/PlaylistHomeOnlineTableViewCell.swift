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
        
        collectionView.backgroundColor = ColorConstants.background
        
        let itemSize = (collectionView.bounds.size.width - itemPadding * 4) / 3
        let height = itemSize * 3 + itemPadding * 2
        
        collectionView.addConstraint(NSLayoutConstraint(
            item: collectionView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: height
        ))
        
        collectionView.dataSource = self
    }
    
    fileprivate let itemPadding: CGFloat = 8

}

extension PlaylistHomeOnlineTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifier.playlistHomeOnlineCollection, for: indexPath)
        
        if (indexPath as NSIndexPath).item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifier.morePlaylistHomeOnlineCollection, for: indexPath)
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
    
    func itemSizeForCollectionView(_ collectionView: UICollectionView) -> CGFloat {
        return (self.collectionView.bounds.size.width - 4 * self.itemPadding) / 3
    }
    
    func itemPaddingForCollectionView(_ collectionView: UICollectionView) -> CGFloat {
        return self.itemPadding
    }
    
}
