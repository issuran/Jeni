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

struct PeriodReminder {
    let days: String
    let type: PeriodType
    
    func formattedPeriodReminder() -> String {
        return Int(days)! > 1 ? "\(days)/\(type.periodTypeIdentifier())s" : "\(days)/\(type.periodTypeIdentifier())"
    }
}

enum PeriodType {
    case day
    case week
    case month
    case year
    
    func periodTypeIdentifier() -> String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
    
    func periodTypeTimes() -> Int {
        switch self {
        case .day:
            return 1
        case .week:
            return 7
        case .month:
            return 30
        case .year:
            return 365
        }
    }
}

class ReminderViewModel {
    let pickerSourceDaysPeriod = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],["Day", "Week", "Month", "Year"]]
    
    var timesReminderArray = [TimeReminder]()
    var periodReminder = PeriodReminder(days: "0", type: PeriodType.day)
    var selectedType: Int?
    var medicineTypeArray = ["Pill", "Dose", "Injection", "Solution", "Alternative"]
    var endDate = "01/01/2000"
    
    // MARK: Add
    
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
    
    func getMedicineTypeName(_ medicineType: String, _ action: UserInteraction) -> String {
        switch action {
        case .create, .deselect:
            return "\(medicineType)Blue"
        case .select:
            return "\(medicineType)White"
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
        
        periodReminder = PeriodReminder(days: days, type: periodTypeIdentifier(period))
        
        return periodReminder.formattedPeriodReminder()
    }
    
    func getDateDuration() -> String {
        let today = Date()
        let times = Int(periodReminder.days)! * periodReminder.type.periodTypeTimes()
        let nextDate = Calendar.current.date(byAdding: .day, value: times, to: today)
        return nextDate?.toString(dateFormat: "dd/MM/yyyy") ?? "01/01/2000"
    }
    
    func periodTypeIdentifier(_ period: String) -> PeriodType {
        switch period {
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
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
