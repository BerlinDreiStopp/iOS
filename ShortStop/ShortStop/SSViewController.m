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

@interface SSViewController ()

@property (nonatomic, strong) SSService *serviceserviceSERVICE;
@property (nonatomic, strong) SSLocationManager *locationManager;

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[SSLocationManager alloc] init];
    self.serviceserviceSERVICE = [[SSService alloc] init];

    __weak typeof(self) weakSelf = self;
    self.locationManager.onUpdateLocations = ^(NSArray *locations) {
        CLLocation *location = locations.firstObject;

        if (nil == location) {
            [weakSelf showMarkersForStops:nil];
        }

        [weakSelf updateStopsNearLocation:location];
    };
    
    [self configureMapView];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    SSStop *stop = view.annotation;

    NSArray *nearbyStops = [self.serviceserviceSERVICE stopsWithinShortTripRangeOfStops:@[stop]];

    // naively reset to red
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        MKPinAnnotationView *v = (MKPinAnnotationView *)[self.mapView viewForAnnotation:annotation];
        v.pinColor = MKPinAnnotationColorRed;
    }

    // show current as purple
    view.pinColor = MKPinAnnotationColorPurple;

    // tag the neato-burrito nearby ones as green
    for (SSStop *nearbyStop in nearbyStops) {
        for (id<MKAnnotation> annotation in mapView.annotations) {
            if ([annotation isEqual:nearbyStop]) {
                MKPinAnnotationView *v = (MKPinAnnotationView *)[self.mapView viewForAnnotation:annotation];
                v.pinColor = MKPinAnnotationColorGreen;
            }
        }
    }
}

#pragma mark - Helper

- (void)configureMapView
{
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    CLLocation *location = [self.locationManager currentUserLocation];

    MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);

    [self.mapView setRegion:region animated:NO];

    [self updateStopsNearLocation:nil];
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

    MKCoordinateRegion region = [self regionForAnnotations:stops];
    [self.mapView setRegion:region animated:YES];
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


@end
