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

class RouteManager {
    
    static let sharedInstance = RouteManager()
    
    private init() { }
    
    private var plannedRoute: [PXGoogleDirectionsRoute]?
    
    private var transitFences: [TransitFence]?
    
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
        appendFences()
    }
    
    func appendFences() {
        if plannedRoute != nil {
            print(plannedRoute![plannedRoute!.startIndex].legs[plannedRoute!.startIndex])
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
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = true
//        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    
}