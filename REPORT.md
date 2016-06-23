### Short overview
Trip is a lightweight public transport assistant. It shows the user an easy to read overview of the planned journey, and alerts the user when they need to make a transit movement (exiting their vehicle). 

![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Views.png "Main views of Trip")

### Technical design
- high level overview
A route is requested through the PXGoogleDirections framework which 

- classes


### Changes and Challenges

- google maps issues. unfortunately apple's own MapKit does not have transit support for the Netherlands yet, so I chose to use Google Maps, which proved to be quite the hassle
- google directions API returns a highly nested JSON array. swift does not play nice with JSON with regards to the handling of optional values and dynamic JSON content, so I used the PXGoogleDirections (PXGD) framework which parses the JSON response into a very large, nested 'routes' object. Unfortunately, this framework uses an outdated version of Google Maps.
- I eventually installed the PXGD framework through CocoaPods because the TA and I could not get the manual installation to work properly. This is also where the root error of my project deletion lay, as I had to use a new Xcode project to which I transferred my work by reference only. Unknowingly, from that point on I had not been committing my actual work to my Git, and as such when I deleted the old, broken Xcode project folder I cleaned out all my work. ![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Remnants_of_a_viewcontroller.png "The result of a file 'recovery' program")

- location issues
- project deletion, leading to a reduction in scope
- instead of the original proposed implementation of real-time public transport data, opted for a pure location based approach using Google Directions
- notifications through NSNotificationCenter
- local notifications




### Decisions

- decided on a singleton (RouteManager) to manage the route early on, because extensive data retention is not needed in this application
- 





### Credits

<div>Icons made by <a href="http://www.flaticon.com/authors/scott-de-jonge" title="Scott de Jonge">Scott de Jonge</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

<div>Icons made by <a href="http://www.flaticon.com/authors/google" title="Google">Google</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>