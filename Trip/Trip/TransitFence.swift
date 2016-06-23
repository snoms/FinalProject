//
//  TransitFence.swift
//  Trip
//
//  Created by bob on 14/06/16.
//  Copyright © 2016 bob. All rights reserved.
//
//  Defines the TransitFence class which holds coordinates for the Geofence
//

import UIKit
import CoreLocation

class TransitFence {
    // stop variable is a human-readable description of the Geofence
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: Int
    var stop: String
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: Int, stop: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.stop = stop
    }
}