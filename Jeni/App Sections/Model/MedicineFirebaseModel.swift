//
//  MedicineFirebaseModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 05/06/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

struct MedicineFirebaseModel: Codable {
    let name: String?
    let image: String?
    let amount: String?
    let period: String?
    let periodTypeIdentifier: String?
    let periodTypeTimes: Int?
    let beginDate: String?
    let endDate: String?
    let typeName: String?
    let reminderTimeHour: [String]?
    let reminderTimeMinute: [String]?
    let reminderIdentifiers: [String]?
}
