//
//  UserProfileFetcher.swift
//  MyMusicApp
//
//  Created by Titus Logo on 20/12/24.
//

import Foundation

protocol UserProfileFetcherProtocol: AnyObject {
    var fetchUserProfileDataTask: URLSessionDataTask? { get }
    
    /// API call to fetch user profile "/user/profile"
    /// - Parameters:
    ///   - successBlock: on API Success - Returns `UserModel`
    ///   - failureBlock: on API Failure - Returns error message
    func fetchUserProfile(
        successBlock: ((UserModel) -> Void)?,
        failureBlock: ((String) -> Void)?
    )
}

final class UserProfileFetcher: UserProfileFetcherProtocol {
    var fetchUserProfileDataTask: URLSessionDataTask?
    
    func fetchUserProfile(
        successBlock: ((UserModel) -> Void)?,
        failureBlock: ((String) -> Void)?
    ) {
        guard fetchUserProfileDataTask == nil else { return }
        
        let urlString: String = UserProfileURLManager.getUserProfile.getURL()
        guard let url: URL = URL(string: urlString) else {
            failureBlock?(ServiceManager.defaultErrorMessage)
            return
        }
        
        fetchUserProfileDataTask = ServiceManager.fetchAPI(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let user: UserModel = try JSONDecoder().decode(UserModel.self, from: data)
                    self.fetchUserProfileDataTask = nil
                    successBlock?(user)
                }
                catch {
                    self.fetchUserProfileDataTask = nil
                    failureBlock?(ServiceManager.defaultErrorMessage)
                }
            case .failure(let error):
                self.fetchUserProfileDataTask = nil
                failureBlock?(error.localizedDescription)
            }
        }
    }
}
