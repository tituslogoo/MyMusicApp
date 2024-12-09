//
//  SearchFetcher.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation

protocol SearchFetcherProtocol: AnyObject {
    var fetchMediaDataTask: URLSessionDataTask? { get set }
    
    /// Fetches media items from the iTunes Search API.
    /// - Parameters:
    ///   - term: The search term (e.g., artist or song name).
    ///   - successBlock: Response of the API
    ///   - errorBlock: Error Message of API
    func fetchMedia(
        term: String,
        successBlock: (([MediaItem]) -> Void)?,
        errorBlock: ((String) -> Void)?
    )
}

class SearchFetcher: SearchFetcherProtocol {
    var fetchMediaDataTask: URLSessionDataTask?
    private let baseURL = "https://itunes.apple.com/search"
    
    func fetchMedia(
        term: String,
        successBlock: (([MediaItem]) -> Void)?,
        errorBlock: ((String) -> Void)?
    ) {
        guard fetchMediaDataTask == nil else {
            return
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            errorBlock?("InvalidURL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music") /// For now locked to only show music
        ]
        
        guard let url = urlComponents.url else {
            errorBlock?("InvalidURL")
            return
        }
        
        fetchMediaDataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle error
            if let error = error {
                self.fetchMediaDataTask = nil
                errorBlock?(error.localizedDescription)
                return
            }
            
            // Validate response and parse data
            guard let data = data else {
                self.fetchMediaDataTask = nil
                errorBlock?("No Data")
                return
            }
            
            do {
                let searchResult = try JSONDecoder().decode(iTunesSearchResult.self, from: data)
                self.fetchMediaDataTask = nil
                successBlock?(searchResult.results)
                return
            } catch {
                self.fetchMediaDataTask = nil
                errorBlock?(error.localizedDescription)
                return
            }
        }
        fetchMediaDataTask?.resume()
    }
}
