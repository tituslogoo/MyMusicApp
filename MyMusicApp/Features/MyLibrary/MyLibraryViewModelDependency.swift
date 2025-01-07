//
//  MyLibraryViewModelDependency.swift
//  MyMusicApp
//
//  Created by Titus Logo on 20/12/24.
//

import Foundation

struct MyLibraryViewModelDependency {
    let userProfileFetcher: UserProfileFetcherProtocol
    let playlistManager: PlaylistManagerProtocol
    
    init(
        userProfileFetcher: UserProfileFetcherProtocol? = nil,
        playlistManager: PlaylistManagerProtocol? = nil
    ) {
        self.userProfileFetcher = userProfileFetcher ?? UserProfileFetcher()
        self.playlistManager = playlistManager ?? PlaylistManager()
    }
}
