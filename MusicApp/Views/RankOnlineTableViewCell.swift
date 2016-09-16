//
//  RankOnlineTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class RankOnlineTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var rankTitle: UILabel!
    @IBOutlet fileprivate weak var rankImageView: UIImageView!
    @IBOutlet fileprivate weak var firstRankItemLabel: UILabel!
    @IBOutlet fileprivate weak var secondRankItemLabel: UILabel!
    @IBOutlet fileprivate weak var thirdRankItemLabel: UILabel!
    @IBOutlet fileprivate weak var fourRankItemLabel: UILabel!
    
    @IBOutlet fileprivate weak var firstBadgetView: UIView!
    @IBOutlet fileprivate weak var secondBadgetView: UIView!
    @IBOutlet fileprivate weak var thirdBadgetView: UIView!
    @IBOutlet fileprivate weak var fourBadgetView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBadgets()
    }
    
    fileprivate func setupBadgets() {
        
        func setup(badget: UIView) {
            badget.layer.cornerRadius = 5
        }
        
        setup(badget: firstBadgetView)
        setup(badget: secondBadgetView)
        setup(badget: thirdBadgetView)
        setup(badget: fourBadgetView)
    }

}
