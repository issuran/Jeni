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
    var medicineTypes = [0, 1, 2, 3, 4, 5]
    var selectedType: Int?
    
}
