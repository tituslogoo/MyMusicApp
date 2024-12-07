//
//  HomeHeaderSectionView.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import Kingfisher
import SnapKit
import UIKit

protocol HomeHeaderSectionViewDelegate {
    func onPlusButtonTapped()
}

final class HomeHeaderSectionView: UIView {
    // MARK: Properties
    static let profilePictureSize: CGSize = CGSize(width: 34.0, height: 34.0)
    static let verticalSpacer: CGFloat = 8.0
    private let plusButtonSize: CGSize = CGSize(width: 26.0, height: 26.0)
    
    private let imageurl: String
    var delegate: HomeHeaderSectionViewDelegate?
    
    // MARK: UI
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Self.profilePictureSize.width / 2
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .semibold)
        label.textColor = ColorTool.lightPrimary
        label.textAlignment = .left
        label.text = "Your Library"
        label.numberOfLines = 1
        return label
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
    
    // MARK: Init
    init(imageUrl: String) {
        self.imageurl = imageUrl
        super.init(frame: .zero)
        setupView()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Functions
    public static func calculateHeight() -> CGFloat {
        return profilePictureSize.height + (verticalSpacer * 2)
    }
}

// MARK: Private Functions
private extension HomeHeaderSectionView {
    func setupView() {
        backgroundColor = ColorTool.darkPrimary
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(Self.profilePictureSize)
            make.leading.equalToSuperview().offset(12.0)
            make.top.equalToSuperview().offset(Self.verticalSpacer)
            make.bottom.equalToSuperview().offset(-Self.verticalSpacer)
        }
        
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(6.0)
            make.top.equalToSuperview().offset(Self.verticalSpacer)
            make.bottom.equalToSuperview().offset(-Self.verticalSpacer)
        }
        
        addSubview(plusImageButton)
        plusImageButton.snp.makeConstraints { make in
            make.size.equalTo(plusButtonSize)
            make.leading.lessThanOrEqualTo(headerLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-12.0)
            make.top.equalToSuperview().offset(Self.verticalSpacer)
            make.bottom.equalToSuperview().offset(-Self.verticalSpacer)
        }
    }
    
    func setupData() {
        profileImageView.kf.setImage(with: URL(string: imageurl))
    }
    
    @objc
    func onPlusButtonDidTapped() {
        delegate?.onPlusButtonTapped()
    }
}
