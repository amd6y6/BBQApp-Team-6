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
  import YelpAPI
  import MapKit
  import CoreLocation
  
@objc class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
        
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        struct Location {
            let title: String
            let latitude: Double
            let longitude: Double
        }
        
        let locations = [
            Location(title: "University of Missouri", latitude: 38.940389, longitude:  -92.327748),
            Location(title: "Jared's Jefferson City House", latitude: 38.505166, longitude:  -92.140403),
            Location(title: "Jared's Columbia House", latitude: 38.924261, longitude:  -92.329040),
            Location(title: "Sandman Tiger Express", latitude: 38.909146, longitude:  -92.334114)
        ]
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            map.addAnnotation(annotation)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
                self.map.setRegion(region, animated: true)
                self.map.showsUserLocation = true
                CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
                    if error != nil {
                        print(error)
                    } else {
                        if let placemark = placemarks?[0] {
                            var subThoroughfare = ""
                            if placemark.subThoroughfare != nil {
                                subThoroughfare = placemark.subThoroughfare!
                            }
                            var thoroughfare = ""
                            if placemark.thoroughfare != nil {
                                thoroughfare = placemark.thoroughfare!
                            }
                            var subLocality = ""
                            if placemark.subLocality != nil {
                                subLocality = placemark.subLocality!
                            }
                            var subAdministrativeArea = ""
                            if placemark.subAdministrativeArea != nil {
                                subAdministrativeArea = placemark.subAdministrativeArea!
                            }
                            var postalCode = ""
                            if placemark.postalCode != nil {
                                postalCode = placemark.postalCode!
                            }
                            var country = ""
                            if placemark.country != nil {
                                country = placemark.country!
                            }
                            print(subThoroughfare + " " + thoroughfare + "\n" + subLocality + subAdministrativeArea + "\n" + postalCode + "\n" + country)
                        }
                    }
        
                }
    }
    
  }
  

