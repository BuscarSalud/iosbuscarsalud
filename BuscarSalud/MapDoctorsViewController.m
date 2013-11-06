//
//  MapDoctorsViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 3/2/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "MapDoctorsViewController.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "ProfileViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface MapDoctorsViewController ()

@end

@implementation MapDoctorsViewController{
    CLLocationManager *locationManager;
    NSMutableArray *locations;
    double lat;
    double lon;
}

@synthesize doctorsDictionary, mapView, toolBar, navBar;

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
   // UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar-background-ios7"];
    //[navBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    UINavigationBar *navigationBar = [[UINavigationBar alloc]init];
    [self.view addSubview:navigationBar];
    
    NSString* navBarPortraitBackgroundPath = [[NSBundle mainBundle] pathForResource:@"navbar-background-ios7" ofType:@"png"];
    

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithContentsOfFile:navBarPortraitBackgroundPath] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Map Doctors Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
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
    Annotation *myAnn;
    
    int i = [doctorsDictionary count];
    NSLog(@"Num de objetos en diccionario: %d", i);
    for (int a = 0 ; a<i; a++) {
        
        //NSString *doctor = [[doctorsDictionary allKeys] objectAtIndex:a];
        NSString *doctor = [NSString stringWithFormat:@"doctor%d", a];
        if ([[[doctorsDictionary objectForKey:doctor] objectForKey:@"latitude"] isKindOfClass:[NSNull class]]) {
            NSLog(@"Elemento sin coordenadas");
        }else{
            double extraLat = [[[doctorsDictionary objectForKey:doctor] objectForKey:@"latitude"] doubleValue];
            double extraLon = [[[doctorsDictionary objectForKey:doctor] objectForKey:@"longitude"] doubleValue];
            NSString *extraName = [[doctorsDictionary objectForKey:doctor] objectForKey:@"nombre"];
            NSString *extraDegree = [[doctorsDictionary objectForKey:doctor] objectForKey:@"titulo"];
            NSString *extraNid = [[doctorsDictionary objectForKey:doctor] objectForKey:@"nid"];
            
            NSLog(@"%@",[[doctorsDictionary objectForKey:doctor]  objectForKey:@"longitude"]);
            
            myAnn = [[Annotation alloc] init];
            location.latitude = extraLat;
            location.longitude = extraLon;
            myAnn.coordinate = location;
            myAnn.title = extraName;
            myAnn.subtitle = extraDegree;
            myAnn.nid = extraNid;
            [locations addObject:myAnn];
            NSLog(@"%d", [locations count]);
        }
    }
    NSLog(@"%@", locations);
    
    [mapView addAnnotations:locations];
    
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



- (IBAction)setMapType:(id)sender {
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}

- (IBAction)backButtonBarItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *MyPin = nil;
    if (annotation != mapView.userLocation) {
        MyPin =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        MyPin.pinColor = MKPinAnnotationColorGreen;
        NSLog(@"MKPin Mostrado");
        
        UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        MyPin.animatesDrop = TRUE;
        MyPin.rightCalloutAccessoryView = advertButton;
        MyPin.draggable = NO;
        MyPin.highlighted = YES;
        MyPin.canShowCallout = YES;
    } else{
        [mapView.userLocation setTitle:@"Aqui estoy!"];
    }
    
    return MyPin;
    

}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self performSegueWithIdentifier:@"goToProfile" sender:view];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *destViewController = segue.destinationViewController;
    MKAnnotationView *annotationView = sender;
    Annotation *ann = [[Annotation alloc] init];
    ann = annotationView.annotation;
    NSString *id = ann.nid;
    destViewController.nidReceived = id;
    destViewController.fromMap = @"yes";
    
}


@end
