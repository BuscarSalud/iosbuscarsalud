//
//  LoadingAndDecideViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 8/15/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingAndDecideViewController : UIViewController
{
    UIImageView *containerView;

}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *passFlag;
@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *uuid;
@property (weak, nonatomic) IBOutlet UITextField *usernameEmailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuSlideButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBottomConstraint;


- (IBAction)loginButton:(id)sender;
- (IBAction)registerButton:(id)sender;
@end
