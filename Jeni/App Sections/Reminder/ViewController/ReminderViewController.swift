//
//  ReminderViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 08/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

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
    @IBOutlet weak var doneButton: JeniButton!
    
    var actionCaller: ActionCaller = .add
    var medicineModel: MedicineModel?
    var indexSelected: Int?
    
    let tableReuseIdentifier = "timeReminderCell"
    let collectionReuseIdentifier = "medicineImage"
    
    let datePicker = UIPickerView()
    let timePicker = UIDatePicker()
    
    var eventStore: EKEventStore!
    var reminder: EKReminder!
    
    var viewModel = ReminderViewModel()
    var hud = HUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud.center = self.view.center
        self.view.addSubview(hud)
        
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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                self.alert(message: "You need to grant permission to use Notification before you set a reminder!", title: "No permission granted!", completion: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
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
            fillFields(medicineModel ?? MedicineModel(id: "id", name: "Teste", image: "", medicineDetail: nil))
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        medicineModel = nil
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deleteReminderAction(_ sender: Any) {
        
        self.alert(message: "Medicine Reminder removed from your list!", title: "Delete") {
            BaseViewController.medicineItemArray.remove(at: self.indexSelected!)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func addTimeReminderAction(_ sender: Any) {
        guard let time = medicineTimeTextField.text, !time.isEmpty else {
            self.alert(message: "Pick a time to remind before add!")
            return
        }
        
        viewModel.addTimeReminder(time)
        medicineTimeTextField.text?.removeAll()
        timeReminderTableView.reloadData()
    }
    
    @IBAction func doneReminderAction(_ sender: Any) {
        var message = "Sorry, unfortunatelly you missed:\n"
        var filledSuccessfully = true
        
        let medicineName = medicineNameTextField.text
        let medicineAmount = medicineAmountTextField.text
        let medicineDuration = medicineDurationTextField.text
        
        if medicineName?.isEmpty ?? false {
            message.append("✧ The medicine's name\n")
            filledSuccessfully = false
        }
        
        if medicineAmount?.isEmpty ?? false {
            message.append("✧ The medicine's daily amount\n")
            filledSuccessfully = false
        }
        
        if medicineDuration?.isEmpty ?? false {
            message.append("✧ The medicine's period you should take\n")
            filledSuccessfully = false
        }
        
        if viewModel.selectedType == nil {
            message.append("✧ The medicine's type\n")
            filledSuccessfully = false
        }
        
        if viewModel.timesReminderArray.count == 0 {
            message.append("✧ The medicine's time schedule\n")
            filledSuccessfully = false
        }
        
        if filledSuccessfully {
            switch actionCaller {
            case .add:
                    let uuid = UUID().uuidString
                    let medicineType = viewModel.getMedicineType(viewModel.selectedType!)
                    
                    let medicineDetails = MedicineDetail(amount: medicineAmount!,
                                                         period: viewModel.periodReminder.days,
                                                         periodType: viewModel.periodReminder.type,
                                                         beginDate: viewModel.getBeginDateDuration(),
                                                         endDate: viewModel.getEndDateDuration(),
                                                         typeName: medicineType,
                                                         reminderTime: viewModel.timesReminderArray)
                    let medicine = MedicineModel(id: uuid,
                                                 name: medicineName!,
                                                 image: viewModel.getMedicineTypeName(medicineType, .create),
                                                 medicineDetail: medicineDetails)
                    
                    let content = UNMutableNotificationContent()
                    content.title = "It is drug time!"
                    content.body = "You should take your \(viewModel.medicineTypeArray[viewModel.selectedType!].lowercased()) of \(medicineName!)!"
                    content.badge = 1
                    content.categoryIdentifier = "alarm"
                    content.sound = UNNotificationSound.default
                    
                    for time in viewModel.timesReminderArray {
                        let notification = UNUserNotificationCenter.current()
//
                        let calendar = Calendar.current
//                        let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour, .minute])
//
//                        var beginDate = DateComponents()
//                        beginDate.day = Int(viewModel.beginDay)
//                        beginDate.month = Int(viewModel.beginMonth)
//                        beginDate.year = Int(viewModel.beginYear)
//                        beginDate.hour = Int(time.hour)
//                        beginDate.minute = Int(time.minute)

                        let beginDate = DateComponents(calendar: calendar, timeZone: .current, year: Int(viewModel.beginYear), month: Int(viewModel.beginMonth), day: Int(viewModel.beginDay), hour: Int(time.hour), minute: Int(time.minute))
                        
//                        var endDate = DateComponents()
//                        endDate.day = Int(viewModel.endDay)
//                        endDate.month = Int(viewModel.endMonth)
//                        endDate.year = Int(viewModel.endYear)
//                        endDate.hour = Int(time.hour)
//                        endDate.minute = Int(time.minute)
                        let endDate = DateComponents(calendar: calendar, timeZone: .current, year: Int(viewModel.endYear), month: Int(viewModel.endMonth), day: Int(viewModel.endDay), hour: Int(time.hour), minute: Int(time.minute))
//
                        let uuidIdentifier = UUID().uuidString
                        
//                        let anchorComponents = calendar.dateComponents(unitFlags, from: beginDate, to: endDate)
                        
//                        let trigger = UNCalendarNotificationTrigger(dateMatching: anchorComponents, repeats: true)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: beginDate, repeats: true)
                        
                        let request = UNNotificationRequest(identifier: uuidIdentifier, content: content, trigger: trigger)
                        
                        notification.add(request, withCompletionHandler: nil)
                        
                        print("\n=====TEST TIME \(time.formattedTimeReminder())=======\nBegin Date: \(beginDate)\nEndDate: \(endDate)\nUUID: \(uuidIdentifier)\n")
                        
                        // REMINDER
                        reminder = EKReminder(eventStore: eventStore)
                        reminder.title = medicineName!
                        reminder.priority = 5
                        reminder.startDateComponents = beginDate
                        reminder.dueDateComponents = endDate
                        
                        let alarm = EKAlarm(absoluteDate: beginDate.date!)
                        reminder.addAlarm(alarm)
                        
                        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
                        
                        do {
                            try eventStore.save(reminder, commit: true)
                        } catch {
                            print("Damn it!")
                        }
                        print("Save it!")
                        
                        print("\n=====TEST REMINDER \(reminder.title)=======\nreminder.startDateComponents: \(reminder.startDateComponents)\nreminder.dueDateComponents: \(reminder.dueDateComponents)\nalarm: \(alarm)\n")
                    }
                    
                    BaseViewController.medicineItemArray.append(medicine)
                
            case .edit:
                
                medicineModel = BaseViewController.medicineItemArray.first(where: { $0.id == self.medicineModel?.id })
                
                let medicineType = viewModel.getMedicineType(viewModel.selectedType!)
                
                let medicineDetails = MedicineDetail(amount: medicineAmount!,
                                                     period: viewModel.periodReminder.days,
                                                     periodType: viewModel.periodReminder.type,
                                                     beginDate: viewModel.getBeginDateDuration(),
                                                     endDate: viewModel.getEndDateDuration(),
                                                     typeName: medicineType,
                                                     reminderTime: viewModel.timesReminderArray)
                medicineModel?.name = medicineName!
                medicineModel?.image = viewModel.getMedicineTypeName(medicineType, .create)
                medicineModel?.medicineDetail = medicineDetails
                
                BaseViewController.medicineItemArray[indexSelected!] = medicineModel!
            }
        } else {
            alert(message: message)
        }
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func scheduleNotification(at date: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Tutorial Reminder"
        content.body = "Just a reminder to read your tutorial over at appcoda.com!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    func returnDateFromString(_ date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: date)
        return date!
    }
    
    func fillFields(_ medicineModel: MedicineModel) {
        medicineNameTextField.text = medicineModel.name
        medicineAmountTextField.text = medicineModel.medicineDetail?.amount
        guard let periodType = medicineModel.medicineDetail?.periodType else { return }
        viewModel.periodReminder = PeriodReminder(days: medicineModel.medicineDetail?.period ?? "0",
                                    type: periodType)
        medicineDurationTextField.text = viewModel.periodReminder.formattedPeriodReminder()
        viewModel.timesReminderArray = medicineModel.medicineDetail?.reminderTime ?? [TimeReminder]()
        viewModel.selectedType = viewModel.medicineTypeArray.firstIndex(of: medicineModel.medicineDetail?.typeName ?? "Pill")
        pillCollectionView.selectItem(at: IndexPath(item: viewModel.selectedType ?? 0, section: 0), animated: true, scrollPosition: .right)
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
        medicineTimeTextField.text = viewModel.getMedicineTime(timePicker.date)
    }
}

// MARK: Picker View - How long picker

extension ReminderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.pickerSourceDaysPeriod.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerSourceDaysPeriod[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerSourceDaysPeriod[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let duration = viewModel.getMedicineDuration(
            selectedRowFirst: pickerView.selectedRow(inComponent: 0),
            selectedRowLast: pickerView.selectedRow(inComponent: 1))
        
        medicineDurationTextField.text = duration
    }
}

extension ReminderViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: Table View - Time schedule to remind

extension ReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.timesReminderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseIdentifier) as! TimeReminderTableViewCell
        cell.timeLabel.text = viewModel.timesReminderArray[indexPath.row].formattedTimeReminder()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            viewModel.timesReminderArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

// MARK: Collection View - Medicine type

extension ReminderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.medicineTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as! PillCollectionViewCell
        let medicineType = viewModel.getMedicineType(indexPath.row)
        cell.titleLabel.text = medicineType
        cell.imageView.image = viewModel.getMedicineTypeImage(medicineType, .create)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedType = indexPath.row
        let cell = pillCollectionView.cellForItem(at: indexPath) as! PillCollectionViewCell
        let medicineType = viewModel.getMedicineType(indexPath.row)
        cell.imageView.image = viewModel.getMedicineTypeImage(medicineType, .select)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = pillCollectionView.cellForItem(at: indexPath) as! PillCollectionViewCell
        let medicineType = viewModel.getMedicineType(indexPath.row)
        cell.imageView.image = viewModel.getMedicineTypeImage(medicineType, .deselect)
    }
}
