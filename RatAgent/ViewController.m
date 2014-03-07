//
//  ViewController.m
//  RatAgent
//
//  Created by Angelo Castro on 6/29/13.
//  Copyright (c) 2013 Angelo Castro. All rights reserved.
//

#import "ViewController.h"
#import "RatLocations.h"
#import "FoodDropOffSites.h"
#import "MBProgressHUD.h"
#import "Rats.h"
#import "RatLocations.h"

@interface ViewController ()

@end

@implementation ViewController {
}
@synthesize responseData;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self getData:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    NSString *imageName = @"rat-marker_sm.png"; ;//[annotation performSelector:@selector(getImageName)];
    MKAnnotationView *aview;
    if ([imageName length] > 0) {
        aview = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TrashIcon.png"];
        aview.canShowCallout = YES;
        [aview setImage:[UIImage imageNamed:imageName]];
    }
    return aview;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
}
//Copy Code BELOW HERE!!!VVV   VVV

-(void) getData:(NSString *)code {
    
    // Have URL, now load data.
    self.responseData = [NSMutableData data];
    
    // Start the activity Spinner, this displays the progress indicator while the
    // data is being loaded.
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
//	[self.navigationController.view addSubview:HUD];
    
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Searching for Rats";
	HUD.square = YES;
	
    [HUD show:YES];
    
    
    // https://foodagentp1486727504trial.nwtrial.ondemand.com/FoodAgent/
    // https://helloworldtriali804190trial.nwtrial.ondemand.com/FoodAgent/
    
    NSString *urlstring = [[NSString alloc] initWithFormat:@"http://data.cityofnewyork.us/resource/3q43-55fe.json"];
    
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
- (void)    :(NSURLConnection *)connection
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
    RatLocations *ratLoc;
    
    for (NSDictionary *dict in json) {
        // Create an instance of class Item for storing this Item in the History list
        Rats *rats = [[Rats alloc] init];
        rats.incidentZip = [dict objectForKey:@"incident_zip"];
        // Get the Item
        NSDictionary *location = [dict objectForKey:@"location"];
        rats.longitude = [location objectForKey:@"longitude"];
        rats.latitude = [location objectForKey:@"latitude"];
        
     //   NSDictionary *dropOffSite = [dict objectForKey:@"]
        
        
        ratLoc = [[RatLocations alloc] init];
        
        
        CLLocationCoordinate2D coord;
        coord.latitude = [rats.latitude floatValue];
        coord.longitude = [rats.longitude floatValue];
        ratLoc.coordinate = coord;
        MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:ratLoc reuseIdentifier:@"location"];
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:ratLoc reuseIdentifier:@"myAnnotationIdentifier"];
    //    aView.image = [UIImage imageNamed:[ra]];
        [self.mapView addAnnotation:ratLoc];
    }
    MKCoordinateRegion region = [self.mapView region];
    region.span.latitudeDelta = 0.42555;
    region.span.longitudeDelta = 0.42555;
    region.center.latitude = ratLoc.coordinate.latitude;
    region.center.longitude = ratLoc.coordinate.longitude;
    [self.mapView setRegion:region animated:YES];

}


@end
