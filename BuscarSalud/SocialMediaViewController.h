//
//  SocialMediaViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/14/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialMediaViewController : UIViewController

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;

@property (weak, nonatomic) IBOutlet UITextField *facebookTextField;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (weak, nonatomic) IBOutlet UITextField *linkedinTextField;
@property (weak, nonatomic) IBOutlet UITextField *googleplusTextField;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)nextButton:(id)sender;

@end
