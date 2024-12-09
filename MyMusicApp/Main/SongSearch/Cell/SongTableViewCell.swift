//
//  SongTableViewCell.swift
//  MyMusicApp
//
//  Created by Titus Logo on 09/12/24.
//

import Foundation
import Kingfisher
import SnapKit
import UIKit

final class SongTableViewCell: UITableViewCell {
    // MARK: Properties
    private let verticalSpacer: CGFloat = 2.0
    private let songImageViewSize: CGSize = CGSize(width: 50.0, height: 50.0)
    
    var currentMediaItem: MediaItem?
    private var cellState: SongTableViewCellType = .addSong // default value
    
    private lazy var songImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
    func configure(with data: MediaItem, cellState: SongTableViewCellType) {
        self.cellState = cellState
        if !songImageView.isDescendant(of: contentView) {
            setupUI()
        }
        
        handleData(withData: data)
    }
}

// MARK: Private Functions
private extension SongTableViewCell {
    func setupUI() {
        selectionStyle = .none
        setupBackground()
        setupSongImageView()
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
    
    func setupSongImageView() {
        contentView.addSubview(songImageView)
        songImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalSpacer)
            make.leading.equalToSuperview().offset(16.0)
            make.size.equalTo(songImageViewSize).priority(.required)
            make.bottom.equalToSuperview().offset(-verticalSpacer)
        }
        
        songImageView.layer.cornerRadius = cellState == .addSong
        ? songImageViewSize.height / 2
        : 0
        
        songImageView.clipsToBounds = cellState == .addSong
    }
    
    func setupTextLabels() {
        contentView.addSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(contentView.snp.top)
            make.leading.equalTo(songImageView.snp.trailing).offset(16.0)
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16.0)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func handleData(withData data: MediaItem) {
        if let currentMediaItem,
           data.trackName == currentMediaItem.trackName {
            return
        }
        
        self.currentMediaItem = data
        titleLabel.text = data.trackName
        subtitleLabel.text = "Song • \(data.artistName ?? "")"
        if  let songURLString: String = data.artworkUrl100,
            let songURL: URL = URL(string: songURLString) {
            songImageView.kf.setImage(with: songURL)
        }
    }
}
