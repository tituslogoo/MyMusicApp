//
//  MyLibraryViewModel.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation

protocol MyLibraryViewModelAction: AnyObject {
    func notifyToSetupUserProfile()
    func notifyToShowError(withMessage message: String)
}

protocol MyLibraryViewModelProtocol: AnyObject {
    var userProfile: UserModel? { get }
    var myPlaylist: MyPlaylistsModel? { get }
    var action: MyLibraryViewModelAction? { get set }
    
    func onViewDidLoad()
    func onViewWillAppear()
    func onNeedToSavePlaylist(playlist: PlaylistModel)
}

final class MyLibraryViewModel: MyLibraryViewModelProtocol {
    // MARK: Properties
    var userProfile: UserModel?
    var myPlaylist: MyPlaylistsModel?
    weak var action: MyLibraryViewModelAction?
    private var dependency: MyLibraryViewModelDependency
    
    // MARK: Init
    init(dependency: MyLibraryViewModelDependency? = nil) {
        self.dependency = dependency ?? MyLibraryViewModelDependency()
    }
    
    // MARK: Public Functions
    func onViewDidLoad() {
        fetchUserProfile()
    }
    
    func onViewWillAppear() {
        myPlaylist = PlaylistManager.loadAllPlaylists()
    }
    
    func onNeedToSavePlaylist(playlist: PlaylistModel) {
        PlaylistManager.savePlaylist(playlist: playlist)
    }
}

// MARK: Private Functions
private extension MyLibraryViewModel {
    func fetchUserProfile() {
        dependency.userProfileFetcher.fetchUserProfile { [weak self] user in
            guard let self else {
                return
            }
            
            userProfile = user
            action?.notifyToSetupUserProfile()
        } failureBlock: { [weak self] errorMessage in
            guard let self else {
                self?.action?.notifyToShowError(withMessage: ServiceManager.defaultErrorMessage)
                return
            }
            
            action?.notifyToShowError(withMessage: errorMessage)
        }
    }
}
