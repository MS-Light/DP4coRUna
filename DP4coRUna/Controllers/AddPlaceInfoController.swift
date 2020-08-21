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
    
    var placeinfo : Results<PlaceInfo>?
    
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeinfo = realm.objects(PlaceInfo.self)
        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let newDetail = PlaceDetail()
        newDetail.tag = self.tagTextField.text!
        newDetail.place = self.placeNameTextField.text!
        newDetail.address = self.streetAddressTextField.text!
        newDetail.city = self.cityTextField.text!
        newDetail.country = self.countryTextField.text!
        newDetail.floor = self.floorTextField.text!
        newDetail.state = self.stateTextField.text!
        newDetail.zipcode = self.zipCodeTextField.text!
        self.saveInfo(detail: newDetail)
        
    }

    func saveInfo(detail: PlaceDetail){
        do {
            try realm.write {
                if detail.tag == "" || detail.place == ""{
                    self.placeNameTextField.placeholder = "Enter Something Here!"
                    self.tagTextField.placeholder = "Enter Something Here!"
                }
                else if let info = placeinfo?.filter("tag == %@", self.tagTextField.text!){
                    if info.count > 0{
                        info[0].placeDetail.append(detail)
                    }else{
                        let newCategory = PlaceInfo()
                        newCategory.tag = detail.tag
                        newCategory.placeDetail.append(detail)
                        realm.add(newCategory)
                    }
                }else{
                    let newCategory = PlaceInfo()
                    newCategory.tag = detail.tag
                    newCategory.placeDetail.append(detail)
                    realm.add(newCategory)
                }
                DispatchQueue.main.async {
                    self.streetAddressTextField.text = ""
                    self.cityTextField.text = ""
                    self.stateTextField.text = ""
                    self.zipCodeTextField.text = ""
                    self.countryTextField.text = ""
                    self.floorTextField.text = ""
                    self.placeNameTextField.text = ""
                    self.tagTextField.text = ""
                }
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
