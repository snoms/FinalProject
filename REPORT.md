# Trip
![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Trip_icon.png "Trip icon")

## Short overview
Trip is a lightweight public transport assistant. It shows the user an easy to read overview of the planned journey, and alerts the user when they need to make a transit movement (exiting their vehicle). 

![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Views.png "Main views of Trip")

## Technical design
##### Overview
A route is requested through the PXGoogleDirections (PXGD) framework which returns a complex nested object containing the directions. This object is placed in a singleton (**RouteManager**). The framework includes the Google Maps SDK, which was also used to display the route in the Map view. [Insight into a single step of a journey.](https://github.com/snoms/FinalProject/blob/master/doc/Overly_nested_structure.png )

In addition to the PXGD framework, I used SwiftLocation, which is a framework that provides a singleton instance of the Apple CoreLocation Location Manager and adds several useful functions such as filtering location request responses by a certain accuracy and automating certain Region Monitoring aspects. To manage the journey planner view and its interaction with the keyboard elegantly the module IQKeyboard was used.

### Classes
The main class which I've created is a singleton called RouteManager, which holds the PXGD response and contains several functions.

#### RouteManager
##### Data
The RouteManager contains the PXGD response in the plannedRoute array, and two arrays: **TransitFences** (a transitFence holds data on a transit point on which a geofence will be based - coordinates, a radius, and a name) and **fenceRegions** (the actual geofence as created by the SwiftLocation singleton). 

##### Methods
* getRoute() -> returns the loaded route
* clearRoute() -> clears the loaded route and its geofences and stops region monitoring
* stopMonitoring() -> loops over the fences and halts monitoring
* setRoute() -> loads a PXGD response into the singleton
* detectTransitStops() -> loops over the steps of the loaded route, detecting relevant transit points and creating transitFences
* startMonitoring() -> initiates the geofences, attaching the relevant notifications to be included in the alerts triggered on entering these regions

## Changes and Challenges
- Google Maps issues. Unfortunately Apple's own MapKit does not support transit in the Netherlands, so I chose to use Google Maps, which caused some difficulties.
- The Google Directions API returns a highly nested JSON array. Swift does not play nice with JSON with regards to the handling of optional values and dynamic JSON content, so I used the PXGoogleDirections (PXGD) framework which parses the JSON response into a very large, nested 'routes' object. Unfortunately, this framework uses an outdated version of Google Maps.
- I eventually installed the PXGD framework through CocoaPods because the TA and I could not get the manual installation to work properly. This is also where the root error of my project deletion lay, as I had to use a new Xcode project to which I transferred my work by reference only. Unknowingly, from that point on I had not been committing my actual work to my Git, and as such when I deleted the old, broken Xcode project folder I cleaned out all my work. This has unfortunately forced me to reduce the scope of this project. ![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Remnants_of_a_viewcontroller.png "The result of a file 'recovery' program")
- Near the end of the project I ran into some difficulty with the SwiftLocation framework. I fell back on the native CoreLocation functionality, but this leads to some duplicate location reporting and increased battery usage. It should be fixed in future versions.
- A major point in the scope of scope reduction was the decision to instead of the original proposed implementation of real-time public transport data, opt for a pure location based approach using Google Directions. I had wanted to track the vehicle the user was in to provide actual alerts based on robust information, but due to setbacks in the project I instead used the data from the Google Directions API to provide this functionality.
- In order to post the notifications throughout the app when the geofence was entered, the NSNotificationCenter proved useful. It allowed me to broadcast the signal that a fence had been triggered to all view controllers, and attach information from that signal to the broadcast. To show notifications with Trip in the background, UILocalNotifications were sent.

## Decisions

- I decided on a singleton (RouteManager) to manage the route early on, because extensive data retention is not needed in this application. My reasoning was that once a journey was loaded, the trip would be 'consumed' and as such has no reason to remain in memory. 
- I decided to let go of my original ambitions for Trip simply due to time constraints. I had wanted to implement a much more advanced travel assistant, but it proved too ambitious. I do believe there is a lot of room for improvement, but I am at least reasonably satisfied with the aesthetics of the app.

## Bugs

- There are some issues with correctly stopping region monitoring for a geofence.
- Background (and most notably during subway transit) location accuracy is sometimes problematically inaccurate, leading to false triggers of regions. This is something that would have been solved elegantly if a fallback to the real-time public transport data had been implemented during low-accuracy location situations, or lengthy steps during a journey where intensive location monitoring is unnecessary.
- Notifications are sent twice.
- Sometimes location services become unavailable during simulation. This appears to be a problem with the simulator.

### Credits

Frameworks:

PXGoogleDirections
SwiftLocation
IQKeyboardManagerSwift
Google Maps

<div>Icons made by <a href="http://www.flaticon.com/authors/scott-de-jonge" title="Scott de Jonge">Scott de Jonge</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

<div>Icons made by <a href="http://www.flaticon.com/authors/google" title="Google">Google</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>