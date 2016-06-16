//
//  TransitFence.swift
//  Trip
//
//  Created by bob on 14/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import CoreLocation

//enum EventType: Int {
//    case OnEntry = 0
//    case OnExit
//}

class TransitFence {
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: Int
    var stop: String
//    var eventType: EventType
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: Int, stop: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.stop = stop
//        self.eventType = eventType
    }
}