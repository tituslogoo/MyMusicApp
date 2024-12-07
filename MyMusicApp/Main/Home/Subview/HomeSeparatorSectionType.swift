//
//  HomeSeparatorSectionType.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import UIKit

enum HomeSeparatorSectionType {
    case list
    case grid
    
    func imageData() -> UIImage {
        switch self {
        case .list:
            return UIImage(named: "ic_list") ?? UIImage()
        case .grid:
            return UIImage(named: "ic_grid") ?? UIImage()
        }
    }
}
