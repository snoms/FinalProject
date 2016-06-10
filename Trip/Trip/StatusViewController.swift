//
//  StatusViewController.swift
//  Trip
//
//  Created by bob on 07/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import PXGoogleDirections

class StatusViewController: UIViewController {

    @IBOutlet weak var statusField: UILabel!
    
    @IBAction func updateStatus(sender: AnyObject) {
        
        
    }
    
    var plannedRoute: [PXGoogleDirectionsRoute]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if RouteManager.sharedInstance.getRoute() != nil {
            plannedRoute = RouteManager.sharedInstance.getRoute()
            statusField.text = "Route is loaded"
//            statusField.text = plannedRoute![0].summary
//            statusField.text = "TEST"
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

}

