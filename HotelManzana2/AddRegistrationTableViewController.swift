//
//  AddRegistrationTableViewController.swift
//  HotelManzana2
//
//  Created by Александр on 27.04.21.
//

import UIKit

//protocol RegistrationDetailTableViewControllerDelegate: AnyObject {
//    func registrationDetailTableViewController(_ controller: AddRegistrationTableViewController, didSave registration: Registration)
//}

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate{

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdaltsLabel: UILabel!
    @IBOutlet var numberOfAdaltsStepper: UIStepper!
    @IBOutlet var numberOfChildren: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet var wifiSwitch: UISwitch!
    
    @IBOutlet var roomTypeLabel: UILabel!
    
    @IBOutlet var numberOfNightTitle: UILabel!
    @IBOutlet var numberOfHightSubTitle: UILabel!
    @IBOutlet var roomTypeChargesTitle: UILabel!
    @IBOutlet var roomTypeChargesSubTitle: UILabel!
    @IBOutlet var wifiChargesTitle: UILabel!
    @IBOutlet var wifiChargesSubTitle: UILabel!
    @IBOutlet var totalDetailLabel: UILabel!
    
    @IBOutlet var doneButton: UIBarButtonItem!
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    var roomType: RoomType? {
        didSet {
            updateChargesLabel()
        }
    }
    
    var registration: Registration?
    
    init?(coder: NSCoder, registration: Registration?) {
        self.registration = registration
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRegistration() -> Registration? {
        guard let roomType = roomType else { return nil }

        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdalts = Int(numberOfAdaltsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdalts: numberOfAdalts, numverOfChildren: numberOfChildren, wifi: hasWifi, roomType: roomType)
    }
    
    // нижние, четыре переменные нужны чтобы регулировать размер строки выбора даты (скрывать их, если не нужны)
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
        updateChargesLabel()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateChargesLabel()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // отключаю кнопку Done, пока не будут заполнены все поля
    func updateDoneButtonState() {

//        let firstName = firstNameTextField.text ?? ""
//        let lastName = lastNameTextField.text ?? ""
//        let email = emailTextField.text ?? ""
//
//        doneButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
        
//        doneButton.isEnabled = self.registration != nil
        let showDoneButton = firstNameTextField.text?.isEmpty == false && lastNameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false
        if self.roomType != nil {
            doneButton.isEnabled = showDoneButton
        } else {
            doneButton.isEnabled = false
        }
        
//        if self.registration == nil {
//            doneButton.isEnabled = false
//        } else {
//            doneButton.isEnabled = true
//        }
   }
    
    @IBAction func textEditingChanged() {
        updateDoneButtonState() 
    }
    
    // обновление тексровой информации (количевтво дней, общая сумма и т.д.) в реальном времени
    func updateChargesLabel() {
        let date = Calendar.current.dateComponents([Calendar.Component.day], from: checkInDatePicker.date, to: checkOutDatePicker.date)
    
        numberOfNightTitle.text = String(date.day!)
        numberOfHightSubTitle.text = "\(checkInDateLabel.text!) - \(checkOutDateLabel.text!)"
        if wifiSwitch.isOn {
            wifiChargesTitle.text = String(10 * date.day!)
        } else {
            wifiChargesTitle.text = String(0)
        }
        if wifiSwitch.isOn {
            wifiChargesSubTitle.text = "Yes"
        } else {
            wifiChargesSubTitle.text = "No Wi-Fi"
        }
        guard let roomType = roomType else { return }
        roomTypeChargesTitle.text = String(roomType.price * Int(date.day!))
        roomTypeChargesSubTitle.text = "\(roomType.name) @  \(roomType.price)/night"
        roomTypeChargesSubTitle.text = "\(roomType.name) @  $\(roomType.price)/night"
        totalDetailLabel.text = "$\( String(Int(roomTypeChargesTitle.text!)! + Int(wifiChargesTitle.text!)!))"
    }
    
    func updateDateView() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        numberOfAdaltsLabel.text = "\(Int(numberOfAdaltsStepper.value))"
        numberOfChildren.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "No Set"
        }
    }
    // реализлвываем метод делегата
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateDoneButtonState()
    }
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegat = self
        selectRoomTypeController?.roomType = roomType
        return selectRoomTypeController
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let registration = registration {
            firstNameTextField.text = registration.firstName
            lastNameTextField.text = registration.lastName
            emailTextField.text = registration.emailAddress
            checkInDatePicker.date = registration.checkInDate
            checkOutDatePicker.date = registration.checkOutDate
            numberOfAdaltsStepper.value = Double(registration.numberOfAdalts)
            numberOfChildrenStepper.value = Double(registration.numverOfChildren)
            wifiSwitch.isOn = registration.wifi
            roomTypeLabel.text = registration.roomType.name
            title = "Edit inforvation"
        } else {
            title = "Add Guest"
        }
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        updateDateView()
        updateNumberOfGuests()
        updateRoomType()
        updateDoneButtonState()
        updateChargesLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind", let roomType = roomType  else { return }

        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdalts = Int(numberOfAdaltsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn

        registration = Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdalts: numberOfAdalts, numverOfChildren: numberOfChildren, wifi: hasWifi, roomType: roomType)
    }
    
    // регулирую высоту ячеек выбора даты (DatePicker)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        default:
           return UITableView.automaticDimension
        }
//        switch (indexPath.section, indexPath.row) {
//        case (checkInDatePickerCellIndexPath.section, checkInDatePickerCellIndexPath.row):
//            return isCheckInDatePickerVisible ? 216.0 : 0.0
//        case (checkOutDatePickerCellIndexPath.section, checkOutDatePickerCellIndexPath.row):
//            return isCheckOutDatePickerVisible ? 216.0 : 0.0
//        default:
//            return 44.0
//        }
    }
    // метод вносит изменения, когда пользователь выбирает date label cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // снимаю выделение ячейки
        tableView.deselectRow(at: indexPath, animated: true)

        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerCellIndexPath.section, checkInDatePickerCellIndexPath.row - 1):
            if isCheckInDatePickerVisible {
                isCheckInDatePickerVisible = false
            } else if isCheckOutDatePickerVisible {
                isCheckOutDatePickerVisible = false
                isCheckInDatePickerVisible = true
            } else {
                isCheckInDatePickerVisible = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()

            case (checkOutDatePickerCellIndexPath.section, checkOutDatePickerCellIndexPath.row - 1):
                if isCheckOutDatePickerVisible {
                    isCheckOutDatePickerVisible = false
                } else if isCheckInDatePickerVisible {
                    isCheckInDatePickerVisible = false
                    isCheckOutDatePickerVisible = true
                } else {
                    isCheckOutDatePickerVisible = true
                }
                tableView.beginUpdates()
                tableView.endUpdates()
        default:
            break
        }
    }
//        if indexPath == checkInDatePickerCellIndexPath && isCheckOutDatePickerVisible == false {
//            isCheckInDatePickerVisible.toggle()
//        } else if indexPath == checkOutDatePickerCellIndexPath && isCheckOutDatePickerVisible == false {
//            isCheckOutDatePickerVisible.toggle()
//        } else if indexPath == checkInDatePickerCellIndexPath || indexPath == checkOutDatePickerCellIndexPath {
//            isCheckInDatePickerVisible.toggle()
//            isCheckOutDatePickerVisible.toggle()
//        } else {
//            return
//        }
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }

}

     
