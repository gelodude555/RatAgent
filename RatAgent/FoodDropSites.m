//
//  FoodDropSites.m
//  RatAgent
//
//  Created by Angelo Castro on 6/30/13.
//  Copyright (c) 2013 Angelo Castro. All rights reserved.
//

#import "FoodDropSites.h"

@implementation FoodDropSites
@synthesize responseData;

-(void) getData:(NSString *)code {
    
    // Have URL, now load data.
    self.responseData = [NSMutableData data];
    
    // Start the activity Spinner, this displays the progress indicator while the
    // data is being loaded.
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = [NSString stringWithFormat:@"Retrieving product info for %@", code];
	HUD.square = YES;
	
    [HUD show:YES];
    
    
    // https://foodagentp1486727504trial.nwtrial.ondemand.com/FoodAgent/
    // https://helloworldtriali804190trial.nwtrial.ondemand.com/FoodAgent/
    
    NSString *urlstring = [[NSString alloc] initWithFormat:@"http://data.cityofnewyork.us/resource/rmmq-46n5.json"];
    
    NSLog(@"Getting data from %@", urlstring);
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    NSLog(@"Response received %d",[(NSHTTPURLResponse*)response statusCode]);
    NSDictionary *allHeaders = [(NSHTTPURLResponse*)response allHeaderFields];
    //    NSLog(@"Response headers %@",allHeaders);
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HUD hide:YES];
}

// This message is called when the data has been loaded from Nikola's server. This data is the JSON of the item and ingredients.
// The data looks something like this:
/*
 {"Item":{"ID":"2","Name":"Applesauce","Brand":"Giant","ImageURL":"http://t1.gstatic.com/images?q=tbn:ANd9GcTdpan8bm6lE7BpzWzHeJM62ExUZyaydZipJQY_U6VUxp4ROoCJzg","Location":"Baltimore, MD","Lat":"39.302425","Lng":"-76.612587"},"Count":"1","Ingredients":[{"ID":"1","Lat":"39.1718","Lng":"-77.3264","Name":"Apple"},{"ID":"2","Lat":"39.1864","Lng":"-77.3043","Name":"Water"},{"ID":"3","Lat":"39.15952","Lng":"-77.27885","Name":"Sugar"}],"Hazards":[{"ID":"1","Lat":"39.238448","Lng":"-76.58792","Name":"Maryland Chemical Plant"},{"ID":"2","Lat":"38.432211","Lng":"-76.452506","Name":"Calvert Cliffs Nuclear Power Plant "},{"ID":"3","Lat":"39.438182","Lng":"-77.432942","Name":"Fort Detrick"}]}
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //    NSLog(@"Finished loading, got %d bytes", [self.responseData length]);
    
    // Hide the spinner window
    [HUD hide:YES];
    
    // Once this method is invoked, "responseData" contains the complete result
    // The data comes in the format     "Content-Type" = "application/json;charset=ISO-8859-1";
    /*
     NSString *newStr = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
     NSLog(@"Received data as string%@",newStr);
     */
    
    // Extract the received data from the response from the web page
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     
                     options:kNilOptions
                     error:&error];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    TrashLocations *trashLoc;
    
    for (NSDictionary *dict in json) {
        // Create an instance of class Item for storing this Item in the History list
        Trash *trash = [[Trash alloc] init];
        Trash.incidentZip = [dict objectForKey:@"incident_zip"];
        // Get the Item
        NSDictionary *location = [dict objectForKey:@"location"];
        trash.longitude = [location objectForKey:@"longitude"];
        trash.latitude = [location objectForKey:@"latitude"];
        
        //   NSDictionary *dropOffSite = [dict objectForKey:@"]
        
        
        trashLoc = [[TrasLocations alloc] init];
        
        
        CLLocationCoordinate2D coord;
        coord.latitude = [rats.latitude floatValue];
        coord.longitude = [rats.longitude floatValue];
        trashLoc.coordinate = coord;
        MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:trashLoc reuseIdentifier:@"location"];
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:trashLoc reuseIdentifier:@"myAnnotationIdentifier"];
        //    aView.image = [UIImage imageNamed:[ra]];
        [self.mapView addAnnotation:trashLoc];
    }
    MKCoordinateRegion region = [self.mapView region];
    region.span.latitudeDelta = 0.42555;
    region.span.longitudeDelta = 0.42555;
    region.center.latitude = trashLoc.coordinate.latitude;
    region.center.longitude = trashLoc.coordinate.longitude;
    [self.mapView setRegion:region animated:YES];
    
    /*
     MKCoordinateRegion region = [self.mapView region];
     region.span.latitudeDelta = 0.015;
     region.span.longitudeDelta = 0.015;
     region.center.latitude = location2D.latitude;
     region.center.longitude = location2D.longitude;
     [self.mapView setRegion:region animated:YES];
     // Tell the view to refresh with the new data
     //      [self.view setNeedsDisplay];
     */
}

@end
