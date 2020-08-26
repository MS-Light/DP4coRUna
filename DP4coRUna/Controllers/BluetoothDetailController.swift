//
//  BluetoothDetailController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/26/20.
//

import UIKit
import RealmSwift

class BluetoothDetailController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var bluetooth: Results<BluetoothDetail>?
    let realm = try! Realm()
    var selectedCategory: Bluetooth? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func loadItems() {
        bluetooth = selectedCategory?.details.sorted(byKeyPath: "timePoint", ascending: true)
        tableView.reloadData()
    }
    
    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetooth?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = bluetooth?[indexPath.row] {
            cell.textLabel?.text = item.timePoint + ", \(item.RSSI)"
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
}


//Mark: - Searchbar delegate methods
extension BluetoothDetailController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        bluetooth = bluetooth?.filter("UUID CONTAINS[cd] %@ OR timePoint CONTAINS[cd] %@", searchBar.text!, searchBar.text!).sorted(byKeyPath: "timePoint", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
