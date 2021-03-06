    //
//  SSViewController.m
//  ShortStop
//
//  Created by Conrad Stoll on 5/16/14.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSViewController.h"

#import "SSService.h"
#import "SSLocationManager.h"

#import "SSStop.h"
#import "SSTrainLinePolyline.h"

@interface SSViewController ()

@property (nonatomic, strong) SSService *serviceserviceSERVICE;
@property (nonatomic, strong) SSLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *adjacencyOverlays;

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.adjacencyOverlays = [NSMutableArray array];

    self.locationManager = [[SSLocationManager alloc] init];
    self.serviceserviceSERVICE = [[SSService alloc] init];

//    __weak typeof(self) weakSelf = self;
//    self.locationManager.onUpdateLocations = ^(NSArray *locations) {
//        CLLocation *location = locations.firstObject;
//
//        if (nil == location) {
////            [weakSelf showMarkersForStops:nil];
//        }
//
////        [weakSelf updateStopsNearLocation:location];
//    };
    
    [self configureMapView];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    if (![view isKindOfClass:[MKPinAnnotationView class]]) {
        return;
    }

    SSStop *stop = view.annotation;

    NSArray *nearbyStops = [self.serviceserviceSERVICE stopsWithinShortTripRangeOfStops:@[stop]];

    // naively reset state
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        MKPinAnnotationView *v = (MKPinAnnotationView *)[self.mapView viewForAnnotation:annotation];
        if (![v isKindOfClass:[MKPinAnnotationView class]]) {
            continue;
        }
        v.pinColor = MKPinAnnotationColorRed;
    }

    [self.mapView removeOverlays:self.adjacencyOverlays];
    [self.adjacencyOverlays removeAllObjects];

    // show current as purple
    view.pinColor = MKPinAnnotationColorPurple;

    // tag the neato-burrito nearby ones as green
    for (SSStop *nearbyStop in nearbyStops) {
        for (id<MKAnnotation> annotation in mapView.annotations) {
            if ([annotation isEqual:nearbyStop]) {
                MKPinAnnotationView *v = (MKPinAnnotationView *)[self.mapView viewForAnnotation:annotation];
                if (![v isKindOfClass:[MKPinAnnotationView class]]) {
                    return;
                }
                v.pinColor = MKPinAnnotationColorGreen;
            }
        }

        for (NSString *stopID in nearbyStop.adjacentStops) {
            NSUInteger idx = [self.mapView.annotations indexOfObjectPassingTest:^BOOL(SSStop *stop, NSUInteger idx, BOOL *stopLoop) {
                if (![stop isKindOfClass:[SSStop class]]) {
                    return NO;
                }
                return [stop.hafasId isEqual:stopID];
            }];

            if (NSNotFound == idx) {
                continue;
            }

            SSStop *adjacentStop = [self.mapView.annotations objectAtIndex:idx];

            if (![nearbyStops containsObject:adjacentStop]) {
                continue;
            }

            CLLocationCoordinate2D coordinateArray[2];
            coordinateArray[0] = nearbyStop.coordinate;
            coordinateArray[1] = adjacentStop.coordinate;
            MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinateArray count:2];

            [self.mapView addOverlay:polyline];

            [self.adjacencyOverlays addObject:polyline];
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[SSTrainLinePolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        renderer.lineWidth = 3.f;
        renderer.strokeColor = ((SSTrainLinePolyline *)overlay).color;
        renderer.alpha = 0.9f;
        return renderer;
    }
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
    renderer.lineWidth = 3.f;
    renderer.strokeColor = [UIColor blueColor];
    renderer.alpha = 0.5f;
    
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    static NSString *AnnotationIdentifier = @"AnnotationIdentifier";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (nil == pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];

        [pinView setPinColor:MKPinAnnotationColorRed];
        pinView.canShowCallout = YES;

        UIImageView *iconView = [[UIImageView alloc] initWithImage:[self iconForStop:annotation]];
        pinView.leftCalloutAccessoryView = iconView;
    }
    else 
    {
        UIImageView *iconView = (UIImageView *)pinView.leftCalloutAccessoryView;
        iconView.image = [self iconForStop:annotation];
        pinView.annotation = annotation;
    }
    
    return pinView; 
}

#pragma mark - Helper

- (void)configureMapView
{
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeNone;
    
    CLLocation *location = [self.locationManager currentUserLocation];

    if (nil == location) {
        // betahaus
        location = [[CLLocation alloc] initWithLatitude:52.502543 longitude:13.412206];
    }

    // draw bahn lines
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU1]] color:[SSTrainLinePolyline colorForU1]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU2]] color:[SSTrainLinePolyline colorForU2]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU3]] color:[SSTrainLinePolyline colorForU3]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU4]] color:[SSTrainLinePolyline colorForU4]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU5]] color:[SSTrainLinePolyline colorForU5]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU55]] color:[SSTrainLinePolyline colorForU55]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU6]] color:[SSTrainLinePolyline colorForU6]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU7]] color:[SSTrainLinePolyline colorForU7]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU8]] color:[SSTrainLinePolyline colorForU8]]];
    [self.mapView addOverlay:[SSTrainLinePolyline polylineForStops:[self.serviceserviceSERVICE stopsWithNames:[SSTrainLinePolyline stopsForU9]] color:[SSTrainLinePolyline colorForU9]]];

    MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);

    [self.mapView setRegion:region animated:NO];
    [self updateStopsNearLocation:location];
}

- (void)updateStopsNearLocation:(CLLocation *)location
{
    NSArray *stops = [self.serviceserviceSERVICE closestStopsTo:location.coordinate];
    [self showMarkersForStops:stops];
}

- (void)showMarkersForStops:(NSArray *)stops
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:stops];

    if (!self.mapView.userLocation) {
        MKCoordinateRegion region = [self regionForAnnotations:stops];
        [self.mapView setRegion:region animated:YES];
    }
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;

    // this is pretty useless in the simuator BECAUSE I AM TOO LAZY TO PRETEND I AM IN BERLIN RIGHT NOW
//    annotations = [annotations arrayByAddingObject:self.mapView.userLocation];

    if (0 == annotations.count) {
        region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 0.25, 0.25);
    } else if (1 == annotations.count) {
        id<MKAnnotation> annotation = annotations.firstObject;
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 0.25, 0.25);
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id<MKAnnotation> annotation in annotations) {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 2;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [self.mapView regionThatFits:region];
}

- (UIImage *)iconForStop:(SSStop *)stop
{
    if (stop.isSBahn && stop.isUBahn) {
        return [UIImage imageNamed:@"USBahnLogo"];
    } else if (stop.isSBahn) {
        return [UIImage imageNamed:@"SBahnLogo"];
    } else if (stop.isUBahn) {
        return [UIImage imageNamed:@"UBahnLogo"];
    }

    return nil;
}

@end
