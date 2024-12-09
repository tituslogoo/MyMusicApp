//
//  MyLibraryViewController.swift
//  MyMusicApp
//
//  Created by Titus Logo on 06/12/24.
//

import Foundation
import SnapKit
import UIKit

final class MyLibraryViewController: UIViewController {
    // MARK: Properties
    var viewModel: MyLibraryViewModelProtocol
    
    // MARK: UI
    private lazy var headerView: MyLibraryHeaderSectionView = {
        let view = MyLibraryHeaderSectionView(imageUrl: viewModel.profilePictureUrl)
        view.delegate = self
        return view
    }()
    
    private lazy var separatorView: MyLibarySeparatorSectionView = {
        let view = MyLibarySeparatorSectionView()
        return view
    }()
    
    // MARK: Init
    init(viewModel: MyLibraryViewModelProtocol? = nil) {
        self.viewModel = viewModel ?? MyLibraryViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: Private Functions
private extension MyLibraryViewController {
    func setupUI() {
        view.backgroundColor = ColorTool.darkPrimary
        setHeader()
        setSeparatorView()
    }
    
    func setHeader() {
        let headerViewHeight: CGFloat = MyLibraryHeaderSectionView.calculateHeight()
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(headerViewHeight)
        }
    }
    
    func setSeparatorView() {
        let viewHeight: CGFloat = MyLibarySeparatorSectionView.calculateHeight()
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(viewHeight)
        }
    }
    
    func presentCreatePlaylistTray() {
        let trayVC = CreatePlaylistViewController()
        trayVC.delegate = self
        present(trayVC, animated: true)
    }
    
    func onPlaylistDidCreated(withName name: String) {
        let viewModel: PlaylistDetailViewModel = PlaylistDetailViewModel(playlist: .init(name: name))
        let playlistVC: PlaylistDetailViewController = PlaylistDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(playlistVC, animated: true)
    }
}

// MARK: HomeHeaderSectionViewDelegate
extension MyLibraryViewController: HomeHeaderSectionViewDelegate {
    func onPlusButtonTapped() {
        let trayVC = AddPlaylistTrayViewController()
        trayVC.delegate = self
        present(trayVC, animated: true)
    }
}

// MARK: HomeAddPlaylistTrayViewControllerDelegate
extension MyLibraryViewController: HomeAddPlaylistTrayViewControllerDelegate {
    func onPlaylistButtonTapped() {
        dismiss(animated: true, completion: {
            self.presentCreatePlaylistTray()
        })
    }
}

// MARK: CreatePlaylistViewControllerDelegate
extension MyLibraryViewController: CreatePlaylistViewControllerDelegate {
    func createPlaylist(with name: String) {
        dismiss(animated: true, completion: {
            self.onPlaylistDidCreated(withName: name)
        })
    }
}
