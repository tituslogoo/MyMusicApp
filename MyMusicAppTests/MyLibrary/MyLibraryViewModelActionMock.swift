//
//  MyLibraryViewModelActionMock.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/01/25.
//

import Foundation
@testable import MyMusicApp

final class MyLibraryViewModelActionMock: MyLibraryViewModelAction {
    var isNotifyToSetupUserProfileCalled: Bool = false
    var isNotifyToShowErrorCalled: Bool = false
    var notifyToShowErrorMessage: String?
    
    func notifyToSetupUserProfile() {
        isNotifyToSetupUserProfileCalled = true
    }
    
    func notifyToShowError(withMessage message: String) {
        notifyToShowErrorMessage = message
        isNotifyToShowErrorCalled = true
    }
}
