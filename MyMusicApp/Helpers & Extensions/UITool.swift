//
//  UITool.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/12/24.
//

import Foundation
import UIKit

public final class UITool {
    static func hasNotch() -> Bool {
        guard let window = UIApplication.shared.windows.first else {
            return false
        }
        // Check if the top safe area inset is greater than 20 (notch height varies across devices)
        return window.safeAreaInsets.top > 20
    }
}

extension UIViewController {
    func showError(errorMessage: String?) {
        let alert = UIAlertController(
            title: "Error",
            message: errorMessage ?? "There's something wrong",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
