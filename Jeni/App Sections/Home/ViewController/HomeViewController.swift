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
        let space: CGFloat
        let dimension: CGFloat
        
        if UIDeviceOrientation.portrait.isPortrait {
            space = 16.0
            dimension = (view.frame.size.width - (2 * space)) / 2
        } else {
            space = 1.0
            dimension = (view.frame.size.width - (1 * space)) / 3
        }
        
        flowLayout.itemSize = CGSize(width: dimension + 30, height: dimension)
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
    
}
