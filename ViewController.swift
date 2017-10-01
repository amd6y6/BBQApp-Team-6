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

class ViewController: UIViewController, GMSMapViewDelegate {

  override func loadView() {

/*    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    */
    
    let camera = GMSCameraPosition.camera(withLatitude: 38.5767, longitude: 92.1735, zoom: 6.0) //Jefferson City's coordinates
    let mapView = GMSMapView.map(withFrame: .zero, camera: camera) //CGRect
    self.view = mapView
    // mapView.mapType = kGMSTypeSatellite //Makes the map look normal (This is used for directions
    
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: 38.5767, longitude: 92.1735)
    marker.title = "Jefferson City"
    marker.snippet = "Missouri"
    marker.map = mapView

    /* Accessability elements
    mapView.accessibilityElementsHidden = false
    My location - A blue dot which shows where I am
    */

    mapView.isMyLocationEnabled = true //This allows a blue dot to appear on Google Maps to showcase the user's location
    if let mylocation = mapView.myLocation {
        print("User's location: \(mylocation)")
    } else {
        print("User's location is unknown")
    }
    // >>> IMPORTANT <<< Learn how users may give or revoke consent

    //GMSMapView.padding
    //39.0997*N 94.5786*W Coordinates of Kansas City
    //
    
    let mapInsets = UIEdgeInsets(top: 40.630114, left: -95.790173, bottom: 35.989040, right: -89.094006)
    mapView.padding = mapInsets
    
    func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 38.5767,
                                              longitude:92.1735,
                                              zoom:14)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
    }
    
    let infoMarker = GMSMarker() //Declaration
    func mapView(_ mapview: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    }
    
    /* SHOW INFORMATION */
    
    }
    }
