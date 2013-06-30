//
//  FoodDropOff.h
//  RatAgent
//
//  Created by Angelo Castro on 6/30/13.
//  Copyright (c) 2013 Angelo Castro. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface FoodDropOff : UIViewController <MKMapViewDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    CLLocationCoordinate2D coordinate;
}


@end
