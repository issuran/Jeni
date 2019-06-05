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
import Firebase
import FirebaseAuth
import FirebaseFirestore

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
    
    var docRef: DocumentReference!
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
        timeReminderTableView.register(UINib(nibName: "TimeReminderTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: tableReuseIdentifier)
        
        pillCollectionView.delegate = self
        pillCollectionView.dataSource = self
        pillCollectionView.allowsMultipleSelection = false
        pillCollectionView.register(UINib(nibName: "PillCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier: collectionReuseIdentifier)
        
        medicineDurationTextField.inputView = self.datePicker
        medicineTimeTextField.inputView = self.timePicker
        
        createDateToolBar()
        createTimeToolBar()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                self.alert(message: "You need to grant permission to use Notification before you set a reminder!",
                           title: "No permission granted!", completion: {
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
            viewModel.reminderIdentifiers = medicineModel?.medicineDetail?.reminderIdentifiers ?? [String]()
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
            viewModel.medicineName = medicineName!
            switch actionCaller {
            case .add:
                    let uuid = UUID().uuidString
                    let medicineType = viewModel.getMedicineType(viewModel.selectedType!)
                    
                    scheduleNotification(medicineModel) {
                        let medicineDetails = MedicineDetail(amount: medicineAmount!,
                                                             period: self.viewModel.periodReminder.days,
                                                             periodType: self.viewModel.periodReminder.type,
                                                             beginDate: self.viewModel.getBeginDateDuration(),
                                                             endDate: self.viewModel.getEndDateDuration(),
                                                             typeName: medicineType,
                                                             reminderTime: self.viewModel.timesReminderArray,
                                                             reminderIdentifiers: self.viewModel.reminderIdentifiers)
                        let medicine = MedicineModel(id: uuid,
                                                     name: medicineName!,
                                                     image: self.viewModel.getMedicineTypeName(medicineType, .create),
                                                     medicineDetail: medicineDetails)
                        
                        self.saveReminderToFirestore(medicine)
                        
                        BaseViewController.medicineItemArray.append(medicine)
                    }
                
            case .edit:
                
                medicineModel = BaseViewController.medicineItemArray.first(where: { $0.id == self.medicineModel?.id })
                
                let medicineType = viewModel.getMedicineType(viewModel.selectedType!)
                
                scheduleNotification(medicineModel) {
                    let medicineDetails = MedicineDetail(amount: medicineAmount!,
                                                         period: self.viewModel.periodReminder.days,
                                                         periodType: self.viewModel.periodReminder.type,
                                                         beginDate: self.viewModel.getBeginDateDuration(),
                                                         endDate: self.viewModel.getEndDateDuration(),
                                                         typeName: medicineType,
                                                         reminderTime: self.viewModel.timesReminderArray,
                                                         reminderIdentifiers: self.viewModel.reminderIdentifiers)
                    self.medicineModel?.name = medicineName!
                    self.medicineModel?.image = self.viewModel.getMedicineTypeName(medicineType, .create)
                    self.medicineModel?.medicineDetail = medicineDetails
                    
                    BaseViewController.medicineItemArray[self.indexSelected!] = self.medicineModel!
                }
            }
        } else {
            alert(message: message)
        }
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func saveReminderToFirestore(_ medicineModel: MedicineModel) {
        
        var reminderTimeHourArray = [String]()
        var reminderTimeMinuteArray = [String]()
        for time in medicineModel.medicineDetail?.reminderTime ?? [TimeReminder]() {
            reminderTimeHourArray.append(time.hour)
            reminderTimeMinuteArray.append(time.minute)
        }
        let dataToSave: [String: Any] = [
            "name": "\(medicineModel.name)",
            "image": "\(medicineModel.image)",
            "amount": "\(medicineModel.medicineDetail?.amount ?? "")",
            "period": "\(medicineModel.medicineDetail?.period ?? "")",
            "periodTypeIdentifier": "\(medicineModel.medicineDetail?.periodType.periodTypeIdentifier() ?? "")",
            "periodTypeTimes": "\(medicineModel.medicineDetail?.periodType.periodTypeTimes() ?? 1)",
            "beginDate": "\(medicineModel.medicineDetail?.beginDate ?? "")",
            "endDate": "\(medicineModel.medicineDetail?.endDate ?? "")",
            "typeName": "\(medicineModel.medicineDetail?.typeName ?? "")",
            "reminderTimeHour": "\(reminderTimeHourArray)",
            "reminderTimeMinute": "\(reminderTimeMinuteArray)",
            "reminderIdentifiers": "\(medicineModel.medicineDetail?.reminderIdentifiers ?? [String]())"
        ]
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        docRef = db.document("users/\(currentUserId)/medicines/\(medicineModel.id)")
        
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("Got an error! \(error.localizedDescription)")
            } else {
                print("Data has been saved!")
            }
        }
    }
    
    func scheduleNotification(_ medicineModel: MedicineModel?, completion: @escaping Handler) {
        
        switch actionCaller {
        case .edit:
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notifications) in
                print("num of pending notifications \(notifications.count)")
            })
            UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
                print("num of delivered notifications \(notifications.count)")
            }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: viewModel.reminderIdentifiers)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: viewModel.reminderIdentifiers)
            self.viewModel.reminderIdentifiers.removeAll()
        default:
            print("Nothing to do then!")
        }
        
        let notification = UNUserNotificationCenter.current()
        notification.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                for time in self.viewModel.timesReminderArray {
                    let content = UNMutableNotificationContent()
                    content.title = "It is drug time!"
                    content.body = "You should take your \(self.viewModel.medicineTypeArray[self.viewModel.selectedType!].lowercased()) of \(self.viewModel.medicineName)!"
                    content.badge = 1
                    content.categoryIdentifier = "alarm"
                    content.sound = UNNotificationSound.default
                    
                    let calendar = Calendar.current
                    
                    let beginDate = DateComponents(calendar: calendar, timeZone: .current, year: Int(self.viewModel.beginYear), month: Int(self.viewModel.beginMonth), day: Int(self.viewModel.beginDay), hour: Int(time.hour), minute: Int(time.minute))
                    
                    //                                let endDate = DateComponents(calendar: calendar, timeZone: .current, year: Int(self.viewModel.endYear), month: Int(self.viewModel.endMonth), day: Int(self.viewModel.endDay), hour: Int(time.hour), minute: Int(time.minute))
                    
                    //                                let triggerDaily = calendar.dateComponents(Set<Calendar.Component>([.hour, .minute]), from:beginDate.date!, to: endDate.date!)
                    
                    let triggerDaily = calendar.dateComponents([.hour, .minute, .second], from: beginDate.date!)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                    
                    let identifier = UUID().uuidString
                    self.viewModel.reminderIdentifiers.append(identifier)
                    
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    notification.add(request, withCompletionHandler: { (error) in
                        if error != nil {
                            print("Not good! \(error?.localizedDescription ?? "Error during create new Notification!")")
                        } else {
                            print("Success")
                        }
                    })
                }
                completion()
            }
        }
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
