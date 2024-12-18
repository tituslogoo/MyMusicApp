//
//  MyLibraryCoordinator.swift
//  MyMusicApp
//
//  Created by Titus Logo on 18/12/24.
//

import Foundation
import UIKit

protocol MyLibraryCoordinatorDelegate: AnyObject {
    func onCreateEntryFlowStarted(delegate: CreatePlaylistViewControllerDelegate?)
    func onMyLibraryFlowFinished(with playlist: PlaylistModel)
    func onMyLibraryCreatePlaylistFlowStarted()
}

final class MyLibraryCoordinator: Coordinator {
    // MARK: Properties
    var navigationController: UINavigationController
    private var myLibraryVC: MyLibraryViewController?
    weak var delegate: MyLibraryCoordinatorDelegate?
    
    // MARK: Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        myLibraryVC = MyLibraryViewController(
            coor: self,
            viewModel: MyLibraryViewModel()
        )
        
        guard let myLibraryVC else {
            return
        }
        navigationController.pushViewController(myLibraryVC, animated: false)
    }
    
    private func showCreatePlaylistTray() {
        let trayVC: CreatePlaylistViewController = CreatePlaylistViewController()
        trayVC.delegate = self
        navigationController.present(trayVC, animated: true)
    }
    
    private func navigateToPlaylistDetail(with name: String) {
        guard let myLibraryVC else {
            return
        }
        
        let newPlaylist = PlaylistModel(name: name)
        myLibraryVC.onNeedToSavePlaylist(playlist: newPlaylist)
        
        let viewModel: PlaylistDetailViewModel = PlaylistDetailViewModel(playlist: newPlaylist)
        let playlistVC: PlaylistDetailViewController = PlaylistDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(playlistVC, animated: true)
    }
}

extension MyLibraryCoordinator: MyLibraryCoordinatorDelegate {
    func onCreateEntryFlowStarted(delegate: CreatePlaylistViewControllerDelegate?) {
        let trayVC: CreatePlaylistViewController = CreatePlaylistViewController()
        trayVC.delegate = delegate
        navigationController.present(trayVC, animated: true)
    }
    
    func onMyLibraryFlowFinished(with playlist: PlaylistModel) {
        let viewModel: PlaylistDetailViewModel = PlaylistDetailViewModel(playlist: playlist)
        let playlistVC: PlaylistDetailViewController = PlaylistDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(playlistVC, animated: true)
    }
    
    func onMyLibraryCreatePlaylistFlowStarted() {
        let trayVC = AddPlaylistTrayViewController()
        trayVC.delegate = self
        navigationController.present(trayVC, animated: true)
    }
}

// MARK: AddPlaylistTrayViewControllerDelegate
extension MyLibraryCoordinator: AddPlaylistTrayViewControllerDelegate {
    func onPlaylistButtonTapped() {
        navigationController.dismiss(animated: true, completion: {
            self.showCreatePlaylistTray()
        })
    }
}

// MARK: CreatePlaylistViewControllerDelegate
extension MyLibraryCoordinator: CreatePlaylistViewControllerDelegate {
    func createPlaylist(with name: String) {
        navigationController.dismiss(animated: true, completion: {
            self.navigateToPlaylistDetail(with: name)
        })
    }
}
