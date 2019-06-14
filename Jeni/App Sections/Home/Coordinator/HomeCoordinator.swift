//
//  HomeCoordinator.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit
import EventKit

protocol HomeCoordinatorDelegate: AnyObject {
    func callLogin(_ viewModel: HomeViewModel)
    func callAddReminder(_ actionCaller: ActionCaller, event: EKEventStore)
    func callEditReminder(_ actionCaller: ActionCaller, event: EKEventStore, index: Int, medicineModel: MedicineModel, medicineModelArray: [MedicineModel])
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
