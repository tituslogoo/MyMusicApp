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
    case successNil
    case failure
    case failureNil
}

// MARK: UserProfileFetcherMock
final class UserProfileFetcherMock: UserProfileFetcherProtocol {
    var serviceState: UserProfileFetcherState = .success
    var fetchUserProfileDataTask: URLSessionDataTask?
    
    // MARK: Testing Parameters
    var isFetchUserProfileCalled: Bool = false
    var isFetchUserProfileCallSuccess: Bool = false
    
    func fetchUserProfile(successBlock: ((MyMusicApp.UserModel?) -> Void)?, failureBlock: ((String?) -> Void)?) {
        isFetchUserProfileCalled = true
        
        switch serviceState {
        case .success:
            isFetchUserProfileCallSuccess = true
            successBlock?(JSONHelper.readJSON(from: "UserModelSuccess", type: UserModel.self))
        case .successNil:
            // To test guard
            isFetchUserProfileCallSuccess = true
            successBlock?(nil)
        case .failure:
            isFetchUserProfileCallSuccess = false
            failureBlock?(ServiceManager.defaultErrorMessage)
        case .failureNil:
            // To test guard
            isFetchUserProfileCallSuccess = false
            failureBlock?(nil)
        }
    }
}
