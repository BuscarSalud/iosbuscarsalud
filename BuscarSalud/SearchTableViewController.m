//
//  SearchTableViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/19/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SpecialtiesViewController.h"
#import "iOSRequest.h"
#import "NSString+WebService.h"
#import "AppDelegate.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface SearchTableViewController (){
    NSDictionary *specialties;

}

@end



@implementation SearchTableViewController{
    CLLocationManager *locationManager;
    double lat;
    double lon;
}

@synthesize searchTable, specialtyNameLabel, receiveDisplay, receiveName, tabBarController, latitude, longitude, categoriesUploadEngine, flOperation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    [searchTable setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-main.png"]]];
    specialtyNameLabel.text = @"Tap para seleccionar una especialidad";
    
    UIView *backgroundSelectedCell = [[UIView alloc] init];
    [backgroundSelectedCell setBackgroundColor:[UIColor colorWithRed:(68/255.0) green:(110/255.0) blue:(32/255.0) alpha:1]];
    
    for (int section = 0; section < [self.tableView numberOfSections]; section++)
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++)
        {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
            
            [cell setSelectedBackgroundView:backgroundSelectedCell];
            
            if (cellPath.row == 0){
                UIImage *image = [UIImage imageNamed:@"medical.png"]; //or wherever you take your image from
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                cell.accessoryView = imageView;
            }
        }
    
    NSLog(@"specialties in didload = %@", specialties);

   // NSLog(@"%@", specialties);
}

-(void)viewDidAppear:(BOOL)animated
{
    /*
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:@"especialidad" forKey:@"todos"];

    [ApplicationDelegate.infoEngine getInfo:postParams completionHandler:^(NSDictionary *categories){
        specialties = categories;
        NSLog(@"specialties in didAppear = %@", specialties);
    } errorHandler:^(NSError* error){
    }];
    */
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        NSIndexPath *indexPath = [self.searchTable indexPathForSelectedRow];
        [searchTable deselectRowAtIndexPath:indexPath animated:YES];
         NSLog(@"specialties in segue = %@", specialties);
    }
}


@end
