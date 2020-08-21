//
//  SettingsController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/21/20.
//

import UIKit

class SettingsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func functionButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.switches, sender: self)
    }
    @IBAction func detectorButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.detectorSettings, sender: self)
    }
    
}
