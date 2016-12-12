//
//  PlaylistOnlineCollectionViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class PlaylistOnlineCollectionViewCell: UICollectionViewCell {
    
    var playlistImage: UIImage? { didSet { playlistImageView.image = playlistImage } }
    var playlistName: String? { didSet { playlistNameLabel.text = playlistName } }
    var singerName: String? { didSet { singerNameLabel.text = singerName } }
    var numberOfListening: Int? { didSet { numberOfListeningLabel.text = "\(numberOfListening ?? 0)" } }
    
    @IBOutlet fileprivate weak var playlistImageView: UIImageView!
    @IBOutlet fileprivate weak var playlistNameLabel: UILabel!
    @IBOutlet fileprivate weak var singerNameLabel: UILabel!
    @IBOutlet fileprivate weak var numberOfListeningLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = ScreenSize.borderRadius
        self.clipsToBounds = true
    }
    
}
