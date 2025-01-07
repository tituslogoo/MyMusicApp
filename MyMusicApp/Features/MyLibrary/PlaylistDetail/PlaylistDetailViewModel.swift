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
    
    private var dependency: PlaylistDetailViewModelDependency
    
    init(
        playlist: PlaylistModel,
        dependency: PlaylistDetailViewModelDependency = PlaylistDetailViewModelDependency()
    ) {
        self.playlist = playlist
        self.dependency = dependency
    }
    
    func updatePlaylist(with playlist: PlaylistModel) {
        self.playlist = playlist
        dependency.playlistManager.savePlaylist(playlist: self.playlist)
        action?.notifyToReloadData()
    }
}
