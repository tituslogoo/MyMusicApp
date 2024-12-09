//
//  ColorTool.swift
//  MyMusicApp
//
//  Created by Titus Logo on 06/12/24.
//

import Foundation
import UIKit

public final class ColorTool: UIColor, @unchecked Sendable {
    static var darkPrimary: UIColor = UIColor.black
    static var darkSecondary: UIColor = UIColor.darkGray
    static var darkTrayBackground: UIColor = UIColor(hex: "#333333")
    static var lightPrimary: UIColor = UIColor.white
    static var greenTheme: UIColor = UIColor(hex: "#1ED760")
    
    static var randomColor: UIColor = {
        UIColor(
            red: CGFloat.random(in: 0...255)/255,
            green: CGFloat.random(in: 0...255)/255,
            blue: CGFloat.random(in: 0...255)/255,
            alpha: 1.0
        )
    }()
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove the hash symbol if it's present
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        // Ensure the hex string is 6 characters
        guard hexSanitized.count == 6 else {
            self.init(white: 0.0, alpha: 1.0) // Default to black if invalid hex string
            return
        }
        
        // Get RGB values from the hex string
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
