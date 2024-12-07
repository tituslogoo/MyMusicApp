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
    private let backButtonSize: CGSize = CGSize(width: 20, height: 14)
    private let plusButtonSize: CGSize = CGSize(width: 26.0, height: 26.0)
    
    // MARK: UI
    // Custom Navbar
    private lazy var navBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorTool.darkPrimary
        return view
    }()
    
    private lazy var backButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_back"))
        imageView.tintColor = ColorTool.white
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBackButtonDidTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    private lazy var plusImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "ic_add")
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPlusButtonDidTapped))
        
        return imageView
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: Private Functions
private extension PlaylistDetailViewController {
    func setupViews() {
        view.backgroundColor = ColorTool.black
        setupCustomNavBar()
    }
    
    func setupCustomNavBar() {
        view.addSubview(navBarContainerView)
        navBarContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        navBarContainerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
            make.centerY.equalToSuperview()
            make.leading.equalTo(18.0)
        }
        
        navBarContainerView.addSubview(plusImageButton)
        plusImageButton.snp.makeConstraints { make in
            make.size.equalTo(plusButtonSize)
            make.leading.lessThanOrEqualTo(backButton.snp.trailing)
            make.trailing.equalToSuperview().offset(-12.0)
            make.top.equalToSuperview().offset(Self.verticalSpacer)
            make.bottom.equalToSuperview().offset(-Self.verticalSpacer)
        }
    }
}

private extension PlaylistDetailViewController {
    @objc
    func onBackButtonDidTapped() {
        
    }
    
    @objc
    func onPlusButtonDidTapped() {
        
    }
}
