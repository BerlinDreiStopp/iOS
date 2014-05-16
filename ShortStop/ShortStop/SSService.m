//
//  SSService.m
//  ShortStop
//
//  Created by Robert Atkins on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSService.h"
#import "SSStop.h"
#import "SSLine.h"

static const NSUInteger kRange = 3;
static NSString *const kStopDataFileName = @"stops.json";
static NSString *const kLineDataFileName = @"lines.json";

@interface SSStopDistance : NSObject

@property (nonatomic, assign) double distance;
@property (nonatomic, strong) SSStop *stop;

@end

@implementation SSStopDistance

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%f: %@", self.distance, self.stop.name];
}

@end

@interface SSService ()

@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) NSDictionary *linesByName;

@end

@implementation SSService

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadLines];
        [self loadStops];
    }
    return self;
}

- (void)loadLines
{
    NSMutableDictionary *linesByName = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in [self arrayWithKey:@"lines" fromJSONFileNamed:kLineDataFileName]) {
        SSLine *line = [[SSLine alloc] init];
        line.name = dict[@"id"];
        line.hexColor = dict[@"color"];
        [linesByName setObject:line forKey:line.name];
    }
    self.linesByName = linesByName;
}

- (void)loadStops
{
    NSMutableDictionary *stopsById = [NSMutableDictionary dictionary];
    
    // Do one pass over the JSON and set up each object
    for (NSDictionary *dict in [self arrayWithKey:@"stops" fromJSONFileNamed:kStopDataFileName]) {
        SSStop *stop = [[SSStop alloc] init];
        stop.hafasId = dict[@"id"];
        stop.name = dict[@"name"];
        stop.latitude = [dict[@"latitude"] doubleValue];
        stop.longitude = [dict[@"longitude"] doubleValue];
        stop.lines = [self linesForLineNames:dict[@"lines"]];
        stop.lineTypes = dict[@"type"];
        stop.adjacentStopIds = dict[@"adjacent_stops"];
        [stopsById setObject:stop forKey:stop.hafasId];
    }

    // Do another pass over the stop objects and connect up the adjacent stops
    for (SSStop *stop in [stopsById allValues]) {
        NSMutableArray *adjacentStops = [NSMutableArray array];
        for (NSString *adjacentStopId in stop.adjacentStopIds) {
            [adjacentStops addObject:stopsById[adjacentStopId]];
        }
        stop.adjacentStops = [NSArray arrayWithArray:adjacentStops];
    }
    self.stops = [stopsById allValues];
}

- (NSArray *)linesForLineNames:(NSArray *)lineNames
{
    NSMutableSet *lines = [NSMutableSet set];
    for (NSString *lineName in lineNames) {
        SSLine *line = self.linesByName[lineName];
        if (line) {
            [lines addObject:line];
        }
    }
    return [lines allObjects];
}

- (NSArray *)arrayWithKey:(NSString *)key fromJSONFileNamed:(NSString *)file
{
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    return json[key];
}

- (NSArray *)closestStopsTo:(CLLocationCoordinate2D)location
{
    if (location.longitude == 0 && location.latitude == 0) {
        return self.stops;
    }
    
    NSMutableArray *stopsByDistance = [NSMutableArray array];
    for (SSStop *stop in self.stops) {
        SSStopDistance *stopDistance = [[SSStopDistance alloc] init];
        stopDistance.distance = distance(location, stop.coordinate);
        stopDistance.stop = stop;
        [stopsByDistance addObject:stopDistance];
    }
    NSArray *sortedStopsByDistance = [stopsByDistance sortedArrayUsingComparator:^NSComparisonResult(SSStopDistance *obj1, SSStopDistance *obj2) {
        return obj1.distance < obj2.distance ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    return self.stops;
}

- (NSArray *)stopsWithinShortTripRangeOfStops:(NSArray *)stops
{
    NSMutableSet *results = [NSMutableSet set];
    for (SSStop *stop in stops) {
        [self stopsWithinRange:kRange ofStop:stop withResults:results];
    }
    return [results allObjects];
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
    CLLocation *fromLocation = [[CLLocation alloc] initWithCoordinate:from altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:0];
    CLLocation *toLocation = [[CLLocation alloc] initWithCoordinate:to altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:0];
    return [fromLocation distanceFromLocation:toLocation];
};

- (NSArray *)stopsWithNames:(NSArray *)stopNames
{
    NSMutableArray *stops = [NSMutableArray array];
    for (NSString *stopName in stopNames) {
        [stops addObject:[self stopWithName:stopName]];
    }
    return [stops copy];
}

- (SSStop *)stopWithName:(NSString *)name
{
    NSUInteger idx = [self.stops indexOfObjectPassingTest:^BOOL(SSStop *sstop, NSUInteger idx, BOOL *stop) {
        return [sstop.name isEqualToString:name];
    }];

    NSAssert(NSNotFound != idx, @"Can't find stop: %@", name);

    return [self.stops objectAtIndex:idx];
}

@end
