//
//  LoadingAndDecideViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 8/15/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "LoadingAndDecideViewController.h"
#import "GetProfileViewController.h"
#import "ProfileInRequestViewController.h"
#import "NSString+MD5.h"
#import "AppDelegate.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "SWRevealViewController.h"


@interface LoadingAndDecideViewController (){
    NSString *loginSuccess;
    NSDictionary *doctorInfo;
}

@end

@implementation LoadingAndDecideViewController
@synthesize uuid, requestObject, passFlag, nid, passwordField, usernameEmailField, window, menuSlideButton, registerButton, loginButton, registerBottomConstraint;

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
	// Do any additional setup after loading the view.
    NSLog(@"Request Object -> %@", requestObject);
    NSLog(@"Pass Flag en LoadingAndDecide -> %@", passFlag);
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuSlideButton.target = self.revealViewController;
    menuSlideButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Login Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self.view removeConstraint:registerBottomConstraint];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        registerBottomConstraint =  [NSLayoutConstraint constraintWithItem:registerButton
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-30];
        [self.view addConstraint:registerBottomConstraint];

    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        registerBottomConstraint =  [NSLayoutConstraint constraintWithItem:registerButton
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-30];
        [self.view addConstraint:registerBottomConstraint];
        
    } else if (orientation == UIInterfaceOrientationPortrait) {
        registerBottomConstraint =  [NSLayoutConstraint constraintWithItem:registerButton
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-94];
        [self.view addConstraint:registerBottomConstraint];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    requestObject = [defaults objectForKey:@"requestObject"];
    passFlag = [defaults objectForKey:@"passFlag"];
    nid = [defaults objectForKey:@"nid"];
    uuid = [defaults objectForKey:@"uuid"];
    NSString *isLogged = [defaults objectForKey:@"profileClaimedAlert"];
    
    if ([passFlag isEqualToString:@"1"] || [isLogged isEqualToString:@"1"]) {
        [self performSegueWithIdentifier:@"toProfile" sender:self];
    }
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self.view removeConstraint:registerBottomConstraint];
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        NSLog(@"Landscape Left");
        registerBottomConstraint =  [NSLayoutConstraint constraintWithItem:registerButton
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-30];
        [self.view addConstraint:registerBottomConstraint];
    }
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape Right");
        registerBottomConstraint =  [NSLayoutConstraint constraintWithItem:registerButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-30];
        [self.view addConstraint:registerBottomConstraint];
    }
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        registerBottomConstraint =  [NSLayoutConstraint constraintWithItem:registerButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-94];
        [self.view addConstraint:registerBottomConstraint];
    }
    //registerButton.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toRequest"]){
        GetProfileViewController *destViewController = segue.destinationViewController;
        destViewController.uuid = uuid;
        destViewController.passFlag = passFlag;
        destViewController.requestObject = requestObject;
    }
    if ([segue.identifier isEqualToString:@"toProfile"]){
        ProfileInRequestViewController *destViewController = segue.destinationViewController;
        destViewController.nidReceived = nid;
        destViewController.loginSuccess = loginSuccess;
        destViewController.doctorInfo = doctorInfo;
    }
}

-(IBAction)reset:(UIStoryboardSegue *)segue {
    //do stuff
}

- (IBAction)loginButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *passwordMD5 = [passwordField.text MD5];
    NSString *usernameEmail = usernameEmailField.text;
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:usernameEmail forKey:@"user"];
    [postParams setValue:passwordMD5 forKey:@"pass"];
    [postParams setValue:@"1" forKey:@"login"];
    
    [ApplicationDelegate.infoEngine login:postParams completionHandler:^(NSDictionary *response){
        //NSLog(@"%@", response);
        doctorInfo = response;
        NSNumber *responseString = [response valueForKey:@"responseCode"];
        if ([responseString isEqualToNumber:@([@"1" integerValue])]) {
            nid = [response valueForKey:@"nid"];
            loginSuccess = @"1";
            [defaults setObject:@"1" forKey:@"logged"];
            [defaults setObject:nid forKey:@"nid"];
            [defaults setObject:@"1" forKey:@"profileClaimedAlert"];
            [defaults setObject:usernameEmail forKey:@"user_logged"];
            [defaults synchronize];            
            [self performSegueWithIdentifier:@"toProfile" sender:self];
        }else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Verfique su nombre de usuario y contraseña" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
        NSLog(@"%@", response);

    } errorHandler:^(NSError* error){
    }];

}

- (IBAction)registerButton:(id)sender {
    [self performSegueWithIdentifier:@"toRequest" sender:self];
    
}
@end
