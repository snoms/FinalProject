//
//  JourneyViewController.swift
//  Trip
//
//  Created by bob on 09/06/16.
//  Copyright © 2016 bob. All rights reserved.
//
//  View controller for Journey overview. Contains a table view with
//  the steps of the journey and allows users to open that step in 
//  the iOS Maps application.
// 

import UIKit
import PXGoogleDirections
import CoreLocation
import MapKit

class JourneyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var plannedRoute: [PXGoogleDirectionsRoute]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        // NSNC observer to catch the region notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JourneyViewController.catchNotification(_:)) , name: "fenceProx", object: nil)
        loadData()
        tableView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        if RouteManager.sharedInstance.getRoute() != nil {
            plannedRoute = RouteManager.sharedInstance.getRoute()
        }
        else {
            print("error, no route available yet")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (plannedRoute != nil) {
            print("cell count")
            print(plannedRoute![0].legs[0].steps.count)
            return plannedRoute![0].legs[0].steps.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("journeyStepCell", forIndexPath: indexPath) as! journeyStepCell
        
        if indexPath.row == 0 {
            cell.timeLabel.text = plannedRoute?[0].legs[0].departureTime?.description!
        }
        else if indexPath.row == (tableView.numberOfRowsInSection(0) - 1) {
            cell.timeLabel.text = plannedRoute?[0].legs[0].arrivalTime?.description!
        }
        else {
            cell.timeLabel.text = plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.departureTime?.description!
        }
        
        cell.stepTextfield.text = plannedRoute?[0].legs[0].steps[indexPath.row].htmlInstructions!
        cell.motLabel.text = plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.name!
        cell.lineLabel.text = plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.shortName!
        
        if plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails == nil {
            cell.motImage.image = UIImage(named: "walking")
            cell.backgroundColor = UIColor.init(red: 0.0, green: 0.8, blue: 0.2, alpha: 0.075)
        }
        
        if plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.CommuterTrain || plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.HeavyRail || plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.HighSpeedTrain {
            cell.motImage.image = UIImage(named: "train")
            cell.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.075)
        }

        if plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.Subway {
            cell.motImage.image = UIImage(named: "subway")
            cell.backgroundColor = UIColor.init(red: 0.3, green: 0.2, blue: 0.0, alpha: 0.075)
        }
        
        if plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.Tram {
            cell.motImage.image = UIImage(named: "tram")
            cell.backgroundColor = UIColor.init(red: 0.2, green: 0.0, blue: 0.2, alpha: 0.075)
        }
        
        if plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.type! == PXGoogleDirectionsVehicleType.Bus {
            cell.motImage.image = UIImage(named: "bus")
            cell.backgroundColor = UIColor.init(red: 0.0, green: 0.2, blue: 0.8, alpha: 0.075)
        }
        
        cell.stepTextfield.numberOfLines = 2;
        cell.stepTextfield.minimumScaleFactor = 8/UIFont.labelFontSize();
        cell.stepTextfield.adjustsFontSizeToFitWidth = true;
        cell.stepTextfield.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
        
        cell.motLabel.numberOfLines = 1;
        cell.motLabel.minimumScaleFactor = 8/UIFont.labelFontSize();
        cell.motLabel.adjustsFontSizeToFitWidth = true;
        cell.motLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11.0)
        
        cell.lineLabel.numberOfLines = 1;
        cell.lineLabel.minimumScaleFactor = 8/UIFont.labelFontSize();
        cell.lineLabel.adjustsFontSizeToFitWidth = true;
        cell.lineLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
        
        cell.timeLabel.numberOfLines = 1;
        cell.timeLabel.minimumScaleFactor = 8/UIFont.labelFontSize();
        cell.timeLabel.adjustsFontSizeToFitWidth = true;
        cell.timeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true

        return cell
    }
    
    // method to present alert on receiving any NSNotification
    func catchNotification(notification:NSNotification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String else {
                print("No userInfo found in notification")
                return
        }
        let alert = UIAlertController(title: "Wake up!",
                                      message:"You are approaching: \(message). Prepare to disembark!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // method to open the selected journey step cell instructions in Maps
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let openGmaps = UITableViewRowAction(style: .Default, title: "Open in Maps") { (action, indexPath) in
            // compose Apple Maps URL
            let startLatitude = String(format: "%f", (self.plannedRoute?[0].legs[0].steps[indexPath.row].startLocation!.latitude)!)
            let startLongitude = String(format: "%f", (self.plannedRoute?[0].legs[0].steps[indexPath.row].startLocation!.longitude)!)
            let startString = startLatitude + "," + startLongitude
            
            let endLatitude = String(format: "%f", (self.plannedRoute?[0].legs[0].steps[indexPath.row].endLocation!.latitude)!)
            let endLongitude = String(format: "%f", (self.plannedRoute?[0].legs[0].steps[indexPath.row].endLocation!.longitude)!)
            let endString = endLatitude + "," + endLongitude
            
            let mapsString = "http://maps.apple.com/?daddr=" + startString + "&saddr=" + endString

            UIApplication.sharedApplication().openURL(NSURL(string: mapsString)!)
        }
        openGmaps.backgroundColor = self.view.tintColor
        return [openGmaps]
    }
}