//
//  GoogleMapsViewController.swift
//  BBQApp
//
//  Created by Robert Backus on 10/15/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func loadView() {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
        
    let camera = GMSCameraPosition.camera(withLatitude: 38.5767, longitude: -92.1735, zoom: 12.0) //Jefferson City's coordinates
    let mapView = GMSMapView.map(withFrame: .zero, camera: camera) //CGRect
    self.view = mapView
    mapView.setMinZoom(10, maxZoom:15)
    
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: 38.5767, longitude: -92.1735)
    marker.title = "Jefferson City"
    marker.snippet = "Missouri"
    marker.map = mapView
        
    //Accessability elements
    mapView.accessibilityElementsHidden = false
    mapView.isMyLocationEnabled = true //This allows a blue dot to appear on Google Maps to showcase the user's location
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
        print("User's location is unknown")
        }
        
        let mapInsets = UIEdgeInsets(top: 40.630114, left: -95.790173, bottom: 35.989040, right: -89.094006)
        mapView.padding = mapInsets
        
        func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 38.5767,
            longitude: -92.1735,
            zoom:12)
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
            infoMarker.opacity = 0
            infoMarker.infoWindowAnchor.y = 1
            infoMarker.map = mapView
            mapView.selectedMarker = infoMarker
        }
        
        /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

         override func loadView() {
         
         var locationManager = CCLocationManager()
         var currentLocation: CCLocation?
         
         let camera = GMSCameraPosition.camera(withLatitude: 38.5767, longitude: -92.1735, zoom: 12.0) //Jefferson City's coordinates
         let mapView = GMSMapView.map(withFrame: .zero, camera: camera) //CGRect
         self.view = mapView
         mapView.setMinZoom(10, maxZoom:15)
         
         let marker = GMSMarker()
         marker.position = CLLocationCoordinate2D(latitude: 38.5767, longitude: -92.1735)
         marker.title = "Jefferson City"
         marker.snipper = "Missouri"
         marker.map = mapView
         
         // IMPORTANT - Users must know that they are giving or revoking consent to use their location
         mapView.accessibilityElementsHidden = false //Accessibility Elements
         mapView.isMyLocationEnabled = true //Allows a blue dot to appear at the user's location
         
         if let mylocation = mapView.myLocation {
         print("User's location: \(mylocation)")
         } else {
         print("User's location is unknown")
         }
         
         //Map Bounderies
         let mapInsets = UIEdgeInsets(top: 40.630114, left: -95.790173, bottom: 35.989040, -89.094006)
         
         let infoMarker = GMSMarker() //Declaration of markers
         func mapView(_ mapview: GMSMapView, didTapPOIWithPlaceID placeID: String,
         name: String, location: CLLocationCoordinate2D) {
         infoMarker.snippet = placeID
         infoMarker.position = location
         infoMarker.title = name
         infoMarker.opacity = 0
         infoMarker.infoWindowAnchor.y = 1
         infoMarker.map = mapView
         }
         } //END override func loadView
         }
    */

}
}
