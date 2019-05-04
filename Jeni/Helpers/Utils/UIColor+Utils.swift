//
//  UIColor+Utils.swift
//  Jeni
//
//  Created by Tiago Oliveira on 02/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

struct UIColorUtils {
    static let blueColor = UIColor(hex: "30c3e1")
    static let greenColor = UIColor(hex: "02d3a5")
    static let backgroundBlueColor = UIColor(hex: "03a9f4")
}
