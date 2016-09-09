//
//  SingerOnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class SingerOnlineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = ColorConstants.backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private let itemPadding: CGFloat = 8
    private let itemRatio: CGFloat = 7 / 5 // height = ratio * width

}

extension SingerOnlineViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellsIdentifier.SingerOnlineCollectionCell, forIndexPath: indexPath)
        
        if let singerCell = cell as? SingerOnlineCollectionViewCell {
            singerCell.singerImage = UIImage(named: "background")
            singerCell.singerName = "Bich Phuong"
        }
        
        return cell
    }
    
}

extension SingerOnlineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 4 * itemPadding) / 3
        let height = width * itemRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemPadding
    }
    
}
