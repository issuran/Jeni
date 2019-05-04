//
//  LoginViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 01/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: JeniTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var confirmPasswordStackView: UIStackView!
    
    @IBOutlet weak var swapOptionsLabel: UILabel!
    
    @IBOutlet weak var signButton: JeniButton!
    @IBOutlet weak var swapButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                                switch self.viewModel.signOption {
                                case .signIn?:
                                    self.swapOptionsLabel.text = self.viewModel.signInText
                                    self.swapButton.setTitle(self.viewModel.signInTextButton, for: .normal)
                                    self.signButton.setTitle(self.viewModel.signUpTextButton, for: .normal)
                                    self.confirmPasswordStackView.isHidden = false
                                    self.viewModel.signOption = .signUp
                                case .signUp?:
                                    self.swapOptionsLabel.text = self.viewModel.signUpText
                                    self.swapButton.setTitle(self.viewModel.signUpTextButton, for: .normal)
                                    self.signButton.setTitle(self.viewModel.signInTextButton, for: .normal)
                                    self.confirmPasswordStackView.isHidden = true
                                    self.viewModel.signOption = .signIn
                                case .none:
                                    fatalError()
                                }
        }, completion: nil)]
    }
}
