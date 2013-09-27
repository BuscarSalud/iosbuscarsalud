//
//  SingleDoctorMapViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 3/6/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "SingleDoctorMapViewController.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface SingleDoctorMapViewController ()

@end

@implementation SingleDoctorMapViewController
{
    CLLocationManager *locationManager;
    NSMutableArray *locations;
    double lat;
    double lon;
}

@synthesize latReceived, lonReceived, nameReceived, addressReceived, mapView, navBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar-background"];
    [navBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        lon = currentLocation.coordinate.longitude;
        lat = currentLocation.coordinate.latitude;
    }
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    
    locations = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    Annotation *myAnn = [[Annotation alloc] init];
    
    double extraLat = [latReceived doubleValue];
    double extraLon = [lonReceived doubleValue];
    
    NSLog(@"Latitude: %f -- Longitude: %f", extraLat, extraLon);
    
    location.latitude = extraLat;
    location.longitude = extraLon;
    myAnn.coordinate = location;
    myAnn.title = nameReceived;
    myAnn.subtitle = addressReceived;
    myAnn.nid = nil;

    [mapView addAnnotation:myAnn];
    
    
    NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
    
    NSLog(@"%@", coordinates);
    
    CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
    CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
    for(NSValue *value in coordinates) {
        CLLocationCoordinate2D coord = {0.0f, 0.0f};
        [value getValue:&coord];
        if(coord.longitude > maxCoord.longitude) {
            maxCoord.longitude = coord.longitude;
        }
        
        if(coord.latitude > maxCoord.latitude) {
            maxCoord.latitude = coord.latitude;
        }
        
        if(coord.longitude < minCoord.longitude) {
            minCoord.longitude = coord.longitude;
        }
        
        if(coord.latitude < minCoord.latitude) {
            minCoord.latitude = coord.latitude;
        }
    }
    
    if(lon > maxCoord.longitude) {
        maxCoord.longitude = lon;
    }
    
    if(lat > maxCoord.latitude) {
        maxCoord.latitude = lat;
    }
    
    if(lon < minCoord.longitude) {
        minCoord.longitude = lon;
    }
    
    if(lat < minCoord.latitude) {
        minCoord.latitude = lat;
    }
    
    
    MKCoordinateRegion reg = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    reg.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
    reg.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
    reg.span.longitudeDelta = (maxCoord.longitude - minCoord.longitude) * 1.0;
    reg.span.latitudeDelta = (maxCoord.latitude - minCoord.latitude) * 1.0;
    NSLog(@"longitude delta: %f", reg.span.longitudeDelta);
    NSLog(@"latitude delta: %f", reg.span.latitudeDelta);
    NSLog(@"longitude center: %f", reg.center.longitude);
    NSLog(@"latitude center: %f", reg.center.latitude);
    
    [self.mapView setRegion:reg animated:NO];

}

-(MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *MyPin = nil;
    if (annotation != mapView.userLocation) {
        MyPin =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        MyPin.animatesDrop = TRUE;
        MyPin.pinColor = MKPinAnnotationColorGreen;
        MyPin.draggable = NO;
        MyPin.highlighted = YES;
        MyPin.canShowCallout = YES;
    } else{
        [mapView.userLocation setTitle:@"Aqui estoy!"];
    }
    
    return MyPin;
    
    
}


@end
