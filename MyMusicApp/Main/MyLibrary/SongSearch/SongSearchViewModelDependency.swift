//
//  SongSearchViewModelDependency.swift
//  MyMusicApp
//
//  Created by Titus Logo on 09/12/24.
//

import Foundation

struct SongSearchViewModelDependency {
    let fetcher: SearchFetcherProtocol
    
    init(fetcher: SearchFetcherProtocol? = nil) {
        self.fetcher = fetcher ?? SearchFetcher()
    }
}
