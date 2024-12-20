//
//  UserModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 20/12/24.
//

import Foundation

final class UserModel: Codable {
    let id : String
    let username: String
    let profilePictureUrl: String
    
    init(
        id : String,
        username: String,
        profilePictureUrl: String
    ) {
        self.id = id
        self.username = username
        self.profilePictureUrl = profilePictureUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        profilePictureUrl = try container.decode(String.self, forKey: .profilePictureUrl)
    }
}
