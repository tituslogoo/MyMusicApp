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
    private let tabSectionHeight: CGFloat = 60.0
    private let pillSize: CGSize = CGSize(width: 84.0, height: 34.0)
    private var currentViewState: MyLibrarySeparatorSectionType = .grid
    
    private let collectionViewSpacing: CGFloat = 16.0
    
    var viewModel: MyLibraryViewModelProtocol
    
    // MARK: UI
    private lazy var headerView: MyLibraryHeaderSectionView = {
        let view = MyLibraryHeaderSectionView(imageUrl: viewModel.profilePictureUrl)
        view.delegate = self
        return view
    }()
    
    private lazy var tabPillSectionView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = ColorTool.darkPrimary
        
        let pillLabel: UILabel = UILabel()
        pillLabel.text = "Playlists"
        pillLabel.textColor = ColorTool.lightPrimary
        
        let playlistPillView: UIView = UIView()
        playlistPillView.addSubview(pillLabel)
        playlistPillView.layer.borderColor = ColorTool.lightPrimary.cgColor
        playlistPillView.layer.borderWidth = 1
        playlistPillView.layer.cornerRadius = pillSize.height / 2
        playlistPillView.clipsToBounds = true
        
        pillLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(playlistPillView)
        playlistPillView.snp.makeConstraints { make in
            make.size.equalTo(pillSize)
            make.leading.equalTo(view.snp.leading).offset(16.0)
            make.centerY.equalToSuperview()
        }
        return view
    }()
    
    private lazy var separatorView: MyLibarySeparatorSectionView = {
        let defaultState: MyLibrarySeparatorSectionType
        if currentViewState == .grid {
            defaultState = .list
        }
        else {
            defaultState = .grid
        }
        
        let view = MyLibarySeparatorSectionView(with: currentViewState)
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = currentViewState == .grid
        tableView.backgroundColor = ColorTool.darkPrimary
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: "PlaylistTableViewCell")
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let totalSpacing: CGFloat = collectionViewSpacing
        let totalWidth: CGFloat = UIScreen.main.bounds.width
        let itemWidth: CGFloat = (totalWidth - totalSpacing) / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: PlaylistCollectionViewCell.calculateHeight(contentWidth: itemWidth))
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = currentViewState == .list
        collectionView.backgroundColor = ColorTool.darkPrimary
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        
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
        reloadPlaylistData()
    }
}

// MARK: Private Functions
private extension MyLibraryViewController {
    func setupUI() {
        view.backgroundColor = ColorTool.darkPrimary
        setHeader()
        setPillSectionView()
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
    
    func setPillSectionView() {
        view.addSubview(tabPillSectionView)
        tabPillSectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(tabSectionHeight)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setSeparatorView() {
        let viewHeight: CGFloat = MyLibarySeparatorSectionView.calculateHeight()
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(tabPillSectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(viewHeight)
        }
    }
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16.0)
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
    
    func reloadPlaylistData() {
        if currentViewState == .list {
            tableView.reloadData()
        }
        else {
            collectionView.reloadData()
        }
    }
    
    func updatePlaylistVisibility() {
        tableView.isHidden = currentViewState == .grid
        collectionView.isHidden = currentViewState == .list
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
        return viewModel.myPlaylist?.playlists.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: PlaylistCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PlaylistCollectionViewCell",
            for: indexPath
        ) as? PlaylistCollectionViewCell,
           let playlist: PlaylistModel = viewModel.myPlaylist?.playlists[indexPath.row] {
            
            let totalSpacing: CGFloat = collectionViewSpacing
            let totalWidth: CGFloat = UIScreen.main.bounds.width
            let itemWidth: CGFloat = (totalWidth - totalSpacing) / 2
            
            cell.configure(with: playlist, contentWidth: itemWidth)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playlist: PlaylistModel = viewModel.myPlaylist?.playlists[indexPath.row] {
            navigateToPlaylistDetail(with: playlist)
        }
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

// MARK: MyLibrarySeparatorSectionViewDelegate
extension MyLibraryViewController: MyLibrarySeparatorSectionViewDelegate {
    func didTapContentTypeButton(withType type: MyLibrarySeparatorSectionType) {
        // the type passed here is the image shown in separator view, we should use the opposite for that as state.
        
        currentViewState = type
        separatorView.onContentTypeChanged(to: type == .grid ? .list : .grid)
        reloadPlaylistData()
        updatePlaylistVisibility()
    }
}
