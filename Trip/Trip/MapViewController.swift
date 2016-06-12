//
//  MapViewController.swift
//  Trip
//
//  Created by bob on 07/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import GoogleMaps

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
            
        let camera = GMSCameraPosition.cameraWithLatitude(52.370216,
                                                          longitude: 4.895168, zoom: 10)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(52.370216, 4.895168)
        marker.title = "Amsterdam"
        marker.snippet = "The Netherlands"
        marker.map = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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