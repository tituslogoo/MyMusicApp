//
//  Coordinator.swift
//  MyMusicApp
//
//  Created by Titus Logo on 18/12/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()
}
