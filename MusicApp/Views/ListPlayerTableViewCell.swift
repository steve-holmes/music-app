//
//  ListPlayerTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 8/21/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

protocol ListPlayerTableViewCellDelegate: class {
    
    
    
}

class ListPlayerTableViewCell: UITableViewCell {
    
    // MARK: Delegation
    
    weak var delegate: ListPlayerTableViewCellDelegate?

    // MARK: Table View Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
