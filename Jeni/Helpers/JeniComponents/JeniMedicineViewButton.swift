//
//  JeniMedicineViewButton.swift
//  Jeni
//
//  Created by Tiago Oliveira on 07/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

@IBDesignable class JeniMedicineViewButton : UIView {
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
