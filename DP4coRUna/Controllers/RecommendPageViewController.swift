//
//  RecommendPageViewController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 12/11/20.
//

import UIKit

class RecommendPageViewController: UIViewController {

    @IBOutlet weak var departureTimeSelector: UITextField!
    var destinationValue: String?
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationLabel.text = destinationValue ?? " "
        createDatePicker()
    }
    func createDatePicker(){
        departureTimeSelector.textAlignment = .center
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        departureTimeSelector.inputAccessoryView = toolbar
        
        departureTimeSelector.inputView = datePicker
        
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        departureTimeSelector.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        arrivalTime.text = formatter.string(from: datePicker.date+3000)
        
    }


}
