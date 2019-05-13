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

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var viewModel: HomeViewModel!
    let reuseIdentifier: String = "medicineCell"
    private let itemsPerRow: CGFloat = 3
    var reminder = ReminderViewController()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpFlowLayout()
        
        collectionView.register(UINib(nibName: "MedicineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        if Auth.auth().currentUser != nil {
            usernameLabel.text = Auth.auth().currentUser?.displayName
        }
    }
    
    // MARK: Private functions
    fileprivate func setUpFlowLayout() {
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
        reminder.actionCaller = .add
        navigationController?.pushViewController(reminder, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.viewModel.logout()
        } catch {
            print("Damn it")
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MedicineCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reminder.actionCaller = .edit
        navigationController?.pushViewController(reminder, animated: true)
    }
}
