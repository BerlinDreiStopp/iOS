//
//  SSLocationManager.h
//  ShortStop
//
//  Created by Conrad Stoll on 5/16/14.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SSLocationManager : NSObject

- (CLLocation *)currentUserLocation;

@end
