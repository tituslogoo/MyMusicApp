//
//  Environment.swift
//  MyMusicApp
//
//  Created by Titus Logo on 20/12/24.
//

import Foundation

final class Environment {
    static var current: EnvironmentType = .staging // Default
    
    enum EnvironmentType {
        case staging
        case production
    }
    
    static var baseURL: String {
        switch current {
        case .staging:
//            return "https://api.staging.mymusicapp.com"
            return "http://0.0.0.0:3001" // Mockoon
        case .production:
            return "https://api.mymusicapp.com"
        }
    }
}
