//
//  PlaylistHomeOnlineCollectionViewLayout.swift
//  MusicApp
//
//  Created by HungDo on 9/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

protocol PlaylistHomeOnlineCollectionViewLayoutDelegate {
    
    func itemSizeForCollectionView(collectionView: UICollectionView) -> CGFloat
    func itemPaddingForCollectionView(collectionView: UICollectionView) -> CGFloat
    
}

class PlaylistHomeOnlineCollectionViewLayout: UICollectionViewLayout {
    
    var delegate: PlaylistHomeOnlineCollectionViewLayoutDelegate?
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        guard cache.isEmpty else { return }
        guard let collectionView = collectionView else { return }
        guard collectionView.numberOfItemsInSection(0) == 6 else { return }
        
        guard let itemSize = self.delegate?.itemSizeForCollectionView(collectionView) else { return }
        guard let itemPadding = self.delegate?.itemPaddingForCollectionView(collectionView) else { return }
        
        let bigLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        bigLayoutAttributes.frame = CGRect(x: itemPadding, y: 0, width: 2 * itemSize + itemPadding, height: 2 * itemSize + itemPadding)
        cache.append(bigLayoutAttributes)
        
        for item in 1 ... 2 {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: item, inSection: 0))
            layoutAttributes.frame = CGRect(
                x: 2 * itemSize + 3 * itemPadding,
                y: CGFloat(item - 1) * (itemSize + itemPadding),
                width: itemSize,
                height: itemSize
            )
            cache.append(layoutAttributes)
        }
        
        for item in 3 ... 5 {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: item, inSection: 0))
            layoutAttributes.frame = CGRect(
                x: itemPadding + CGFloat(item - 3) * (itemSize + itemPadding),
                y: 2 * (itemSize + itemPadding),
                width: itemSize,
                height: itemSize
            )
            cache.append(layoutAttributes)
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        guard let collectionView = collectionView else { return CGSizeZero }
        guard let itemSize = self.delegate?.itemSizeForCollectionView(collectionView) else { return CGSizeZero }
        guard let itemPadding = self.delegate?.itemPaddingForCollectionView(collectionView) else { return CGSizeZero }
        
        return CGSize(
            width: 3 * itemSize + 4 * itemPadding,
            height: 3 * itemSize + 2 * itemPadding
        )
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = cache.filter { $0.frame.intersects(rect) }
        return layoutAttributes.isEmpty ? nil : layoutAttributes
    }

}
