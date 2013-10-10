//
//  ProfileIdentityViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 6/9/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "ProfileIdentityViewController.h"
#import "CedulaProfesionalViewController.h"
#import "States.h"
#import "Specialty.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface ProfileIdentityViewController ()
{
    int flagButton;
    NSData *imageOne;
    NSData *imageTwo;
    int statSpec;
    NSString *selectedStateName;
    NSString *selectedStateTid;
    NSString *selectedSpecialtyName;
    NSString *selectedSpecialtyTid;
    UIImage *thumbCedFront;
    UIImage *thumbCedBack;
}

@end

@implementation ProfileIdentityViewController
@synthesize userInfoRequestDictionary, pickerViewContainer, statesArray, specialtiesArray, stateSpecialtyPicker, selectSpecialtyButton, selectStateButton, imageViewCedFront, imageViewSelectCedFront, cedNumberTextField, requestObject, requestFlag, requestOpenNoteLabel;

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
   // NSLog(@"%@", userInfoRequestDictionary);
	// Do any additional setup after loading the view.
    NSLog(@"Otro view, hizo segue");
    selectedSpecialtyName = @"";
    selectedStateName = @"";
   
    if ([requestFlag isEqualToString:@"0"]) {
        requestOpenNoteLabel.hidden = NO;
    }
    
    [imageViewCedFront setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapCedFront =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCedFrontImage:)];
    [singleTapCedFront setNumberOfTapsRequired:1];
    [imageViewCedFront addGestureRecognizer:singleTapCedFront];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Claim Profile - Listing Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)selectStateButton:(id)sender {
    [stateSpecialtyPicker reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        pickerViewContainer.frame = CGRectMake(0, 107, 320, 260);
        statSpec = 1;
    }];
}

- (IBAction)selectSpecialtyButton:(id)sender {
    [stateSpecialtyPicker reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        pickerViewContainer.frame = CGRectMake(0, 107, 320, 260);
        statSpec = 0;
    }];
}

- (IBAction)cancelButtonPickerView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    }];
}

- (IBAction)selectButtonPickerView:(id)sender {
    if (statSpec == 1) {
        [selectStateButton setTitle:selectedStateName forState:UIControlStateNormal];
    }else{
        [selectSpecialtyButton setTitle:selectedSpecialtyName forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    }];
}

- (IBAction)nextButton:(id)sender {
    BOOL flag = NO;
    NSMutableDictionary *listado = [[NSMutableDictionary alloc]init];
    
    if (![selectedStateName isEqualToString:@""]) {
        [listado setValue:selectedStateTid forKey:@"tidEstadoListado"];
        flag = YES;
    }
    
    if (![selectedSpecialtyName isEqualToString:@""]) {
        [listado setValue:selectedSpecialtyTid forKey:@"tidEspecialidadListado"];
        flag = YES;
    }
    
    if (flag == YES) {
        [userInfoRequestDictionary setValue:listado forKey:@"listado"];
    }
    
    [self performSegueWithIdentifier:@"listadoToCedula" sender:self];
}



-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (statSpec == 1) {
        return [statesArray count];
    }else{
        return [specialtiesArray count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (statSpec == 1) {
        States *estados = [statesArray objectAtIndex:row];
        return estados.display;
    }else{
        Specialty *especialidad = [specialtiesArray objectAtIndex:row];
        return especialidad.display;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (statSpec == 1) {
        States *estados = [statesArray objectAtIndex:row];
        selectedStateName = estados.display;
        selectedStateTid = estados.name;
        NSLog(@"Selected state %@", estados.display);
    }else{
        Specialty *especialidades = [specialtiesArray objectAtIndex:row];
        selectedSpecialtyName = especialidades.display;
        selectedSpecialtyTid = especialidades.name;
        NSLog(@"Selected specialty %@", especialidades.display);
    }    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"listadoToCedula"]){
        CedulaProfesionalViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.requestObject = requestObject;
        destViewController.requestFlag = requestFlag;
        NSLog(@"Segue Listado to Cedula");
    }
}

@end
