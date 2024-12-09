//
//  SongSearchViewController.swift
//  MyMusicApp
//
//  Created by Titus Logo on 08/12/24.
//

import Foundation
import SnapKit
import UIKit

protocol SongSearchViewControllerDelegate: AnyObject {
    func updatePlaylist(with playlist: PlaylistModel)
}

final class SongSearchViewController: UIViewController {
    // MARK: Properties
    private let searchImageSize: CGFloat = 12.0
    private let searchBarBackgroundHeight: CGFloat = 35.0
    
    weak var delegate: SongSearchViewControllerDelegate?
    private var viewModel: SongSearchViewModelProtocol
    
    // MARK: UI
    private lazy var searchBarContainerView: UIView = UIView()
    private lazy var searchBarBackgroundView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = ColorTool.darkTrayBackground
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "ic_search-white")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = ColorTool.clear
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 15.0)
        textField.textColor = ColorTool.lightPrimary
        textField.returnKeyType = .done
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: ColorTool.lightGray]
        )
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var cancelTextButton: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Cancel"
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = ColorTool.lightPrimary
        label.textAlignment = .center
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onCloseButtonDidTapped)
        )
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        
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
    init(withVM viewModel: SongSearchViewModelProtocol) {
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
        setupUI()
    }
}

// MARK: Private Functions
private extension SongSearchViewController {
    func setupUI() {
        view.backgroundColor = ColorTool.darkPrimary
        setupSearchBar()
        setupTableView()
    }
    
    func setupSearchBar() {
        view.addSubview(searchBarContainerView)
        searchBarContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(8.0)
            make.height.equalTo(searchBarBackgroundHeight)
        }
        
        searchBarContainerView.addSubview(searchBarBackgroundView)
        searchBarBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.height.equalTo(searchBarBackgroundHeight)
        }
        
        searchBarBackgroundView.addSubview(searchImageView)
        searchImageView.snp.makeConstraints { make in
            make.size.equalTo(searchImageSize)
            make.leading.equalToSuperview().offset(8.0)
            make.centerY.equalToSuperview()
        }
        
        searchBarBackgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(8.0)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8.0)
        }
        
        searchBarContainerView.addSubview(cancelTextButton)
        cancelTextButton.snp.makeConstraints { make in
            make.leading.equalTo(searchBarBackgroundView.snp.trailing).offset(4.0)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12.0)
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBarContainerView.snp.bottom).offset(8.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc
    func onCloseButtonDidTapped() {
        dismiss(animated: true)
    }
}

// MARK: UITextFieldDelegate
extension SongSearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // todo: may need delay
        if textField.text?.count ?? 0 > 5 {
            viewModel.searchSongs(query: textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.searchSongs(query: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}

// MARK: SongSearchViewModelAction
extension SongSearchViewController: SongSearchViewModelAction {
    func notifyToReloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func notifyToShowError(withMessage errorMessage: String) {
        DispatchQueue.main.async {
            self.showError(errorMessage: errorMessage)
        }
    }
}

extension SongSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mediaItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SongTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as? SongTableViewCell,
           let mediaItem = viewModel.mediaItems?[indexPath.row] {
            cell.configure(with: mediaItem, cellState: .addSong)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.addSong(withIndex: indexPath.row) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.delegate?.updatePlaylist(with: self.viewModel.currentPlaylist)
                self.dismiss(animated: true)
                break
            case .failure(let errorMessage):
                self.showError(errorMessage: errorMessage)
                break
            }
        }
    }
}
