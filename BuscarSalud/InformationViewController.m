//
//  InformationViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 5/5/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "InformationViewController.h"
#import "SWRevealViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

@synthesize sidebarButton;

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
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMail:(id)sender {
    NSString *subject = [[NSString alloc]initWithFormat:@"Ayuda con app de BuscarSalud"];
    NSString *message = [[NSString alloc]initWithFormat:@"Hola equipo de soporte tecnico de BuscarSalud. Estoy teniendo algunos problemas con la aplicacion para iPhone. Esto es lo que pasa: \n"];
    MFMailComposeViewController *mailcontroller = [[MFMailComposeViewController alloc] init];
    [mailcontroller setMailComposeDelegate:self];
    NSString *email1 = @"felix@buscarsalud.com";
    NSString *email2 = @"cristian@buscarsalud.com";
    NSArray *emailArray = [[NSArray alloc] initWithObjects:email1,email2, nil];
    [mailcontroller setToRecipients:emailArray];
    [mailcontroller setSubject:subject];
    
    [mailcontroller setMessageBody:message isHTML:NO];
    
    [self presentViewController:mailcontroller animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
