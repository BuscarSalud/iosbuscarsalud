//
//  AccessDataViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/16/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileUploadEngine.h"


@interface AccessDataViewController : UIViewController<UITextFieldDelegate>{
    UIImageView *containerView;

}

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;

@property (strong, nonatomic) fileUploadEngine *flUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordsMatchLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)sendButton:(id)sender;
@end
