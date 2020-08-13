//
//  PlaceInfo.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/12/20.
//

import UIKit
import RealmSwift

class PlaceInfoController: SwipeTableViewController {

    let realm = try! Realm()
    var placeInfo: Results<PlaceInfo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //       centralManager = CBCentralManager(delegate: self, queue: nil)
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(named: "#1D9BF6")
    }
    
    //Mark: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeInfo?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = placeInfo?[indexPath.row].place ?? "No Categories added yet"
        
        return cell
    }
    
    
    //Mark: - Data Manipulation Methods
    
    func loadCategories() {
        placeInfo = realm.objects(PlaceInfo.self)
        tableView.reloadData()
    }
    
    //Mark: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.placeInfo?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //Mark: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.placeDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PlaceDetailController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = placeInfo?[indexPath.row]
        }
    }
}

