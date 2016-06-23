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
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mapDims = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - CGRectGetHeight((self.tabBarController?.tabBar.frame)!))
        let camera = GMSCameraPosition.cameraWithLatitude(52.370216,
                                                          longitude: 4.895168, zoom: 10)
        let mapView = GMSMapView.mapWithFrame(mapDims, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        LocationManager.shared.observeLocations(.House, frequency: .OneShot, onSuccess: { location in
            mapView.camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13)
        }) { error in
            print(error)
        }
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        self.view = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // NSNC observer to catch the region notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.catchNotification(_:)) , name: "fenceProx", object: nil)
        super.viewDidLoad()
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
            
            // configure polyline
            let routePolyline = GMSPolyline(path: polyline)
            routePolyline.strokeWidth = 7.0
            routePolyline.strokeColor = self.view.tintColor
            routePolyline.map = mapView
            var bounds = GMSCoordinateBounds()
            
            // plot polyline
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
    
    // method to present alert on receiving any NSNotification
    func catchNotification(notification:NSNotification) -> Void {
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String else {
                return
        }
        let alert = UIAlertController(title: "Wake up!",
                                      message:"You are approaching: \(message). Prepare to disembark!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}