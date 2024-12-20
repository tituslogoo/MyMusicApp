//
//  MyLibarySeparatorSectionView.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import SnapKit
import UIKit

protocol MyLibrarySeparatorSectionViewDelegate: AnyObject {
    func didTapContentTypeButton(withType type: MyLibrarySeparatorSectionType)
}

final class MyLibarySeparatorSectionView: UIView {
    // MARK: Properties
    var delegate: MyLibrarySeparatorSectionViewDelegate?
    
    static let buttonSize: CGSize = CGSize(width: 16.0, height: 16.0)
    private var contentType: MyLibrarySeparatorSectionType
    
    // MARK: UI
    private lazy var contentTypeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_list")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(oncontentTypeButtonDidTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    // MARK: Init
    init(with type: MyLibrarySeparatorSectionType? = nil) {
        contentType = type ?? .list
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    public static func calculateHeight() -> CGFloat {
        return buttonSize.height
    }
    
    func onContentTypeChanged(to contentType: MyLibrarySeparatorSectionType) {
        self.contentType = contentType
        contentTypeButton.image = contentType.imageData()
    }
    
    private func setupView() {
        addSubview(contentTypeButton)
        contentTypeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(snp.trailing).offset(-24.0)
            make.size.equalTo(Self.buttonSize)
        }
    }
    
    @objc
    private func oncontentTypeButtonDidTapped() {
        delegate?.didTapContentTypeButton(withType: contentType)
    }
}
