//
//  DestinationList.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 11/20/20.
//

import Foundation
import RealmSwift

class DestinationList: SwipeTableViewController{
    
    var destinationCell: Results<DirectionList1>?
    let realm = try! Realm()
    var destinationtext: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.separatorStyle = .none
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationCell?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = destinationCell?[indexPath.row] {
            cell.textLabel?.text = item.direction
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //Mark - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = destinationCell?[indexPath.row] {
//            .
////            destinationtext = item.direction
////            let vc = GoogleMapViewController()
////            vc.dataRecieved = item.direction
////            navigationController?.popViewController(animated: true)
////            dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "seeRecommandation", sender: self)
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //Mark - Model Manipulation Methods
    func loadItems() {
        destinationCell = realm.objects(DirectionList1.self)
            //.sorted(byKeyPath: "time", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = destinationCell?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeRecommandation"{
            let destinationVC = segue.destination as! RecommendPageViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.destinationValue = destinationCell?[indexPath.row].direction
            }
        }
    }
}

