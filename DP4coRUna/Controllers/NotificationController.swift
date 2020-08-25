//
//  NotificationController.swift
//  DP4coRUna
//
//  Created by Srinjoy DasMahapatra on 8/22/20.
//

import Foundation
import UIKit
import UserNotifications     //library file

class NotificationController: UIViewController{
    
    override func viewDidLoad() {
        
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options:[.alert, .sound])
            { (granted, error) in
            
            }
        
        // Step2 : Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "DP4coRUna - You might have been exposed"
        content.body = "Go take a Covid Test Soon"
        
        // Step3: Create the notification trigger
        let date = Date().addingTimeInterval(5)
        
        let dateComponents = Calendar.current.dateComponents([.year,.month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //Step 4:  Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content , trigger: trigger)
        
        
        //Step 5:  Register the request
        center.add(request) { (error) in
            }
    }
}



