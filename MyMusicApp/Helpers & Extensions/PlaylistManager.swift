//
//  PlaylistManager.swift
//  MyMusicApp
//
//  Created by Titus Logo on 10/12/24.
//

import Foundation

protocol PlaylistManagerProtocol {
    func savePlaylist(playlist: PlaylistModel)
    func loadAllPlaylists() -> MyPlaylistsModel?
}

final class PlaylistManager: PlaylistManagerProtocol {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func savePlaylist(playlist: PlaylistModel) {
        var myPlaylists = loadAllPlaylists() ?? MyPlaylistsModel(playlists: [])

        if let existingIndex = myPlaylists.playlists.firstIndex(where: { $0.id == playlist.id }) {
            myPlaylists.playlists[existingIndex] = playlist
        } else {
            myPlaylists.playlists.append(playlist)
        }

        if let encodedData = try? JSONEncoder().encode(myPlaylists) {
            defaults.set(encodedData, forKey: "myPlaylists")
        }
    }

    func loadAllPlaylists() -> MyPlaylistsModel? {
        if let savedData = defaults.data(forKey: "myPlaylists") {
            return try? JSONDecoder().decode(MyPlaylistsModel.self, from: savedData)
        }
        return nil
    }
}
