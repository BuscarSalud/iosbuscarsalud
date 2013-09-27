//
//  CedulaProfesionalViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/8/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CedulaProfesionalViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectCedFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCedFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelecteCedBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCedBack;
@property (weak, nonatomic) IBOutlet UITextField *cedNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)nextButton:(id)sender;
@end
