//
//  AppCoordinator.swift
//  Jeni
//
//  Created by Tiago Oliveira on 01/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    
    required init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([loginViewController], animated: true)
    }
    
}
