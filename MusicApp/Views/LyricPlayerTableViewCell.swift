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
    case bold
    case regular
    case other // never use
}

// MARK: Procotol LyricPlayerTableViewCellDelegate

protocol LyricPlayerTableViewCellDelegate: class {
    
    func lyricPlayerCell(_ lyricCell: LyricPlayerTableViewCell, didSelectLyricFontStyle lyricFontStyle: LyricPlayerFontStyle)
    
}

// MARK: Class LyricPlayerTableViewCell

class LyricPlayerTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var lyricLabel: UILabel!
    
    // MARK: Models
    
    var lyric: String = "" {
        didSet {
            lyricLabel.text = lyric
        }
    }
    
    var lyricStyle: LyricPlayerFontStyle = .regular {
        didSet {
            switch lyricStyle {
            case .bold:
                lyricLabel.font = lyricLabel.font.boldTrait().withSize(15)
                delegate?.lyricPlayerCell(self, didSelectLyricFontStyle: .bold)
            case .regular:
                lyricLabel.font = lyricLabel.font.regularTrait().withSize(14)
                delegate?.lyricPlayerCell(self, didSelectLyricFontStyle: .regular)
            default:
                break
            }
        }
    }
    
    // MARK: Delegation
    
    weak var delegate: LyricPlayerTableViewCellDelegate?

}
