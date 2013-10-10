//
//  LanguagesViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/14/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "LanguagesViewController.h"
#import "SocialMediaViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface LanguagesViewController ()
{
    NSArray *languageLevel;
    int levelFlag;
    NSString *selectedLevel1;
    NSString *selectedLevel2;
}

@end

@implementation LanguagesViewController
@synthesize pickerViewContainer, languagesPicker, userInfoRequestDictionary, selectLevel1Button, selectLevel2Button, language1TextField, language2TextField, requestOpenNoteLabel, requestFlag, requestObject;

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
    
    languageLevel = [NSArray arrayWithObjects:@"-Selecccionar-", @"Nivel Básico", @"Nivel Básico Limitada", @"Nivel Básico Profiesional", @"Nivel Profesional", @"Idioma Nativo", nil];
    
    NSLog(@"%@", userInfoRequestDictionary);
    
    [language1TextField setDelegate:self];
    [language1TextField setDelegate:self];
    
    selectedLevel1 = @"";
    selectedLevel2 = @"";
    
    if ([requestFlag isEqualToString:@"0"]) {
        requestOpenNoteLabel.hidden = NO;
        [language1TextField setEnabled:NO];
        [language2TextField setEnabled:NO];
        language1TextField.text = [requestObject valueForKey:@"language1"];
        language2TextField.text = [requestObject valueForKey:@"language2"];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Claim Profile - Languages Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectLevel1Button:(id)sender {
    [languagesPicker reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        pickerViewContainer.frame = CGRectMake(0, 107, 320, 260);
        levelFlag = 1;
    }];
    //NSLog(@"%@", [languageLevel objectForKey:@"1"]);
    [language1TextField resignFirstResponder];
    [language2TextField resignFirstResponder];

}

- (IBAction)selectLevel2Button:(id)sender {
    [languagesPicker reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        pickerViewContainer.frame = CGRectMake(0, 107, 320, 260);
        levelFlag = 2;
    }];
    [language1TextField resignFirstResponder];
    [language2TextField resignFirstResponder];
}

- (IBAction)cancelButtonPicker:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    }];
}

- (IBAction)selectButtonPicker:(id)sender {
    if (levelFlag == 1) {
        [selectLevel1Button setTitle:selectedLevel1 forState:UIControlStateNormal];
    }
    if (levelFlag == 2) {
        [selectLevel2Button setTitle:selectedLevel2 forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);
    }];
}

- (IBAction)nextButton:(id)sender {
    BOOL flagIdioma1 = NO;
    BOOL flagIdioma2 = NO;
    BOOL flag = NO;
    
    NSMutableDictionary *idioma1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *idioma2 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *idiomas = [[NSMutableDictionary alloc]init];
    
    if (![language1TextField.text isEqualToString:@""]) {
        [idioma1 setValue:language1TextField.text forKey:@"idioma1"];
        flagIdioma1 = YES;
    }
    if (![selectedLevel1 isEqualToString:@""]) {
        [idioma1 setValue:selectedLevel1 forKey:@"nivel_idioma_1"];
        flagIdioma1 = YES;
    }
    
    if (![language2TextField.text isEqualToString:@""]) {
        [idioma2 setValue:language2TextField.text forKey:@"idioma2"];
        flagIdioma2 = YES;
    }
    if (![selectedLevel2 isEqualToString:@""]) {
        [idioma2 setValue:selectedLevel2 forKey:@"nivel_idioma_2"];
        flagIdioma2 = YES;
    }
    
    if (flagIdioma1 == YES) {
        [idiomas setValue:idioma1 forKey:@"0"];
        flag = YES;
    }
    if (flagIdioma2 == YES) {
        [idiomas setValue:idioma2 forKey:@"1"];
        flag = YES;
    }
    
    if (flag == YES) {
        [userInfoRequestDictionary setValue:idiomas forKey:@"idiomas"];
    }
    
    [self performSegueWithIdentifier:@"languagesToSocialMedia" sender:self];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [languageLevel count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [languageLevel objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (levelFlag == 1) {
        selectedLevel1 = [languageLevel objectAtIndex:row];
        NSLog(@"Selected level 1: %@", selectedLevel1);
    }
    if (levelFlag == 2) {
        selectedLevel2 = [languageLevel objectAtIndex:row];
        NSLog(@"Selected level 2: %@", selectedLevel2);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [language1TextField resignFirstResponder];
    [language2TextField resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"languagesToSocialMedia"]){
        SocialMediaViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.requestObject = requestObject;
        destViewController.requestFlag = requestFlag;
        NSLog(@"Segue Languages to Social Media");
    }
}


@end
