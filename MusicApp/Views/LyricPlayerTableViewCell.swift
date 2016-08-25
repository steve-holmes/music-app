//
//  LyricPlayerTableViewCell.swift
//  MusicApp
//
//  Created by HungDo on 8/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

// MARK: Enum LyricPlayerFontStyle

enum LyricPlayerFontStyle {
    case Bold
    case Regular
    case Other // never use
}

// MARK: Procotol LyricPlayerTableViewCellDelegate

protocol LyricPlayerTableViewCellDelegate {
    
    func lyricPlayerCell(lyricCell: LyricPlayerTableViewCell, didSelectLyricFontStyle lyricFontStyle: LyricPlayerFontStyle)
    
}

class LyricPlayerTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var lyricLabel: UILabel!
    
    // MARK: Models
    
    var lyric: String = "" {
        didSet {
            lyricLabel.text = lyric
        }
    }
    
    var lyricStyle: LyricPlayerFontStyle = .Regular {
        didSet {
            switch lyricStyle {
            case .Bold:
                lyricLabel.font = lyricLabel.font.boldTrait().fontWithSize(15)
                delegate?.lyricPlayerCell(self, didSelectLyricFontStyle: .Bold)
            case .Regular:
                lyricLabel.font = lyricLabel.font.regularTrait().fontWithSize(14)
                delegate?.lyricPlayerCell(self, didSelectLyricFontStyle: .Regular)
            default:
                break
            }
        }
    }
    
    // MARK: Delegation
    
    var delegate: LyricPlayerTableViewCellDelegate?

}
