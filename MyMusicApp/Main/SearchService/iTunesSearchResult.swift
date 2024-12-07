//
//  iTunesSearchResult.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation

struct iTunesSearchResult: Codable {
    let resultCount: Int
    let results: [MediaItem]
}

struct MediaItem: Codable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl100: String?
}
