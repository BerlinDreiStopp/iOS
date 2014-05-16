//
//  SSStop.h
//  ShortStop
//
//  Created by Robert Atkins on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SSStop : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *hafasId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *lines;
@property (nonatomic, strong) NSArray *adjacentStops;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

@property (nonatomic, readonly) BOOL isSBahn;
@property (nonatomic, readonly) BOOL isUBahn;

@end
