////
////  LocationManager.swift
////  Trip
////
////  Created by bob on 14/06/16.
////  Copyright © 2016 bob. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//
//class LocationManager: CLLocationManager, CLLocationManagerDelegate {
//    
//    static let sharedInstance = LocationManager()
//    
//    var locationManager = CLLocationManager()
//
//    
//    private override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//    
//    
//    
//    
//    
//
//
//
//
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedAlways {
//            print("reached first if block")
//            //            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
//            //                print("reached second if block")
//            //                if CLLocationManager.isRangingAvailable() {
//            //                    print("reached third if block")
//            //                    if let location1: CLLocation! = locationManager.location {
//            //                        print("reached inner if block")
//            //                        let coordinate1: CLLocationCoordinate2D = location1.coordinate
//            //                        // ... proceed with the location and coordintes
//            //                        directionsAPI.from = PXLocation.CoordinateLocation(coordinate1)
//            //                    } else {
//            //                        print("no location...")
//            ////                    }
//            ////                }
//            //            }
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location1:CLLocationCoordinate2D = (locations.last?.coordinate)!
//        print("locations = \(location1.latitude) \(location1.longitude)")
//        if let location1: CLLocation! = locationManager.location {
//            print("reached inner if block")
//            let coordinate1: CLLocationCoordinate2D = location1!.coordinate
//            // ... proceed with the location and coordintes
////            directionsAPI.from = PXLocation.CoordinateLocation(coordinate1)
//        } else {
//            print("no location...")
//            //                    }
//            //                }
//        }
//    }
//    
//
//
////    func startMonitoringGeotification(geotification: TransitFence) {
////        // 1
////        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
////            //            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
////            return
////        }
////        // 2
////        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
////            //            showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
////        }
////        // 3
////        let region = regionWithGeotification(geotification)
////        // 4
////        locationManager.startMonitoringForRegion(region)
////    }
//
//
//}