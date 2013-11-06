//
//  LanguagesViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/14/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguagesViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;

@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (weak, nonatomic) IBOutlet UIPickerView *languagesPicker;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButtonPicker;
@property (weak, nonatomic) IBOutlet UIButton *selectLevel1Button;
@property (weak, nonatomic) IBOutlet UIButton *selectLevel2Button;
@property (weak, nonatomic) IBOutlet UITextField *language1TextField;
@property (weak, nonatomic) IBOutlet UITextField *language2TextField;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)selectLevel1Button:(id)sender;
- (IBAction)selectLevel2Button:(id)sender;
- (IBAction)cancelButtonPicker:(id)sender;
- (IBAction)selectButtonPicker:(id)sender;
- (IBAction)nextButton:(id)sender;

@end
