//
//  JourneyViewController.swift
//  Trip
//
//  Created by bob on 09/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import PXGoogleDirections
import CoreLocation

class JourneyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    

//        
//        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
//            UIApplication.sharedApplication().openURL((NSURL(string:
//                "comgooglemaps://?saddr=\(RouteManager.sharedInstance.getRoute()?.first?.path?.coordinateAtIndex(0))&daddr=,\(RouteManager.sharedInstance.getRoute()?.last?.path?.coordinateAtIndex(0))&directionsmode=transit")!))
//            
//        } else {
//            NSLog("Can't use comgooglemaps://");
//        }
//    
//        
        
        
    
    
    
    
    var plannedRoute: [PXGoogleDirectionsRoute]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
//        if (RouteManager.sharedInstance.getRoute() != nil) {
//            plannedRoute = RouteManager.sharedInstance.getRoute()
//            print("ok")
//            for routeleg in plannedRoute![0].legs[0].steps {
//                //                    print(routeleg.transitDetails)
//                //                    print(routeleg.description)
//                print(routeleg.htmlInstructions!)
//                print(plannedRoute![0].legs[0].steps.count)
//                print(plannedRoute?.description)
//            }
//            
//        }
//        else {
//            print("error in viewdidload if let")
//        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JourneyViewController.catchNotification(_:)) , name: "fenceProx", object: nil)
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
            print("route loaded")
        }
        else {
            print("error, no route available yet")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print("CALLED NUMBER OF ROWS IN SECTION")
//        print(plannedRoute)
        if (plannedRoute != nil) {
            print("cell count")
            print(plannedRoute![0].legs[0].steps.count)
            return plannedRoute![0].legs[0].steps.count
        }
        else {
            return 10
        }
    }
    
    @IBAction func updateTable(sender: AnyObject) {
        
        if (RouteManager.sharedInstance.getRoute() != nil) {
            plannedRoute = RouteManager.sharedInstance.getRoute()
            print("ok")
            for routeleg in plannedRoute![0].legs[0].steps {
                //                    print(routeleg.transitDetails)
                //                    print(routeleg.description)
                print(routeleg.htmlInstructions!)
                print(plannedRoute![0].legs[0].steps.count)
                print(plannedRoute?.description)
            }
        }
        else {
            print("error in viewdidload if let")
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        if plannedRoute != nil {

        let cell = self.tableView.dequeueReusableCellWithIdentifier("journeyStepCell", forIndexPath: indexPath) as! journeyStepCell
        print("CALLED CELL FOR ROW AT INDEX")
        
        
        if indexPath.row == 0 {
            cell.timeLabel.text = NSDate(timeInterval: plannedRoute?[0].legs[0].departureTime?.timestamp!).time
        }
        else {
            cell.timeLabel.text = plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.departureTime?.description!
        }
        
        cell.stepTextfield.text = plannedRoute?[0].legs[0].steps[indexPath.row].htmlInstructions!
        
        cell.motLabel.text = plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.vehicle?.name!
        
        cell.lineLabel.text = plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.line?.shortName!
        
//        cell.timeLabel.text = plannedRoute?[0].legs[0].steps[indexPath.row].transitDetails?.
        
        
        cell.stepTextfield.numberOfLines = 1;
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
        cell.timeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11.0)
        
        cell.trackLabel.numberOfLines = 1;
        cell.trackLabel.minimumScaleFactor = 8/UIFont.labelFontSize();
        cell.trackLabel.adjustsFontSizeToFitWidth = true;
        cell.trackLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11.0)
        
        cell.motImage.image = UIImage(named: "status_icon")
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true


        
        
//        cell.todoTextfield.numberOfLines = 1;
//        cell.todoTextfield.minimumScaleFactor = 8/UIFont.labelFontSize();
//        cell.todoTextfield.adjustsFontSizeToFitWidth = true;
//        cell.todoTextfield.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
//        cell.layoutMargins = UIEdgeInsetsZero
//        cell.layer.cornerRadius = 5
//        cell.layer.masksToBounds = true
//        if TodoManager.sharedInstance.todolists[listID].getTodos()[indexPath.row].getStatus() {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//            cell.backgroundColor = completedColor
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryType.None
//            cell.backgroundColor = clearColor
//        }
        return cell
        }
//        else {
//            print("error in cell creation")
//            return
//        }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        let todo = TodoManager.sharedInstance.todolists[listID].getTodos()[indexPath.row]
//        todo.toggleStatus()
//        if todo.getStatus() {
//            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
//            cell?.backgroundColor = completedColor
//        }
//        else {
//            cell?.accessoryType = UITableViewCellAccessoryType.None
//            cell?.backgroundColor = clearColor
//        }
//        TodoManager.sharedInstance.saveTodos()
//    }
    
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


}