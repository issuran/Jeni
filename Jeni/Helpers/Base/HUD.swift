//
//  HUD.swift
//  Jeni
//
//  Created by Tiago Oliveira on 26/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class HUD: UIActivityIndicatorView {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.style = UIActivityIndicatorView.Style.gray
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadingView(_ isLoading: Bool) {
        if isLoading {
            self.startAnimating()
        } else {
            self.stopAnimating()
            self.hidesWhenStopped = true
        }
    }
}
