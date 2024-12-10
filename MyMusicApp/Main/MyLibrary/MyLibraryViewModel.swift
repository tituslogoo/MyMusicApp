//
//  MyLibraryViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation

protocol MyLibraryViewModelProtocol: AnyObject {
    var profilePictureUrl: String { get }
    var myPlaylist: MyPlaylistsModel? { get }
    
    func loadMyPlaylists()
}

final class MyLibraryViewModel: MyLibraryViewModelProtocol {
    var profilePictureUrl: String = "https://picsum.photos/50/50"
    var myPlaylist: MyPlaylistsModel?
    
    func loadMyPlaylists() {
        myPlaylist = PlaylistManager.loadAllPlaylists()
    }
}
