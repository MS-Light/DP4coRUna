//
//  PlaceDetail.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/12/20.
//

import UIKit
import RealmSwift

class PlaceDetailController: SwipeTableViewController {
    
    var placeDetail: Results<PlaceDetail>?
    let realm = try! Realm()
    var selectedCategory: PlaceInfo? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeDetail?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = placeDetail?[indexPath.row] {
            cell.textLabel?.text = item.place
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }

    //Mark - Model Manipulation Methods
    func loadItems() {
        placeDetail = selectedCategory?.placeDetail.sorted(byKeyPath: "place", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = placeDetail?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}


//Mark: - Searchbar delegate methods
extension PlaceDetailController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        placeDetail = placeDetail?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "place", ascending: true)
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
