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
    var amount: Int
    var period: Int
    var periodType: String
    var typeImage: String
    var typeName: String
    var reminderTime: [String]
}
