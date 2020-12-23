//
//  GoogleMapViewController.swift
//  GoogleMap_demo
//
//  Created by YANBO JIANG on 10/22/20.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import RealmSwift
import MapKit
import GoogleMapsUtils
import CoreMotion
import FirebaseFirestore
import FirebaseFirestoreSwift
//import SwiftSocket

class POIItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var name: String!

  init(position: CLLocationCoordinate2D, name: String) {
    self.position = position
    self.name = name
  }
}

let kClusterItemCount = 10000
var kCameraLatitude = -33.8
var kCameraLongitude = 151.2
class GoogleMapViewController: UIViewController {
    

    //instandtiate a location manager
    var directionManager = DirectionManager()
    private let locationManager = CLLocationManager()
    var arrayPolyline = [GMSPolyline]()
    var selectedRought:String!
    private var clusterManager: GMUClusterManager!
    
    //global Data for deadreckoning
    var from_date = Date()
    var to_date = Date()
    var heading = Double()
    var y_distance = Double()
    var x_distance = Double()
    var current_lat = Double()
    var current_lot = Double()
    let pedometer = CMPedometer()
    let lengthFormatter = LengthFormatter()
    var pedemoterStarted : Bool = false
   
    // MARK: Create source location and destination location so that you can pass it to the URL
    @IBOutlet weak var Map: GMSMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var destinationTextField: UITextField!
    var dataRecieved: String? {
            willSet {
                destinationTextField.text = newValue
            }
        }
    //record current position
    @IBOutlet weak var recording: UIButton!
    @IBAction func record(_ sender: Any) {
        let mylocation = locationdata()
        /*if(locationManager.location!.horizontalAccuracy>10){
            //the case when user indoor, GPS accuracy is low
            //then we use indoor localization "decdreckoning"
            //it calculate from distance(CMpedometer) and north_heading(compass)
            from_date = Date()
            y_distance = 0
            x_distance = 0
            heading = locationManager.location!.course
            print("heading from course")
            print(heading)
            if pedemoterStarted {
                //self.stopCounting()
                self.stopheading()
                //convert meter to latitude and longitude
                
                current_lat = current_lat + x_distance/111.139
                current_lot = current_lot + y_distance/111.139
                print(current_lat,current_lot)
                /*
                let current_location = GMSMarker()
                current_location.position = CLLocationCoordinate2D(latitude:current_lat, longitude: current_lot)
                current_location.title = "current_location"
                current_location.snippet = "Hi"
                current_location.map = self.Map
                */
                let mylocation = locationdata()
                mylocation.id = mylocation.IncrementaID()
                mylocation.latitude = current_lat
                mylocation.longitude = current_lot
                let realm = try! Realm()
                try! realm.write {
                    realm.add(mylocation)
                }
                pedemoterStarted = !pedemoterStarted
                self.recording.setTitle("record init", for: .normal)
            }
            else{
                current_lat = (locationManager.location?.coordinate.latitude)!
                current_lot = (locationManager.location?.coordinate.longitude)!
                print(current_lat,current_lot)
                //self.startCounting()
                self.startHeading()
                print("start counting")
                pedemoterStarted = !pedemoterStarted
                self.recording.setTitle("get recordinhg", for: .normal)
            }
              
        }else{*/
            var currentLoc: CLLocation!
            currentLoc = locationManager.location
            mylocation.id = mylocation.IncrementaID()
            mylocation.latitude = currentLoc.coordinate.latitude
            mylocation.longitude = currentLoc.coordinate.longitude
            kCameraLatitude = mylocation.latitude
            kCameraLongitude = mylocation.longitude
            generateClusterItems()
            // Call cluster() after items have been added to perform the clustering and rendering on map.
            clusterManager.cluster()
        
            let realm = try! Realm()
            try! realm.write {
                realm.add(mylocation)
            }
       // }
    }
    
    //show marker on map
    @IBAction func showdata(_ sender: Any) {
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            let docRef = db.collection("positive_case").document("NJ")
                
            let marker = GMSMarker()
            var location:CLLocationCoordinate2D
            location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
           // marker.map = Map
          //marker.icon = self.imageWithImage(image: UIImage(named: "virus.png")!, scaledToSize: CGSize(width: 30.0, height: 30.0))
            docRef.getDocument { (snapshot, err) in
                if let data = snapshot?.data() {
                    print(data)
                    //location = CLLocationCoordinate2D(latitude: data["lat"], longitude: data["lot"]) as CLLocationCoordinate2D
                } else {
                    print("Couldn't find the document")
                }
            marker.position = location
                marker.map = self.Map

        }
            
    }
        /*
        let circleCenter = CLLocationCoordinate2D(latitude: 40.54719, longitude: -74.33571)
        let circle1 = GMSCircle(position: circleCenter, radius: 5)
        circle1.strokeWidth = 2
        circle1.strokeColor = UIColor.blue
        circle1.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circle1.map = self.Map
        
        let circleCenter1 = CLLocationCoordinate2D(latitude: 40.54887, longitude: -74.33565)
        let circle2 = GMSCircle(position: circleCenter1, radius: 5)
        circle2.strokeWidth = 2
        circle2.strokeColor = UIColor.blue
        circle2.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circle2.map = self.Map
        */
        
        //var iconBase = "https://maps.google.com/mapfiles/kml/shapes/"
        /*
        let realm = try! Realm()
        // Read some data from the bundled Realm
        let results = realm.objects(locationdata.self)
        for a in results {
              let marker = GMSMarker()
            print(a.latitude)
            print(a.longitude)
              marker.position = CLLocationCoordinate2D(latitude: a.latitude, longitude: a.longitude)
              marker.map = Map
            //marker.icon = self.imageWithImage(image: UIImage(named: "virus.png")!, scaledToSize: CGSize(width: 30.0, height: 30.0))
          }
        */
        
        //now show the data from Firebase
        
    }
    
    /*
    func echoService(client: TCPClient) {
        print("Newclient from:\(client.address)[\(client.port)]")
        let d = client.read(1024*10)
        client.send(data: d!)
        client.close()
    }
    
    func testServer() {
        let server = TCPServer(address: "192.168.0.174", port: 80)
        sleep(10)
        print("server listen")
        sleep(3)
        switch server.listen() {
          case .success:
            while true {
                if let client = server.accept(timeout:1000) {
                    echoService(client: client)
                } else {
                    print("accept error")
                }
            }
          case .failure(let error):
            print("server failed")
            print(error)
        }
    }
    */
    
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        Map.isMyLocationEnabled = true
        Map.settings.myLocationButton = true
        Map.delegate = self
        
        directionManager.delegate = self
        destinationTextField.delegate = self
        //testServer()
        let servertask = DispatchQueue(label: "server")
          servertask.async {
           // Add your serial task
          
          }
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: Map, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: Map, algorithm: algorithm, renderer: renderer)
        
        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()

        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
    }
    
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocation) {
      let geocoder = GMSGeocoder()
        let coordinate1:CLLocationCoordinate2D = coordinate.coordinate
      geocoder.reverseGeocodeCoordinate(coordinate1) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
          return
        }
        self.address.text = lines.joined(separator: "\n")
        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }


}

// MARK: - CLLocationManagerDelegate
extension GoogleMapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()
    Map.isMyLocationEnabled = true
    Map.settings.myLocationButton = true
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    Map.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    locationManager.stopUpdatingLocation()
  }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("received heading change")
        if newHeading.headingAccuracy < 0 {
            print("heading change not accuracy")
                    return
        }
        //user change direction in this case
        //time to calculate the distance for the previous heading
        
        //update current time
        to_date = Date()
        var distance = Double()
        
        if CMPedometer.isStepCountingAvailable() {
            pedometer.queryPedometerData(from: from_date, to: to_date) { (data, error) in
                distance = data?.distance as! Double
                print(data)
            }
        }
        y_distance = y_distance+cos(heading)*distance
        x_distance = x_distance+sin(heading)*distance
        print(x_distance,y_distance)
        from_date = to_date
        
        /*
        let heading: CLLocationDirection = ((newHeading.trueHeading > 0) ?
                    newHeading.trueHeading : newHeading.magneticHeading);
        print(newHeading.magneticHeading)
        print("heading")*/
        heading = newHeading.trueHeading
        print(heading)
    }
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print("heading failed with error")
    }
}

// MARK: - GMSMapViewDelegate
extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if let position:CLLocation = self.locationManager.location {
            reverseGeocodeCoordinate(position)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      mapView.animate(toLocation: marker.position)
      if let _ = marker.userData as? GMUCluster {
        mapView.animate(toZoom: mapView.camera.zoom + 1)
        print("You tapped : \(marker.position.latitude),\(marker.position.longitude)")
        NSLog("Did tap cluster")
        return true
      }
      NSLog("Did tap marker")
    print("You tapped : \(marker.position.latitude),\(marker.position.longitude)")
      return false
    }
}


//MARK: - DirectionManagerDelegate
extension GoogleMapViewController: DirectionManagerDelegate{
    func didUpdateLocation(_ directionManager: DirectionManager, direction:DirectionModel){
        DispatchQueue.main.async{
            //change maps
            self.Map.clear()
            print("here")
            print(direction.destination.lat)
            
            let start = GMSMarker()
            start.position = CLLocationCoordinate2D(latitude: direction.origin.lat, longitude: direction.origin.lng)
            start.title = "start point"
            //start.snippet = "Hi"
            start.map = self.Map
            start.icon = GMSMarker.markerImage(with: UIColor.green)
            
            let end = GMSMarker()
            end.position = CLLocationCoordinate2D(latitude: direction.destination.lat, longitude: direction.destination.lng)
            end.title = "end point"
            end.snippet = "Hi"
            end.map = self.Map
            end.icon = GMSMarker.markerImage(with: UIColor.green)
            
            for route in direction.polyline{
                let path = GMSPath.init(fromEncodedPath: route)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 3
                self.Map.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path!), withPadding: 30))
                polyline.map = self.Map
            }
        }
    }
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

extension GoogleMapViewController: UITextFieldDelegate{

    @IBAction func searchPressed(_ sender: UIButton) {
        destinationTextField.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        destinationTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type in the Destination"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let geocoder = CLGeocoder()
         
        if let destination = destinationTextField.text{
            let direction = DirectionList1()
            direction.direction = destination
            direction.time = NSTimeIntervalSince1970;
            let realm = try! Realm()
            try! realm.write {
                realm.add(direction)
            }
            geocoder.geocodeAddressString(destination){(place, error) in
                if error == nil{
                    if let myplace = place?[0]{
                        let geo_destination = myplace.location!
                       print(geo_destination)
                        return
                    }
                }
            }
            
            directionManager.fetchDirection(origin: address.text ?? "", destination: destination)
        }

        destinationTextField.text = ""
    }
}
extension GoogleMapViewController{
    private func generateClusterItems() {
      let extent = 0.2
      for _ in 1...kClusterItemCount {
        let lat = kCameraLatitude + extent * randomScale()
        let lng = kCameraLongitude + extent * randomScale()
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = GMSMarker(position: position)
        clusterManager.add(marker)
      }
    }

    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
      return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            //mapView.clear()
        DispatchQueue.main.async{
            self.Map.clear()
            let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let marker = GMSMarker(position: position)
            
        
        // prepare json data
        var currentLoc: CLLocation!
        currentLoc = self.locationManager.location
        let mylocation = locationdata()
        mylocation.id = mylocation.IncrementaID()
        let x1 = currentLoc.coordinate.latitude
        let y1 = currentLoc.coordinate.longitude
       // let x1 = 40.546323
       // let y1 = -74.3368945
        var location:Array<Array<Double>>
        location = [[]]
        let x2 = coordinate.latitude
        let y2 = coordinate.longitude
       
            let json: [String: Any] = ["A": ["x":x1,"y":y1],
                                   "B": ["x":x2,"y":y2]]

            let jsonData = try? JSONSerialization.data(withJSONObject: json)

            // create post request
            let group = DispatchGroup()
                group.enter()
            let url = URL(string: "http://192.168.1.56:5000/python")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // insert json data to the request
            request.httpBody = jsonData
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    group.leave()
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    //print(responseJSON)
                    guard let location_array = responseJSON["return"] as? Array<Array<Double>> else { return }
                    print("success extract")
                    print(location_array)
                    location = location_array
                    group.leave()
                    /*
                    for location in location_array{
                        if (period%30==0){// take points from every 30 location
                            period = period+1
                            path.add(CLLocationCoordinate2D(latitude: location[0], longitude: location[1]))
                        }
                    }*/
                    //let polyline = GMSPolyline(path:path)
                }
            }
            task.resume()
            group.wait()
            let path = GMSMutablePath()
        
            for my_location in location{
                print("add points")
                if my_location != nil && my_location.count > 0 {
                
                    path.add(CLLocationCoordinate2D(latitude: my_location[0], longitude: my_location[1]))
                    print(my_location)
                }
                
            }
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3
            self.Map.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path), withPadding: 30))
            
            polyline.map = mapView
            marker.title = "Destination"
            marker.map = mapView
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {

        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {

            UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        }
        else {

            let alert = UIAlertController(title: "Google Maps not found", message: "Please install Google Maps in your device.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
}

// Handle the user's selection.
extension GoogleMapViewController{
    
    func startCounting() {
        let date = Date()
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: date) { (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil) {
                        print("\(data!.numberOfSteps)")
                        let distance = data!.distance?.doubleValue
                        let steps = data!.numberOfSteps.doubleValue
                        
                        print(String(steps))
                        print(self.lengthFormatter.string(fromMeters: distance!))

                        
                    } else {
                        print("Pedometer error \(String(describing: error))")
                    }
                })
            }
        } else {
            print("Pedometer is not available")
        }
    }
    
    func stopCounting() {
        self.pedometer.stopUpdates()
    }
    
    func startHeading(){
        print("try heading")
        if (CLLocationManager.headingAvailable()) {
            print("heading start")
            locationManager.headingFilter = 40
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        }
    }

    
    func stopheading(){
        locationManager.stopUpdatingHeading()
    }
    
}
