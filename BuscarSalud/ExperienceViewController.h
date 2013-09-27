//
//  ExperienceViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/13/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Switchy.h"

@interface ExperienceViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    Switchy *sw1;
}

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;

@property (weak, nonatomic) IBOutlet UIView *datePickerViewContainer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *selectDateSinceButton;
@property (weak, nonatomic) IBOutlet UIButton *selectDateUntilButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (weak, nonatomic) IBOutlet UITextField *puestoTextField;
@property (weak, nonatomic) IBOutlet UITextField *ubicacionTextField;
@property (weak, nonatomic) IBOutlet UITextField *empresaTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlEmpresaTextField;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)cancelButtonDatePickerView:(id)sender;
- (IBAction)selectButtonDatePickerView:(id)sender;
- (IBAction)selectDateButton:(id)sender;
- (IBAction)selectDateUntilButton:(id)sender;
- (IBAction)nextButton:(id)sender;


@end
