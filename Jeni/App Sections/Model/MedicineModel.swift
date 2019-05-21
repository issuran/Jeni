//
//  MedicineModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 18/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

struct MedicineModel {
    var id: String
    var name: String
    var image: String
    var medicineDetail: MedicineDetail?
}

struct MedicineDetail {
    var amount: String
    var period: String
    var periodType: PeriodType
    var endDate: String
    var typeName: String
    var reminderTime: [TimeReminder]
}
