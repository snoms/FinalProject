<div id="container">
    <img />
	![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Trip_icon.png "Trip icon")
</div>


#container {
    height:100px;
    line-height:100px;
}

#container img {
    vertical-align:middle;
    max-height:100%;
}


<div style="text-align:center"><img src ="https://raw.githubusercontent.com/snoms/FinalProject/master/doc/Trip_icon.png" /></div>


## Short overview
Trip is a lightweight public transport assistant. It shows the user an easy to read overview of the planned journey, and alerts the user when they need to make a transit movement (exiting their vehicle). 

![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Views.png "Main views of Trip")

## Technical design
##### Overview
A route is requested through the PXGoogleDirections (PXGD) framework which returns a complex nested object containing the directions. This object is placed in a singleton (RouteManager). The framework includes the Google Maps SDK, which was also used to display the route in the Map view. [Insight into a single step of a journey.](https://github.com/snoms/FinalProject/blob/master/doc/Overly_nested_structure.png )

In addition to the PXGD framework, I used SwiftLocation, which is a framework that provides a singleton instance of the Apple CoreLocation Location Manager and adds several useful functions such as filtering location request responses by a certain accuracy and automating certain Region Monitoring aspects.

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

- Google maps issues. Unfortunately Apple's own MapKit does not support transit in the Netherlands, so I chose to use Google Maps, which caused some difficulties.
- google directions API returns a highly nested JSON array. swift does not play nice with JSON with regards to the handling of optional values and dynamic JSON content, so I used the PXGoogleDirections (PXGD) framework which parses the JSON response into a very large, nested 'routes' object. Unfortunately, this framework uses an outdated version of Google Maps.
- I eventually installed the PXGD framework through CocoaPods because the TA and I could not get the manual installation to work properly. This is also where the root error of my project deletion lay, as I had to use a new Xcode project to which I transferred my work by reference only. Unknowingly, from that point on I had not been committing my actual work to my Git, and as such when I deleted the old, broken Xcode project folder I cleaned out all my work. ![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Remnants_of_a_viewcontroller.png "The result of a file 'recovery' program")

- location issues
- project deletion, leading to a reduction in scope
- instead of the original proposed implementation of real-time public transport data, opted for a pure location based approach using Google Directions
- notifications through NSNotificationCenter
- local notifications




## Decisions

- decided on a singleton (RouteManager) to manage the route early on, because extensive data retention is not needed in this application
- 





### Credits

<div>Icons made by <a href="http://www.flaticon.com/authors/scott-de-jonge" title="Scott de Jonge">Scott de Jonge</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

<div>Icons made by <a href="http://www.flaticon.com/authors/google" title="Google">Google</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>