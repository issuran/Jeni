//
//  HomeCoordinator.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func callLogin(_ viewModel: HomeViewModel)
}

class HomeCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    var delegate: HomeCoordinatorDelegate!
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewModel = HomeViewModel()
        homeViewModel.delegate = self.delegate
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([homeViewController], animated: true)
    }
    
}