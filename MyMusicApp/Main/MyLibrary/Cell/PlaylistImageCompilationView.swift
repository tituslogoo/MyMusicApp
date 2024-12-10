//
//  PlaylistImageCompilationView.swift
//  MyMusicApp
//
//  Created by Titus Logo on 10/12/24.
//

import Foundation
import Kingfisher
import SnapKit
import UIKit

final class PlaylistImageCompilationView: UIView {
    // MARK: Properties
    static let imageSize: CGSize = CGSize(width: 67.0, height: 67.0)
    private let songs: [MediaItem]
    private var customWidth: CGFloat?
    
    // MARK: Init
    init(
        withPlaylist playlist: PlaylistModel,
        customWidth: CGFloat? = nil
    ) {
        songs = Array(playlist.songs.prefix(4))
        super.init(frame: .zero)
        self.customWidth = customWidth
        setupUI()
    }
    
    init() {
        songs = []
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onPrepareForReuse() {
        subviews.forEach({
            $0.removeFromSuperview()
        })
    }
}

// MARK: Private Functions
private extension PlaylistImageCompilationView {
    func setupUI() {
        let finalImageSize: CGSize
        if let customWidth {
            finalImageSize = CGSize(width: customWidth, height: customWidth)
        }
        else {
            finalImageSize = Self.imageSize
        }
        
        if songs.count == .zero {
            let imageView: UIImageView = UIImageView()
            imageView.image = UIImage(named: "ic_playlist_placeholder")
            addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.size.equalTo(finalImageSize).priority(.required)
                make.edges.equalToSuperview()
            }
        }
        else if songs.count < 4 {
            let imageView: UIImageView = UIImageView()
            imageView.kf.setImage(
                with: URL(string: songs[0].artworkUrl100 ?? ""),
                placeholder: UIImage(named: "ic_playlist_placeholder")
            )
            imageView.contentMode = .scaleAspectFill
            addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.size.equalTo(finalImageSize)
                make.edges.equalToSuperview()
            }
        }
        else {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .zero
            stackView.distribution = .fillEqually
            
            for row in 0..<2 {
                let horizontalStackView = UIStackView()
                horizontalStackView.axis = .horizontal
                horizontalStackView.spacing = .zero
                horizontalStackView.distribution = .fillEqually
                
                for col in 0..<2 {
                    let index = row * 2 + col
                    let imageView = UIImageView()
                    imageView.kf.setImage(
                        with: URL(string: songs[index].artworkUrl100 ?? ""),
                        placeholder: UIImage(named: "ic_playlist_placeholder")
                    )
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    
                    horizontalStackView.addArrangedSubview(imageView)
                }
                
                stackView.addArrangedSubview(horizontalStackView)
            }
            
            addSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.size.equalTo(finalImageSize)
                make.edges.equalToSuperview()
            }
        }
    }
}
