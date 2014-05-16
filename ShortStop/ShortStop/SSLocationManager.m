//
//  SSLocationManager.m
//  ShortStop
//
//  Created by Conrad Stoll on 5/16/14.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSLocationManager.h"

@interface SSLocationManager ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation SSLocationManager

- (id)init {
    if ((self = [super init])) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager startUpdatingLocation];
    }

    return self;
}

- (CLLocation *)currentUserLocation {
    return self.locationManager.location;
}

@end
