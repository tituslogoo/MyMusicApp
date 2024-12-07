//
//  HomeSeparatorSectionView.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import SnapKit
import UIKit

protocol HomeSeparatorSectionViewDelegate: AnyObject {
    func didTapContentTypeButton(withType type: HomeSeparatorSectionType)
}

final class HomeSeparatorSectionView: UIView {
    // MARK: Properties
    var delegate: HomeSeparatorSectionViewDelegate?
    
    static let buttonSize: CGSize = CGSize(width: 16.0, height: 16.0)
    private var contentType: HomeSeparatorSectionType
    
    // MARK: UI
    private lazy var contentTypeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_list")
        imageView.contentMode = .scaleAspectFit
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(oncontentTypeButtonDidTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    // MARK: Init
    init(with type: HomeSeparatorSectionType? = nil) {
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
    
    func onContentTypeChanged(to contentType: HomeSeparatorSectionType) {
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
