//
//  UIColor+Theme.swift
//  ios-stations
//

import UIKit

// UIColorをデフォルト実装
extension UIColor {
    struct Theme {
        static var main: UIColor  { return UIColor(named: "Main")! }
    }
    
    // rgbをランダムに変更
    static var random: UIColor {
        let r = CGFloat.random(in: 0...255) / 255.0
        let g = CGFloat.random(in: 0...255) / 255.0
        let b = CGFloat.random(in: 0...255) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
