//
//  SSStop.m
//  ShortStop
//
//  Created by Robert Atkins on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSStop.h"

@implementation SSStop

#pragma mark - Accessors

- (BOOL)isSBahn
{
    return [self.name hasPrefix:@"S "] || [self.name hasPrefix:@"S+U "];
}

- (BOOL)isUBahn
{
    return [self.name hasPrefix:@"U "] || [self.name hasPrefix:@"S+U "];
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

 - (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"Connects with %u line(s).", self.lines.count];
}

#pragma mark - NSObject

- (BOOL)isEqual:(SSStop *)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[SSStop class]]) {
        return NO;
    }

    return [self.hafasId isEqualToString:object.hafasId];
}

- (NSUInteger)hash
{
    return [self.hafasId hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"hafasId:%@, name:%@, adjacentStops:<%@>", self.hafasId, self.name, self.adjacentStops ? [[self.adjacentStops valueForKey:@"hafasId"] componentsJoinedByString:@",\n  "] : nil];
}

@end
