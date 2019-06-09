//
//  MedicineFirebaseModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 05/06/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

struct MedicineFirebaseModel: Codable {
    let id: String?
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
    
    func convertPeriodType() -> PeriodType {
        switch self.periodTypeIdentifier! {
        case "Day":
            return .day
        case "Week":
            return .week
        case "Month":
            return .month
        case "Year":
            return .year
        default:
            return .day
        }
    }
    
    func convertReminderTime() -> [TimeReminder] {
        var timeReminderArray = [TimeReminder]()
        if let count = self.reminderTimeHour?.count {
            for index in 0...count {
                let newTimeReminder = TimeReminder(hour: self.reminderTimeHour?[index] ?? "00", minute: self.reminderTimeMinute?[index] ?? "00")
                timeReminderArray.append(newTimeReminder)
            }
        }
        return timeReminderArray
    }
}
