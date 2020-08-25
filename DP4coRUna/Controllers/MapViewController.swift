//
//  ViewController.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 7/29/20.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift
import Foundation
import SystemConfiguration.CaptiveNetwork

class MapViewController: UIViewController{
    @IBOutlet private var Map: MKMapView!
    @IBOutlet private var TextField: UITextField!
    @IBOutlet weak var ssid: UILabel!
    
    
    private let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?

    
    
    /*
    var currentNetworkInfos: Array<NetworkInfo>? {
            get {
                return SSID.fetchNetworkInfo()
            }
        }
 */
    
    //initialize at Rutgers
    //let initialLocation = CLLocation(latitude: 40.5008, longitude: -74.4474)
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptLocationAccess()
        let a = fetchSSIDInfo()
        print ("SSID: \(Date()): \(a)")
       
    }
/*
    func updateWiFi() {
            print("SSID: \(currentNetworkInfos?.first?.ssid ?? "")")
            self.ssid.text = currentNetworkInfos?.first?.interface
        }  */
    // A permission check function
    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do staff
                    print("location permission granted")
                }
            }
        }
    }*/
    
    private func fetchSSIDInfo() -> String {
            guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
                return "NO-INTERFACE"
            }
            return interfaceNames.compactMap { name in
                guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                    print("Error: CNcopycurrentnetwork not working!!!!!")
                    return nil
                }
                guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                    return nil
                }
                return ssid
                }
                .filter({ (ssid) -> Bool in
                    !ssid.isEmpty
                    }
                )
                .first ?? "NONE"
        }
    
    private func attemptLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else {
          return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
          locationManager.requestWhenInUseAuthorization()
      //      updateWiFi()
            
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
           
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        } else{
          locationManager.requestLocation()
          locationManager.startUpdatingLocation()
       
        }
    }
    
    
}

extension MapViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
  }
}


extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
  //  updateWiFi()
    guard status == .authorizedWhenInUse else {
      return
    }
    manager.requestLocation()
    manager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else {
      return
    }
    // write the location to textfield
    CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
      guard
        let firstPlace = places?.first,
        self.TextField.contents == nil
        else {
          return
      }
      self.currentPlace = firstPlace
        self.TextField.text = firstPlace.abbreviation
       
    }
    let center = CLLocationCoordinate2D(latitude: firstLocation.coordinate.latitude, longitude: firstLocation.coordinate.longitude)
    let myRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    Map.setRegion(myRegion, animated: true)
    
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error requesting location: \(error.localizedDescription)")
  }
}

extension UITextField {
  var contents: String? {
    guard
      let text = text?.trimmingCharacters(in: .whitespaces),
      !text.isEmpty
      else {
        return nil
    }

    return text
  }
}

extension CLPlacemark {
  var abbreviation: String {
    if let name = self.name {
      return name
    }

    if let interestingPlace = areasOfInterest?.first {
      return interestingPlace
    }

    return [subThoroughfare, thoroughfare].compactMap { $0 }.joined(separator: " ")
  }
}
/*
public class SSID {
    class func fetchNetworkInfo() -> [NetworkInfo]? {
        if let interfaces: NSArray = CNCopySupportedInterfaces() {
            var networkInfos = [NetworkInfo]()
            for interface in interfaces {
                let interfaceName = interface as! String
                var networkInfo = NetworkInfo(interface: interfaceName,
                                              success: false,
                                              ssid: nil,
                                              bssid: nil)
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    networkInfo.success = true
                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                }
                networkInfos.append(networkInfo)
            }
            return networkInfos
        }
        return nil
    }
}

struct NetworkInfo {
    var interface: String
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}
*/
