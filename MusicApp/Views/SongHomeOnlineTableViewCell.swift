//
//  SongHomeOnlineTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 8/29/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class SongHomeOnlineTableViewCell: UITableViewCell {
    
    // MARK: Models
    
    var songName: String? {
        didSet {
            songNameLabel.text = songName
        }
    }
    var singerName: String? {
        didSet {
            singerNameLabel.text = singerName
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var headsetImageView: UIImageView!
    @IBOutlet weak var numberOfListeningLabel: UILabel!
    
    // MARK: UITableViewCell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let image = headsetImageView.image?.imageWithColor(UIColor(white: 128/255, alpha: 1))
        headsetImageView.image = image
    }

}
