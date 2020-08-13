//
//  AddUserInfo.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/12/20.
//

import UIKit
import RealmSwift

class AddPlaceInfoController: UIViewController {
    let realm = try! Realm()
    
    
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var placeNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let newCategory = PlaceInfo()
        newCategory.place = self.placeNameTextField.text!
        self.saveInfo(category: newCategory)
        
        DispatchQueue.main.async {
            self.streetAddressTextField.text = ""
            self.cityTextField.text = ""
            self.stateTextField.text = ""
            self.zipCodeTextField.text = ""
            self.countryTextField.text = ""
            self.floorTextField.text = ""
            self.placeNameTextField.text = ""
        }
    }
    func saveInfo(category: PlaceInfo) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
