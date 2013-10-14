//
//  InformationViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 5/5/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface InformationViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


- (IBAction)sendMail:(id)sender;
@end
