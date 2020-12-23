//
//  StartViewController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 10/11/20.
//

import UIKit
import RealmSwift
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class StartViewController: UIViewController {
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var Notify: UIButton!
    @IBOutlet weak var sickSwitchOutlet: UISwitch!
    var itemArray = [SaveOptions]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SaveOptions.plist")
    // Make status bar light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([SaveOptions].self, from: data)
            }catch{
                print("Decoding error \(error)")
            }
            LoggerSettings.RUsick = itemArray[9].switchedON
            sickSwitchOutlet.isOn = itemArray[9].switchedON
        }
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

    @IBAction func sickSwitchAction(_ sender: UISwitch) {
        loadItems()
        itemArray[9].switchedON = !itemArray[9].switchedON
        sickSwitchOutlet.isOn = itemArray[9].switchedON
        saveItems()
    }


    // Objects from the AppDelegate
    var logger: Logger!
    var sensors: Sensors!
    var advertiser: BluetoothAdvertiser!
    var scanner: BluetoothScanner!
    var firstRun: Bool!
    var isRunning: Bool!
    var haveInitialLog: Bool!
    var range: Int!
    var angle: Int!


    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Get objects from the AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        logger = delegate.logger
        sensors = delegate.sensors
        advertiser = delegate.advertiser
        scanner = delegate.scanner

        // Notifications for when app transitions between background and foreground
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        // Notification when proximity sensor is activated
        // (required since the app does not go into the background!)
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged(notification:)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }

        // Initial states
        firstRun = true
        haveInitialLog = false
        range = 6
        angle = 0
        isRunning = false

    }

    //button to notify
    @IBAction func notify(_ sender: UIButton) {
        // prepare json data
        NSLog("Start notify")
        let json: [String: Any] = ["title": "ABC",
                                   "dict": ["1":"First", "2":"Second"]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // create post request
        let url = URL(string: "http://192.168.1.56:5000")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        
        //post location data to firebase
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            print("load firebase")
            let realm = try! Realm()
            // Read some data from the bundled Realm
            let results = realm.objects(locationdata.self)
            for a in results {
                print("success loading data into cloud")
                let x = a.latitude
                let y = a.longitude
                
                db.collection("positive_case").document("NJ").setData([
                    "population": 1,
                    "lat":x,
                    "lot":y
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                //print(a.latitude)
                //print(a.longitude)
            }
        }
        
    }

    @IBAction func sickSwitch(_ sender: UISwitch) {
    }
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if startButtonOutlet.title(for: .normal) == "Start"{
            if haveInitialLog {

                // Warn before deleting old log
                let alert = UIAlertController(title: "Warning", message: "Creating a new log will delete the old log. To avoid losing data, make sure the old log has been sent off of this device before continuing.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    self.logger.deleteLogs()
                    self.logger.createNewLog()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    // Nothing to do here
                }))
                present(alert, animated: true, completion: nil)

            } else {
                logger.createNewLog()
                haveInitialLog = true
            }
            if firstRun {
                let alert = UIAlertController(title: "Warning", message: "Please do not lock the phone using the power button (turning off the screen will interfere with data collection). The automatic screen lock/sleep will be disabled while logging. This message will only be displayed once.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    self.firstRun = false
                    self.startRun()
                }))
                present(alert, animated: true, completion: nil)
            } else {
                startRun()
            }
            startButtonOutlet.setTitle("Stop", for: .normal)
        }else{
            if isRunning {
                stopRun()
                startButtonOutlet.setTitle("Start", for: .normal)
            }
        }
    }
    func startRun() {

        // Make sure Bluetooth is on
        if !advertiser.isOn() || !scanner.isOn() {
            let alert = UIAlertController(title: "Warning", message: "Bluetooth is not on. Please turn it on to continue.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                // Nothing to do here
            }))
            present(alert, animated: true, completion: nil)
            return
        }

        // Write range and angle to the log file
        logger.write("Range,\(range!)")
        logger.write("Angle,\(angle!)")

        // Start sensors
        if LoggerSettings.gpsEnabled {
            sensors.startGPS()
        }
        if LoggerSettings.accelerometerEnabled {
            sensors.startAccelerometer()
        }
        if LoggerSettings.gyroscopeEnabled {
            sensors.startGyroscope()
        }
        if LoggerSettings.proximityEnabled {
            sensors.startProximity()
        }
        if LoggerSettings.compassEnabled {
            sensors.startCompass()
        }
        if LoggerSettings.altimeterEnabled {
            sensors.startAltimeter()
        }
        if LoggerSettings.pedometerEnabled {
            sensors.startPedometer()
        }

        // Start Bluetooth
        advertiser.start()
        scanner.logToFile = true
        scanner.startScanForAll()
        scanner.resetRSSICounts()

        // Override screen auto-lock, so it will stay on
        UIApplication.shared.isIdleTimerDisabled = true

        // Update state
        isRunning = true
    }

    // Stops running
    func stopRun() {

        // Stop sensors
        if LoggerSettings.gpsEnabled {
            sensors.stopGPS()
        }
        if LoggerSettings.accelerometerEnabled {
            sensors.stopAccelerometer()
        }
        if LoggerSettings.gyroscopeEnabled {
            sensors.stopGyroscope()
        }
        if LoggerSettings.proximityEnabled {
            sensors.stopProximity()
        }
        if LoggerSettings.compassEnabled {
            sensors.stopCompass()
        }
        if LoggerSettings.altimeterEnabled {
            sensors.stopAltimeter()
        }
        if LoggerSettings.pedometerEnabled {
            sensors.stopPedometer()
        }

        // Stop Bluetooth
        advertiser.stop()
        scanner.logToFile = false
        scanner.stop()
        stopUpdatingRSSICounts()


        // Restore screen auto-lock
        UIApplication.shared.isIdleTimerDisabled = false

        // Update state
        isRunning = false
    }
    var rsssiTimer: Timer?
    func stopUpdatingRSSICounts() {
        rsssiTimer?.invalidate()
        rsssiTimer = nil
    }
    //MARK: - objc funcs
    @objc func didEnterBackground() {
        if isRunning {

            // Cycle the advertister
            advertiser.stop()
            advertiser.start()

            // Scanner can only scan for one service, and must do so in a timed loop
            scanner.stop()
            scanner.startScanForServiceLoop()

            // Log the state
            logger.write("AppState,Background")
        }
    }

    // When application moves to the foreground, we can restore the original Bluetooth
    // operation
    @objc func willEnterForeground() {
        if isRunning {

            // Cycle the advertister
            advertiser.stop()
            advertiser.start()

            // Switch scanner from one service to everything
            scanner.stopScanForServiceLoop()
            scanner.startScanForAll()

            // Log the state
            logger.write("AppState,Foreground")
        }
    }

    // Called when the proximity sensor is activated
    // If it's on, go into background mode, otherwise, come into foreground mode
    @objc func proximityChanged(notification: NSNotification) {
        let state = UIDevice.current.proximityState ? 1 : 0
        if state == 1 {
            didEnterBackground()
        } else {
            willEnterForeground()
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
