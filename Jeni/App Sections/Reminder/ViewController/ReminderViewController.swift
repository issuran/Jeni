//
//  ReminderViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 08/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class ReminderViewController: BaseViewController {
    
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    @IBOutlet weak var medicineDurationTextField: UITextField!
    
    @IBOutlet weak var medicineTimeTextField: UITextField!
    
    var actionCaller: String = ""
    let pickerSourceDaysPeriod = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],["Day", "Week", "Month", "Year"]];
    let datePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineDurationTextField.delegate = self
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
        medicineDurationTextField.inputView = self.datePicker
        
        createToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reminderLabel.text = "\(actionCaller) Reminder"
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        toolBar.setItems([doneButton], animated: false)
        self.medicineDurationTextField.inputAccessoryView = toolBar
    }
    
    @objc
    func doneButtonTapped(){
        self.medicineDurationTextField.resignFirstResponder()
    }
}

extension ReminderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerSourceDaysPeriod.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSourceDaysPeriod[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerSourceDaysPeriod[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let days = pickerSourceDaysPeriod[0][pickerView.selectedRow(inComponent: 0)]
        let period = pickerSourceDaysPeriod[1][pickerView.selectedRow(inComponent: 1)]
        if Int(days) ?? 1 > 1 {
            medicineDurationTextField.text = "\(days)/\(period)s"
        } else {
            medicineDurationTextField.text = "\(days)/\(period)"
        }
    }
}

extension ReminderViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
