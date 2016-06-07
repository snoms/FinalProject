## Design Document

### Global summary
Trip is a public transportation app which offers live guidance to travellers unfamiliar with their surroundings. Instructions will include alerts to request a Stop, upcoming changes of vehicles etc.

### Description
For this project I intend to create a public transport (PT) assistance application. Current popular PT apps offer robust guidance, but lack in real-time assistance during the trip. This interaction gap is especially problematic for travellers unknown with the itinerary, such as tourists or simply people unknown with that specific route. Most notably, knowing when to prepare for leaving the vehicle or requesting a stop is often confusing. Real time PT data is available through the OpenOV api (http://openov.nl/) which already is essential for the user friendliness of modern day PT apps. Here I will empower environment-naive users with the comfort locals enjoy through their familiarity with their city by using their geolocation to track their PT vehicle and inform them of upcoming changes (e.g. Press Stop Now and exit your Tram # at the next stop).

### Components

* Route planning interface (from / to)
* Map view to show route and current location
* Live route view (overview of upcoming changes)
* Background functionality (notifications)

### Required frameworks and APIs

* Google Maps API / SDK **or** MapKit
* Google Maps Directions API
* Google Places API (for Autocomplete, extra resource: https://github.com/watsonbox/ios_google_places_autocomplete)
* OpenOV API (https://github.com/skywave/KV78Turbo-OVAPI/wiki)
* iOS Region Monitoring
* SwiftyJSON (https://github.com/SwiftyJSON/SwiftyJSON)
* PXGoogleDirections (https://github.com/poulpix/PXGoogleDirections)

### Design
To track a user's nearness to the relevant stop, use of iOS Core Location may prove enough. Coarse location accuracy may however be insufficient to give robust alerts (location may skip in and out of the relevant geofenced regions, leading to multiple or erroneous alerts). Ideally, Trip should autonomously verify which vehicle the user is travelling on, but implementing this in a both efficient and robust way may lie beyond the scope of this project. A much less elegant solution is to ask the user to verify they indeed got on to the vehicle their planned route told them to. 

### Technical design
The backend for Trip should include a way to save journey itineraries of dynamic length and complexity, and keep the relevant points on the route in memory for use in the background. The Google Maps Directions API (GMD API) provides a requested itinerary in JSON format. As JSON is not very well supported natively by Swift, I intend to use SwiftyJSON to make processing any JSON arrays easier. To make the GMD responses more usable I intend to use PXGoogleDirections.

### Explanation of sketches and screenshots in /doc
The interface will consist of three main views / activities, always shown in the Tab Bar Navigator. The Route Planner will be a simple form with several buttons, mostly for changing the time of the trip. The Route Overview will be a double table, as shown in the sketch (UI Upcoming Route View.jpg), which will scroll by as the user travels. The Route Map / View Status tab will be as shown in the UI Map View sketch, with a small information bar below the actual Google Maps map. The pop-up notifications' content will depend on the context of the alert, as hinted at in UI Alert Notification.jpg.