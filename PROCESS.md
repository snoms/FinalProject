## Process Book

#### day 1 - May 30
Conceived plan for a public transport application which will offer real-time assistance during a journey. Today I mostly thought about the APIs and data sources I would need to make my app happen: Google Directions API, hopefully MapKit from Apple, and the OpenOV Datasets. I've put these in my Project Proposal, together with my current idea for the Minimum Viable Product (MVP). Also set up my Github

#### day 2 - May 31
not a very productive day to be honest. still getting used to the course rhythm. contacted some people who might be able to help me with my APIs, notably skywave who made a real-time public transport times application, and the supplier of that data. checked out the JSON arrays I might have to handle, and how to do that in Swift, seems messy... also worked on my design document, heavily based off of my project proposal.

#### day 3 - June 1
attempted to load all the necessary frameworks into my project using cocoapods. found a swift framework that handles google directions requests (PXGoogleDirections) which seems ideal for my purposes. 

#### day 4 - June 2
Today I worked some more on getting the frameworks to work in my project and unfortunately managed to break my original project in the process. The issues is that I need both the official Google Maps framework, and the PXGoogleDirections framework also uses the Google Maps framework, but an outdated version. This is causing conflicts in CocoaPods. Whipped up a prototype though.

#### day 5 - June 3
prototype day. because xcode has a very accessible interface builder, it was quite easy to get something presentable, although mostly without function. I did already implement several data classes (at least the ones that were referenced in my interface)

Presentation went well.



#### day 6 - June 6
I missed this day due to personal circumstances.

#### day 7 - June 7
it's all gone horribly wrong. because of the framework conflicts last week and the creation of new xcode projects... I transferred my old files to my new project but only by reference, so the files weren'ta ctually copied from the old project. so the files I've been working on were never committed to my git. I usually work in dropbox because it keeps backups of every file iteration but ironically, because it was full and I wanted to clean it up, I deleted my original project folder (which had my actual code...................) it's all gone. I've tried some file recovery software but it only gave me garbled results.

#### day 8 - June 8
still pretty bummed out about my carelessness. was able to reproduce the interface I concocted earlier though, so that's something. also redid my boilerplate code and I know what up

#### day 9 - June 9
Alright, I've caught up to pre-disaster Tuesday levels of both motivation and code. The time I spent rewriting did give me a chance to critically think over some design decisions and improve them. I don't think it's feasible to implement all the functions I wanted to. To retain main functionality, I will focus on location-based journey warnings, instead of using the real-time public transport data (OpenOV)

#### day 10 - June 10
Alpha day. Didn't have much more to present than my prototype last week, so a very underwhelming day for me.

#### day 11 - June 13
I'm using a singleton called RouteManager which will allow me to load in a route and then access it until a new route is loaded or the app is removed from background. I thought about retaining the route using CoreData or NSCoding, but it's pretty useless because my app will always be active in the background when in use, and when it's been inactive for a long time it would be annoying to still have the old route loaded. 


#### day 12 - June 14
decided to use a framework 'SwiftLocation' which also provides a Location Manager singleton instead of my own, because I couldn't get it to work with my regions
Got location simulation to work (as in, providing a simulated route with a certain speed (.gpx waypoint file))

#### day 13 - June 15
forgot to log this day

#### day 14 - June 16
YES, got my transit stop detection code working (processes the route and extracts coordinates for the stops) 
The core of my functionality now kind of works, as the code triggers when the user enters the relevant region. doesn't work in the background yet though, nor do I have notifications implemented yet. just an alert rn.


#### day 15 - June 17
Beta day. Glad I got my regions working before this, finally something cool to present, even if it's very barebones.

#### day 16 - June 20
not sure which features that are lacking are necessary to implement. there's so much I still want to add, but the deadline is closing fast. prioritizing on getting the most basic functionality 'perfect', rather than adding optional but very noteworthy QoL improvements. decided to scrap a planned feature to open the loaded route in google maps. also putting the 

#### day 17 - June 21
i'm going bad. the location library I was using partially stopped working for some reason. I'm trying to get apple's built-in location services to work now. Background location (accuracy) is an issue.


#### day 18 - June 22
I've made it work, but it's messy. I'm still adding functionality, because it just wasn't complete enough. Made the geofences radius variable depending on the type of vehicle, because you need an earlier warning for getting out of a train than a bus.


#### day 19 - June 23
Code cleaning, report writing. Still adding tiny functionality, mostly to prevent bug abuse though.



# Features I would implement given unlimited time and resources:

Alternative journey suggestions

Real-time PT data implementations (of your relevant vehicle)

A pretty interface

Autocomplete in the text fields so that you always have a valid request

Lower battery usage

Customized alerts instead of just showing the upcoming stop