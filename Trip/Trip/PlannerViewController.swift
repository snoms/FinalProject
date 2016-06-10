//
//  PlannerViewController.swift
//  Trip
//
//  Created by bob on 07/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import PXGoogleDirections
import CoreLocation

class PlannerViewController: UIViewController {

    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var destField: UITextField!
    let directionsAPI = PXGoogleDirections(apiKey: GoogleAPIkey)

    override func viewDidLoad() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = false
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func planTrip(sender: AnyObject) {
        directionsAPI.mode = PXGoogleDirectionsMode.Transit
        
        //        directionsAPI.departureTime = PXGoogleDirectionsTime
        //        PXGoo
        
        if fromField.text == "" {
            //retrieve current location through CLLocation
            // var curLoc = ^
            // set directionsAPI.from = PXLocation.SpecificLocation(curLoc)
            // continue
        }
        else {
            directionsAPI.from = PXLocation.NamedLocation(fromField.text!)
        }
        
        if destField.text == "" {
            // pop up error
            print("error: must enter destination")
        }
        else {
        directionsAPI.to = PXLocation.NamedLocation(destField.text!)
        }
        
        directionsAPI.calculateDirections({ response in
            switch response {
            case let .Error(_, error):
                // Oops, something bad happened, see the error object for more information
                print(error)
                break
            case let .Success(request, routes):
                // Do your work with the routes object array here
                print("route found")
                print("here it is")
                
                RouteManager.sharedInstance.setRoute(routes)
                
                for routeleg in routes[0].legs[0].steps {
                    //                    print(routeleg.transitDetails)
                    //                    print(routeleg.description)
                    print(routeleg.htmlInstructions!)
                }
                
                break
            }
        })

        
    }
    
    
    
    
    
    
    
}
