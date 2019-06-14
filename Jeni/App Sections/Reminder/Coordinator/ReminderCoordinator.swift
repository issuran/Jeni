//
//  ReminderCoordinator.swift
//  Jeni
//
//  Created by Tiago Oliveira on 13/06/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

protocol ReminderCoordinatorDelegate: AnyObject {
    func backToHome(_ viewModel: ReminderViewModel)
}

class ReminderCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    var delegate: ReminderCoordinatorDelegate!
    
    var reminderViewController: ReminderViewController!
    var reminderViewModel: ReminderViewModel!
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(_ actionCaller: ActionCaller, reminderViewModel: ReminderViewModel) {
        self.reminderViewModel = reminderViewModel
        switch actionCaller {
        case .add:
            startAdd()
        case .edit:
            startEdit()
        }
    }
    
    func startAdd() {
        reminderViewModel.delegate = self.delegate
        reminderViewController = ReminderViewController(viewModel: reminderViewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([reminderViewController], animated: true)
    }
    
    func startEdit() {
        reminderViewModel.delegate = self.delegate
        let reminderViewController = ReminderViewController(viewModel: reminderViewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([reminderViewController], animated: true)
    }
}
