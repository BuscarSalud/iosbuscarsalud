//
//  SearchViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 10/9/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "SearchViewController.h"
#import "SpecialtiesViewController.h"
#import "iOSRequest.h"
#import "NSString+WebService.h"
#import "AppDelegate.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "SWRevealViewController.h"

@interface SearchViewController ()
{
    NSDictionary *specialties;    
}

#define IS_WIDESCREEN ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )

@end


@implementation SearchViewController{
    CLLocationManager *locationManager;
    double lat;
    double lon;
}

@synthesize specialtyNameLabel, receiveDisplay, receiveName, tabBarController, latitude, longitude, sidebarButton;

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
    
    if (IS_WIDESCREEN) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-main-five.png"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-main.png"]];
    }
    


    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    [sidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];


    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"tt0001m_: %@",
          [UIFont fontNamesForFamilyName:@"Source Sans Pro"]
          );
    NSLog(@"User active = %@", [defaults objectForKey:@"user_logged"]);
    
    // Get location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
        
    NSLog(@"specialties in didload = %@", specialties);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Home Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Get Current Location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"No pudimos encontrar tu ubicación" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    latitude = [NSNumber numberWithDouble:lat];
    longitude = [NSNumber numberWithDouble:lon];
    
    
}

# pragma mark - Prepare Data for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goToSpecialties"]) {
        SpecialtiesViewController *destViewController = segue.destinationViewController;
        destViewController.latitudeSpec = latitude;
        destViewController.longitudeSpec = longitude;
        //destViewController.specialtiesDictionary = specialties;
        
        NSLog(@"specialties in segue = %@", specialties);
    }
}


- (IBAction)sidebarButton:(id)sender {

}
@end
