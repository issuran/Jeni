//
//  HomeViewModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel {
    
    var medicineFirebaseStatus: Observable<RequestStates<[MedicineFirebaseModel], Error>> = Observable(.empty)
    
    weak var delegate: HomeCoordinatorDelegate!
    
    func logout() {
        delegate.callLogin(self)
    }
    
    func loadMedicinesFromFirebase() {
        medicineFirebaseStatus.value = .loading
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users/\(currentUserId)/medicines").getDocuments { (querySnapshot, error) in
            if let error = error {
                self.medicineFirebaseStatus.value = .error(error)
                print("Error getting documents: \(error)")
            } else {
                let medicines: [MedicineFirebaseModel] = try! querySnapshot!.decoded()
                self.medicineFirebaseStatus.value = .load(medicines)
                medicines.forEach({ print($0) })
            }
        }
    }
}
