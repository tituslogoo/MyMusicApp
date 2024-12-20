//
//  MyLibraryViewModelDependency.swift
//  MyMusicApp
//
//  Created by Titus Logo on 20/12/24.
//

import Foundation

struct MyLibraryViewModelDependency {
    let userProfileFetcher: UserProfileFetcherProtocol
    
    init(userProfileFetcher: UserProfileFetcherProtocol? = nil) {
        self.userProfileFetcher = userProfileFetcher ?? UserProfileFetcher()
    }
}
