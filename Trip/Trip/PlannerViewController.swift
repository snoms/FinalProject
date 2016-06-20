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

class PlannerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var destField: UITextField!
    let directionsAPI = PXGoogleDirections(apiKey: GoogleAPIkey)
//    var locationManager: CLLocationManager = CLLocationManager()
    
//    let gpaViewController = GooglePlacesAutocomplete(
//        apiKey: GoogleAPIkey, placeType: .Address)
    @IBOutlet weak var openInGmapsButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func openInGmaps(sender: AnyObject) {
        
        var gmapsURL = "comgooglemaps://"
        
        if self.fromField.text == "" {
            LocationManager.shared.observeLocations(.House, frequency: .OneShot, onSuccess: { location in
                gmapsURL = "comgooglemaps://?saddr=\(location.coordinate))&daddr=,\(self.destField.text)&directionsmode=transit"
                print("success")
                }, onError: { error in
                    print("error in getting location")
                    print(error)
            }) }
    
    
        if self.fromField.text != "" {
            gmapsURL = "comgooglemaps://?saddr=\(self.fromField.text)&daddr=,\(self.destField.text)&directionsmode=transit"
        }
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: gmapsURL)!) {
            UIApplication.sharedApplication().openURL(NSURL(string: gmapsURL)!)
        }
        else {
            var alert = UIAlertController(title: "Error", message: "Google maps not installed", preferredStyle: UIAlertControllerStyle.Alert)
            var ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated:true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = false
        
        self.openInGmapsButton.enabled = false
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
        datePicker.addTarget(self, action: #selector(PlannerViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        directionsAPI.mode = PXGoogleDirectionsMode.Transit
        self.directionsAPI.units = PXGoogleDirectionsUnit.Metric
        directionsAPI.region = "nl"
        

        // Do any additional setup after loading the view, typically from a nib.
        
        LocationManager.shared.observeLocations(.House, frequency: .OneShot, onSuccess: { location in
            print(location.coordinate)
            print("success")
            self.directionsAPI.from = PXLocation.CoordinateLocation(location.coordinate)
        }) { error in
            print("error in getting location")
            print(error)
        }
//        locRequest.start()
//        locRequest.onSuccess { (location) in
//            self.directionsAPI.from = PXLocation.CoordinateLocation(location.coordinate)
//        }
//        locRequest.stop()
        print("Loaded")
        super.viewDidLoad()

    }

    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
//        dateLabel.text = strDate
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
    
    
    func planNewTrip() {
        
    }
    
    @IBAction func planFutureTrip(sender: AnyObject) {
//        directionsAPI.departureTime = strDate
        planTrip(self)
    }
    
    
    
    @IBAction func planTrip(sender: AnyObject) {
        
        //        directionsAPI.departureTime = PXGoogleDirectionsTime
        //        PXGoo
        
        if fromField.text == "" {
            //retrieve current location through CLLocation
            
//            if let location1: CLLocation! = locationManager.location {
//                let coordinate1: CLLocationCoordinate2D = location1!.coordinate
//                
//                // ... proceed with the location and coordintes
//                directionsAPI.from = PXLocation.CoordinateLocation(coordinate1)
//
//            } else {
//                print("no location...")
////            }
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
            
//            var curLoc = locationManager.location
            // continue
            
            
//            LocationManager.shared.observeLocations(.House, frequency: .OneShot, onSuccess: { location in
//                self.directionsAPI.from = PXLocation.CoordinateLocation(location.coordinate)
//                }, onError: { error in
//                    print(error)
//            })
//            
//            
            
            
        }
        else {
            directionsAPI.from = PXLocation.NamedLocation(fromField.text!)
        }
        
        if destField.text == "" {
            // pop up error
            
            let alert = UIAlertController(title: "Error", message: "Destination field may not be empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("error: must enter destination")
        }
        else {
        directionsAPI.to = PXLocation.NamedLocation(destField.text!)
        directionsAPI.calculateDirections({ response in
            switch response {
            case let .Error(_, error):
                // Oops, something bad happened, see the error object for more information
                print(error)
                break
            case let .Success(request, routes):
                // Do your work with the routes object array here
                print("route found")
                print("here it is")
                
                RouteManager.sharedInstance.setRoute(routes)
                self.openInGmapsButton.enabled = true
                for routeleg in routes[0].legs[0].steps {
                    //                    print(routeleg.transitDetails)
                    //                    print(routeleg.description)
                    print(routeleg.htmlInstructions!)
                }
                
//                for leg in routes[0].legs {
//                    for steps in leg.steps {
//                        if steps.transitDetails != nil {
//                            print(steps.transitDetails?.arrivalStop?.location?.latitude)
////                            print("huge loop1")
//                            if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
//                                if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
////                                    print("huge loop2")
//                                    if let newRegion: CLCircularRegion = CLCircularRegion(center: (steps.transitDetails?.arrivalStop?.location)!, radius: 100.0, identifier: (steps.transitDetails?.arrivalStop?.description!)!) {
//                                        newRegion.notifyOnEntry = true
//                                        newRegion.notifyOnExit = false
//                                        self.locationManager.startMonitoringForRegion(newRegion)
////                                        print("huge loop3")
//                                    }
//                                    
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                
//                
                break
            }
        })

        }
    }
}
