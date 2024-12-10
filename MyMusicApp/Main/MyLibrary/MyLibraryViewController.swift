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
    private var isUsingTableView: Bool = true
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = !isUsingTableView
        tableView.backgroundColor = ColorTool.darkPrimary
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: "PlaylistTableViewCell")
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = isUsingTableView
        return collectionView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadMyPlaylists()
        tableView.reloadData()
    }
}

// MARK: Private Functions
private extension MyLibraryViewController {
    func setupUI() {
        view.backgroundColor = ColorTool.darkPrimary
        setHeader()
        setSeparatorView()
        setTableView()
        setCollectionView()
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
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func presentCreatePlaylistTray() {
        let trayVC = CreatePlaylistViewController()
        trayVC.delegate = self
        present(trayVC, animated: true)
    }
    
    func onPlaylistDidCreated(withName name: String) {
        let newPlaylist = PlaylistModel(name: name)
        let viewModel: PlaylistDetailViewModel = PlaylistDetailViewModel(playlist: newPlaylist)
        let playlistVC: PlaylistDetailViewController = PlaylistDetailViewController(viewModel: viewModel)
        PlaylistManager.savePlaylist(playlist: newPlaylist)
        navigationController?.pushViewController(playlistVC, animated: true)
    }
    
    func navigateToPlaylistDetail(with playlist: PlaylistModel) {
        let viewModel: PlaylistDetailViewModel = PlaylistDetailViewModel(playlist: playlist)
        let playlistVC: PlaylistDetailViewController = PlaylistDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(playlistVC, animated: true)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension MyLibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myPlaylist?.playlists.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: PlaylistTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "PlaylistTableViewCell") as? PlaylistTableViewCell,
           let playlist: PlaylistModel = viewModel.myPlaylist?.playlists[indexPath.row] {
            cell.configure(with: playlist)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let playlist: PlaylistModel = viewModel.myPlaylist?.playlists[indexPath.row] {
            navigateToPlaylistDetail(with: playlist)
        }
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension MyLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0 // Replace with your data count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourCellIdentifier", for: indexPath)
        // Configure your cell here
        return cell
    }
}

// MARK: HomeHeaderSectionViewDelegate
extension MyLibraryViewController: MyLibraryHeaderSectionViewDelegate {
    func onPlusButtonTapped() {
        let trayVC = AddPlaylistTrayViewController()
        trayVC.delegate = self
        present(trayVC, animated: true)
    }
}

// MARK: AddPlaylistTrayViewControllerDelegate
extension MyLibraryViewController: AddPlaylistTrayViewControllerDelegate {
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
