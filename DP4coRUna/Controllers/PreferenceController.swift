//
//  PreferenceController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 7/30/20.
//

import UIKit
import RealmSwift

class PerferenceController: UITableViewController {

    var itemArray = [SaveOptions]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SaveOptions.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = SaveOptions()
        newItem.tableCell = "Wifi"
        itemArray.append(newItem)
        
        let newItem2 = SaveOptions()
        newItem2.tableCell = "Bluetooth"
        itemArray.append(newItem2)
        
        let newItem3 = SaveOptions()
        newItem3.tableCell = "GPS"
        itemArray.append(newItem3)
        
        let newItem4 = SaveOptions()
        newItem4.tableCell = "Compass"
        itemArray.append(newItem4)
        
        let newItem5 = SaveOptions()
        newItem5.tableCell = "Altimeter"
        itemArray.append(newItem5)
        
        let newItem6 = SaveOptions()
        newItem6.tableCell = "Pedometer"
        itemArray.append(newItem6)
        
        let newItem7 = SaveOptions()
        newItem7.tableCell = "Accelerometer"
        itemArray.append(newItem7)
        
        let newItem8 = SaveOptions()
        newItem8.tableCell = "Gyroscope"
        itemArray.append(newItem8)
        
        let newItem9 = SaveOptions()
        newItem9.tableCell = "Proximity"
        itemArray.append(newItem9)
        
        
        
        loadItems()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.preferenceCell, for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].tableCell
        
        cell.accessoryType = itemArray[indexPath.row].switchedON ? .checkmark : .none
        self.saveItems()

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].switchedON = !itemArray[indexPath.row].switchedON
        switch indexPath.row {
        case 2:
            LoggerSettings.gpsEnabled = itemArray[indexPath.row].switchedON
        case 3:
            LoggerSettings.compassEnabled = itemArray[indexPath.row].switchedON
        case 4:
            LoggerSettings.altimeterEnabled = itemArray[indexPath.row].switchedON
        case 5:
            LoggerSettings.pedometerEnabled = itemArray[indexPath.row].switchedON
        case 6:
            LoggerSettings.accelerometerEnabled = itemArray[indexPath.row].switchedON
        case 7:
            LoggerSettings.gyroscopeEnabled = itemArray[indexPath.row].switchedON
        case 8:
            LoggerSettings.proximityEnabled = itemArray[indexPath.row].switchedON
        default:
            print("Error on changing Switches")
        }
        if itemArray[3].switchedON {
            // Inform that calibration is necessary
            let alert = UIAlertController(title: "Note", message: "The compass must be calibrated to return true heading. Stand in an open area away from interference and move your phone through a figure 8 motion. If you choose not to do this, only the magnetic heading will be valid.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
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
