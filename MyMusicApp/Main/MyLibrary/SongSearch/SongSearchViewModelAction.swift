//
//  SongSearchViewModelAction.swift
//  MyMusicApp
//
//  Created by Titus Logo on 09/12/24.
//

import Foundation

protocol SongSearchViewModelAction: AnyObject {
    func notifyToReloadData()
    func notifyToShowError(withMessage errorMessage: String)
}
