//
//  MyPlaylistsModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 10/12/24.
//

import Foundation

final class MyPlaylistsModel: Codable {
    var playlists: [PlaylistModel]
    
    init(playlists: [PlaylistModel]) {
        self.playlists = playlists
    }
}
