//
//  RegistrationTableViewController.swift
//  HotelManzana2
//
//  Created by Александр on 28.04.21.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    @IBAction func unwindFromAddRegistration(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let addRegistrationTableViewController = segue.source as? AddRegistrationTableViewController,
              let registration = addRegistrationTableViewController.registration else { return }
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            registrations[selectedIndexPath.row] = registration
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: registrations.count, section: 0)
        registrations.append(registration)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.reloadData()
    }
}
    
    var registrations: [Registration] = []
    
    var dateFormater: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        
        return dateFormater
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        cell.textLabel?.text = registration.firstName + " " + registration.lastName
        cell.detailTextLabel?.text = dateFormater.string(from: registration.checkInDate) + " - " + dateFormater.string(from: registration.checkOutDate) + ": " + registration.roomType.name

        return cell
    }
 
    @IBSegueAction func editRegistration(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
      
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let guestEdit = registrations[indexPath.row]
        return  AddRegistrationTableViewController(coder: coder, registration: guestEdit)
        } else {
        return AddRegistrationTableViewController(coder: coder, registration: nil)
        }
    }
//
//    func registrationDetailTableViewController(_ controller: AddRegistrationTableViewController, didSave registration: Registration) {
//        if let indexPath = tableView.indexPathForSelectedRow {
//            registrations.remove(at: indexPath.row)
//            registrations.insert(registration, at: indexPath.row)
//        } else {
//            registrations.append(registration)
//        }
//
//        tableView.reloadData()
//        dismiss(animated: true, completion: nil)
//    }

}
