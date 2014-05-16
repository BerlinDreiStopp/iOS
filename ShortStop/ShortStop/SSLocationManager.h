//
//  SSLocationManager.h
//  ShortStop
//
//  Created by Conrad Stoll on 5/16/14.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SSLocationManagerUpdateLocationsHandler)(NSArray *locations);

@interface SSLocationManager : NSObject

- (CLLocation *)currentUserLocation;

@property (nonatomic, copy) SSLocationManagerUpdateLocationsHandler onUpdateLocations;

@end
