//
//  PlaylistModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 09/12/24.
//

import Foundation

final class PlaylistModel: Codable {
    let id: UUID
    let name: String
    var songs: [MediaItem]
    
    var numberOfSongs: Int { songs.count }
    
    convenience init(name: String) {
        self.init(name: name, songs: [])
    }
    
    init(name: String, songs: [MediaItem]) {
        self.id = UUID()
        self.name = name
        self.songs = songs
    }
}
