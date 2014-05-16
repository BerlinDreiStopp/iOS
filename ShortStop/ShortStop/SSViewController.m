//
//  SSViewController.m
//  ShortStop
//
//  Created by Conrad Stoll on 5/16/14.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSViewController.h"

#import "SSLocationManager.h"

@interface SSViewController ()

@property (nonatomic, strong) SSLocationManager *locationManager;

@end

@implementation SSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[SSLocationManager alloc] init];
    
    [self configureMapView];
}

- (void)configureMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsBuildings = YES;
    
    CLLocation *location = [self.locationManager currentUserLocation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    
    [self.mapView setRegion:region animated:YES];
}

@end
