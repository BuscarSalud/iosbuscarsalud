//
//  ProfileIdentityViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 6/9/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileIdentityViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;
@property (retain, nonatomic)NSMutableArray *statesArray;
@property (retain, nonatomic)NSMutableArray *specialtiesArray;
@property (weak, nonatomic) IBOutlet UIPickerView *stateSpecialtyPicker;
@property (strong, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *selectStateButton;
@property (weak, nonatomic) IBOutlet UIButton *selectSpecialtyButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCedFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectCedFront;
@property (weak, nonatomic) IBOutlet UITextField *cedNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)selectStateButton:(id)sender;
- (IBAction)selectSpecialtyButton:(id)sender;
- (IBAction)cancelButtonPickerView:(id)sender;
- (IBAction)selectButtonPickerView:(id)sender;
- (IBAction)nextButton:(id)sender;

@end
