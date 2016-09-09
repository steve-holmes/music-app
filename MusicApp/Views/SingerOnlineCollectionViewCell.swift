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
    
    @IBOutlet private weak var singerImageView: UIImageView!
    @IBOutlet private weak var singerNameLabel: UILabel!
    
}
