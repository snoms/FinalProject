//
//  PlannerViewController.swift
//  Trip
//
//  Created by bob on 07/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import PXGoogleDirections
import CoreLocation
import SwiftLocation

class PlannerViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var destField: UITextField!
    
    @IBOutlet weak var currentRoute: UILabel!
    
    @IBOutlet weak var currentDestination: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBAction func clearRoute(sender: AnyObject) {
        RouteManager.sharedInstance.clearRoute()
        hideRouteInfo()
        self.tabBarController?.tabBar.items?[1].enabled = false
        self.tabBarController?.tabBar.items?[2].enabled = false
        self.currentDestination.text = "No route loaded!"
    }
    
    let directionsAPI = PXGoogleDirections(apiKey: GoogleAPIkey)
    override func viewDidLoad() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appdelegate.shouldSupportAllOrientation = false
        
        // configure status label
        self.currentDestination.numberOfLines = 3
        self.currentDestination.minimumScaleFactor = 8/UIFont.labelFontSize()
        self.currentDestination.adjustsFontSizeToFitWidth = true
        self.currentDestination.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.currentDestination.text = "No route loaded!"
        
        hideRouteInfo()
        fromField.delegate = self
        destField.delegate = self
        self.fromField.placeholder = ""
        
        // configure the PXGoogleDirections instance for transit
        directionsAPI.mode = PXGoogleDirectionsMode.Transit
        self.directionsAPI.units = PXGoogleDirectionsUnit.Metric
        directionsAPI.region = "nl"
        
        // disable the tab bar items for now
        self.tabBarController?.tabBar.items?[1].enabled = false
        self.tabBarController?.tabBar.items?[2].enabled = false
        
        // request location and use it as default departure location if response is ok
        getLocation()
        print("Loaded")
        super.viewDidLoad()
    }
    
    func showRouteInfo() {
//        currentDestination.hidden = false
//        currentRoute.hidden = false
//        clearButton.hidden = false
        if RouteManager.sharedInstance.getRoute() != nil {
            clearButton.enabled = true
        }
    }
    
    func hideRouteInfo() {
//        currentDestination.hidden = true
//        currentRoute.hidden = true
//        clearButton.hidden = true
        clearButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        getLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedAlways {
//            print("reached first if block")
////            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
////                print("reached second if block")
////                if CLLocationManager.isRangingAvailable() {
////                    print("reached third if block")
////                    if let location1: CLLocation! = locationManager.location {
////                        print("reached inner if block")
////                        let coordinate1: CLLocationCoordinate2D = location1.coordinate
////                        // ... proceed with the location and coordintes
////                        directionsAPI.from = PXLocation.CoordinateLocation(coordinate1)
////                    } else {
////                        print("no location...")
//////                    }
//////                }
////            }
//        }
//    }
////    
////    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location1:CLLocationCoordinate2D = (locations.last?.coordinate)!
//        print("locations = \(location1.latitude) \(location1.longitude)")
//        if let location1: CLLocation! = locationManager.location {
//            print("reached inner if block")
//            let coordinate1: CLLocationCoordinate2D = location1!.coordinate
//            // ... proceed with the location and coordintes
//            directionsAPI.from = PXLocation.CoordinateLocation(coordinate1)
//        } else {
//            print("no location...")
//            //                    }
//            //                }
//        }
//    }
    
    func getCoreLocation() {
        
    }

    func getLocation() {
        LocationManager.shared.observeLocations(.Block, frequency: .Continuous, onSuccess: { location in
            print(location.coordinate)
            print("getLocation success")
            self.fromField.placeholder = "Current location"
            self.directionsAPI.from = PXLocation.CoordinateLocation(location.coordinate)
        }) { error in
            print("error in getLocation")
            print(error)
            // TODO: error alert saying location could not be retrieved
        }
    }
    
    @IBAction func planTrip(sender: AnyObject) {
        
        // if departure field is not empty, use that text as departure point
        if fromField.text == "" {
            // if location not filled in yet, retry location
            if self.directionsAPI.from == nil {
                getLocation()
            }
        }
        else {
            directionsAPI.from = PXLocation.NamedLocation(fromField.text!)
        }
        
        // check if destination field is empty
        if destField.text == "" {
            // pop up error because we need a destination
            let alert = UIAlertController(title: "Error", message: "Destination field may not be empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("error: must enter destination")
        }
        else {
            // time to retrieve directions
            directionsAPI.to = PXLocation.NamedLocation(destField.text!)
            directionsAPI.calculateDirections({ response in
            switch response {
            
                // error occurred, alert user and break request
                case let .Error(_, error):
                    print(error)
                    let alert = UIAlertController(title: "Error", message: "Could not get route from Google", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("error: must enter destination")
                    break
                    
                // route retrieved, show rejectable route preview to user
                case let .Success(request, routes):
                    print("route found")
                    let previewDepart = routes.first?.legs.first?.startAddress!
                    let previewArrive = routes.first?.legs.first?.endAddress
                    let previewDuration = routes.first?.legs.first?.duration?.description!
                    var previewDepartTime = "unavailable"
                    var previewArriveTime = "unavailable"
                    
                    if routes.first?.legs.first?.departureTime?.description! != nil {
                        previewDepartTime = (routes.first?.legs.first?.departureTime?.description!)!
                    }
                    
                    if routes.first?.legs.first?.arrivalTime?.description! != nil {
                        previewArriveTime = (routes.first?.legs.first?.arrivalTime?.description!)!
                    }
                    
                    let routeAlertPreview = UIAlertController(title: "Route suggestion", message: "Journey from:\n\(previewDepart!) \n Depart at: \(previewDepartTime) \n\nto:\n\(previewArrive!) \n Arrive at: \(previewArriveTime) \n\n Trip time: \(previewDuration!).", preferredStyle: .Alert)
                    
                    // on acceptance of proposal load the route in singleton and enable tab bar
                    let acceptAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        self.tabBarController?.tabBar.items?[1].enabled = true
                        self.tabBarController?.tabBar.items?[2].enabled = true
                        RouteManager.sharedInstance.setRoute(routes)
                        self.showRouteInfo()
                        self.currentDestination.text = RouteManager.sharedInstance.getRoute()!.first?.legs.first?.endAddress
    //                    self.openInGmapsButton.enabled = true
                    }
                    
                    // make cancel button
                    let cancelAction = UIAlertAction(title: "Refuse", style: UIAlertActionStyle.Destructive) {
                        UIAlertAction in
                    }
                    
                    // add buttons to alert controller and present it
                    routeAlertPreview.addAction(cancelAction)
                    routeAlertPreview.addAction(acceptAction)
                    self.presentViewController(routeAlertPreview, animated: true, completion: nil)
                    break
                }
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
