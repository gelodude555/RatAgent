//
//  FoodDropOffSites.h
//  RatAgent
//
//  Created by Angelo Castro on 6/29/13.
//  Copyright (c) 2013 Angelo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FoodDropOffSites : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;

-(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;
-(NSString *)getImageName;
-(void) setSubtitle:(NSString *)newtitle;
-(void) setTitle:(NSString *)newtitle;

@end
