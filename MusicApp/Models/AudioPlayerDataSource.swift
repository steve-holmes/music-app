//
//  AudioPlayerDataSource.swift
//  MusicApp
//
//  Created by HungDo on 9/20/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: Data Type

enum AudioPlayerDataType {
    case online
    case offline
}

// MARK: Data Source

protocol AudioPlayerDataSource {
    
    func audioPlayerDataType(forAudioPlayerDataSource dataSource: AudioPlayerDataSource) -> AudioPlayerDataType
    
}

protocol AudioPlayerOnlineDataSource: AudioPlayerDataSource {
    
}

protocol AudioPlayerOfflineDataSource: AudioPlayerDataSource {
    
}

extension AudioPlayerOnlineDataSource {
    
    func audioPlayerDataType(forAudioPlayerDataSource dataSource: AudioPlayerDataSource) -> AudioPlayerDataType {
        return .online
    }
    
}

extension AudioPlayerOfflineDataSource {
    
    func audioPlayerDataType(forAudioPlayerDataSource dataSource: AudioPlayerDataSource) -> AudioPlayerDataType {
        return .offline
    }
    
}

// MARK: Delegate

protocol AudioPlayerDelegate {
    
}

protocol AudioPlayerOnlineDelegate: AudioPlayerDelegate {
    
}

protocol AudioPlayerOfflineDelegate: AudioPlayerDelegate {
    
}

extension AudioPlayerOnlineDelegate {
    
}

extension AudioPlayerOfflineDelegate {
    
}

// MARK: Default Classes

class AudioPlayerOnlineDefaultDataSource: AudioPlayerOnlineDataSource {
    
}

class AudioPlayerOfflineDefaultDataSource: AudioPlayerOfflineDataSource {
    
}

class AudioPlayerDefaultDataSource: AudioPlayerDataSource {
    
    private let defaultOnlineDataSource: AudioPlayerOnlineDataSource! = AudioPlayerOnlineDefaultDataSource()
    private let defaultOfflineDataSource: AudioPlayerOfflineDataSource! = AudioPlayerOfflineDefaultDataSource()
    
    private lazy var dataSource: AudioPlayerDataSource! = self.defaultOnlineDataSource
    
    var type: AudioPlayerDataType = .online {
        didSet {
            switch type {
            case .online:  dataSource = self.defaultOnlineDataSource
            case .offline: dataSource = self.defaultOfflineDataSource
            }
        }
    }
    
    func audioPlayerDataType(forAudioPlayerDataSource dataSource: AudioPlayerDataSource) -> AudioPlayerDataType {
        return self.type
    }
    
}
