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
    
    static let sharedInstance = RouteManager()
    
    private init() { }
    
    private var plannedRoute: [PXGoogleDirectionsRoute]?
    
    private var transitFences: [TransitFence]? = []
    
    private var fenceRegions: [RegionRequest]? = []
    
    func getRoute() -> [PXGoogleDirectionsRoute]? {
        if plannedRoute != nil {
            return plannedRoute
        }
        else {
            return nil
        }
    }
    
    func setRoute(newRoute: [PXGoogleDirectionsRoute]) {
        plannedRoute = newRoute
        detectTransitStops()
        startMonitoring()
        startFenceMonitors()
    }
    
    func appendFence(transitFence: TransitFence) {
        if plannedRoute != nil {
            print("append")
//            print(getRoute()!.first!.legs.first!.steps.first!.transitDetails)
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
    
    func detectTransitStops() {
        if getRoute() != nil {
            for (index, step) in ((getRoute()?.first!.legs.first!.steps)?.enumerate())! {
                if step.transitDetails != nil {
                    if step.travelMode == PXGoogleDirectionsMode.Transit {
                        print("transit point found")
                        //                    appendFence
                        let newFence = TransitFence(coordinate: step.transitDetails!.arrivalStop!.location!, radius: 500.00, identifier: index, stop: (step.transitDetails!.arrivalStop?.description)!)
                        appendFence(newFence)
                    }
                }
            }
        }
    }
    
    func startMonitoring() {
        if transitFences != nil {
            print("this = \(transitFences!.first!.stop))")
            for fence in transitFences! {
                do {
                    print("equal to =\(fence.stop)")
                    let newfence = try BeaconManager.shared.monitorGeographicRegion(fence.stop, centeredAt: fence.coordinate, radius: fence.radius, onEnter: { temp in
                        
                        let nc = NSNotificationCenter.defaultCenter()
                        nc.postNotificationName("fenceProx", object: nil, userInfo: ["message":fence.stop])
                        
                        var notification = UILocalNotification()
                        notification.fireDate = NSDate()
                        notification.alertBody = "Wake up, you're approaching \(fence.stop). Get ready!"
                        notification.alertAction = "open"
                        notification.soundName = UILocalNotificationDefaultSoundName
                        notification.userInfo = ["message":fence.stop]
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//                        notification.region = BeaconManager.
                        
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

    
    
    func startFenceMonitors() {
        for fence in transitFences! {
            regionWithGeotification(fence)
        }
    }

    func getTransitFences() -> [TransitFence]? {
        if transitFences != nil {
            return transitFences
        }
        else {
            return nil
        }
    }
    
    func regionWithGeotification(geotification: TransitFence) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.stop)
        // 2
        region.notifyOnEntry = true
//        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    
}