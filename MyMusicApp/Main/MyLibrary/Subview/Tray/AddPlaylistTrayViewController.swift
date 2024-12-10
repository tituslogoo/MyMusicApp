//
//  AddPlaylistTrayViewController.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import SnapKit
import UIKit

protocol AddPlaylistTrayViewControllerDelegate: AnyObject {
    func onPlaylistButtonTapped()
}

final class AddPlaylistTrayViewController: UIViewController {
    // MARK: Properties
    private let minimumTrayHeight: CGFloat = 60.0
    weak var delegate: AddPlaylistTrayViewControllerDelegate?
    
    // MARK: - UI
    private lazy var addPlaylistTrayView: AddPlaylistTrayView = {
        let view = AddPlaylistTrayView()
        view.isUserInteractionEnabled = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onPlaylistButtonDidTapped)
        )
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupTrayView()
    }
    
    private func setupTrayView() {
        view.addSubview(addPlaylistTrayView)
        
        addPlaylistTrayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(minimumTrayHeight)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        addPlaylistTrayView.layer.cornerRadius = 12.0
        addPlaylistTrayView.clipsToBounds = true
    }
    
    @objc
    private func onPlaylistButtonDidTapped() {
        delegate?.onPlaylistButtonTapped()
    }
}
