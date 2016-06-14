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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
//    let locationManager = CLLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(GoogleAPIkey)
        
        
        // http://stackoverflow.com/questions/33008072/register-notification-in-ios-9
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
        
        
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    var shouldSupportAllOrientation = false
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if (shouldSupportAllOrientation == true){
            return UIInterfaceOrientationMask.All
        }
        return UIInterfaceOrientationMask.Portrait
    }

    func handleRegionEvent(region: CLRegion!) {
        print("Geofence triggered!")
    }
    
    func regionWithGeotification(geotification: TransitFence) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
//        region.notifyOnEntry = (geotification.eventType == .OnEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoringGeotification(geotification: TransitFence) {
        // 1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
//            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
//            showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
        }
        // 3
        let region = regionWithGeotification(geotification)
        // 4
        locationManager.startMonitoringForRegion(region)
    }
    
    
    
    
    
//    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
//        if region is CLCircularRegion {
//            handleRegionEvent(region)
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
//        if region is CLCircularRegion {
//            handleRegionEvent(region)
//        }
//    }
    
}

