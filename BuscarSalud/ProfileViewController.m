//
//  ProfileViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/26/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "iOSRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SingleDoctorMapViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"


@interface ProfileViewController ()
{
    NSDictionary *doctorInfo;
    NSDictionary *idiomas;
    NSDictionary *experiencia;
    NSDictionary *cedulas;
    NSMutableArray *dynamicSubviews;
    NSLayoutConstraint *streetLabelConstraint;
    NSLayoutConstraint *specialtyLableConstraint;
    NSLayoutConstraint *coloniaLabelConstraint;
    NSLayoutConstraint *stateCityConstraint;
    NSLayoutConstraint *pointsImageViewContainterConstraint;
    UIImage *pointsContainerImage;
    UIImageView *pointsImageView;
    UIView *innerDynamicDataContainer;

    int limit;
    int baseLineVariable;
    int fl;
    BOOL landscape;
    int marginItemConstant;
    
}

#define IS_WIDESCREEN ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define BASE_LINE 150
#define BASE_SEPARATOR 8
#define BASE_HEADING 13
#define BASE_ITEMS 12
#define BASE_BLOCK 20
#define BASE_EMPTY 10
#define BASE_ITEM_SEPARATOR 12
#define BASE_SEPARATOR_ITEM 6
#define ITEM_HEIGHT 12
#define HEADING_HEIGHT 20
//#define marginHeading 15
//#define marginItem 15
#define MARGIN_SECOND_ITEM 210
@end

@implementation ProfileViewController
@synthesize nidReceived, phoneLabel, imageProfile, streetLabel, coloniaLabel, specialtyLabel, fromMap, subTitleLabel, stateLabel, navBar, mapButton, sendMail, phoneImageView, profileHeaderImageView, profileImageConstraintLeft, stateLabelConstraintLeft, scrollerBottomConstraint, scrollerDynamicContentView, emailButtonRightConstraint, pointsContainerLeftConstraint, pointsContainerView; 

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
    
    landscape = NO;
    
    pointsContainerImage = [UIImage imageNamed:@"points-container.png"];
    pointsImageView = [[UIImageView alloc]initWithImage:pointsContainerImage];
    pointsContainerView.alpha = 0.0;

    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                  361.0,
                                                                  GAD_SIZE_320x50.width,
                                                                  GAD_SIZE_320x50.height)];
    
    bannerView_.translatesAutoresizingMaskIntoConstraints=NO;
    
    
    // Specify the ad's "unit identifier". This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"ca-app-pub-5383770617488734/6709630408";
    
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
    /*request.testDevices = [NSArray arrayWithObjects:
                           @"045BB3DE-3CF2-5B56-94AF-85CFDA9C7D1E",
                           nil];*/
    request.testDevices = [NSArray arrayWithObjects:@"33c1dd26714bf1d45a6e583a9b626399",GAD_SIMULATOR_ID, nil];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:request];


    phoneImageView.hidden = YES;
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar-background"];
    [navBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self startLoadingBox];
    NSLog(@"Nid received: %@", nidReceived);
    [self getDoctor:nidReceived];
    [sendMail setAlpha:0.0];

    
    UIFont *sourceSansProSemibold = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    UIFont *sourceSansProSemiboldHeader = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16];
    
    UILabel *educationHeaderLabel = (UILabel *)[self.view viewWithTag:101];
    UILabel *languagesHeaderLabel = (UILabel *)[self.view viewWithTag:102];
    UILabel *experienceHeaderLabel = (UILabel *)[self.view viewWithTag:103];
    
    [subTitleLabel setFont:sourceSansProSemibold];
    [educationHeaderLabel setFont:sourceSansProSemiboldHeader];
    [languagesHeaderLabel setFont:sourceSansProSemiboldHeader];
    [experienceHeaderLabel setFont:sourceSansProSemiboldHeader];
    
    
    
}

-(void)viewDidLayoutSubviews{
    if (landscape) {
        innerDynamicDataContainer.frame = CGRectMake(80, 150, scrollerDynamicContentView.frame.size.width, limit);
    }else{
        innerDynamicDataContainer.frame = CGRectMake(0, 150, scrollerDynamicContentView.frame.size.width, limit);
    }
    scrollerDynamicContentView.frame = CGRectMake(0, 0, scroller.frame.size.width, innerDynamicDataContainer.frame.size.height + 160);
    [scroller setContentSize:CGSizeMake(320, scrollerDynamicContentView.frame.size.height)];
}

-(void)handleInterfaceOrientation{
    if (IS_WIDESCREEN) {
        [profileHeaderImageView setImage:[UIImage imageNamed:@"profile-header1-300x568.png"]];
        [profileImageConstraintLeft setConstant:108];
        [pointsContainerLeftConstraint setConstant:206];
        [emailButtonRightConstraint setConstant:103];
    }else{
        [profileHeaderImageView setImage:[UIImage imageNamed:@"profile-header1-300x460.png"]];
        [emailButtonRightConstraint setConstant:58];
        [profileImageConstraintLeft setConstant:62];
        [pointsContainerLeftConstraint setConstant:159];
        
        streetLabelConstraint = [NSLayoutConstraint constraintWithItem:streetLabel
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:-63];
        [self.view addConstraint:streetLabelConstraint];
        
        specialtyLableConstraint = [NSLayoutConstraint constraintWithItem:specialtyLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:-63];
        [self.view addConstraint:specialtyLableConstraint];
        
        coloniaLabelConstraint = [NSLayoutConstraint constraintWithItem:coloniaLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0
                                                               constant:-63];
        [self.view addConstraint:coloniaLabelConstraint];
        
        stateCityConstraint = [NSLayoutConstraint constraintWithItem:stateLabel
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.0
                                                            constant:-63];
        [self.view addConstraint:stateCityConstraint];
        
        [[self phoneImageConstraint] setConstant:140];
    }
    [[self scrollerBottomConstraint] setConstant:37];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [bannerView_ removeFromSuperview];
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0.0, 340.0)];
        landscape = YES;
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape right");
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0.0, 340.0)];
        landscape = YES;
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        NSLog(@"Portrait");
        landscape = NO;
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0.0, 340.0)];
    }
    
    
    bannerView_.translatesAutoresizingMaskIntoConstraints=NO;
    
    bannerView_.adUnitID = @"ca-app-pub-5383770617488734/3234786808";
    
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
    /*request.testDevices = [NSArray arrayWithObjects:
     @"045BB3DE-3CF2-5B56-94AF-85CFDA9C7D1E",
     nil];*/
    
    request.testDevices = [NSArray arrayWithObjects:@"33c1dd26714bf1d45a6e583a9b626399",GAD_SIMULATOR_ID, nil];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:request];
    
    [scroller setScrollEnabled:YES];
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        [self handleInterfaceOrientation];
        landscape = YES;
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape right");
        [self handleInterfaceOrientation];
        landscape = YES;
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        NSLog(@"Portrait");
        [profileHeaderImageView setImage:[UIImage imageNamed:@"profile-header1.png"]];
        [profileImageConstraintLeft setConstant:17];
        [streetLabelConstraint setConstant:-20];
        [specialtyLableConstraint setConstant:-20];
        [coloniaLabelConstraint setConstant:-20];
        [stateCityConstraint setConstant:-20];
        [[self phoneImageConstraint] setConstant:70];
        [[self scrollerBottomConstraint] setConstant:55];
        [pointsContainerLeftConstraint setConstant:114];
        [emailButtonRightConstraint setConstant:16];
        landscape = NO;
    }

}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        NSLog(@"%@", subview);
        [subview removeFromSuperview];
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

-(void)getDoctor:(NSString *)nid
{
    /*
    [iOSRequest getDoctor:nid onCompletion:^(NSDictionary *doctor){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (doctor == nil) {
                //warningLabel.text = @"Error, Please Try Again";
                // warningLabel.hidden = NO;
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Alerta"
                                      message:@"Error de Conexión. Por favor intente de nuevo."
                                      delegate:nil
                                      cancelButtonTitle:@"Cancelar"
                                      otherButtonTitles:nil];
                
                [alert show];
                
            }
            [self setDoctor:doctor];
            doctorInfo = doctor;
            //[self loadDynamicData];
            [self performSelector:@selector(finishLoadingBox) withObject:nil afterDelay:1.0];
            subTitleLabel.text = [doctor objectForKey:@"name"];
        });
    }];*/
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:nid forKey:@"nid"];
    
    [ApplicationDelegate.infoEngine getDoctor:postParams completionHandler:^(NSDictionary *categories){
        if (categories == nil) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta"
                                  message:@"Error de Conexión. Por favor intente de nuevo."
                                  delegate:nil
                                  cancelButtonTitle:@"Cancelar"
                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
        [self setDoctor:categories];
        doctorInfo = categories;
        //[self loadDynamicData];
        [self performSelector:@selector(finishLoadingBox) withObject:nil afterDelay:1.0];
        subTitleLabel.text = [doctorInfo objectForKey:@"name"];
    } errorHandler:^(NSError* error){
    }];
}

-(void)setDoctor:(NSDictionary *)doc
{
    if (_doc != doc) {
        _doc = doc;
    }
    if ([[_doc objectForKey:@"latitude"] isKindOfClass:[NSNull class]]) {
        mapButton.enabled = NO; 
    }else{
        mapButton.enabled = YES;
    }
    NSLog(@"%@", _doc);
    [self createInfoDisplay:_doc];
    specialtyLabel.text = [[[_doc objectForKey:@"cedulas"] objectForKey:@"1"] objectForKey:@"degree"];;
    
    UILabel *schoolItemLabel = (UILabel *)[self.view viewWithTag:106];
    schoolItemLabel.text = [_doc objectForKey:@"school"];

    if ([[_doc objectForKey:@"phone"] isKindOfClass:[NSNull class]]){
        phoneLabel.hidden = YES;
    }else{
        phoneLabel.text = [_doc objectForKey:@"phone"];
        phoneImageView.hidden = NO;
    }
    if ([[_doc objectForKey:@"street"] isKindOfClass:[NSNull class]]){
        streetLabel.hidden = YES;
    }else{
        streetLabel.text = [_doc objectForKey:@"street"];
    }
    
    if ([[_doc objectForKey:@"colonia"] isKindOfClass:[NSNull class]]){
        coloniaLabel.hidden = YES;
    }else{
        coloniaLabel.text = [_doc objectForKey:@"colonia"];
    }
    
    if ([[_doc objectForKey:@"locality"] isKindOfClass:[NSNull class]]){
        stateLabel.hidden = YES;
    }else{
        stateLabel.text = [_doc objectForKey:@"locality"];
    }
    
    if ([[_doc objectForKey:@"photo"] isKindOfClass:[NSNull class]]){
        [imageProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
        [imageProfile setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [imageProfile setAlpha:1.0];
        [UIView commitAnimations];
    }else{
        NSString *photoURL = [NSString stringWithFormat:@"http://www.buscarsalud.com/sites/default/files/styles/perfil_medium/public/%@",[_doc objectForKey:@"photo"]];
        [imageProfile setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [imageProfile setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [imageProfile setAlpha:1.0];
        [UIView commitAnimations];
    }
    
    //Points
    if ([[_doc objectForKey:@"points"] isKindOfClass:[NSNull class]]){
        NSLog(@"No points");
    }else{
        UIFont *verdanaPoints = [UIFont fontWithName:@"Verdana-Bold" size:12];
        UILabel *pointsLabel = [[UILabel alloc]init];
        //[pointsContainerView addSubview:pointsImageView];
        [pointsContainerView addSubview:pointsLabel];
        
        [pointsLabel setText:[_doc objectForKey:@"points"]];
        [pointsLabel setFont:verdanaPoints];
        //pointsImageView.frame = CGRectMake(0, 0, pointsImageView.frame.size.width, pointsImageView.frame.size.height);
        pointsLabel.frame = CGRectMake(0, 18, pointsImageView.frame.size.width - 2, 10);
        pointsLabel.textAlignment = NSTextAlignmentCenter;
        [pointsLabel setBackgroundColor:[UIColor clearColor]];
        [pointsLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:174.0/255.0 blue:100.0/255.0 alpha:1.0]];
    }
    

}
- (IBAction)goBack:(id)sender {
    if ([fromMap isEqualToString:@"no"] ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([fromMap isEqualToString:@"yes"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)butttonSendMail:(id)sender {
    NSString *subject = [[NSString alloc]initWithFormat:@"Mensaje para el doctor %@", [doctorInfo objectForKey:@"name"]];
    MFMailComposeViewController *mailcontroller = [[MFMailComposeViewController alloc] init];
    [mailcontroller setMailComposeDelegate:self];
    NSString *email = [doctorInfo objectForKey:@"email"];
    NSArray *emailArray = [[NSArray alloc] initWithObjects:email, nil];
    [mailcontroller setToRecipients:emailArray];
    [mailcontroller setSubject:subject];
    [self presentViewController:mailcontroller animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
     [self dismissViewControllerAnimated:YES completion:nil];
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
    [self loadDynamicData:15 marginHeading:15];
}

- (void)createInfoDisplay:(NSDictionary *)info{
    UILabel *degreeItemLabel = (UILabel *)[self.view viewWithTag:104];
    degreeItemLabel.text = [[[_doc objectForKey:@"cedulas"] objectForKey:@"1"] objectForKey:@"degree"];
    
    CGRect frame = degreeItemLabel.frame;
    NSLog(@"Frame origin x = %f and Y = %f", frame.origin.x, frame.origin.y);
    frame.origin.y = 500;
    degreeItemLabel.frame = frame;
}


# pragma mark - Prepare Data for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goToSingleDoctorMap"]) {
        NSString *address = [NSString stringWithFormat:@"%@ %@",[_doc objectForKey:@"street"], [_doc objectForKey:@"colonia"]];
        SingleDoctorMapViewController *destViewController = segue.destinationViewController;
        destViewController.latReceived = [_doc objectForKey:@"latitude"];
        destViewController.lonReceived = [_doc objectForKey:@"longitude"];
        destViewController.addressReceived = address;
        destViewController.nameReceived = [_doc objectForKey:@"name"];
    }
}



-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Profile Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    
    [scroller setScrollEnabled:YES];
    //4[scroller setContentSize:CGSizeMake(320, limit)];
    
    //scroller.layer.borderWidth = 1;
    //scroller.layer.borderColor = [UIColor blackColor].CGColor;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [scroller setContentOffset:CGPointMake(0, 0)];
    
}

-(void)loadDynamicData:(int)marginItem marginHeading:(int)marginHeading
{
    dynamicSubviews = [[NSMutableArray alloc]init];
    innerDynamicDataContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 160, scrollerDynamicContentView.frame.size.width, 10)];
    [scrollerDynamicContentView addSubview:innerDynamicDataContainer];
    limit = 0;
    UIFont *sourceSansProSemiboldHeader = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16];
    UIFont *verdana = [UIFont fontWithName:@"Verdana" size:10];
    UIImage *separatorImage = [UIImage imageNamed:@"line-divider-profile.png"];
    UIImage *separatorItemImage = [UIImage imageNamed:@"line-divider-items-profile.png"];
    
    if ([[doctorInfo objectForKey:@"email"] isKindOfClass:[NSNull class]]){
        NSLog(@"No Email");
        //baseLineVariable = 150;
        baseLineVariable = 0;
    }else{
        //baseLineVariable = BASE_LINE + 18;
        baseLineVariable = 25;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [sendMail setAlpha:1.0];
        [UIView commitAnimations];
    }
    UIImageView *separatorViewEducation = [[UIImageView alloc] initWithImage:separatorImage];
    
    // Extract block
    fl = 0;
    if (![[doctorInfo objectForKey:@"subtitle"] isKindOfClass:[NSNull class]]) {
        UILabel *subtitleLabel = [[UILabel alloc]init];
        [subtitleLabel setFont:verdana];
        [subtitleLabel setText:[doctorInfo objectForKey:@"subtitle"]];
        [subtitleLabel setAlpha:0.0];
        [innerDynamicDataContainer addSubview:subtitleLabel];
        subtitleLabel.frame = CGRectMake(marginItem, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        fl = 1;
        subtitleLabel.numberOfLines = 0;
        [subtitleLabel sizeToFit];
        limit = baseLineVariable + BASE_ITEMS + 5;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [subtitleLabel setAlpha:1.0];
        [UIView commitAnimations];
        [dynamicSubviews addObject:subtitleLabel];
    }
    
    if (![[doctorInfo objectForKey:@"summary"] isKindOfClass:[NSNull class]]) {
        UILabel *summaryLabel = [[UILabel alloc]init];
        [summaryLabel setFont:verdana];
        [summaryLabel setText:[doctorInfo objectForKey:@"summary"]];
        [summaryLabel setAlpha:0.0];
        [innerDynamicDataContainer addSubview:summaryLabel];
        if (fl == 1) {
            summaryLabel.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + BASE_ITEMS;
        }else{
            summaryLabel.frame = CGRectMake(marginItem, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + baseLineVariable;
            fl = 1;
        }
        summaryLabel.numberOfLines = 0;
        [summaryLabel sizeToFit];
        limit = limit + 5 + summaryLabel.frame.size.height;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [summaryLabel setAlpha:1.0];
        [UIView commitAnimations];
        [dynamicSubviews addObject:summaryLabel];
    }else{
        if (fl == 1) {
            limit = limit + 5;
        }        
    }
    
    if (![[doctorInfo objectForKey:@"state"] isKindOfClass:[NSNull class]]) {
        UILabel *stateSubtitleLabel = [[UILabel alloc]init];
        [stateSubtitleLabel setFont:verdana];
        [stateSubtitleLabel setText:[doctorInfo objectForKey:@"state"]];
        [stateSubtitleLabel setAlpha:0.0];
        [innerDynamicDataContainer addSubview:stateSubtitleLabel];
        if (fl == 1) {
            stateSubtitleLabel.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + BASE_ITEMS + 5;
        }else{
            stateSubtitleLabel.frame = CGRectMake(marginItem, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = baseLineVariable + BASE_ITEMS + 5;
            fl = 1;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [stateSubtitleLabel setAlpha:1.0];
        [UIView commitAnimations];
        [dynamicSubviews addObject:stateSubtitleLabel];
    }

    if (![[doctorInfo objectForKey:@"specialty"] isKindOfClass:[NSNull class]]) {
        UILabel *specialtySubtitleLabel = [[UILabel alloc]init];
        [specialtySubtitleLabel setFont:verdana];
        [specialtySubtitleLabel setText:[doctorInfo objectForKey:@"specialty"]];
        [specialtySubtitleLabel setAlpha:0.0];
        [innerDynamicDataContainer addSubview:specialtySubtitleLabel];
        if (fl == 1 ){
            specialtySubtitleLabel.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + BASE_BLOCK;
        }else{
            specialtySubtitleLabel.frame = CGRectMake(marginItem, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + baseLineVariable;
            fl = 1;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [specialtySubtitleLabel setAlpha:1.0];
        [UIView commitAnimations];
        [dynamicSubviews addObject:specialtySubtitleLabel];
    }
    
    

    
    //--------------
    
    
    //Education block
    
    UILabel *educacionLabel = [[UILabel alloc]init];    
    [educacionLabel setText:@"Educación"];
    [educacionLabel setFont:sourceSansProSemiboldHeader];
    educacionLabel.backgroundColor = [UIColor clearColor];
    [educacionLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [innerDynamicDataContainer addSubview:educacionLabel];
    [innerDynamicDataContainer addSubview:separatorViewEducation];
    [dynamicSubviews addObject:educacionLabel];
    [dynamicSubviews addObject:separatorViewEducation];
    [educacionLabel setAlpha:0.0];
    [separatorViewEducation setAlpha:0.0];
    if (fl == 1){
        educacionLabel.frame = CGRectMake(marginHeading, limit, 100, HEADING_HEIGHT);
        limit = limit + BASE_HEADING;
    }else{
        educacionLabel.frame = CGRectMake(marginHeading, baseLineVariable, 100, HEADING_HEIGHT);
        limit = baseLineVariable + BASE_HEADING;
    }
    separatorViewEducation.frame = CGRectMake(9, limit, separatorViewEducation.frame.size.width, separatorViewEducation.frame.size.height);
    limit = limit + BASE_SEPARATOR;
    //limit = limit + BASE_HEADING;
    
    int cedulaCounter = 0;
    cedulas = [doctorInfo objectForKey:@"cedulas"];
    for (NSDictionary *cedulaItems in [cedulas allValues]){
        UIImageView *separatorViewItems = [[UIImageView alloc]initWithImage:separatorItemImage];
        
        UILabel *educationDegreeItem = [[UILabel alloc]init];
        UILabel *educationSchoolItem = [[UILabel alloc]init];
        UILabel *educationYearItem = [[UILabel alloc]init];
        
        educationDegreeItem.tag = cedulaCounter + 1;
        educationSchoolItem.tag = cedulaCounter + 1;
        educationYearItem.tag = cedulaCounter + 1;
        
        [educationDegreeItem setText:[cedulaItems objectForKey:@"degree"]];
        [educationSchoolItem setText:[cedulaItems objectForKey:@"school"]];
        [educationYearItem setText:[cedulaItems objectForKey:@"year"]];
        
        [educationDegreeItem setFont:verdana];
        [educationSchoolItem setFont:verdana];
        [educationYearItem setFont:verdana];
        
        [educationDegreeItem setAlpha:0.0];
        [educationSchoolItem setAlpha:0.0];
        [educationYearItem setAlpha:0.0];
        
        [innerDynamicDataContainer addSubview:educationDegreeItem];
        [innerDynamicDataContainer addSubview:educationSchoolItem];
        [innerDynamicDataContainer addSubview:educationYearItem];
        [dynamicSubviews addObject:educationDegreeItem];
        [dynamicSubviews addObject:educationSchoolItem];
        [dynamicSubviews addObject:educationYearItem];

        
        if (cedulaCounter == 0) {
            limit = limit + BASE_SEPARATOR;
        }else{
            if (cedulaCounter < [[doctorInfo objectForKey:@"cedulas"] count]) {
                limit = limit + BASE_ITEMS;
                [separatorViewItems setAlpha:0.0];
                [innerDynamicDataContainer addSubview:separatorViewItems];
                [dynamicSubviews addObject:separatorViewItems];
                separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
                limit = limit + BASE_SEPARATOR_ITEM + 5;
            }
        }
        educationDegreeItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        educationSchoolItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        educationSchoolItem.numberOfLines = 0;
        [educationSchoolItem sizeToFit];
        limit = limit + educationSchoolItem.frame.size.height;
        educationYearItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        
        if (cedulaCounter < [[cedulaItems objectForKey:@"cedulas"] count]) {
            limit = limit + educationYearItem.frame.size.height + 15;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationDuration:0.4];
        [educationDegreeItem setAlpha:1.0];
        [educationSchoolItem setAlpha:1.0];
        [educationYearItem setAlpha:1.0];
        [separatorViewItems setAlpha:1.0];
        [UIView commitAnimations];
        cedulaCounter++;
    }
    limit = limit + BASE_BLOCK;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationDuration:0.4];
    [educacionLabel setAlpha:1.0];
    [separatorViewEducation setAlpha:1.0];
    [UIView commitAnimations];
    
    //Languages Block
    UIImageView *separatorViewLanguages = [[UIImageView alloc]initWithImage:separatorImage];
    UILabel *languagesHeaderLabel = [[UILabel alloc]init];
    [languagesHeaderLabel setText:@"Idiomas"];
    [languagesHeaderLabel setFont:sourceSansProSemiboldHeader];
    languagesHeaderLabel.backgroundColor = [UIColor clearColor];
    [languagesHeaderLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [innerDynamicDataContainer addSubview:languagesHeaderLabel];
    [innerDynamicDataContainer addSubview:separatorViewLanguages];
    [dynamicSubviews addObject:languagesHeaderLabel];
    [dynamicSubviews addObject:separatorViewLanguages];
    [languagesHeaderLabel setAlpha:0.0];
    [separatorViewLanguages setAlpha:0.0];
    languagesHeaderLabel.frame = CGRectMake(marginHeading, limit, 100, HEADING_HEIGHT);
    limit = limit + BASE_HEADING;
    separatorViewLanguages.frame = CGRectMake(9, limit, separatorViewLanguages.frame.size.width, separatorViewLanguages.frame.size.height);
    //Language Items
    if ([[doctorInfo objectForKey:@"languages"] isKindOfClass:[NSNull class]]){
        NSLog(@"No tiene idiomas registrados");
        limit = limit + BASE_EMPTY;
    }else{
        int i = 0;
        idiomas = [doctorInfo objectForKey:@"languages"];
        //NSLog(@"%@", [idiomas allValues]);
        for (NSDictionary *languageItems in [idiomas allValues]) {            
            
            UIImageView *separatorViewItems = [[UIImageView alloc]initWithImage:separatorItemImage];
            UILabel *languageItem = [[UILabel alloc]init];
            UILabel *languageLevel = [[UILabel alloc]init];
            languageItem.tag = i + 1;
            languageLevel.tag = i + 1;
            [languageItem setText:[languageItems objectForKey:@"name"]];
            [languageLevel setText:[languageItems objectForKey:@"level"]];
            [languageItem setFont:verdana];
            [languageLevel setFont:verdana];
            
            [innerDynamicDataContainer addSubview:languageItem];
            [innerDynamicDataContainer addSubview:languageLevel];
            [dynamicSubviews addObject:languageItem];
            [dynamicSubviews addObject:languageLevel];
            [languageLevel setAlpha:0.0];
            [languageItem setAlpha:0.0];
            [separatorViewItems setAlpha:0.0];
            if (i == 0) {
                limit = limit + BASE_SEPARATOR;
            }else{
                if (i <= [[doctorInfo objectForKey:@"languages"] count]) {
                    [innerDynamicDataContainer addSubview:separatorViewItems];
                    [dynamicSubviews addObject:separatorViewItems];
                    separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
                    limit = limit + BASE_SEPARATOR_ITEM;
                }
            }
            languageItem.frame = CGRectMake(marginItem, limit, separatorViewLanguages.frame.size.width, ITEM_HEIGHT);
            languageLevel.frame = CGRectMake(MARGIN_SECOND_ITEM, limit, 160, ITEM_HEIGHT);
            if (i < [[doctorInfo objectForKey:@"languages"] count] - 1) {
                limit = limit + BASE_ITEM_SEPARATOR;
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.25];
            [UIView setAnimationDuration:0.4];
            [languageItem setAlpha:1.0];
            [separatorViewItems setAlpha:1.0];
            [languageLevel setAlpha:1.0];
            [UIView commitAnimations];
            i++;
        }
    }
    limit = limit + BASE_BLOCK;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.25];
    [UIView setAnimationDuration:0.4];
    [languagesHeaderLabel setAlpha:1.0];
    [separatorViewLanguages setAlpha:1.0];
    [UIView commitAnimations];
    
    //Experience block
    UIImageView *separatorViewExperience = [[UIImageView alloc]initWithImage:separatorImage];
    UILabel *experienceHeaderLabel = [[UILabel alloc]init];
    [experienceHeaderLabel setText:@"Experiencia"];
    [experienceHeaderLabel setFont:sourceSansProSemiboldHeader];
    experienceHeaderLabel.backgroundColor = [UIColor clearColor];
    [experienceHeaderLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [innerDynamicDataContainer addSubview:experienceHeaderLabel];
    [innerDynamicDataContainer addSubview:separatorViewExperience];
    [dynamicSubviews addObject:experienceHeaderLabel];
    [dynamicSubviews addObject:separatorViewExperience];
    [separatorViewExperience setAlpha:0.0];
    [experienceHeaderLabel setAlpha:0.0];
    experienceHeaderLabel.frame = CGRectMake(marginHeading, limit, 100, HEADING_HEIGHT);
    limit = limit + BASE_HEADING;
    separatorViewExperience.frame = CGRectMake(9, limit, separatorViewExperience.frame.size.width, separatorViewExperience.frame.size.height);
    if ([[doctorInfo objectForKey:@"experience"] isKindOfClass:[NSNull class]]){
        limit = limit + BASE_EMPTY + 10;
    }else{
        int i = 0;
        experiencia = [doctorInfo objectForKey:@"experience"];
        for (NSDictionary *experienceItems in [experiencia allValues]){
            UIImageView *separatorViewItems = [[UIImageView alloc]initWithImage:separatorItemImage];
            UILabel *experienceTitle = [[UILabel alloc]init];
            UILabel *experienceCompany = [[UILabel alloc]init];
            UILabel *experienceDescription = [[UILabel alloc]init];
            UILabel *experiencePeriod = [[UILabel alloc]init];
            experienceTitle.tag = i + 1;
            experienceCompany.tag = i + 1;
            experienceDescription.tag = i + 1;
            experiencePeriod.tag = i + 1;
            [experienceTitle setText:[experienceItems objectForKey:@"title"]];
            if (![[experienceItems objectForKey:@"company"] isKindOfClass:[NSNull class]]) {
                [experienceCompany setText:[experienceItems objectForKey:@"company"]];
            }
            if (![[experienceItems objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
                [experienceDescription setText:[experienceItems objectForKey:@"description"]];
            }
            [experiencePeriod setText:[experienceItems objectForKey:@"period"]];
            [experienceTitle setFont:verdana];
            [experienceCompany setFont:verdana];
            [experienceDescription setFont:verdana];
            [experiencePeriod setFont:verdana];

            [experienceTitle setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:245.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [experiencePeriod setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:245.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [experienceCompany setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:245.0/255.0 blue:253.0/255.0 alpha:1.0]];        
            [experienceTitle setAlpha:0.0];
            [experienceCompany setAlpha:0.0];
            [experienceDescription setAlpha:0.0];
            [experiencePeriod setAlpha:0.0];
            [innerDynamicDataContainer addSubview:experienceTitle];
            [innerDynamicDataContainer addSubview:experienceCompany];
            [innerDynamicDataContainer addSubview:experienceDescription];
            [innerDynamicDataContainer addSubview:experiencePeriod];
            [dynamicSubviews addObject:experienceTitle];
            [dynamicSubviews addObject:experienceCompany];
            [dynamicSubviews addObject:experienceDescription];
            [dynamicSubviews addObject:experiencePeriod];
            
            if (i == 0) {
                limit = limit + BASE_SEPARATOR;
            }else{
                if (i <= [[doctorInfo objectForKey:@"experience"] count]) {
                    [innerDynamicDataContainer addSubview:separatorViewItems];
                    [dynamicSubviews addObject:separatorViewItems];
                    separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
                    limit = limit + BASE_SEPARATOR_ITEM + 5;
                }
            }
            
            experienceTitle.frame = CGRectMake(marginItem, limit, 294, ITEM_HEIGHT);
            experiencePeriod.frame = CGRectMake(MARGIN_SECOND_ITEM, limit, 99, ITEM_HEIGHT);
            limit = limit + BASE_ITEM_SEPARATOR;
            experienceCompany.frame = CGRectMake(marginItem, limit, 294, ITEM_HEIGHT);
            limit = limit + BASE_ITEM_SEPARATOR + 3;
            experienceDescription.frame = CGRectMake(marginItem, limit, separatorViewItems.frame.size.width, experienceDescription.frame.size.height);
            experienceDescription.numberOfLines = 0;
            [experienceDescription sizeToFit];
            //limit = limit + experienceDescription.frame.size.height;
            //separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
            
            //[scroller addSubview:separatorViewItems];
            
            NSLog(@"Val i: %d   Val Dic: %d", i, [[doctorInfo objectForKey:@"experience"] count]);
            if (i < [[doctorInfo objectForKey:@"experience"] count]) {
                limit = limit + experienceDescription.frame.size.height + 15;
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.25];
            [UIView setAnimationDuration:0.4];
            [experienceTitle setAlpha:1.0];
            [experienceCompany setAlpha:1.0];
            [experienceDescription setAlpha:1.0];
            [experiencePeriod setAlpha:1.0];
            [UIView commitAnimations];
            i++;

        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:0.4];
    [separatorViewExperience setAlpha:1.0];
    [experienceHeaderLabel setAlpha:1.0];
    [UIView commitAnimations];
    
    limit = limit + 10;

    //Contact Information Block
    UIImageView *separatorViewContactInfo = [[UIImageView alloc]initWithImage:separatorImage];
    UILabel *contactInfoHeaderLabel = [[UILabel alloc]init];
    [contactInfoHeaderLabel setText:@"Información de Contacto"];
    [contactInfoHeaderLabel setFont:sourceSansProSemiboldHeader];
    contactInfoHeaderLabel.backgroundColor = [UIColor clearColor];
    [contactInfoHeaderLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [innerDynamicDataContainer addSubview:contactInfoHeaderLabel];
    [innerDynamicDataContainer addSubview:separatorViewContactInfo];
    [dynamicSubviews addObject:contactInfoHeaderLabel];
    [dynamicSubviews addObject:separatorViewContactInfo];
    [separatorViewContactInfo setAlpha:0.0];
    [contactInfoHeaderLabel setAlpha:0.0];
    contactInfoHeaderLabel.frame = CGRectMake(marginHeading, limit, 300, HEADING_HEIGHT);
    limit = limit + BASE_HEADING;
    separatorViewContactInfo.frame = CGRectMake(9, limit, separatorViewExperience.frame.size.width, separatorViewExperience.frame.size.height);
    limit = limit + BASE_SEPARATOR;
    //Address Name Item
    if ([[doctorInfo objectForKey:@"address_name"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin nombre en direccion");
    }else{
        UILabel *contactInfoNameItem = [[UILabel alloc]init];
        [contactInfoNameItem setText:[doctorInfo objectForKey:@"address_name"]];
        [contactInfoNameItem setFont:verdana];
        [innerDynamicDataContainer addSubview:contactInfoNameItem];
        [dynamicSubviews addObject:contactInfoNameItem];
        [contactInfoNameItem setAlpha:0.0];
        contactInfoNameItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoNameItem setAlpha:1.0];
        [UIView commitAnimations];
    }
     //Address Street Item
    if ([[doctorInfo objectForKey:@"street"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoStreetItem = [[UILabel alloc]init];
        [contactInfoStreetItem setText:[doctorInfo objectForKey:@"street"]];
        [contactInfoStreetItem setFont:verdana];
        [innerDynamicDataContainer addSubview:contactInfoStreetItem];
        [dynamicSubviews addObject:contactInfoStreetItem];
        [contactInfoStreetItem setAlpha:0.0];
        contactInfoStreetItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoStreetItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    //Address Colonia Item
    if ([[doctorInfo objectForKey:@"colonia"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoColoniaItem = [[UILabel alloc]init];
        [contactInfoColoniaItem setText:[doctorInfo objectForKey:@"colonia"]];
        [contactInfoColoniaItem setFont:verdana];
        [innerDynamicDataContainer addSubview:contactInfoColoniaItem];
        [dynamicSubviews addObject:contactInfoColoniaItem];
        [contactInfoColoniaItem setAlpha:0.0];
        contactInfoColoniaItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoColoniaItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    //Address Localty Item
    if ([[doctorInfo objectForKey:@"locality"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoLocalityItem = [[UILabel alloc]init];
        [contactInfoLocalityItem setText:[doctorInfo objectForKey:@"locality"]];
        [contactInfoLocalityItem setFont:verdana];
        [innerDynamicDataContainer addSubview:contactInfoLocalityItem];
        [dynamicSubviews addObject:contactInfoLocalityItem];
        [contactInfoLocalityItem setAlpha:0.0];
        contactInfoLocalityItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoLocalityItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    //Address Posta Code Item
    if ([[doctorInfo objectForKey:@"postal_code"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoPostalCodeItem = [[UILabel alloc]init];
        [contactInfoPostalCodeItem setText:[doctorInfo objectForKey:@"postal_code"]];
        [contactInfoPostalCodeItem setFont:verdana];
        [innerDynamicDataContainer addSubview:contactInfoPostalCodeItem];
        [dynamicSubviews addObject:contactInfoPostalCodeItem];
        [contactInfoPostalCodeItem setAlpha:0.0];
        contactInfoPostalCodeItem.frame = CGRectMake(marginItem, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoPostalCodeItem setAlpha:1.0];
        [UIView commitAnimations];
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.35];
    [UIView setAnimationDuration:0.4];
    [separatorViewContactInfo setAlpha:1.0];
    [contactInfoHeaderLabel setAlpha:1.0];
    [UIView commitAnimations];
    
    [[self pointsContainerLeftConstraint] setConstant:118];
    [UIView animateWithDuration:0.2
                          delay:0.7
                        options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         pointsContainerView.alpha = 1.0;
                         [[self pointsContainerView] layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [[self pointsContainerLeftConstraint] setConstant:114];
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                          [[self pointsContainerView]layoutIfNeeded];
                                          }
                          ];
                     }
     ];
    
    NSLog(@"Adentro dynamicData ------ Valor de Limit = %d", limit);
    NSLog(@"Adentro scroller = %@", scroller);
    innerDynamicDataContainer.frame = CGRectMake(0, 150, scrollerDynamicContentView.frame.size.width, limit);
    scrollerDynamicContentView.frame = CGRectMake(0, 0, scroller.frame.size.width, innerDynamicDataContainer.frame.size.height + 160);
    
    NSLog(@"Adentro scrollerDynamicContetView = %@", scrollerDynamicContentView);
    [scroller setContentSize:CGSizeMake(320, scrollerDynamicContentView.frame.size.height)];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  bannerView.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];
}

@end
