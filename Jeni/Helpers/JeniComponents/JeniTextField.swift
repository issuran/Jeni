//
//  JeniTextField.swift
//  Jeni
//
//  Created by Tiago Oliveira on 01/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

@IBDesignable
final class JeniTextField: UITextField {
    
     @IBInspectable var cornerRadius: CGFloat = 0 {
         didSet {
             layer.cornerRadius = cornerRadius
             layer.masksToBounds = cornerRadius > 0
         }
     }
 
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
