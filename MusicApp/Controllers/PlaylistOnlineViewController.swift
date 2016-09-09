//
//  PlaylistOnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class PlaylistOnlineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = ColorConstants.backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private let itemPadding: CGFloat = 8
    private let itemRatio: CGFloat = 11 / 9 // height = ratio * width

}

extension PlaylistOnlineViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellsIdentifier.PlaylistOnlineCollectionCell, forIndexPath: indexPath)
        
        if let playlistCell = cell as? PlaylistOnlineCollectionViewCell {
            playlistCell.playlistImage = UIImage(named: "background")
            playlistCell.playlistName = "Gui Anh Xa Nho"
            playlistCell.singerName = "Bich Phuong"
        }
        
        return cell
    }
    
}

extension PlaylistOnlineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 3 * itemPadding) / 2
        let height = width * itemRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemPadding
    }
    
}