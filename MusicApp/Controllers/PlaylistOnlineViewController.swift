//
//  PlaylistOnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class PlaylistOnlineViewController: OnlineChildViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = ColorConstants.background
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate let itemPadding: CGFloat = 8
    fileprivate let itemRatio: CGFloat = 11 / 9 // height = ratio * width

}

extension PlaylistOnlineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifier.playlistOnlineCollection, for: indexPath)
        
        if let playlistCell = cell as? PlaylistOnlineCollectionViewCell {
            playlistCell.playlistImage = UIImage(named: "background")
            playlistCell.playlistName = "Gui Anh Xa Nho"
            playlistCell.singerName = "Bich Phuong"
        }
        
        return cell
    }
    
}

extension PlaylistOnlineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 3 * itemPadding) / 2
        let height = width * itemRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
}
