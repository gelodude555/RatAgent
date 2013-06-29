//
//  RatLocations.m
//  RatAgent
//
//  Created by Angelo Castro on 6/29/13.
//  Copyright (c) 2013 Angelo Castro. All rights reserved.
//

#import "RatLocations.h"

@implementation RatLocations
@synthesize coordinate, title, subtitle;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

-(void)setTitle:(NSString *)newtitle {
    title = newtitle;
}

-(void)setSubtitle:(NSString *)newtitle {
    subtitle = newtitle;
}

-(NSString *)getImageName {
    return @"caution.png";
}
@end
