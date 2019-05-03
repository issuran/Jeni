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
    @IBOutlet weak var swapButton: UIButton!
    
    var isHidden: Bool = true
    
    let signInText = "Already a patient? Try "
    let signUpText = "Are you a new patient? Try "
    let signInTextButton = "Sign In"
    let signUpTextButton = "Sign Up"
    
    enum SignOption {
        case signIn
        case signUp
    }
    
    var signOption: SignOption!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOption = SignOption.signIn
    }
    
    @IBAction func signButtonAction(_ sender: Any) {
        // TODO : Sign In
        
        // TODO : Sign Up
    }
    
    @IBAction func swapSignOptionsAction(_ sender: Any) {
        _ = [UIView .animate(withDuration: 0.4,
                             delay: 0.1,
                             options: .curveEaseIn,
                             animations: {
                                switch self.signOption {
                                case .signIn?:
                                    self.swapOptionsLabel.text = self.signInText
                                    self.swapButton.setTitle(self.signInTextButton, for: .normal)
                                    self.signButton.setTitle(self.signUpTextButton, for: .normal)
                                    self.confirmPasswordStackView.isHidden = !self.isHidden
                                    self.signOption = SignOption.signUp
                                case .signUp?:
                                    self.swapOptionsLabel.text = self.signUpText
                                    self.swapButton.setTitle(self.signUpTextButton, for: .normal)
                                    self.signButton.setTitle(self.signInTextButton, for: .normal)
                                    self.confirmPasswordStackView.isHidden = self.isHidden
                                    self.signOption = SignOption.signIn
                                case .none:
                                    fatalError()
                                }
        }, completion: nil)]
    }
}
