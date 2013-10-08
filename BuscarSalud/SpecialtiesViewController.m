//
//  SpecialtiesViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/21/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "SpecialtiesViewController.h"
#import "AppDelegate.h"
#import "Specialty.h"
#import "iOSRequest.h"
#import "DoctorResultsViewController.h"


@interface SpecialtiesViewController (){
    NSMutableArray *spec;
    NSDictionary *states;
    UIView *containerView;
    NSIndexPath *lastPath;
}

@end

@implementation SpecialtiesViewController
@synthesize longitudeSpec, latitudeSpec, myTableView, navBar, subTextLabel, specialtiesDictionary;

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
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                  361.0,
                                                                  GAD_SIZE_320x50.width,
                                                                  GAD_SIZE_320x50.height)];
    
    bannerView_.translatesAutoresizingMaskIntoConstraints=NO;

    
    // Specify the ad's "unit identifier". This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"ca-app-pub-5383770617488734/3234786808";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Constraint keeps ad at the bottom of the screen at all times.
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:bannerView_
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0
                                   constant:0]];
    
    // Constraint keeps ad in the center of the screen at all times.
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:bannerView_
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0
                                   constant:0]];
    
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for
    // the simulator as well as any devices you want to receive test ads.
    request.testDevices = [NSArray arrayWithObjects:
                           @"045BB3DE-3CF2-5B56-94AF-85CFDA9C7D1E",
                           nil];

    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:request];
    
    
    [self getAllStates];
    [self startLoadingBox];
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar-background"];
    [navBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];

    //UIFont *sourceSansProRegular = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    //UIFont *sourceSansProBold = [UIFont fontWithName:@"SourceSansPro-Bold" size:18];
    UIFont *sourceSansProSemibold = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    
    [subTextLabel setFont:sourceSansProSemibold];
    [subTextLabel setText:@"Mas Cerca de Ti"];
    
    NSLog(@"%@", longitudeSpec);
    
    //+++++++++++++
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:@"especialidad" forKey:@"todos"];
    
    [ApplicationDelegate.infoEngine getInfo:postParams completionHandler:^(NSDictionary *categories){
        specialtiesDictionary = categories;
        
        NSDictionary *specialtyInDictionary = [[NSDictionary alloc]init];
        spec = [[NSMutableArray alloc]init];
        
        for (int i =1; i<=[specialtiesDictionary count]; i++) {
            NSString *index = [NSString stringWithFormat:@"especialidad%d",i];
            specialtyInDictionary = [specialtiesDictionary objectForKey:index];
            Specialty *specialtyItem = [Specialty new];
            specialtyItem.display = [specialtyInDictionary objectForKey:@"nombre"];
            specialtyItem.name = [specialtyInDictionary objectForKey:@"tid"];
            [spec addObject:specialtyItem];
            
        }
        [self.myTableView reloadData];
        [self finishLoadingBox];
    } errorHandler:^(NSError* error){
    }];
    //+++++++++++++
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [myTableView deselectRowAtIndexPath:lastPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TableView Data Source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [spec count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"MyCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Specialty *specialties = [spec objectAtIndex:indexPath.row];
    UILabel *specNameLabel = (UILabel *)[cell viewWithTag:101];
    [specNameLabel setFont:[UIFont fontWithName:@"SourceSansPro-Black.otf" size:20]];

    specNameLabel.text = specialties.display;
    
    // change background color of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:(93/255.0) green:(153/255.0) blue:(41/255.0) alpha:11]];
    [cell setSelectedBackgroundView:bgColorView];
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lastPath = indexPath;    
}

# pragma mark - Prepare Data for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goToDoctorResults"]) {
        DoctorResultsViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        Specialty *specialty = [spec objectAtIndex:indexPath.row];
        destViewController.specialtyString = specialty.name;
        destViewController.latitudeUser = latitudeSpec;
        destViewController.longitudeUser = longitudeSpec;
        destViewController.subtitleString = specialty.display;
        destViewController.specialities = spec;
        destViewController.statesDictionary = states;
        NSLog(@"Estados: %@", states);
    }
}

-(void)getAllStates{
   /* [iOSRequest getSpecialtiesAndStates:@"" andState:@"" andAll:@"estado" onCompletion:^(NSDictionary *specs){
        dispatch_async(dispatch_get_main_queue(), ^{
            states = specs;
        });
    }];*/
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:@"estado" forKey:@"todos"];
    
    [ApplicationDelegate.infoEngine getInfo:postParams completionHandler:^(NSDictionary *categories){
        states = categories;
    } errorHandler:^(NSError* error){
    }];

}

-(void)startLoadingBox{
    NSLog(@"Empiexza loading box");
    UIImage *statusImage = [UIImage imageNamed:@"loading-background"];
    UIActivityIndicatorView *activitIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    containerView = [[UIImageView alloc] init];
    UIImageView *activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    activitIndicator.center = activityImageView.center;
    [activitIndicator startAnimating];
    [containerView addSubview:activityImageView];
    [containerView addSubview:activitIndicator];
    
    [containerView setAlpha:0.0];
    [self.navigationController.view addSubview:containerView];
    [UIView beginAnimations:nil context:nil];
    [containerView setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)finishLoadingBox{
    [containerView setAlpha:1.0];
    [UIView beginAnimations:nil context:nil];
    [containerView setAlpha:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDelegate:containerView];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
}

@end
