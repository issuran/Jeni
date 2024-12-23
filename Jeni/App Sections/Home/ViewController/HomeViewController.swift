//
//  HomeViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import EventKit
import UserNotifications
import FirebaseFirestore

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var viewModel: HomeViewModel!
    let reuseIdentifier: String = "medicineCell"
    private let itemsPerRow: CGFloat = 3
    var reminder: ReminderViewController!
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    
    var hud = HUD()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hud.center = self.view.center
        self.view.addSubview(hud)
        addButton.isEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpFlowLayout()
        
        collectionView.register(UINib(nibName: "MedicineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        usernameLabel.text = self.viewModel.username
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadReminders()
        
        setObserver()
        viewModel.loadMedicinesFromFirebase()
    }
    
    func setObserver() {
        viewModel.medicineFirebaseStatus.didChange = { [weak self] state in
            guard let self = self else { return }
            
            DispatchQueue.main.async {                
                switch state {
                case .empty:
                    break
                case .loading:
                    self.hud.loadingView(true)
                    break
                case .load(let medicines):
                    self.hud.loadingView(false)
                    medicines.forEach({ print($0) })
                    self.collectionView.reloadData()
                    break
                case .error(let error):
                    self.hud.loadingView(false)
                    print("Error getting documents: \(error)")
                    break
                }
            }
        }
    }
    
    func loadReminders() {
        
        eventStore = EKEventStore()
        reminders = [EKReminder]()
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: { (reminders) in
                    self.reminders = reminders
                    print("\n====REMINDERS====\n\(reminders!)\n")
                    DispatchQueue.main.async {
                        self.addButton.isEnabled = true
                        self.collectionView.reloadData()
                    }
                })
            } else {
                guard let error = error else { return }
                self.alert(message: "Error!", title: "Sorry, please check the following error:\n\(error.localizedDescription)")
            }
        }
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                print("\n====CALENDAR GRANTED====\n")
            } else {
                guard let error = error else { return }
                self.alert(message: "Error!", title: "Sorry, please check the following error:\n\(error.localizedDescription)")
            }
        }
        
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notifications) in
//            print("num of pending notifications \(notifications.count)")
//        })
//        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
//            print("num of delivered notifications \(notifications.count)")
//        }
    }
    
    // MARK: Private functions
    private func setUpFlowLayout() {
        let spacing: CGFloat = 5
        let itemsPerRow: CGFloat = 2
        let screenRect = UIScreen.main.bounds
        let oneMore: CGFloat = itemsPerRow + 1
        let width: CGFloat = screenRect.size.width - spacing * oneMore
        let height: CGFloat = width / itemsPerRow
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        flowLayout.itemSize = CGSize(width: floor(height), height: height)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
    }
    
    @IBAction func addReminderAction(_ sender: Any) {
        viewModel.callAddReminder(.add, event: eventStore)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        self.viewModel.logout()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.numberOfItems() == 0 {
            emptyState.isHidden = false
            return 0
        }
        emptyState.isHidden = true
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MedicineCollectionViewCell
        
        let item = viewModel.getMedicineItem(index: indexPath.row)
        
        let timesToTakeMedicine = item.medicineDetail?.reminderTime?.count ?? 0
        
        cell.medicineImageView.image = UIImage(named: item.image ?? "")
        cell.medicineNameLabel.text = item.name
        cell.medicineQtdPerDayLabel.text = timesToTakeMedicine > 1
            ? "\(timesToTakeMedicine) times today" : "\(timesToTakeMedicine) time today"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let medicineModel = viewModel.medicineItemArray[indexPath.row]
        
        viewModel.callEditReminder(.edit, event: eventStore, index: indexPath.row, medicineModel: medicineModel, medicineModelArray: viewModel.medicineItemArray)
    }
}
