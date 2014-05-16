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
+ (NSArray *)stopsForU2;
+ (UIColor *)colorForU2;
+ (NSArray *)stopsForU3;
+ (UIColor *)colorForU3;
+ (NSArray *)stopsForU4;
+ (UIColor *)colorForU4;
+ (NSArray *)stopsForU5;
+ (UIColor *)colorForU5;
+ (NSArray *)stopsForU55;
+ (UIColor *)colorForU55;
+ (NSArray *)stopsForU6;
+ (UIColor *)colorForU6;
+ (NSArray *)stopsForU7;
+ (UIColor *)colorForU7;
+ (NSArray *)stopsForU8;
+ (UIColor *)colorForU8;
+ (NSArray *)stopsForU9;
+ (UIColor *)colorForU9;

@property (nonatomic, strong) UIColor *color;

@end
