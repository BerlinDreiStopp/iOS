//
//  SSService.h
//  ShortStop
//
//  Created by Robert Atkins on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SSService : NSObject

- (NSArray *)closestStopsTo:(CLLocationCoordinate2D)location;

- (NSArray *)stopsWithinShortTripRangeOfStops:(NSArray *)stops;

@end
