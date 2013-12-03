//
//  GetProfileViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 4/30/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileUploadEngine.h"
#import <QuartzCore/QuartzCore.h>


@interface GetProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>{
    
    UIImageView *containerView;
}

@property (nonatomic, strong) NSMutableDictionary *userInfoRequestDictionary;
@property (strong, nonatomic) fileUploadEngine *flUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;
@property (retain, nonatomic)NSMutableArray *stat;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *extractTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *extractLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *extractDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *charsRemainingTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *charsRemainingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerBottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *buttonNext;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *passFlag;

@property (nonatomic, strong) NSString *uuid;

- (IBAction)buttonNext:(id)sender;

@end
