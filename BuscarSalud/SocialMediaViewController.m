//
//  SocialMediaViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/14/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "SocialMediaViewController.h"
#import "AccessDataViewController.h"

@interface SocialMediaViewController ()

@end

@implementation SocialMediaViewController

@synthesize userInfoRequestDictionary, facebookTextField, twitterTextField, linkedinTextField, googleplusTextField, requestOpenNoteLabel, requestFlag, requestObject;

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
    NSLog(@"%@", userInfoRequestDictionary);
    
    if ([requestFlag isEqualToString:@"0"]) {
        requestOpenNoteLabel.hidden = NO;
        [facebookTextField setEnabled:NO];
        [twitterTextField setEnabled:NO];
        [linkedinTextField setEnabled:NO];
        [googleplusTextField setEnabled:NO];
        
        facebookTextField.text = [requestObject valueForKey:@"facebook"];
        twitterTextField.text = [requestObject valueForKey:@"twitter"];
        linkedinTextField.text = [requestObject valueForKey:@"linkedin"];
        googleplusTextField.text = [requestObject valueForKey:@"googleplus"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButton:(id)sender {
    BOOL flagSocial = NO;
    NSMutableDictionary *social = [[NSMutableDictionary alloc]init];
    
    if (![facebookTextField.text isEqualToString:@""]) {
        [social setValue:facebookTextField.text forKey:@"facebook"];
        flagSocial = YES;
    }
    if (![twitterTextField.text isEqualToString:@""]) {
        [social setValue:twitterTextField.text forKey:@"twitter"];
        flagSocial = YES;
    }
    if (![linkedinTextField.text isEqualToString:@""]) {
        [social setValue:linkedinTextField.text forKey:@"linkedin"];
        flagSocial = YES;
    }
    if (![googleplusTextField.text isEqualToString:@""]) {
        [social setValue:googleplusTextField.text forKey:@"googleplus"];
        flagSocial = YES;
    }
    
    if (flagSocial == YES) {
        [userInfoRequestDictionary setValue:social forKey:@"social_media"];
    }
    
    [self performSegueWithIdentifier:@"socialMediaToAccessData" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"socialMediaToAccessData"]){
        AccessDataViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.requestFlag = requestFlag;
        destViewController.requestObject = requestObject;
        NSLog(@"Segue Languages to Social Media");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [facebookTextField resignFirstResponder];
    [twitterTextField resignFirstResponder];
    [linkedinTextField resignFirstResponder];
    [googleplusTextField resignFirstResponder];
}

@end
