//
//  LoginViewModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

enum SignOption {
    case signIn
    case signUp
}

class LoginViewModel {
    
    var signOption: SignOption!
    
    let signInText = "Already a patient? Try "
    let signUpText = "Are you a new patient? Try "
    let signInTextButton = "Sign In"
    let signUpTextButton = "Sign Up"
    
    init() {
        signOption = .signIn
    }
}
