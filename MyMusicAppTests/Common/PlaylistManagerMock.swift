//
//  PlaylistManagerMock.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/01/25.
//

import Foundation
@testable import MyMusicApp

final class PlaylistManagerMock: PlaylistManagerProtocol {
    // MARK: Testing Parameters
    var isSavePlaylistCalled: Bool = false
    var isLoadAllPlaylistsCalled: Bool = false
    
    var savedPlaylistData: MyMusicApp.PlaylistModel?
    
    // MARK: Control Parameter
    var loadPlaylistStateSuccess: Bool = true
    
    func savePlaylist(playlist: MyMusicApp.PlaylistModel) {
        isSavePlaylistCalled = true
        savedPlaylistData = playlist
    }
    
    func loadAllPlaylists() -> MyMusicApp.MyPlaylistsModel? {
        isLoadAllPlaylistsCalled = true
        
        let mockPlaylist: PlaylistModel = PlaylistModel(name: "Mock Playlist 1", songs: [])
        return loadPlaylistStateSuccess ? MyPlaylistsModel(playlists: [mockPlaylist]) : nil
    }
}
