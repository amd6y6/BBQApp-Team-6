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
  
  
  class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{//GMSMapViewDelegate {
    
    //outlets and location variables
    @IBOutlet weak var map: MKMapView!
    var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else { return }
            //setting the view of the map to direct to the users location
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            let latDelta: CLLocationDegrees = 0.15
            let longDelta: CLLocationDegrees = 0.15
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
            //displaying correct markers based on the users location
            let coordinate = YLPCoordinate(latitude: latitude, longitude: longitude)
            AppDelegate.sharedClient()?.search(with: coordinate, term: nil, limit: 50, offset: 0, categoryFilter: ["bbq"], sort: YLPSortType.distance, completionHandler: { (search, error) in
                for business in search?.businesses ?? [] {
                    print(business)
                    let annotation = MKPointAnnotation()
                    annotation.title = business.name
                    
                    if let lat = business.location.coordinate?.latitude, let long = business.location.coordinate?.longitude {
                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        self.map.addAnnotation(annotation)
                    }
                }
            })
            
            //finding the exact location of the user and printing it to the console for testing purposes
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if error != nil {
                    print(error!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //struct to hold the name, latitude, and longitude of the array sent from yelp
        struct Location {
            let name: String
            let latitude: Double
            let longitude: Double
        }
    }
    
  }
  
