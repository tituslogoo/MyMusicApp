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
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_playlist")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Playlist"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
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
        
        addSubview(iconImageView)
        addSubview(textStackView)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.0)
        }
        
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12.0)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16.0)
        }
    }
}
