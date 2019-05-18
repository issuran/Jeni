//
//  ReminderViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 08/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

enum ActionCaller {
    case add
    case edit
}

enum DatePickerChosen {
    case time
    case period
}

class ReminderViewController: BaseViewController {
    
    @IBOutlet weak var timeReminderTableView: UITableView!
    @IBOutlet weak var pillCollectionView: UICollectionView!
    
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var medicineAmountTextField: UITextField!
    @IBOutlet weak var medicineDurationTextField: UITextField!
    
    @IBOutlet weak var medicineTimeTextField: UITextField!
    
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addTimeReminderButton: JeniButton!
    
    var actionCaller: ActionCaller = .add
    var pickerSelected: DatePickerChosen = .period
    
    let tableReuseIdentifier = "timeReminderCell"
    let collectionReuseIdentifier = "medicineImage"
    
    let pickerSourceDaysPeriod = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],["Day", "Week", "Month", "Year"]]
    var timesReminder = [String]()
    var medicineTypes = [0, 1, 2, 3, 4, 5]
    var selectedType: Int?
    
    let datePicker = UIPickerView()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineDurationTextField.delegate = self
        medicineTimeTextField.delegate = self
        
        datePicker.delegate = self
        datePicker.dataSource = self
        timePicker.datePickerMode = .time
        
        timeReminderTableView.delegate = self
        timeReminderTableView.dataSource = self
        timeReminderTableView.register(UINib(nibName: "TimeReminderTableViewCell", bundle: nil), forCellReuseIdentifier: tableReuseIdentifier)
        
        pillCollectionView.delegate = self
        pillCollectionView.dataSource = self
        pillCollectionView.allowsMultipleSelection = false
        pillCollectionView.register(UINib(nibName: "PillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionReuseIdentifier)
        
        medicineDurationTextField.inputView = self.datePicker
        medicineTimeTextField.inputView = self.timePicker
        
        createDateToolBar()
        createTimeToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch actionCaller {
        case .add:
            reminderLabel.text = "Add Reminder"
            trashButton.isHidden = true
        case .edit:
            reminderLabel.text = "Edit Reminder"
            trashButton.isHidden = false
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deleteReminderAction(_ sender: Any) {
        // TODO: Delete reminder
        print("Delete reminder!")
    }
    
    @IBAction func addTimeReminderAction(_ sender: Any) {
        guard let time = medicineTimeTextField.text, !time.isEmpty else {
            self.alert(message: "Pick a time to remind before add!")
            return
        }
        timesReminder.append(time)
        timeReminderTableView.reloadData()
    }
    
    func createDateToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColorUtils.backgroundBlueColor
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneDateButtonTapped))
        toolBar.setItems([doneButton], animated: false)
        self.medicineDurationTextField.inputAccessoryView = toolBar
    }
    
    func createTimeToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColorUtils.backgroundBlueColor
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTimeButtonTapped))
        toolBar.setItems([doneButton], animated: false)
        self.medicineTimeTextField.inputAccessoryView = toolBar
    }
    
    @objc
    func doneDateButtonTapped() {
        self.medicineDurationTextField.resignFirstResponder()
    }
    
    @objc
    func doneTimeButtonTapped() {
        self.medicineTimeTextField.resignFirstResponder()
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let minute = components.minute! < 10 ? "0\(components.minute!)" : "\(components.minute!)"
        let hour = components.hour! < 10 ? "0\(components.hour!)" : "\(components.hour!)"
        medicineTimeTextField.text = "\(hour):\(minute)"
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == medicineTimeTextField {
            pickerSelected = .time
        } else {
            pickerSelected = .period
        }
    }
}

extension ReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesReminder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseIdentifier) as! TimeReminderTableViewCell
        cell.timeLabel.text = timesReminder[indexPath.row]
        return cell
    }
}

extension ReminderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as! PillCollectionViewCell
        cell.titleLabel.text = "Pilula"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedType = indexPath.row
    }
}
