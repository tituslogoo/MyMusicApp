//
//  SongSearchViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 08/12/24.
//

import Foundation

protocol SongSearchViewModelProtocol {
    var action: SongSearchViewModelAction? { get set }
    var mediaItems: [MediaItem]? { get }
    
    func searchSongs(query: String)
}

final class SongSearchViewModel: SongSearchViewModelProtocol {
    // MARK: Properties
    private let dependency: SongSearchViewModelDependency
    var action: SongSearchViewModelAction?
    var mediaItems: [MediaItem]?
    
    // MARK: Init
    init(dependency: SongSearchViewModelDependency? = nil) {
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
}
