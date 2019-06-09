//
//  ConvertModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 08/06/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

class ConvertModel {
    static func convertFirebaseModelToMedicine(_ medicineFirebaseArray: [MedicineFirebaseModel]) -> [MedicineModel] {
        var medicineModelArray = [MedicineModel]()
        
        for medicineFirebase in medicineFirebaseArray {
            var medicineModel = MedicineModel()
            var medicineDetailModel = MedicineDetail()
            
            medicineModel.id = medicineFirebase.id ?? ""
            medicineModel.name = medicineFirebase.name ?? ""
            medicineModel.image = medicineFirebase.image ?? ""
            
            medicineDetailModel.amount = medicineFirebase.amount ?? ""
            medicineDetailModel.beginDate = medicineFirebase.beginDate ?? ""
            medicineDetailModel.endDate = medicineFirebase.endDate ?? ""
            medicineDetailModel.period = medicineFirebase.period ?? ""
            medicineDetailModel.reminderIdentifiers = medicineFirebase.reminderIdentifiers ?? [String]()
            medicineDetailModel.periodType = medicineFirebase.convertPeriodType()
            medicineDetailModel.reminderIdentifiers = medicineFirebase.reminderIdentifiers ?? [String]()
            medicineDetailModel.reminderTime = medicineFirebase.convertReminderTime()
            medicineDetailModel.typeName = medicineFirebase.typeName ?? ""
            
            medicineModel.medicineDetail = medicineDetailModel
            
            medicineModelArray.append(medicineModel)
        }
        
        return medicineModelArray
    }
}
