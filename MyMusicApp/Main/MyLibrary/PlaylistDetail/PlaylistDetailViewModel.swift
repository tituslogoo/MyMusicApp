//
//  PlaylistDetailViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 08/12/24.
//

protocol PlaylistDetailViewModelAction: AnyObject {
    func notifyToReloadData()
}

protocol PlaylistDetailViewModelProtocol: AnyObject {
    var action: PlaylistDetailViewModelAction? { get set }
    var playlist: PlaylistModel { get }
    
    func updatePlaylist(with playlist: PlaylistModel)
}

final class PlaylistDetailViewModel: PlaylistDetailViewModelProtocol {
    weak var action: PlaylistDetailViewModelAction?
    var playlist: PlaylistModel
    
    init(playlist: PlaylistModel) {
        self.playlist = playlist
    }
    
    func updatePlaylist(with playlist: PlaylistModel) {
        self.playlist = playlist
        PlaylistManager.savePlaylist(playlist: self.playlist)
        action?.notifyToReloadData()
    }
}
