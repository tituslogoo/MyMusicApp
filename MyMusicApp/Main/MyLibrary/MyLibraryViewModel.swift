//
//  MyLibraryViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation

protocol MyLibraryViewModelProtocol: AnyObject {
    var profilePictureUrl: String { get }
}

final class MyLibraryViewModel: MyLibraryViewModelProtocol {
    var profilePictureUrl: String = "https://picsum.photos/50/50"
}
