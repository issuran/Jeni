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
    var medicineItemArray : [MedicineModel] = []
    var username = String()
    let db = Firestore.firestore()
    
    weak var delegate: HomeCoordinatorDelegate!
    
    init() {
        if Auth.auth().currentUser != nil {
            username = Auth.auth().currentUser?.displayName ?? ""
        }
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func numberOfItems() -> Int {
        return medicineItemArray.count
    }
    
    func getMedicineItem(index: Int) -> MedicineModel {
        return medicineItemArray[index]
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            delegate.callLogin(self)
        } catch {
            print("Damn it")
        }
    }
    
    func loadMedicinesFromFirebase() {
        medicineFirebaseStatus.value = .loading
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        db.collection("users/\(currentUserId)/medicines").getDocuments { (querySnapshot, error) in
            if let error = error {
                self.medicineFirebaseStatus.value = .error(error)
            } else {
                let medicines: [MedicineFirebaseModel] = try! querySnapshot!.decoded()
                self.medicineItemArray = ConvertModel.convertFirebaseModelToMedicine(medicines)
                self.medicineFirebaseStatus.value = .load(medicines)
            }
        }
    }
}
