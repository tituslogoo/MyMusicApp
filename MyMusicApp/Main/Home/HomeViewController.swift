//
//  HomeViewController.swift
//  MyMusicApp
//
//  Created by Titus Logo on 06/12/24.
//

import Foundation
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    // MARK: Properties
    
    var viewModel: HomeViewModelProtocol
    
    // MARK: UI
    private lazy var headerView: HomeHeaderSectionView = {
        let view = HomeHeaderSectionView(imageUrl: viewModel.profilePictureUrl)
        return view
    }()
    
    // MARK: Init
    init(viewModel: HomeViewModelProtocol? = nil) {
        self.viewModel = viewModel ?? HomeViewModel()
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
}

// MARK: Private Functions
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = ColorTool.darkPrimary
        setHeader()
    }
    
    func setHeader() {
        let headerViewHeight: CGFloat = HomeHeaderSectionView.calculateHeight()
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(headerViewHeight)
        }
    }
}
