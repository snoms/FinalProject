//
//  RouteManager.swift
//  Trip
//
//  Created by bob on 09/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import PXGoogleDirections
import CoreLocation
import SwiftLocation

class RouteManager {
    
    // initiate singleton as sharedInstance
    static let sharedInstance = RouteManager()
    
    private init() { }
    
    // declare private variables for the route, its fences and the relevant regions
    private var plannedRoute: [PXGoogleDirectionsRoute]?
    
    private var transitFences: [TransitFence]? = []
    
    private var fenceRegions: [RegionRequest]? = []
    
    // function to expose route
    func getRoute() -> [PXGoogleDirectionsRoute]? {
        if plannedRoute != nil {
            return plannedRoute
        }
        else {
            return nil
        }
    }
    
    func clearRoute() {
        stopMonitoring()
        plannedRoute = []
        transitFences = []
        fenceRegions = []
    }
    
    func stopMonitoring() {
        if fenceRegions != nil {
            for fence in fenceRegions! {
                BeaconManager.shared.stopMonitorGeographicRegion(request: fence)
            }
        }
    }
    
    // function to load route and execute fence extraction sequence, and start monitoring
    func setRoute(newRoute: [PXGoogleDirectionsRoute]) {
        clearRoute()
        plannedRoute = newRoute
        detectTransitStops()
        startMonitoring()
    }
    
    // appending the fences of the route to our array of fences
    func appendFence(transitFence: TransitFence) {
        if plannedRoute != nil {
            print("append")
            print("transitfence:\(transitFence)")
            print("transitfenceID: \(transitFence.stop)")
            print(RouteManager.sharedInstance.transitFences)
            RouteManager.sharedInstance.transitFences?.append(transitFence)
            print("appended")
            print("first fence: \(RouteManager.sharedInstance.transitFences?.first?.stop)")
        }
        else {
            print("no route to append fence")
        }
    }
    
    // function to extract the pertinent transit stops and create fences
    func detectTransitStops() {
        if getRoute() != nil {
            for (index, step) in ((getRoute()?.first!.legs.first!.steps)?.enumerate())! {
                if step.transitDetails != nil {
                    if step.travelMode == PXGoogleDirectionsMode.Transit {
                        print("transit point found")
                        var newRadius: CLLocationDistance = 500.00
                        
                        if step.transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.CommuterTrain || step.transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.HeavyRail || step.transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.HighSpeedTrain {
                            newRadius = 5000.00
                        }
                        
                        if step.transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.Subway {
                            newRadius = 2250.00
                        }
                        
                        if step.transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.Tram {
                            newRadius = 500.00
                        }
                        
                        if step.transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.Bus {
                            newRadius = 400.00
                        }
                        let newFence = TransitFence(coordinate: step.transitDetails!.arrivalStop!.location!, radius: newRadius, identifier: index, stop: (step.transitDetails!.arrivalStop?.description)!)
                        appendFence(newFence)
                    }
                }
            }
        }
    }
    
    // initiate region monitoring for our fences
    func startMonitoring() {
        if transitFences != nil {
//            print("this = \(transitFences!.first!.stop))")
            for fence in transitFences! {
                do {
                    print("equal to =\(fence.stop)")
                    let newfence = try BeaconManager.shared.monitorGeographicRegion(fence.stop, centeredAt: fence.coordinate, radius: fence.radius, onEnter: { temp in
                        
                        // post notification through notification center for when user is in app
                        let nc = NSNotificationCenter.defaultCenter()
                        nc.postNotificationName("fenceProx", object: nil, userInfo: ["message":fence.stop])
                        
                        // create notification to be pushed locally when app is in background
                        if UIApplication.sharedApplication()
                            .applicationState != UIApplicationState.Active {
                            let notification = UILocalNotification()
                            notification.alertBody = "Wake up, you're approaching \(fence.stop). Get ready!"
                            notification.alertAction = "Open Trip"
                            notification.soundName = UILocalNotificationDefaultSoundName
                            notification.userInfo = ["message":fence.stop]
                            //                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                            //                        notification.region = BeaconManager.

                            
                        }
                        
                        
                        
                        
//                        let alert = UIAlertController(title: "Alert!", message: "You're getting close to \(fence.stop). Prepare to disembark!", preferredStyle: .Alert)
//                                                // Grab the value from the text field, and print it when the user clicks OK.
//                        let OKAction = UIAlertAction(title: "Got it!", style: .Default) { (action:UIAlertAction!) in
//                        }
//                        alert.addAction(OKAction)
//
////                        self.presentViewController(alert, animated: true, completion: nil)
//
//                        
//                            print("entered region\(fence.stop)")
//                            print(temp)
//                        
                        }, onExit: { temp2 in
                            print("left region \(fence.stop)")
                            print(temp2)
                    })

                    fenceRegions!.append(newfence)
                    print("started monitoring")
                    print("Firstfenceprint: \(fenceRegions!.first)")
                    
                    
                    
                } catch {
                    print(error)
                }
            }
        }
    }

    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        print("notification received!")
    }

    func getTransitFences() -> [TransitFence]? {
        if transitFences != nil {
            return transitFences
        }
        else {
            return nil
        }
    }
    
//    func regionWithGeotification(geotification: TransitFence) -> CLCircularRegion {
//        // 1
//        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.stop)
//        // 2
//        region.notifyOnEntry = true
////        region.notifyOnExit = !region.notifyOnEntry
//        return region
//    }
    
    
}