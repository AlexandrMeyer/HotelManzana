//
//  SelectRoomTableViewController.swift
//  HotelManzana2
//
//  Created by Александр on 27.04.21.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate: class {
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
   
    weak var delegat: SelectRoomTypeTableViewControllerDelegate?

    var roomType: RoomType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]
        cell.textLabel?.text = roomType.name
        cell.detailTextLabel?.text = "$\(roomType.price)"
        // настройка типа аксессуара ячейки (accessoryType)
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // метод вносит изменения, когда пользователь выбирает date label cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // убираю серую подсветку ячейки
        tableView.deselectRow(at: indexPath, animated: true)
        // устанавливая тип комнаты соответствующей indexPath
        let roomType = RoomType.all[indexPath.row]
        // вызываем метод делегата (если он есть)
        self.roomType = roomType
        delegat?.selectRoomTypeTableViewController(self, didSelect: roomType)
        // перезагружаю table view
        tableView.reloadData()
    }


}
