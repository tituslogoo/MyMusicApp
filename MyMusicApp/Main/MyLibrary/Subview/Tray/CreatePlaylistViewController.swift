//
//  CreatePlaylistViewController.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import SnapKit
import UIKit

protocol CreatePlaylistViewControllerDelegate: AnyObject {
    func createPlaylist(with name: String)
}

final class CreatePlaylistViewController: UIViewController {
    // MARK: Properties
    private let buttonHeight: CGFloat = 52
    private let textFieldHorizontalSpacer: CGFloat = 32.0
    weak var delegate: CreatePlaylistViewControllerDelegate?
    
    // MARK:  UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTool.lightPrimary
        label.text = "Name your playlist."
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.textColor = ColorTool.lightPrimary
        return textfield
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorTool.lightPrimary
        return view
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.setTitleColor(ColorTool.darkPrimary, for: .normal)
        button.backgroundColor = ColorTool.greenTheme
        button.layer.cornerRadius = buttonHeight / 2
        button.clipsToBounds = true
        button.addTarget(
            self,
            action: #selector(createButtonDidTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: Private Functions
private extension CreatePlaylistViewController {
    func setupUI() {
        view.backgroundColor = ColorTool.darkTrayBackground
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(160.0)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(textFieldHorizontalSpacer)
        }
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter playlist name",
            attributes: [NSAttributedString.Key.foregroundColor: ColorTool.lightGray]
        )
        
        view.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.0)
            make.width.equalTo(textField)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(textField.snp.bottom).offset(2.0)
        }
        
        view.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16.0)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(140.0)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc
    func createButtonDidTapped() {
        delegate?.createPlaylist(with: textField.text ?? "")
    }
}
