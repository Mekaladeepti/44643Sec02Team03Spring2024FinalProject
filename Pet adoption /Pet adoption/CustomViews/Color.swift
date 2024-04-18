//
//  Color.swift
//  Pet adoption
//
//  Created by Sri Lakshmi  Arthimalla on 3/6/24.
import UIKit

extension UIColor {
    static var appColor: UIColor {
        return UIColor(hex: "622A0F")
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        // Remove any leading "#" character if present
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
