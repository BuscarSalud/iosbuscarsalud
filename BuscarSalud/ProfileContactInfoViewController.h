//
//  ProfileContactInfoViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 5/7/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileContactInfoViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *scroller;
}

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;
@property (retain, nonatomic)NSMutableArray *stat;
@property (retain, nonatomic)NSMutableArray *specialties;
@property (strong, nonatomic)IBOutlet UIPickerView *statePicker;
@property (weak, nonatomic) IBOutlet UITextField *officeNameTextIField;
@property (weak, nonatomic) IBOutlet UITextField *streetNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *coloniaTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *cellphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *streetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)selectState:(id)sender;
- (IBAction)cancelPicker:(id)sender;
- (IBAction)selectedState:(id)sender;
- (IBAction)nextButton:(id)sender;

@end
