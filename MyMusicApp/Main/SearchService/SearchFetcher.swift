//
//  SearchFetcher.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation

protocol SearchFetcherProtocol: AnyObject {
    /// Fetches media items from the iTunes Search API.
    /// - Parameters:
    ///   - term: The search term (e.g., artist or song name).
    ///   - mediaType: The type of media (e.g., music, movie).
    ///   - completion: A closure returning an array of media items or an error.
    func fetchMedia(
        term: String,
        mediaType: String,
        completion: @escaping (Result<[MediaItem], Error>) -> Void
    )
}

class SearchFetcher: SearchFetcherProtocol {
    private let baseURL = "https://itunes.apple.com/search"
    
    func fetchMedia(
        term: String,
        mediaType: String,
        completion: @escaping (Result<[MediaItem], Error>) -> Void
    ) {
        // Prepare the URL components
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Add query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: mediaType)
        ]
        
        // Create the URL
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Validate response and parse data
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Decode the JSON response
                let searchResult = try JSONDecoder().decode(iTunesSearchResult.self, from: data)
                completion(.success(searchResult.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
