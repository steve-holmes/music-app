//
//  AudioPlayer.swift
//  MusicApp
//
//  Created by HungDo on 9/20/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

// MARK: Audio Player

class AudioPlayer {
    
    var dataSource: AudioPlayerDataSource?
    var delegate: AudioPlayerDelegate?
    
}

// MARK: Data Type

enum AudioPlayerDataType {
    case online
    case offline
}

// MARK: Data Source

protocol AudioPlayerDataSource {
    
    func audioPlayerDataType(forAudioPlayer audioPlayer: AudioPlayer) -> AudioPlayerDataType
    
    func numberOfSongs(ofAudioPlayer audioPlayer: AudioPlayer) -> Int
    func audioPlayer(_ audioPlayer: AudioPlayer, songAtIndex index: Int) -> Song?
    
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
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didSelectAtIndex: Int)
    func audioPlayer(_ audioPlayer: AudioPlayer, willTransitionFromIndex fromIndex: Int, toIndex: Int)
    
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
    
    fileprivate init(songs: [Song]) {
        self.songs = songs
    }
    
    fileprivate init() { }
    
    private var songs = [Song]()
    
    func audioPlayerDataType(forAudioPlayer audioPlayer: AudioPlayer) -> AudioPlayerDataType {
        return .online
    }
    
    func numberOfSongs(ofAudioPlayer audioPlayer: AudioPlayer) -> Int {
        return songs.count
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, songAtIndex index: Int) -> Song? {
        return songs[index]
    }
    
}

class AudioPlayerOfflineDefaultDataSource: AudioPlayerOfflineDataSource {
    
    fileprivate init(songs: [Song]) {
        self.songs = songs
    }
    
    fileprivate init() { }
    
    private var songs = [Song]()
    
    func audioPlayerDataType(forAudioPlayer audioPlayer: AudioPlayer) -> AudioPlayerDataType {
        return .offline
    }
    
    func numberOfSongs(ofAudioPlayer audioPlayer: AudioPlayer) -> Int {
        return songs.count
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, songAtIndex index: Int) -> Song? {
        return songs[index]
    }
    
}

class AudioPlayerDefaultDataSource: AudioPlayerDataSource {
    
    init(onlineDataSource: AudioPlayerOnlineDataSource?, offlineDataSource: AudioPlayerOfflineDataSource?) {
        defaultOnlineDataSource = onlineDataSource
        defaultOfflineDataSource = offlineDataSource
        
        if offlineDataSource != nil { self.type = .offline }
        if onlineDataSource != nil { self.type = .online }
    }
    
    convenience init(onlineDataSource: AudioPlayerOnlineDataSource) {
        self.init(onlineDataSource: onlineDataSource, offlineDataSource: nil)
    }
    
    convenience init(offlineDataSource: AudioPlayerOfflineDataSource) {
        self.init(onlineDataSource: nil, offlineDataSource: offlineDataSource)
    }
    
    convenience init(onlineSongs: [Song]) {
        self.init(onlineDataSource: AudioPlayerOnlineDefaultDataSource(songs: onlineSongs))
    }
    
    convenience init(offlineSongs: [Song]) {
        self.init(offlineDataSource: AudioPlayerOfflineDefaultDataSource(songs: offlineSongs))
    }
    
    convenience init() {
        self.init(onlineSongs: [])
    }
    
    var defaultOnlineDataSource: AudioPlayerOnlineDataSource!
    var defaultOfflineDataSource: AudioPlayerOfflineDataSource!
    
    private lazy var dataSource: AudioPlayerDataSource! = self.defaultOnlineDataSource
    
    var type: AudioPlayerDataType = .online {
        didSet {
            switch type {
            case .online:  dataSource = self.defaultOnlineDataSource
            case .offline: dataSource = self.defaultOfflineDataSource
            }
        }
    }
    
    func audioPlayerDataType(forAudioPlayer audioPlayer: AudioPlayer) -> AudioPlayerDataType {
        return self.type
    }
    
    func numberOfSongs(ofAudioPlayer audioPlayer: AudioPlayer) -> Int {
        return dataSource.numberOfSongs(ofAudioPlayer: audioPlayer)
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, songAtIndex index: Int) -> Song? {
        return dataSource.audioPlayer(audioPlayer, songAtIndex: index)
    }
    
}
