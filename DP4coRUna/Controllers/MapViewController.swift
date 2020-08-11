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

class MapViewController: UIViewController{
    @IBOutlet private var Map: MKMapView!
    @IBOutlet private var TextField: UITextField!
    
    private let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptLocationAccess()
    }

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
    
    private func attemptLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else {
          return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
          locationManager.requestWhenInUseAuthorization()
        } else {
          locationManager.requestLocation()
        }
    }
    
    
}

extension MapViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
  }
}


extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    manager.requestLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else {
      return
    }
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
