//
//  PlaylistDetailViewController.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import SnapKit
import UIKit

final class PlaylistDetailViewController: UIViewController {
    // MARK: Properties
    static let verticalSpacer: CGFloat = 8.0
    private let backButtonSize: CGSize = CGSize(width: 20.0, height: 14.0)
    private let plusButtonSize: CGSize = CGSize(width: 26.0, height: 26.0)
    
    var viewModel: PlaylistDetailViewModelProtocol
    
    // MARK: UI
    // Custom Navbar
    private lazy var navBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorTool.clear
        return view
    }()
    
    private lazy var backButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_back"))
        imageView.tintColor = ColorTool.white
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBackButtonDidTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var plusImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "ic_add")
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPlusButtonDidTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4.0
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var playlistTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.textColor = ColorTool.lightPrimary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var playlistSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        label.textColor = ColorTool.lightPrimary
        label.alpha = 0.7
        label.textAlignment = .left
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.backgroundColor = ColorTool.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongTableViewCell")
        return tableView
    }()
    
    // MARK: Init
    init(viewModel: PlaylistDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: Private Functions
private extension PlaylistDetailViewController {
    func setupViews() {
        view.backgroundColor = ColorTool.darkPrimary
        navigationController?.navigationBar.isHidden = true
        
        setupGradientBackground()
        setupCustomNavBar()
        setupStackView()
        setupTableView()
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            ColorTool.randomColor.cgColor,
            ColorTool.randomColor.cgColor,
            ColorTool.darkPrimary.cgColor,
            ColorTool.darkPrimary.cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.07, 0.18, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupCustomNavBar() {
        view.addSubview(navBarContainerView)
        
        let containerHeight: CGFloat = plusButtonSize.height + (Self.verticalSpacer * 2)
        navBarContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(containerHeight)
        }
        
        navBarContainerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
        }
        
        navBarContainerView.addSubview(plusImageButton)
        plusImageButton.snp.makeConstraints { make in
            make.size.equalTo(plusButtonSize)
            make.trailing.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview().offset(Self.verticalSpacer)
            make.bottom.equalToSuperview().offset(-Self.verticalSpacer)
        }
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(navBarContainerView.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview()
        }
        
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    func setupTitleLabel() {
        stackView.addArrangedSubview(playlistTitleLabel)
        playlistTitleLabel.text = viewModel.playlist.name
        
        playlistTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(16.0)
        }
    }
    
    func setupSubtitleLabel() {
        stackView.addArrangedSubview(playlistSubtitleLabel)
        playlistSubtitleLabel.text = "\(viewModel.playlist.numberOfSongs) songs"
        
        playlistSubtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(16.0)
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: Actions
private extension PlaylistDetailViewController {
    @objc
    func onBackButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func onPlusButtonDidTapped() {
        let viewModel: SongSearchViewModelProtocol =
        SongSearchViewModel(currentPlaylist: viewModel.playlist)
        let viewController: SongSearchViewController =
        SongSearchViewController(withVM: viewModel)
        viewController.delegate = self
        
        present(
            viewController,
            animated: true,
            completion: nil
        )
    }
}

// MARK: PlaylistDetailViewModelAction
extension PlaylistDetailViewController: PlaylistDetailViewModelAction {
    func notifyToReloadData() {
        playlistSubtitleLabel.text = "\(viewModel.playlist.numberOfSongs) songs"
        tableView.reloadData()
    }
}

// MARK: SongSearchViewControllerDelegate
extension PlaylistDetailViewController: SongSearchViewControllerDelegate {
    func updatePlaylist(with playlist: PlaylistModel) {
        viewModel.updatePlaylist(with: playlist)
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension PlaylistDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlist.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SongTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as? SongTableViewCell {
            let song = viewModel.playlist.songs[indexPath.row]
            cell.configure(with: song, cellState: .playlist)
            return cell
        }
        
        return UITableViewCell()
    }
}
