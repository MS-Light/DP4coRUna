//
//  PersonalTestController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 7/30/20.
//

import UIKit
import RealmSwift

class PersonalTestController: UITableViewController {
    
    var itemArray = [SaveOptions]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PersonalInfo.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = SaveOptions()
        newItem.tableCell = "WiFi Data"
        itemArray.append(newItem)
        
        let newItem2 = SaveOptions()
        newItem2.tableCell = "func2"
        itemArray.append(newItem2)
        
        let newItem3 = SaveOptions()
        newItem3.tableCell = "func3"
        itemArray.append(newItem3)
        
        loadItems()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.perosonalTestCell, for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].tableCell

        self.saveItems()

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.wifiDelegate, sender: self)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! DataSourceController
//        if let indexPath = tableView.indexPathForSelectedRow {
//
//        }
//    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("\(error)")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([SaveOptions].self, from: data)
            }catch{
                print("Decoding error \(error)")
            }
        }
    }

}
