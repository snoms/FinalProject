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
    var identifier: String
//    var eventType: EventType
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
//        self.eventType = eventType
    }
}