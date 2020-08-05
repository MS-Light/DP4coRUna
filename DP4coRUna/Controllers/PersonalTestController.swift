//
//  PersonalTestController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 7/30/20.
//

import UIKit

class PersonalTestController: UITableViewController {
    
    var itemArray = K.personalItemArray
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: K.perosonalTestCell) as? [String]{
            itemArray = items
        }
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.perosonalTestCell, for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at:indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at:indexPath)?.accessoryType = .none
            self.defaults.setValue(self.itemArray, forKey: K.perosonalTestCell)
        }else{
            tableView.cellForRow(at:indexPath)?.accessoryType = .checkmark
            self.defaults.setValue(self.itemArray, forKey: K.perosonalTestCell)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
