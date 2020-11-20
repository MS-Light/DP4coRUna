//
//  SettingsController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/21/20.
//

import UIKit
import CoreBluetooth
import os

class SettingsController: UIViewController {
    let client = Client(host:"192.168.1.152" , port: 80)
    let server = Server(port: 80)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func bluetoothonPressed(_ sender:UIButton) {
        
    }
    @IBAction func notificationPressed(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options:[.alert, .sound])
            { (granted, error) in
            
            }
        
        // Step2 : Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "DP4coRUna - You might have been exposed"
        content.body = "Go take a Covid Test Soon"
        
        // Step3: Create the notification trigger
        let date = Date().addingTimeInterval(5) // The notification will pop after 5 seconds running.
        
        let dateComponents = Calendar.current.dateComponents([.year,.month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //Step 4:  Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content , trigger: trigger)
        
        
        //Step 5:  Register the request
        center.add(request) { (error) in
            }
    }
    @IBAction func functionButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.switches, sender: self)
    }
    @IBAction func detectorButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.detectorSettings, sender: self)
    }
    @IBAction func Startclient(_ sender: Any) {
        DispatchQueue.global().async {
            self.client.start()
            let data = Data("There's a device next to you!".utf8)
            self.client.connection.send(data: data)
        }
    }
    
    @IBAction func Stopclient(_ sender: Any) {
        client.stop()
    }
    
    @IBAction func Startserver(_ sender: Any) {
        DispatchQueue.global().async {
            try! self.server.start()
        }
    }

    @IBAction func Sropserver(_ sender: Any) {
        server.stop()
    }
    
}
