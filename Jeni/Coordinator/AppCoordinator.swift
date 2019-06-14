//
//  AppCoordinator.swift
//  Jeni
//
//  Created by Tiago Oliveira on 01/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit
import EventKit

class AppCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    
    // Login
    var loginCoordinator: LoginCoordinator!
    
    // Home
    var homeCoordinator: HomeCoordinator!
    
    // Reminder
    var reminderCoordinator: ReminderCoordinator!
    
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
    func callAddReminder(_ actionCaller: ActionCaller, event: EKEventStore) {
        print("Add Reminder")
        reminderCoordinator = ReminderCoordinator(navigationController: navigationController)
        reminderCoordinator.delegate = self
        
        let reminderViewModel = ReminderViewModel()
        reminderViewModel.actionCaller = .add
        reminderViewModel.eventStore = event
        
        reminderCoordinator.start(actionCaller, reminderViewModel: reminderViewModel)
    }
    
    func callEditReminder(_ actionCaller: ActionCaller, event: EKEventStore, index: Int, medicineModel: MedicineModel, medicineModelArray: [MedicineModel]) {
        print("Edit Reminder")
        reminderCoordinator = ReminderCoordinator(navigationController: navigationController)
        reminderCoordinator.delegate = self
        
        let reminderViewModel = ReminderViewModel()
        reminderViewModel.actionCaller = .edit
        reminderViewModel.eventStore = event
        reminderViewModel.indexSelected = index
        reminderViewModel.medicineModel = medicineModel
        reminderViewModel.medicineItemArray = medicineModelArray
        
        reminderCoordinator.start(actionCaller, reminderViewModel: reminderViewModel)
    }
    
    func callLogin(_ viewModel: HomeViewModel) {
        homeCoordinator = nil
        start()
    }
}

extension AppCoordinator: ReminderCoordinatorDelegate {
    func backToHome(_ viewModel: ReminderViewModel) {
        callHome(LoginViewModel())
    }
}
