//
//  RankOnlineTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class RankOnlineTableViewCell: UITableViewCell {

    @IBOutlet private weak var rankTitle: UILabel!
    @IBOutlet private weak var rankImageView: UIImageView!
    @IBOutlet private weak var firstRankItemLabel: UILabel!
    @IBOutlet private weak var secondRankItemLabel: UILabel!
    @IBOutlet private weak var thirdRankItemLabel: UILabel!
    @IBOutlet private weak var fourRankItemLabel: UILabel!
    
    @IBOutlet private weak var firstBadgetView: UIView!
    @IBOutlet private weak var secondBadgetView: UIView!
    @IBOutlet private weak var thirdBadgetView: UIView!
    @IBOutlet private weak var fourBadgetView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBadgets()
    }
    
    private func setupBadgets() {
        
        func setupBadget(badget: UIView) {
            badget.layer.cornerRadius = 5
        }
        
        setupBadget(firstBadgetView)
        setupBadget(secondBadgetView)
        setupBadget(thirdBadgetView)
        setupBadget(fourBadgetView)
    }

}
