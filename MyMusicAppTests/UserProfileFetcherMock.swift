//
//  UserProfileFetcherMock.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/01/25.
//

import Foundation
@testable import MyMusicApp

// MARK: UserProfileFetcherState
enum UserProfileFetcherState {
    case success
    case failure
}

// MARK: UserProfileFetcherMock
final class UserProfileFetcherMock: UserProfileFetcherProtocol {
    var serviceState: UserProfileFetcherState = .success
    var fetchUserProfileDataTask: URLSessionDataTask?
    
    // MARK: Testing Parameters
    var isFetchUserProfileCalled: Bool = false
    var isFetchUserProfileCallSuccess: Bool = false
    
    func fetchUserProfile(successBlock: ((MyMusicApp.UserModel) -> Void)?, failureBlock: ((String) -> Void)?) {
        isFetchUserProfileCalled = true
        
        switch serviceState {
        case .success:
            if let userModelMock: UserModel = JSONHelper.readJSON(from: "UserModelSuccess", type: UserModel.self) {
                isFetchUserProfileCallSuccess = true
                successBlock?(userModelMock)
            }
            else {
                isFetchUserProfileCallSuccess = false
                failureBlock?("userModelMock decoding failed")
            }
        case .failure:
            isFetchUserProfileCallSuccess = false
            failureBlock?(ServiceManager.defaultErrorMessage)
        }
    }
}
