//
//  HomeViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

protocol HomeViewModelProtocol: AnyObject {
    var profilePictureUrl: String { get }
}

final class HomeViewModel: HomeViewModelProtocol {
    var profilePictureUrl: String = "https://picsum.photos/50/50"
    
    
}
