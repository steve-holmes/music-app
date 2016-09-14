//
//  PlaylistHomeOnlineCollectionViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/8/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class PlaylistHomeOnlineCollectionViewCell: UICollectionViewCell {
    
    var playlistImage: UIImage? { didSet { playlistImageView.image = playlistImage } }
    var playlistName: String? { didSet { playListNameLabel.text = playlistName } }
    var singerName: String? { didSet { singerNameLabel.text = singerName } }
    var numberOfListening: Int? { didSet { numberOfListeningLabel.text = "\(numberOfListening ?? 0)" } }
    
    @IBOutlet fileprivate weak var playlistImageView: UIImageView!
    @IBOutlet fileprivate weak var playListNameLabel: UILabel!
    @IBOutlet fileprivate weak var singerNameLabel: UILabel!
    @IBOutlet fileprivate weak var numberOfListeningLabel: UILabel!
    
}
