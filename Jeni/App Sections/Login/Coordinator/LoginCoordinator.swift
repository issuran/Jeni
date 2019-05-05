//
//  LoginCoordinator.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func callHome(_ viewModel: LoginViewModel)
}

class LoginCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    var delegate: LoginCoordinatorDelegate!
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewModel = LoginViewModel()
        loginViewModel.delegate = self.delegate
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([loginViewController], animated: true)
    }
}
