//
//  UserProfileURLManager.swift
//  MyMusicApp
//
//  Created by Titus Logo on 20/12/24.
//

import Foundation

enum UserProfileURLManager {
    case getUserProfile
    case updateUserProfile
    
    func getURL() -> String {
        let baseURL = Environment.baseURL
        switch self {
        case .getUserProfile:
            return "\(baseURL)/user/profile"
        case .updateUserProfile:
            return "\(baseURL)/user/profile/update"
        }
    }
}
