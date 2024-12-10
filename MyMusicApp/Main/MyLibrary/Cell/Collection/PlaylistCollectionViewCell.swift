//
//  PlaylistCollectionViewCell.swift
//  MyMusicApp
//
//  Created by Titus Logo on 10/12/24.
//

import Foundation
import SnapKit
import UIKit

final class PlaylistCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    private static let contentStackViewHeight: CGFloat = 4.0
    private static let titleLabelHeight: CGFloat = 15.0
    private static let subtitleLabelHeight: CGFloat = 13.0
    
    private var playlistData: PlaylistModel?
    private var contentWidth: CGFloat = .zero
    
    // MARK: UI
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = Self.contentStackViewHeight
        return stackView
    }()
    
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
    
    // MARK: Public Functions
    static func calculateHeight(contentWidth: CGFloat) -> CGFloat {
        return contentWidth
        + contentStackViewHeight
        + titleLabelHeight
        + contentStackViewHeight
        + subtitleLabelHeight
    }
    
    func configure(
        with playlistData: PlaylistModel,
        contentWidth: CGFloat
    ) {
        self.playlistData = playlistData
        self.contentWidth = contentWidth
        
        if !titleLabel.isDescendant(of: contentView) {
            setupUI()
        }
        
        handleData(withData: playlistData)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistImageView?.onPrepareForReuse()
        
        contentStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}

// MARK: Private Functions
private extension PlaylistCollectionViewCell {
    func setupUI() {
        setupBackground()
        setupContentStackView()
        setupPlaylistImageView()
        setupTextLabels()
        
        if let playlistImageView {
            playlistImageView.setContentCompressionResistancePriority(
                titleLabel.contentCompressionResistancePriority(for: .vertical) + 1,
                for: .vertical
            )
            titleLabel.setContentCompressionResistancePriority(
                subtitleLabel.contentCompressionResistancePriority(for: .vertical) + 1,
                for: .vertical
            )
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBackground() {
        backgroundColor = ColorTool.clear
        contentView.backgroundColor = ColorTool.clear
    }
    
    func setupContentStackView() {
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func setupPlaylistImageView() {
        guard let playlistData else {
            return
        }
        playlistImageView = PlaylistImageCompilationView(
            withPlaylist: playlistData,
            customWidth: contentWidth
        )
        
        guard let playlistImageView else {
            return
        }
        
        contentStackView.addArrangedSubview(playlistImageView)
    }
    
    func setupTextLabels() {
        contentStackView.addArrangedSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(Self.titleLabelHeight)
        }
        
        contentStackView.addArrangedSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(Self.subtitleLabelHeight)
        }
    }
    
    func handleData(withData data: PlaylistModel) {
        titleLabel.text = data.name
        subtitleLabel.text = "Playlist • \(data.numberOfSongs) songs"
    }
}
