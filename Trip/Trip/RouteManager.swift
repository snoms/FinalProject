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
            RouteManager.sharedInstance.transitFences?.append(transitFence)
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
                        var newRadius: CLLocationDistance = 500.00
                        let vehicleType = step.transitDetails?.line?.vehicle?.type!
                        switch vehicleType! {
                            case PXGoogleDirectionsVehicleType.CommuterTrain, PXGoogleDirectionsVehicleType.HeavyRail, PXGoogleDirectionsVehicleType.HighSpeedTrain : newRadius = 3000.00
                            case PXGoogleDirectionsVehicleType.Subway : newRadius = 700.00
                            case PXGoogleDirectionsVehicleType.Tram : newRadius = 500.00
                            case PXGoogleDirectionsVehicleType.Bus : newRadius = 350.00
                            default : break
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
            for (index, fence) in transitFences!.enumerate() {
                do {
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
                            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                        }
                    }, onExit: { temp2 in
                        if index == self.transitFences!.count {
                            self.stopMonitoring()
                        }
                    })
                    fenceRegions!.append(newfence)
                    try self.fenceRegions!.first?.start()
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