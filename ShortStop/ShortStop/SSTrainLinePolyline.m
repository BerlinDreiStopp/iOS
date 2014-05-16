//
//  SSTrainLinePolyline.m
//  ShortStop
//
//  Created by joshua may on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSTrainLinePolyline.h"

#import "SSStop.h"

@implementation SSTrainLinePolyline

+ (NSArray *)stopsForU1
{
    return @[
             @"Schlesisches Tor",
             @"Görlitzer Bahnhof",
             @"Kottbusser Tor",
             @"Prinzenstraße",
             @"Hallesches Tor",
             @"Möckernbrücke",
             @"Gleisdreieck",
             
             @"Kurfürstenstraße",
             @"Nollendorfplatz",
             @"Wittenbergplatz",
             @"Kurfürstendamm",
             @"Uhlandstraße",
             ];
}

+ (UIColor *)colorForU1
{
    return [UIColor colorWithRed:82.f/255.f green:169.f/255.f blue:12.f/255.f alpha:1.f];
}

+ (NSArray *)stopsForU8
{
    return @[
             @"Wittenau",
             @"Rathaus Reinickendorf",
             @"Karl-Bonhoeffer-Nervenklinik",
             @"Lindauer Allee",
             @"Paracelsus-Bad",
             @"Residenzstraße",
             @"Franz-Neumann-Platz",
             @"Osloer Straße",
             @"Pankstraße",
             @"Gesundbrunnen",
             @"Voltastraße",
             @"Bernauer Straße",
             @"Rosenthaler Platz",
             @"Weinmeisterstraße",
             @"Alexanderplatz",
             @"Jannowitzbrücke",
             @"Heinrich-Heine-Straße",
             @"Moritzplatz",
             @"Kottbusser Tor",
             @"Schönleinstraße",
             @"Hermannplatz",
             @"Boddinstraße",
             @"Leinestraße",
             @"Hermannstraße",
             ];
}

+ (UIColor *)colorForU8
{
    return [UIColor colorWithRed:0.f green:95.f/255.f blue:161.f/255.f alpha:1.f];
}

+ (instancetype)polylineForStops:(NSArray *)stops color:(UIColor *)color
{
    CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * stops.count);

    NSInteger idx = 0;
    for (SSStop *stop in stops) {
        coordinateArray[idx++] = stop.coordinate;
    }

//    CLLocationCoordinate2D coordinateArray[3];
//    coordinateArray[0] = CLLocationCoordinate2DMake(52.4992490, 13.4181670); // kottbusser tor
//    coordinateArray[1] = CLLocationCoordinate2DMake(52.5037390, 13.4109470); // moritzplatz
//    coordinateArray[2] = CLLocationCoordinate2DMake(52.5108580, 13.4161690); // U Heinrich-Heine-Str

    SSTrainLinePolyline *p = [self polylineWithCoordinates:coordinateArray count:stops.count];
    p.color = color;
    return p;
}

@end
