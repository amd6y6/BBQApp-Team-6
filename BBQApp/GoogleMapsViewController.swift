  /*
 * Copyright 2016 Google Inc. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import UIKit
import GoogleMaps
import GooglePlaces
import YelpAPI

  
class GoogleMapsViewController: UIViewController, GMSMapViewDelegate {

   // let infoMarker = GMSMarker() //Declaration
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    var mapView : GMSMapView! //CGRect
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.0

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 38.9517, longitude: -92.3341, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        
        view.addSubview(mapView)
        mapView.isHidden = false
        
    
    }
    
    
//    func mapView(_ mapview: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
//        infoMarker.snippet = placeID
//        infoMarker.position = location
//        infoMarker.title = name
//        infoMarker.opacity = 0
//        infoMarker.infoWindowAnchor.y = 1
//        infoMarker.map = mapView
//        mapView.selectedMarker = infoMarker
//    }
    
//  override func loadView() {
//    mapView()
//    let camera = GMSCameraPosition.camera(withTarget: currentLocation!, zoom: 12.0) //Columbia coordinates
//
//    // FOR FUTURE USE
//    // let camera = GMSCameraPosition.camera(withLatitude: <(User position + destination) / 2>, longitude: <(User position + destination) / 2>
//
//    mapView.settings.scrollGestures = true
//    mapView.settings.zoomGestures = true
//    self.view = mapView
//
//    mapView.setMinZoom(10, maxZoom:15)
////    mapView.frame = mapView.bounds;
////    mapView.addSubview(mapView)
//
////    mapView.mapType = kGMSTypeSatellite //Makes the map look normal (This is used for directions)
//    let marker = GMSMarker()
//    //marker.position = CLLocationCoordinate2D(latitude: 38.9517, longitude: -92.3341)
//    marker.position = CLLocationCoordinate2D!(currentLocation!)
//    marker.title = "Columbia"
//    marker.snippet = "Missouri"
//    marker.map = mapView
//    mapView.accessibilityElementsHidden = false
//    mapView.isMyLocationEnabled = true //This allows a blue dot to appear on Google Maps to showcase the user's location
//    let mapInsets = UIEdgeInsets(top: 40.630114, left: -95.790173, bottom: 35.989040, right: -89.094006)
//    mapView.padding = mapInsets
//    }
//
  }
  extension GoogleMapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location = \(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
       // listLikelyPlaces()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location was restricted")
        case .denied:
            print("User denied access to location")
            mapView.isHidden = false
        case .notDetermined:
            print("Location not determined")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
  }
