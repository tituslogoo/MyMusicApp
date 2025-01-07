//
//  PlaylistDetailViewModelDependency.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/01/25.
//

import Foundation

struct PlaylistDetailViewModelDependency {
    let playlistManager: PlaylistManagerProtocol
    
    init(playlistManager: PlaylistManagerProtocol? = nil) {
        self.playlistManager = playlistManager ?? PlaylistManager()
    }
}
