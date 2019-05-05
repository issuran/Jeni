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
    
    // Login
    var loginCoordinator: LoginCoordinator!
    
    // Home
    var homeCoordinator: HomeCoordinator!
    
    required init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start()
    }
    
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func callHome(_ viewModel: LoginViewModel) {
        homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.delegate = self
        loginCoordinator = nil
        homeCoordinator.start()
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func callLogin(_ viewModel: HomeViewModel) {
        homeCoordinator = nil
        start()
    }
}
