//
//  PlaylistDetailViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 08/12/24.
//

protocol PlaylistDetailViewModelProtocol: AnyObject {
    var playlistName: String { get }
    var numberOfSongs: Int { get }
}

final class PlaylistDetailViewModel: PlaylistDetailViewModelProtocol {
    var playlistName: String
    var numberOfSongs: Int = 0 //note: Change later
    
    init(playlistName: String) {
        self.playlistName = playlistName
    }
}
