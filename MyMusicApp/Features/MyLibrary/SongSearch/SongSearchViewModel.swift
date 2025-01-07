//
//  SongSearchViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 08/12/24.
//

import Foundation

enum AddSongResultType {
    case success
    case failure(errorMessage: String)
}

protocol SongSearchViewModelProtocol {
    var action: SongSearchViewModelAction? { get set }
    var currentPlaylist: PlaylistModel { get set }
    var mediaItems: [MediaItem]? { get }
    
    func searchSongs(query: String)
    func addSong(withIndex index: Int, completion: ((AddSongResultType) -> Void))
}

final class SongSearchViewModel: SongSearchViewModelProtocol {
    // MARK: Properties
    private let dependency: SongSearchViewModelDependency
    var action: SongSearchViewModelAction?
    var currentPlaylist: PlaylistModel
    var mediaItems: [MediaItem]?
    
    // MARK: Init
    init(currentPlaylist: PlaylistModel, dependency: SongSearchViewModelDependency? = nil) {
        self.currentPlaylist = currentPlaylist
        self.dependency = dependency ?? SongSearchViewModelDependency()
    }
    
    func searchSongs(query: String) {
        dependency.fetcher.fetchMedia(term: query) { [weak self] mediaItems in
            guard let self else {
                return
            }
            
            self.mediaItems = mediaItems
            self.action?.notifyToReloadData()
        } errorBlock: { [weak self] errorMessage in
            guard let self else {
                return
            }
            
            self.action?.notifyToShowError(withMessage: errorMessage)
        }
    }
    
    func addSong(withIndex index: Int, completion: ((AddSongResultType) -> Void)) {
        guard let mediaItem: MediaItem = mediaItems?[index] else {
            completion(.failure(errorMessage: "There's something wrong"))
            return
        }
        
        currentPlaylist.songs.append(mediaItem)
        completion(.success)
    }
}
