//
//  ProfileInRequestViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 8/21/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ProfileInRequestViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    UIImageView *containerView;
    IBOutlet UIScrollView *scroller;
}

@property (nonatomic, strong) NSDictionary *doc;
@property (nonatomic, strong) NSDictionary *doctorInfo;
@property(strong, nonatomic)NSString *nidReceived;
@property(strong, nonatomic)NSString *fromMap;
@property(strong, nonatomic)NSString *loginSuccess;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *coloniaLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuSidebarButton;

@end
