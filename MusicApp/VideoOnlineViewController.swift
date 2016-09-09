//
//  VideoOnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 9/8/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class VideoOnlineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = ColorConstants.backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private let itemPadding: CGFloat = 10
    private let itemRatioRate: CGFloat = 4 / 7 // height = ratio * width

}

extension VideoOnlineViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellsIdentifier.VideoOnlineCollectionCell, forIndexPath: indexPath)
        
        if let videoCell = cell as? VideoOnlineCollectionViewCell {
            videoCell.videoName = "Gui Anh Xa Nho"
            videoCell.singerName = "Bich Phuong"
            videoCell.numberOfListening = 500
            videoCell.duration = 300
            videoCell.videoImage = UIImage(named: "background")
        }
        
        return cell
    }
    
}

extension VideoOnlineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.size.width - 2 * itemPadding
        let itemHeight = itemRatioRate * itemWidth
        return CGSize(width: itemWidth,  height: itemHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: itemPadding)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: itemPadding)
    }
    
}