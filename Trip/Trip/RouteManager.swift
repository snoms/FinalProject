//
//  RouteManager.swift
//  Trip
//
//  Created by bob on 09/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import PXGoogleDirections

class RouteManager {
    
    static let sharedInstance = RouteManager()
    
    private init() { }
    
    private var plannedRoute: [PXGoogleDirectionsRoute]?
    
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
    }

}