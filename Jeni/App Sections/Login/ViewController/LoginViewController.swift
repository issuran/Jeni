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
    
    typealias Handler = (Bool) -> Void
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordStackView: UIStackView!
    @IBOutlet weak var usernameStackView: UIStackView!
    
    @IBOutlet weak var swapOptionsLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var signButton: JeniButton!
    @IBOutlet weak var swapButton: UIButton!
    
    var viewModel: LoginViewModel!
    var hud = HUD()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        self.hud.loadingView(true)
        switch viewModel.signOption {
        case .signIn?:
            signInFlow()
        case .signUp?:
            signUpFlow()
        case .none:
            break
        }
    }
    
    func signInFlow() {
        Auth.auth().signIn(withEmail: emailTextField!.text ?? "", password: passwordTextField!.text ?? "") { (user, error) in
            if error == nil && user != nil {
                self.hud.loadingView(false)
                self.viewModel.callHome()
            } else {
                self.hud.loadingView(false)
                self.alert(message: "Erro: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    fileprivate func firebaseSignUp() {
        Auth.auth().createUser(withEmail: emailTextField!.text ?? "", password: passwordTextField!.text ?? "") { (user, error) in
            if error == nil && user != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.usernameTextField!.text ?? ""
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        self.hud.loadingView(false)
                        self.viewModel.callHome()
                    } else {
                        self.hud.loadingView(false)
                        self.alert(message: "Erro: \(String(describing: error?.localizedDescription))")
                    }
                })
            } else {
                self.hud.loadingView(false)
                self.alert(message: "Erro: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func signUpFlow() {
        
        let result = confirmFieldsFulfilled()
        
        switch result {
        case true:
            firebaseSignUp()
        case false:
            self.hud.loadingView(false)
            print("Error")
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
                                    break
                                }
        }, completion: nil)]
    }
    
    override func viewDidLayoutSubviews() {
        self.hud.center = self.view.center
        self.view.addSubview(hud)
    }
}

// Verifications
extension LoginViewController {
    func confirmFieldsFulfilled() -> Bool {
        if usernameTextField.text?.isEmpty ?? true
            || emailTextField.text?.isEmpty ?? true
            || passwordTextField.text?.isEmpty ?? true
            || confirmPasswordTextField.text?.isEmpty ?? true {
            self.alert(message: "Fill up all the fields!")
            return false
        }
        
        if usernameTextField.text!.count > 20 {
            self.alert(message: "Name has a 20 characteres limit!")
            return false
        }
        
        if passwordTextField.text!.count < 6
            || confirmPasswordTextField.text!.count < 6 {
            self.alert(message: "You password must have at least 6 characteres!")
            return false
        }
        
        if passwordTextField.text! == confirmPasswordTextField.text! {
            return true
        } else {
            self.alert(message: "Your password must be the same at confirm password field!")
            return false
        }
    }
}
