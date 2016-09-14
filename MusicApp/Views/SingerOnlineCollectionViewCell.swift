//
//  SingerOnlineCollectionViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class SingerOnlineCollectionViewCell: UICollectionViewCell {
    
    var singerImage: UIImage? { didSet { singerImageView.image = singerImage } }
    var singerName: String? { didSet { singerNameLabel.text = singerName } }
    
    @IBOutlet fileprivate weak var singerImageView: UIImageView!
    @IBOutlet fileprivate weak var singerNameLabel: UILabel!
    
}
