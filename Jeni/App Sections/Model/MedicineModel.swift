//
//  MedicineModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 18/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

struct MedicineModel {
    let name: String
    let image: String
    let medicineDetail: MedicineDetail?
}

struct MedicineDetail {
    var amount: String
    var period: String
    var periodType: String
    var typeName: String
    var reminderTime: [TimeReminder]
}
