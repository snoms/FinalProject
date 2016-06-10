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
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("CALLED NUMBER OF ROWS IN SECTION")
        print(plannedRoute)
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
        cell.stepTextfield.text = "test"

        cell.stepTextfield.text = plannedRoute?[0].legs[0].steps[indexPath.row].htmlInstructions!
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

}