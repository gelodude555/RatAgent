//
//  ViewController.h
//  RatAgent
//
//  Created by Angelo Castro on 6/29/13.
//  Copyright (c) 2013 Angelo Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController <MKMapViewDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;   
@end
