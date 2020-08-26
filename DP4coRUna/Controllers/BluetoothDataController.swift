//
//  BluetoothDataController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/26/20.
//

import UIKit
import RealmSwift

class BluetoothDataController: SwipeTableViewController {
    let realm = try! Realm()
    var bluetooth: Results<Bluetooth>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    //Mark: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetooth?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = bluetooth?[indexPath.row].UUID ?? "No Categories added yet"
        
        return cell
    }
    
    
    //Mark: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        bluetooth = realm.objects(Bluetooth.self)
        tableView.reloadData()
    }
    
    
    //Mark: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.gotoBluetoothDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! BluetoothDetailController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = bluetooth?[indexPath.row]
        }
    }
    
    
}
