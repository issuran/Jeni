//
//  LoginViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 01/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: JeniTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var confirmPasswordStackView: UIStackView!
    
    @IBOutlet weak var swapOptionsLabel: UILabel!
    
    @IBOutlet weak var signButton: JeniButton!
    
    var isHidden: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signButtonAction(_ sender: Any) {
        _ = [UIView .animate(withDuration: 0.4,
                             delay: 0.1,
                             options: .curveEaseIn,
                             animations: {
            self.confirmPasswordStackView.isHidden = !self.isHidden
            self.isHidden = !self.isHidden
        }, completion: nil)]
    }
}
