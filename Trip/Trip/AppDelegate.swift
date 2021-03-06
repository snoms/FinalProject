//
//  AppDelegate.swift
//  Trip
//
//  Created by bob on 07/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SwiftLocation
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var newlocationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // provide the Google API key for the Google Maps Service
        GMSServices.provideAPIKey(GoogleAPIkey)
        
        // enable IQ Keyboard manager
        IQKeyboardManager.sharedManager().enable = true
        
        // initialize location manager
        initLocationManager()
        
        // from http://stackoverflow.com/questions/33008072/register-notification-in-ios-9
        if application.respondsToSelector("registerUserNotificationSettings:") {
            if #available(iOS 8.0, *) {
                let types:UIUserNotificationType = ([.Alert, .Sound])
                let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            } else {
                application.registerForRemoteNotificationTypes([.Alert, .Sound])
            }
        }
        else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes([.Alert, .Sound])
        }
        
        LocationManager.shared.allowsBackgroundEvents = true
        
        return true
    }
    
    // from http://stackoverflow.com/questions/34869507/device-rotation-in-a-specific-uiviewcontroller-within-uitabbarcontroller-and-uin/34869508#34869508
    func application (application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return checkOrientation(self.window?.rootViewController)
    }
    
    func checkOrientation (viewController: UIViewController?) -> UIInterfaceOrientationMask {
        if viewController is PlannerViewController {
            return UIInterfaceOrientationMask.Portrait
            
        } else if viewController == nil {
            return UIInterfaceOrientationMask.All
        }
        else if viewController is JourneyViewController {
            return UIInterfaceOrientationMask.All
            
        } else if viewController is UITabBarController {
            if let tabBarController = viewController as? UITabBarController,
                navigationViewControllers = tabBarController.viewControllers as? [UINavigationController] {
                return checkOrientation(navigationViewControllers[tabBarController.selectedIndex].visibleViewController)
            } else {
                return UIInterfaceOrientationMask.Portrait
            }
            
        } else {
            return checkOrientation(viewController!.presentedViewController)
        }
    }

    // Location manager from  http://stackoverflow.com/questions/24252645/how-to-get-location-user-whith-cllocationmanager-in-swift
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        newlocationManager = CLLocationManager()
        newlocationManager.delegate = self
        CLLocationManager.locationServicesEnabled()
        newlocationManager.desiredAccuracy = kCLLocationAccuracyBest
        newlocationManager.requestAlwaysAuthorization()
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        newlocationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            print(coord.latitude)
            print(coord.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager!,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            newlocationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        LocationManager.shared.allowsBackgroundEvents = true
        LocationManager.shared.observeLocations(.Block, frequency: .Continuous, onSuccess: { (location) in
            print("background monitored: \(location)")
            }) { (error) in
                print("background error: \(error)")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        RouteManager.sharedInstance.clearRoute()
    }

    func handleRegionEvent(region: CLRegion!) {
        if UIApplication.sharedApplication()
            .applicationState != UIApplicationState.Active {
            let notification = UILocalNotification()
            notification.alertBody = "Wake up, you're approaching \(region.identifier). Get ready!"
            notification.alertAction = "Open Trip"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["message":region.identifier]
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        else {
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName("fenceProx", object: nil, userInfo: ["message":region.identifier])
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
            print("Entered")
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("Region Exited")
        }
    }
}