//
//  PlaylistTableViewCell.swift
//  MyMusicApp
//
//  Created by Titus Logo on 10/12/24.
//

import Foundation
import SnapKit
import UIKit

final class PlaylistTableViewCell: UITableViewCell {
    // MARK: Properties
    private let verticalSpacer: CGFloat = 2.0
    private let horizontalSpacer: CGFloat = 16.0
    private var playlistData: PlaylistModel? // just in case, may not be used at all
    
    // MARK: UI
    private var playlistImageView: PlaylistImageCompilationView?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = ColorTool.lightPrimary
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = ColorTool.darkSecondary
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        return stackView
    }()
    
    // MARK: Public Functions
    func configure(with playlistData: PlaylistModel) {
        self.playlistData = playlistData
        if !textStackView.isDescendant(of: contentView) {
            setupUI()
        }
        
        handleData(withData: playlistData)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistImageView?.onPrepareForReuse()
    }
}

// MARK: Private Functions
private extension PlaylistTableViewCell {
    func setupUI() {
        selectionStyle = .none
        setupBackground()
        setupPlaylistImageView()
        setupTextLabels()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setupBackground() {
        backgroundColor = ColorTool.clear
        contentView.backgroundColor = ColorTool.clear
    }
    
    func setupPlaylistImageView() {
        guard let playlistData else {
            return
        }
        playlistImageView = PlaylistImageCompilationView(withPlaylist: playlistData)
        
        guard let playlistImageView else {
            return
        }
        
        contentView.addSubview(playlistImageView)
        playlistImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalSpacer)
            make.leading.equalToSuperview().offset(horizontalSpacer)
            make.size.equalTo(PlaylistImageCompilationView.imageSize).priority(.required)
            make.bottom.equalToSuperview().offset(-verticalSpacer)
        }
    }
    
    func setupTextLabels() {
        guard let playlistImageView else {
            return
        }
        
        contentView.addSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(contentView.snp.top)
            make.leading.equalTo(playlistImageView.snp.trailing).offset(horizontalSpacer)
            make.centerY.equalTo(contentView.snp.centerY)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func handleData(withData data: PlaylistModel) {
        playlistImageView?.updateData(withPlaylist: data)
        titleLabel.text = data.name
        subtitleLabel.text = "Playlist • \(data.numberOfSongs) songs"
    }
}
