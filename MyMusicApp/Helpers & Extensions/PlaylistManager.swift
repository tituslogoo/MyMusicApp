//
//  PlaylistManager.swift
//  MyMusicApp
//
//  Created by Titus Logo on 10/12/24.
//

import Foundation

final class PlaylistManager {
    static func savePlaylist(playlist: PlaylistModel) {
        let defaults = UserDefaults.standard
        var myPlaylists = loadAllPlaylists() ?? MyPlaylistsModel(playlists: [])
        
        if let existingIndex = myPlaylists.playlists.firstIndex(where: { $0.id == playlist.id }) {
            myPlaylists.playlists[existingIndex] = playlist
        }
        else {
            myPlaylists.playlists.append(playlist)
        }
        
        if let encodedData = try? JSONEncoder().encode(myPlaylists) {
            defaults.set(encodedData, forKey: "myPlaylists")
        }
    }
    
    static func loadAllPlaylists() -> MyPlaylistsModel? {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "myPlaylists") {
            return try? JSONDecoder().decode(MyPlaylistsModel.self, from: savedData)
        }
        return nil
    }
}
