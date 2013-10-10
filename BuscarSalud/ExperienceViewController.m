//
//  ExperienceViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/13/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "ExperienceViewController.h"
#import "LanguagesViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface ExperienceViewController ()
{
    int dateSinceUntil;
    NSDate *selectedDate;
    NSString *dateSince;
    NSString *dateUntil;
    NSDate *now;
    int puestoActual;
    BOOL switchVal;
}

@end

@implementation ExperienceViewController
@synthesize userInfoRequestDictionary, datePicker, datePickerViewContainer, selectDateSinceButton, selectDateUntilButton, descriptionTextView, scroller, puestoTextField, ubicacionTextField, empresaTextField, urlEmpresaTextField, requestOpenNoteLabel, requestFlag, requestObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"%@", userInfoRequestDictionary);
    datePicker.datePickerMode = UIDatePickerModeDate;
    now = [NSDate date];
    
    [sw1 setState:NO];
    sw1 = [[Switchy alloc] initWithFrame:CGRectMake(0, 0, 70, 25) withOnLabel:@"Si" andOfflabel:@"No"
                     withContainerColor1:[UIColor colorWithRed:0.1 green:0.7 blue:0.1 alpha:1.0]
                      andContainerColor2:[UIColor colorWithRed:0.1 green:0.4 blue:0.1 alpha:1.0]
                          withKnobColor1:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                           andKnobColor2:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0] withShine:NO];
    [self.scroller addSubview:sw1];
    sw1.center = CGPointMake(146, 149);
    
    descriptionTextView.delegate = self;
    puestoTextField.delegate = self;
    ubicacionTextField.delegate = self;
    empresaTextField.delegate = self;
    urlEmpresaTextField.delegate = self;
    
    if ([requestFlag isEqualToString:@"0"]) {
        [sw1 setEnabled:NO];
        requestOpenNoteLabel.hidden = NO;
        puestoTextField.text = [requestObject valueForKey:@"job"];
        ubicacionTextField.text = [requestObject valueForKey:@"jobLocality"];
        int currentjob = [[requestObject valueForKey:@"currentJob"] intValue];
        if (currentjob == 1){
            [sw1 setState:YES];
        }
        empresaTextField.text = [requestObject valueForKey:@"company"];
        urlEmpresaTextField.text = [requestObject valueForKey:@"urlCompany"];
        descriptionTextView.text = [requestObject valueForKey:@"desc"];
    }

    
    [[descriptionTextView layer] setBorderColor:[[UIColor colorWithRed:170/256.0 green:170/256.0 blue:170/256.0 alpha:1.0] CGColor]];
    [[descriptionTextView layer] setBorderWidth:2.3];
    [[descriptionTextView layer] setCornerRadius:10];
    [descriptionTextView setClipsToBounds: YES];
    [descriptionTextView setEditable:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [scroller addGestureRecognizer:tapGesture];
    
    puestoTextField.delegate = self;
    empresaTextField.delegate = self;
    urlEmpresaTextField.delegate = self;
    descriptionTextView.delegate = self;

}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Claim Profile - Experience Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 430)];
    [sw1 addTarget:self action:@selector(switchy) forControlEvents:UIControlEventTouchUpInside];
    switchVal = [sw1 getOn];
    if (switchVal == YES) {
        NSLog(@"Si");
        puestoActual = 1;
    }
    if (switchVal == NO) {
        NSLog(@"No");
        puestoActual = 0;
    }
    dateSince = @"";
    dateUntil = @"";
}

-(void)switchy{
    switchVal = [sw1 getOn];
    if (switchVal == YES) {
        NSLog(@"Si");
        puestoActual = 1;
    }
    if (switchVal == NO) {
        NSLog(@"No");
        puestoActual = 0;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [scroller setContentOffset:CGPointMake(0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonDatePickerView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        datePickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    }];
}

- (IBAction)selectButtonDatePickerView:(id)sender {
    selectedDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *convertedString = [dateFormatter stringFromDate:selectedDate];
    
    if (dateSinceUntil == 0) {
        [selectDateSinceButton setTitle:convertedString forState:UIControlStateNormal];
        dateSince = convertedString;
    }
    if (dateSinceUntil == 1) {
        [selectDateUntilButton setTitle:convertedString forState:UIControlStateNormal];
        dateUntil = convertedString;
    }
    [UIView animateWithDuration:0.3 animations:^{
        datePickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    }];
}

- (IBAction)selectDateButton:(id)sender {
    [datePicker setDate:now];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        datePickerViewContainer.frame = CGRectMake(0, 107, 320, 260);
        dateSinceUntil = 0;
    }];
}

- (IBAction)selectDateUntilButton:(id)sender {
    [datePicker setDate:now];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        datePickerViewContainer.frame = CGRectMake(0, 107, 320, 260);
        dateSinceUntil = 1;
    }];
}

- (IBAction)nextButton:(id)sender {
    BOOL flag = NO;
    NSMutableDictionary *experiencia = [[NSMutableDictionary alloc]init];
    
    if (![puestoTextField.text isEqualToString:@""]) {
        [experiencia setValue:puestoTextField.text forKey:@"puesto"];
        flag = YES;
    }
    
    if (![ubicacionTextField.text isEqualToString:@""]) {
        [experiencia setValue:ubicacionTextField.text forKey:@"ubicacion"];
        flag = YES;
    }
    
    if (![dateSince isEqualToString:@""]) {
        [experiencia setValue:dateSince forKey:@"fecha_desde"];
        flag = YES;
    }
    
    if (puestoActual == 1) {
        [experiencia setValue:[NSString stringWithFormat:@"%d", puestoActual] forKey:@"puesto_actual"];
        flag = YES;
    }else{
        if (puestoActual == 0) {
            flag = NO;
        }
    }
    
    if (![dateUntil isEqualToString:@""]) {
        [experiencia setValue:dateUntil forKey:@"fecha_hasta"];
        flag = YES;
    }
    
    if (![empresaTextField.text isEqualToString:@""]) {
        [experiencia setValue:empresaTextField.text forKey:@"empresa"];
        flag = YES;
    }
    
    if (![urlEmpresaTextField.text isEqualToString:@""]) {
        [experiencia setValue:urlEmpresaTextField.text forKey:@"url_empresa"];
        flag = YES;
    }
    
    if (![descriptionTextView.text isEqualToString:@""]) {
        [experiencia setValue:descriptionTextView.text forKey:@"descripcion"];
        flag = YES;
    }
    
    if (flag == YES) {
        [userInfoRequestDictionary setValue:experiencia forKey:@"experiencia"];
    }

    [self performSegueWithIdentifier:@"experienceToLanguages" sender:self];
}

- (void)dismissKeyboard{
    [puestoTextField resignFirstResponder];
    [ubicacionTextField resignFirstResponder];
    [empresaTextField resignFirstResponder];
    [urlEmpresaTextField resignFirstResponder];
    [descriptionTextView resignFirstResponder];

}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    if ([requestFlag isEqualToString:@"0"]) {
        [textField setEnabled:NO];
    }else{
        int yValue;
        int bottomOffset;
        BOOL flag = NO;
        switch (textField.tag) {
            case 101:
                yValue = -45;
                bottomOffset = 0;
                NSLog(@"Value y = %d", yValue);
                flag = YES;
                break;
            case 102:
                yValue = -90;
                bottomOffset = 0;
                NSLog(@"Value y = %d", yValue);
                flag = YES;
                break;
            case 201:
                yValue = -125;
                bottomOffset = scroller.contentSize.height - scroller.bounds.size.height;
                NSLog(@"Value y = %d", yValue);
                flag = YES;
                break;
            default:
                break;
        }
        if (flag == YES) {
            [UIView animateWithDuration:0.3 animations:^{
                [scroller setContentOffset:CGPointMake(0, bottomOffset)];
                [UIView setAnimationBeginsFromCurrentState:YES];
                scroller.frame = CGRectMake(0, yValue, scroller.frame.size.width, scroller.frame.size.height);
            }];
        }else{
            NSLog(@"Nooooo");
        }
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    int yValue;
    int bottomOffset;
    BOOL flag = NO;
    switch (textField.tag) {
        case 101:
            yValue = 0;
            bottomOffset = 0;
            NSLog(@"Value y = %d", yValue);
            flag = YES;
            break;
        case 102:
            yValue = 0;
            bottomOffset = 0;
            NSLog(@"Value y = %d", yValue);
            flag = YES;
            break;
        case 201:
            yValue = 0;
            bottomOffset = scroller.contentSize.height - scroller.bounds.size.height;
            NSLog(@"Value y = %d", yValue);
            flag = YES;
            break;
            
        default:
            break;
    }
    if (flag == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            [scroller setContentOffset:CGPointMake(0, bottomOffset)];
            [UIView setAnimationBeginsFromCurrentState:YES];
            scroller.frame = CGRectMake(0, yValue, scroller.frame.size.width, scroller.frame.size.height);
        }];
    }else{
        NSLog(@"Nooooo");
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([requestFlag isEqualToString:@"0"]) {
        [textView setEditable:NO];
    }else{
        NSLog(@"Text View in focus");
        int bottomOffset = scroller.contentSize.height - scroller.bounds.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            [scroller setContentOffset:CGPointMake(0, bottomOffset)];
            [UIView setAnimationBeginsFromCurrentState:YES];
            scroller.frame = CGRectMake(0, -115, scroller.frame.size.width, scroller.frame.size.height);
        }];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    int bottomOffset = scroller.contentSize.height - scroller.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        [scroller setContentOffset:CGPointMake(0, bottomOffset)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        scroller.frame = CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height);
    }];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"experienceToLanguages"]){
        LanguagesViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.requestFlag = requestFlag;
        destViewController.requestObject = requestObject;
        NSLog(@"Segue Experience to Laguages");
    }
}

@end
