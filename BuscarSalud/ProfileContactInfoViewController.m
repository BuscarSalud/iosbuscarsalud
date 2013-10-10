//
//  ProfileContactInfoViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 5/7/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "ProfileContactInfoViewController.h"
#import "ProfileIdentityViewController.h"
#import "AppDelegate.h"
#import "Specialty.h"
#import "States.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"


@interface ProfileContactInfoViewController ()
{
    NSDictionary *specialtiesDictionary;
    NSString *selectedStateName;
    NSString *selectedStateTid;
}

@end

@implementation ProfileContactInfoViewController

@synthesize userInfoRequestDictionary, pickerViewContainer, stat, officeNameTextIField, streetNumberTextField, coloniaTextField, cityTextField, postalCodeTextField, emailTextField, cellphoneTextField, phoneTextField, selectButton, streetNumberLabel, cityLabel, stateLabel, emailLabel, specialties, uuid, requestObject, requestFlag, requestOpenNoteLabel;

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
    
    pickerViewContainer.bounds = CGRectMake(0, 460, 320, 261);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [scroller addGestureRecognizer:tapGesture];

    officeNameTextIField.delegate = self;
    streetNumberTextField.delegate = self;
    coloniaTextField.delegate = self;
    cityTextField.delegate = self;
    postalCodeTextField.delegate = self;
    emailTextField.delegate = self;
    phoneTextField.delegate = self;
    cellphoneTextField.delegate = self;
    postalCodeTextField.delegate = self;
    emailTextField.delegate = self;
    phoneTextField.delegate = self;
    cellphoneTextField.delegate = self;
    selectedStateTid = @"";
    
    if ([requestFlag isEqualToString:@"0"]) {
        [officeNameTextIField setEnabled:NO];
        requestOpenNoteLabel.hidden = NO;
        officeNameTextIField.text = [requestObject valueForKey:@"officeName"];
        streetNumberTextField.text = [requestObject valueForKey:@"streetNumber"];
        coloniaTextField.text = [requestObject valueForKey:@"colonia"];
        cityTextField.text = [requestObject valueForKey:@"city"];
        postalCodeTextField.text = [requestObject valueForKey:@"postalCode"];
        emailTextField.text = [requestObject valueForKey:@"email"];
        phoneTextField.text = [requestObject valueForKey:@"phone"];
        cellphoneTextField.text = [requestObject valueForKey:@"cellphone"];
    }
    
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:@"especialidad" forKey:@"disponible"];
    
    [ApplicationDelegate.infoEngine getInfo:postParams completionHandler:^(NSDictionary *categories){
        specialtiesDictionary = categories;
        
        NSDictionary *specialtyInDictionary = [[NSDictionary alloc]init];
        specialties = [[NSMutableArray alloc]init];
        
        for (int i =0; i<=[specialtiesDictionary count]; i++) {
            NSString *index = [NSString stringWithFormat:@"especialidad%d",i];
            specialtyInDictionary = [specialtiesDictionary objectForKey:index];
            Specialty *specialtyItem = [Specialty new];
            specialtyItem.display = [specialtyInDictionary objectForKey:@"nombre"];
            specialtyItem.name = [NSString stringWithFormat:@"%@", [specialtyInDictionary objectForKey:@"tid"]];;
            [specialties addObject:specialtyItem];
        }
        NSLog(@"Stat array %@", specialties);
    } errorHandler:^(NSError* error){
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Claim Profile - Contact Info Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 450)];
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

- (IBAction)selectState:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [scroller setContentOffset:CGPointMake(0, 0)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        pickerViewContainer.frame = CGRectMake(0, 107, 320, 260);
        scroller.frame = CGRectMake(0, -138, scroller.frame.size.width, scroller.frame.size.height);
    }];
}

- (IBAction)cancelPicker:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
        scroller.frame = CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height);
    }];
}

- (IBAction)selectedState:(id)sender {
    [selectButton setTitle:selectedStateName forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
        scroller.frame = CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height);
    }];
}

- (void)dismissKeyboard{
    [officeNameTextIField resignFirstResponder];
    [streetNumberTextField resignFirstResponder];
    [coloniaTextField resignFirstResponder];
    [cityTextField resignFirstResponder];
    [postalCodeTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [cellphoneTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [stat count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    States *estados = [stat objectAtIndex:row];
    return estados.display;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    States *estados = [stat objectAtIndex:row];
    selectedStateName = estados.display;
    selectedStateTid = estados.name;
    
    NSLog(@"Selected state %@", estados.name);
}


- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([requestFlag isEqualToString:@"0"]) {
        [textField setEnabled:NO];
    }else{
        int yValue;
        int bottomOffset;
        BOOL flag = NO;
        switch (textField.tag) {
            case 105:
                yValue = -5;
                bottomOffset = 0;
                NSLog(@"Value y = %d", yValue);
                flag = YES;
                break;
            case 106:
                yValue = -155;
                bottomOffset = 0;
                NSLog(@"Value y = %d", yValue);
                flag = YES;
                break;
            case 107:
                yValue = -125;
                bottomOffset = scroller.contentSize.height - scroller.bounds.size.height;
                NSLog(@"Value y = %d", yValue);
                flag = YES;
                break;
            case 108:
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
        case 105:
            yValue = 0;
            bottomOffset = 0;
            NSLog(@"Value y = %d", yValue);
            flag = YES;
            break;
        case 106:
            yValue = 0;
            bottomOffset = 0;
            NSLog(@"Value y = %d", yValue);
            flag = YES;
            break;
        case 107:
            yValue = 0;
            bottomOffset = scroller.contentSize.height - scroller.bounds.size.height;
            NSLog(@"Value y = %d", yValue);
            flag = YES;
            break;
        case 108:
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

- (IBAction)nextButton:(id)sender {
    if ([streetNumberTextField.text isEqualToString:@""] || [cityTextField.text isEqualToString:@""] || [selectedStateTid isEqualToString:@""] || [emailTextField.text isEqualToString:@""]) {
        if ([streetNumberTextField.text isEqualToString:@""]) {
            streetNumberLabel.textColor = [UIColor redColor];
        }else{
            streetNumberLabel.textColor = [UIColor blackColor];
        }
        if ([cityTextField.text isEqualToString:@""]) {
            cityLabel.textColor = [UIColor redColor];
        }else{
            cityLabel.textColor = [UIColor blackColor];
        }
        if ([selectedStateTid isEqualToString:@""]) {
            stateLabel.textColor = [UIColor redColor];
        }else{
            stateLabel.textColor = [UIColor blackColor];
        }
        if ([emailTextField.text isEqualToString:@""]){
            emailLabel.textColor = [UIColor redColor];
        }else{
            emailLabel.textColor = [UIColor blackColor];
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alerta"
                              message:@"Por favor llene los campos obligatorios"
                              delegate:nil
                              cancelButtonTitle:@"Regresar"
                              otherButtonTitles:nil];

        [alert show];

    }else{
        NSMutableDictionary *domicilio = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *contacto = [[NSMutableDictionary alloc]init];
        
        if (![officeNameTextIField.text isEqualToString:@""]) {
            [domicilio setValue:officeNameTextIField.text forKey:@"consultorio"];
        }
        [domicilio setValue:streetNumberTextField.text forKey:@"callenumero"];
        
        if (![coloniaTextField.text isEqualToString:@""]) {
            [domicilio setValue:coloniaTextField.text forKey:@"colonia"];
        }
        [domicilio setValue:cityTextField.text forKey:@"ciudad"];
        
        if (![postalCodeTextField.text isEqualToString:@""]) {
            [domicilio setValue:postalCodeTextField.text forKey:@"codigopostal"];
        }
        [domicilio setValue:selectedStateTid forKey:@"estadotid"];
        
        [contacto setValue:emailTextField.text forKey:@"email"];
        
        if (![phoneTextField.text isEqualToString:@""]) {
            [contacto setValue:phoneTextField.text forKey:@"telefono"];
        }
        if (![cellphoneTextField.text isEqualToString:@""]) {
            [contacto setValue:cellphoneTextField.text forKey:@"celular"];
        }
        
        [userInfoRequestDictionary setValue:domicilio forKey:@"domicilio"];
        [userInfoRequestDictionary setValue:contacto forKey:@"contacto"];
        
        NSLog(@"%@", userInfoRequestDictionary);
        [self performSegueWithIdentifier:@"contactInfoToIdentity" sender:self];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"contactInfoToIdentity"]){
        ProfileIdentityViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.statesArray = stat;
        destViewController.specialtiesArray = specialties;
        destViewController.requestFlag = requestFlag;
        destViewController.requestObject = requestObject;
        NSLog(@"Segue!!");
    }
}



@end
