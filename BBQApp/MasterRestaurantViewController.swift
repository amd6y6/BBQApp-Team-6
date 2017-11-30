//
//  MasterRestaurantViewController.swift
//  BBQApp
//
//  Created by Christopher King on 11/12/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit
import CoreLocation

class MasterRestaurantViewController: UIViewController {

    //necessary variables and outlets for segment control and location on restaurants tab
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkGray
        //set up the delegates and request user access first time app is ran
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //decides which view controller to call based on segement control selection
    private func setupView(){
        setupSegmentedControl()
        updateView()
    }
    
    //segment control implementation
    private func setupSegmentedControl(){
        segmentedControl.removeAllSegments()
        segmentedControl.isUserInteractionEnabled = false
        segmentedControl.insertSegment(withTitle: "List", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Map", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1

    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    //call the yelp api controller
    private lazy var ylpTableViewController: YLPSearchTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "YLPSearchTableViewController") as! YLPSearchTableViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    //call the maps view controller
    private lazy var googleMapsViewController: GoogleMapsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "GoogleMapsViewController") as! GoogleMapsViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    //switches the controller
    private func add(asChildViewController viewController: UIViewController){
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    //removes current view controller making switch to other available
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }

    //updates the view with the corret controller based off of segment control index
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: googleMapsViewController)
            add(asChildViewController: ylpTableViewController)
        } else {
            remove(asChildViewController: ylpTableViewController)
            add(asChildViewController: googleMapsViewController)
        }
    }

}

//extension deals with the delegation of the current location and makes it available to send to other necessary controllers
extension MasterRestaurantViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.userLocation = location
        self.ylpTableViewController.userLocation = location
        self.ylpTableViewController.tableView.reloadData()
        self.googleMapsViewController.userLocation = location
        self.segmentedControl.isUserInteractionEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
