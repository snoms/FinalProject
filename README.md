# Trip

![alt text](https://github.com/sn/FinalProject/blob/master/doc/Trip_icon.png "Trip icon")

### Programming Project 

Bob Oey

### Global summary
A public transportation app which offers live guidance to travellers unfamiliar with their surroundings. Instructions include alerts of upcoming transit transfer points by telling the user they are approaching a stop where a switch-over is required.

![alt text](https://github.com/snoms/FinalProject/blob/master/doc/Views.png "Main views of Trip")

### Description
For this project I created a public transport (PT) assistance application. Current popular PT apps offer robust guidance, but lack in real-time assistance during the trip. This interaction gap is especially problematic for travellers unknown with the itinerary, such as tourists or simply people unknown with that specific route. Most notably, knowing when to prepare for leaving the vehicle or requesting a stop is often confusing. Here I will empower environment-naive users with the comfort locals enjoy through their familiarity with their city by using their geolocation to track their PT vehicle and inform them of upcoming changes (e.g. Press Stop Now and exit your Tram # at the next stop).

### Components

* Route planning interface (from / to)
* Map view to show route and current location
* Route view (overview of upcoming changes)
* Background functionality (notifications)

### Used APIs

* Google Maps API
* Google Maps Directions API
* SwiftLocation API
* PXGoogleDirections API
* IQKeyboard
* iOS Region Monitoring

### Instructions

This app requires CocoaPods for local simulation and 'pod install' to be executed within the Trip directory.  
Install or simulate using Xcode. Two sample simulated movement files are provided: FastBusSubwayRoute.gpx and FastTrainRoute.gpx. The best way to demonstrate Trip's functionality is by planning a route from 'Diemen Station' to 'Amsterdam Sloterdijk Station' and from 'Amsterdam Science Park' to 'Amsterdam Wibautstraat' respectively.
