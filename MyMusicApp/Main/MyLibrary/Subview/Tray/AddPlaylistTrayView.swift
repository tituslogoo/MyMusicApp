//
//  AddPlaylistTrayView.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import SnapKit
import UIKit

final class AddPlaylistTrayView: UIView {
    // MARK: - Properties
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, textStackView])
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_playlist")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Playlist"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create a playlist with a song"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4.0
        return stackView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        backgroundColor = ColorTool.darkTrayBackground
        layer.cornerRadius = 10.0
        clipsToBounds = true
        
        let bottomSpacer: CGFloat = UITool.hasNotch() ? 36.0 : 16.0
        
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(8.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-bottomSpacer)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40.0)
        }
    }
}
