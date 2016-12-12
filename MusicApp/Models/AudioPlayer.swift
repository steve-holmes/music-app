//
//  AudioPlayer.swift
//  MusicApp
//
//  Created by HungDo on 9/20/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: Audio Player

class AudioPlayer {
    
    fileprivate init() { }
    
    var dataSource: AudioPlayerDataSource?
    weak var delegate: AudioPlayerDelegate?
    
    var type: AudioPlayerDataType? {
        didSet {
            guard let type = type else { return }
            (dataSource as? AudioPlayerDefaultDataSource)?.type = type
        }
    }
    
    func playSong(atIndex index: Int) {
        guard let song = self.dataSource?.audioPlayer(self, songAtIndex: index) else { return }
        self.play(song: song)
    }
    
    func play() {
        self.playSong(atIndex: 0)
    }
    
    fileprivate func play(song: Song) {
    
    }
    
}

class OnlineAudioPlayer: AudioPlayer {
    
    override convenience init() {
        self.init(songs: [])
    }
    
    init(songs: [Song]) {
        super.init()
        self.type = .online
        self.dataSource = AudioPlayerDefaultDataSource(onlineSongs: songs)
    }
    
}

class OfflineAudioPlayer: AudioPlayer {
    
    override convenience init() {
        self.init(songs: [])
    }
    
    init(songs: [Song]) {
        super.init()
        self.type = .offline
        self.dataSource = AudioPlayerDefaultDataSource(offlineSongs: songs)
    }
    
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
    
    func audioPlayerDataType(forAudioPlayer audioPlayer: AudioPlayer) -> AudioPlayerDataType {
        return .online
    }
    
}

extension AudioPlayerOfflineDataSource {
    
    func audioPlayerDataType(forAudioPlayer audioPlayer: AudioPlayer) -> AudioPlayerDataType {
        return .offline
    }
    
}

// MARK: Delegate

protocol AudioPlayerDelegate: class {
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didSelectAtIndex: Int)
    func audioPlayer(_ audioPlayer: AudioPlayer, willTransitionFromIndex fromIndex: Int, toIndex: Int)
    
}

// MARK: Default Classes

class AudioPlayerOnlineDefaultDataSource: AudioPlayerOnlineDataSource {
    
    init(songs: [Song]) {
        self.songs = songs
    }
    
    init() { }
    
    private var songs = [Song]()
    
    func numberOfSongs(ofAudioPlayer audioPlayer: AudioPlayer) -> Int {
        return songs.count
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, songAtIndex index: Int) -> Song? {
        return songs[index]
    }
    
}

class AudioPlayerOfflineDefaultDataSource: AudioPlayerOfflineDataSource {
    
    init(songs: [Song]) {
        self.songs = songs
    }
    
    init() { }
    
    private var songs = [Song]()
    
    func numberOfSongs(ofAudioPlayer audioPlayer: AudioPlayer) -> Int {
        return songs.count
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, songAtIndex index: Int) -> Song? {
        return songs[index]
    }
    
}

class AudioPlayerDefaultDataSource: AudioPlayerDataSource {
    
    init(onlineDataSource: AudioPlayerOnlineDataSource?, offlineDataSource: AudioPlayerOfflineDataSource?) {
        self.onlineDataSource = onlineDataSource
        self.offlineDataSource = offlineDataSource
        
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
    
    var onlineDataSource: AudioPlayerOnlineDataSource!
    var offlineDataSource: AudioPlayerOfflineDataSource!
    
    private lazy var dataSource: AudioPlayerDataSource! = self.onlineDataSource
    
    var type: AudioPlayerDataType = .online {
        didSet {
            switch type {
            case .online:  dataSource = self.onlineDataSource
            case .offline: dataSource = self.offlineDataSource
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
