//
//  ProfileViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/26/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ProfileViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    UIImageView *containerView;
    IBOutlet UIScrollView *scroller;
}

@property (nonatomic, strong) NSDictionary *doc;
@property(strong, nonatomic)NSString *nidReceived;
@property(strong, nonatomic)NSString *fromMap;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
//@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *coloniaLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendMail;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
- (IBAction)goBack:(id)sender;
- (IBAction)butttonSendMail:(id)sender;
@end
