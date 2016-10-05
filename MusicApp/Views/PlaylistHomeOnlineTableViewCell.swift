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
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = collectionView.collectionViewLayout as? PlaylistHomeOnlineCollectionViewLayout
        layout?.delegate = self
        
        self.update(width: ScreenSize.screenWidth)
        
        collectionView.backgroundColor = ColorConstants.background
        collectionView.dataSource = self
    }
    
    func update() {
        update(width: collectionView.bounds.size.width)
    }
    
    private func update(width: CGFloat) {
        if collectionViewHeightConstraint != nil {
            collectionView.removeConstraint(collectionViewHeightConstraint)
        }
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: width - itemPadding * 2)
        collectionView.addConstraint(collectionViewHeightConstraint)
    }
    
    let itemPadding: CGFloat = 8

}

extension PlaylistHomeOnlineTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifier.playlistHomeOnlineCollection, for: indexPath)
        
        if indexPath.item == 0 {
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
