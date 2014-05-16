//
//  SSTrainLinePolyline.h
//  ShortStop
//
//  Created by joshua may on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SSTrainLinePolyline : MKPolyline

+ (instancetype)polylineForStops:(NSArray *)stops color:(UIColor *)color;

+ (NSArray *)stopsForU1;
+ (UIColor *)colorForU1;
+ (NSArray *)stopsForU8;
+ (UIColor *)colorForU8;

@property (nonatomic, strong) UIColor *color;

@end
