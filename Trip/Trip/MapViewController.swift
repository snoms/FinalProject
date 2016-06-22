//
//  MapViewController.swift
//  Trip
//
//  Created by bob on 07/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = true
        // Do any additional setup after loading the view, typically from a nib.
        let mapDims = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - CGRectGetHeight((self.tabBarController?.tabBar.frame)!))
        print(mapDims)
        print(self.view.frame.size.height)
        print(CGRectGetHeight((self.tabBarController?.tabBar.frame)!))
        let camera = GMSCameraPosition.cameraWithLatitude(52.370216,
                                                          longitude: 4.895168, zoom: 10)
        let mapView = GMSMapView.mapWithFrame(mapDims, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        print(mapView.frame.height)
        
        LocationManager.shared.observeLocations(.House, frequency: .OneShot, onSuccess: { location in
            print(location.coordinate)
            print("success")
            mapView.camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13)
            
        }) { error in
            print("error in getting location")
            print(error)
        }
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        self.view = mapView
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(52.370216, 4.895168)
//        marker.title = "Amsterdam"
//        marker.snippet = "The Netherlands"
//        marker.map = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.catchNotification(_:)) , name: "fenceProx", object: nil)
        
//        observer plaatsen die functie triggert
    }

    override func viewWillAppear(animated: Bool) {
        if RouteManager.sharedInstance.getRoute() != nil {
            // Adding polyline of route and centering map on it
            let polyline = RouteManager.sharedInstance.getRoute()!.first?.path
            let camera = GMSCameraPosition.cameraWithLatitude(52.370216,
                                                              longitude: 4.895168, zoom: 10)
            
            let mapDims = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - CGRectGetHeight((self.tabBarController?.tabBar.frame)!))
            let mapView = GMSMapView.mapWithFrame(mapDims, camera: camera)
            mapView.myLocationEnabled = true
            self.view = mapView
            let routePolyline = GMSPolyline(path: polyline)
            routePolyline.strokeWidth = 7.0
//            let spanstyle = GMSStrokeStyle.gradientFromColor(UIColor.redColor(), toColor: UIColor.purpleColor())
//            routePolyline.spans = [GMSStyleSpan(style: spanstyle)]
            let halfPurp = UIColor(hexColor: "7300e6")
//                UIColor(red: 120, green: 0, blue: 210, alpha: 0.8)
            
            routePolyline.strokeColor = self.view.tintColor
            routePolyline.map = mapView
            var bounds = GMSCoordinateBounds()
            for index in 1...polyline!.count() {
                bounds = bounds.includingCoordinate(polyline!.coordinateAtIndex(index))
            }
            mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 80.0))
            // Adding markers to map
            var markers: [GMSMarker] = []
            for fenceMarker in RouteManager.sharedInstance.getTransitFences()! {
                let newmarker = GMSMarker()
                newmarker.position = fenceMarker.coordinate
                newmarker.title = fenceMarker.stop
                newmarker.map = mapView
                markers.append(newmarker)
            }
            
            let departureMarker = GMSMarker()
            departureMarker.position = (RouteManager.sharedInstance.getRoute()!.first?.path?.coordinateAtIndex(0))!
            departureMarker.title = RouteManager.sharedInstance.getRoute()!.first?.legs.first?.startAddress
            departureMarker.map = mapView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func catchNotification(notification:NSNotification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String else {
                print("No userInfo found in notification")
                return
        }
        let alert = UIAlertController(title: "Wake up!",
                                      message:"You are approaching: \(message). Prepare to disembark!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
//    
//    func presentAlert() {
//        //Take Action on Notification
//        print("notification received!")
//        
//        let alert = UIAlertController(title: "Alert!", message: "You're getting close to \(fence.stop). Prepare to disembark!", preferredStyle: .Alert)
//        // Grab the value from the text field, and print it when the user clicks OK.
//        let OKAction = UIAlertAction(title: "Got it!", style: .Default) { (action:UIAlertAction!) in
//        }
//        alert.addAction(OKAction)
//        
//                                self.presentViewController(alert, animated: true, completion: nil)
//        
//        
//    }
    
}

// MARK: - CLLocationManagerDelegate
//1
//
//extension MapViewController: CLLocationManagerDelegate {
//    // 2
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        // 3
//        if status == .AuthorizedWhenInUse {
//            
//            // 4
//            locationManager.startUpdatingLocation()
//            
//            //5
//            mapView.myLocationEnabled = true
//            mapView.settings.myLocationButton = true
//        }
//    }
//    
//    // 6
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            
//            // 7
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            
//            // 8
//            locationManager.stopUpdatingLocation()
//        }
//        
//    }
//}