//
//  ReminderViewModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 18/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

enum ActionCaller {
    case add
    case edit
}

class ReminderViewModel {
    let pickerSourceDaysPeriod = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],["Day", "Week", "Month", "Year"]]
    var timesReminder = [String]()
    var selectedType: Int?
    var medicineTypeArray = ["Pill", "Dose", "Injection", "Solution", "Alternative"]
    
    func setMedicineDurationText(_ days: String, _ period: String) -> String {
        return Int(days) ?? 1 > 1
            ? "\(days)/\(period)s"
            : "\(days)/\(period)"
    }
    
    func getMedicineType(_ index: Int) -> String {
        return medicineTypeArray[index]
    }
    
    func getMedicineTime(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let minute = components.minute! < 10 ? "0\(components.minute!)" : "\(components.minute!)"
        let hour = components.hour! < 10 ? "0\(components.hour!)" : "\(components.hour!)"
        return "\(hour):\(minute)"
    }
}
