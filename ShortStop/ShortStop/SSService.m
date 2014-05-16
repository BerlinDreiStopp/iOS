//
//  SSService.m
//  ShortStop
//
//  Created by Robert Atkins on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSService.h"
#import "SSStop.h"

@interface SSStopDistance : NSObject

@property (nonatomic, assign) double distance;
@property (nonatomic, strong) SSStop *stop;

@end

@interface SSService ()

@property (nonatomic, strong) NSArray *stops;

@end

@implementation SSService

- (NSArray *)closestStopsTo:(CLLocationCoordinate2D)location
{
    NSMutableArray *stopsByDistance = [NSMutableArray array];
    for (SSStop *stop in self.stops) {
        SSStopDistance *stopDistance = [[SSStopDistance alloc] init];
        stopDistance.distance = distance(location, stop.location);
        stopDistance.stop = stop;
    }
    [stopsByDistance sortedArrayUsingComparator:^NSComparisonResult(SSStopDistance *obj1, SSStopDistance *obj2) {
        return obj1.distance < obj2.distance ? NSOrderedAscending : NSOrderedDescending;
    }];
    return @[stopsByDistance[0], stopsByDistance[1], stopsByDistance[2]];
}

- (NSArray *)stopsWithinShortTripRangeOfStops:(NSArray *)stops
{
    NSMutableSet *results = [NSMutableSet set];
    for (SSStop *stop in stops) {
        [self stopsWithinRange:3 ofStop:stop withResults:results];
    }
    return [NSArray array];
}

- (void)stopsWithinRange:(NSUInteger)range ofStop:(SSStop *)origin withResults:(NSMutableSet *)results
{
    if (range > 0) {
        for (SSStop *stop in origin.adjacentStops) {
            [results addObject:stop];
            [self stopsWithinRange:(range - 1) ofStop:stop withResults:results];
        }
    }
}

double distance (CLLocationCoordinate2D from, CLLocationCoordinate2D to) {
    return sqrt(
                (to.latitude - from.latitude) * (to.latitude - from.latitude)
                + (to.longitude - from.longitude) * (to.longitude - from.longitude)
                );
};

@end
