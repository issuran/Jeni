//
//  LoginViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 01/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordStackView: UIStackView!
    @IBOutlet weak var usernameStackView: UIStackView!
    
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
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.viewModel.callHome()
        }
    }
    
    @IBAction func signButtonAction(_ sender: Any) {
        switch viewModel.signOption {
        case .signIn?:
            signInFlow()
        case .signUp?:
            signUpFlow()
        case .none:
            fatalError()
        }
    }
    
    func signInFlow() {
        print("Sign In Flow")
        
        Auth.auth().signIn(withEmail: emailTextField!.text ?? "", password: passwordTextField!.text ?? "") { (user, error) in
            if error == nil && user != nil {
                self.viewModel.callHome()
            } else {
                print("Erro: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func signUpFlow() {
        print("Sign Up Flow")
        
        Auth.auth().createUser(withEmail: emailTextField!.text ?? "", password: passwordTextField!.text ?? "") { (user, error) in
            if error == nil && user != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.usernameTextField!.text ?? ""
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        print("User display name changed!")
                        self.viewModel.callHome()
                    }
                })
                print("User created!")
            } else {
                print("Erro: \(String(describing: error?.localizedDescription))")
            }
        }
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
                                    self.usernameStackView.isHidden = false
                                    self.viewModel.signOption = .signUp
                                case .signUp?:
                                    self.swapOptionsLabel.text = self.viewModel.signUpText
                                    self.swapButton.setTitle(self.viewModel.signUpTextButton, for: .normal)
                                    self.signButton.setTitle(self.viewModel.signInTextButton, for: .normal)
                                    self.confirmPasswordStackView.isHidden = true
                                    self.usernameStackView.isHidden = true
                                    self.viewModel.signOption = .signIn
                                case .none:
                                    fatalError()
                                }
        }, completion: nil)]
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(up: false)
    }
    
    func animateTextField(up: Bool)
    {
        let movementDistance:CGFloat = -130
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
}
