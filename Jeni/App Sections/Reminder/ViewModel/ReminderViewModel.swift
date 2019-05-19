//
//  ReminderViewModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 18/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

enum ActionCaller {
    case add
    case edit
}

enum UserInteraction {
    case select
    case deselect
    case create
}

struct TimeReminder {
    let hour: String
    let minute: String
    
    func formattedTimeReminder() -> String {
        return "\(hour):\(minute)"
    }
}

class ReminderViewModel {
    let pickerSourceDaysPeriod = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],["Day", "Week", "Month", "Year"]]
    
    var timesReminderArray = [TimeReminder]()
    var selectedType: Int?
    var medicineTypeArray = ["Pill", "Dose", "Injection", "Solution", "Alternative"]
    
    func addTimeReminder(_ time: String) -> Void {
        let timeArray = time.components(separatedBy: ":")
        let timeReminder = TimeReminder(hour: timeArray.first!, minute: timeArray.last!)
        timesReminderArray.append(timeReminder)
    }
    
    // MARK: Getters
    
    func getMedicineTypeImage(_ medicineType: String, _ action: UserInteraction) -> UIImage {
        switch action {
        case .create, .deselect:
            return #imageLiteral(resourceName: "\(medicineType)Blue")
        case .select:
            return #imageLiteral(resourceName: "\(medicineType)White")
        }
    }
    
    func getMedicineType(_ index: Int) -> String {
        return medicineTypeArray[index]
    }
    
    func getMedicineTime(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let minute = components.minute! < 10 ? "0\(components.minute!)" : "\(components.minute!)"
        let hour = components.hour! < 10 ? "0\(components.hour!)" : "\(components.hour!)"
        
        let timeReminder = TimeReminder(hour: hour, minute: minute)
        
        return timeReminder.formattedTimeReminder()
    }
    
    func getMedicineDuration(selectedRowFirst: Int, selectedRowLast: Int) -> String {
        let days = pickerSourceDaysPeriod[0][selectedRowFirst]
        let period = pickerSourceDaysPeriod[1][selectedRowLast]
        
        return formattedMedicineDurationText(days, period)
    }
    
    func formattedMedicineDurationText(_ days: String, _ period: String) -> String {
        return Int(days) ?? 1 > 1
            ? "\(days)/\(period)s"
            : "\(days)/\(period)"
    }
}
