//
//  CedulaProfesionalViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/8/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "CedulaProfesionalViewController.h"
#import "IdentityDocumentViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface CedulaProfesionalViewController ()
{
    int flagButton;
    NSData *imageOne;
    NSData *imageTwo;
    UIImage *thumbCedFront;
    UIImage *thumbCedBack;

}

@end

@implementation CedulaProfesionalViewController

@synthesize imageViewSelectCedFront, imageViewCedFront, imageViewCedBack, imageViewSelecteCedBack, cedNumberTextField, userInfoRequestDictionary, nextButton, requestOpenNoteLabel, requestFlag, requestObject;

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
    
    nextButton.enabled = NO;
    cedNumberTextField.delegate = self;
    
    if ([requestFlag isEqualToString:@"0"]) {
        requestOpenNoteLabel.hidden = NO;
        [cedNumberTextField setEnabled:NO];
        cedNumberTextField.text = [requestObject valueForKey:@"cedulaNum"];
        nextButton.enabled = YES;
    }
    
    [imageViewCedFront setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapCedFront =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCedFrontImage:)];
    [singleTapCedFront setNumberOfTapsRequired:1];
    [imageViewCedFront addGestureRecognizer:singleTapCedFront];
    
    [imageViewCedBack setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapCedBack =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCedBackImage:)];
    [singleTapCedBack setNumberOfTapsRequired:1];
    [imageViewCedBack addGestureRecognizer:singleTapCedBack];
    
    NSLog(@"%@", userInfoRequestDictionary);
    
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(handleTextChange:)
                                                  name:UITextFieldTextDidChangeNotification
                                                object:cedNumberTextField];
}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Claim Profile - Cedula Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTextChange:(NSNotification *)notification{
    if (cedNumberTextField.text.length < 7 ) {
        nextButton.enabled = NO;
    }
    if (cedNumberTextField.text.length == 7) {
        nextButton.enabled = YES;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
    {
        return YES;
    }
    
    if (cedNumberTextField.text.length < 7) {
        return YES;
    }
    return NO;
}

-(void)selectCedFrontImage:(UIGestureRecognizer *)recognizer
{
    flagButton = 1;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Cédula Profesional Frontal"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancelar"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:	@"Tomar Foto",
                                        @"Escoger de un Albúm",
                                        nil];
    
    //[photoSourcePicker showInView:self.view];
    [photoSourcePicker showFromTabBar:self.tabBarController.tabBar];
    //photoSourcePicker.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
}

-(void)selectCedBackImage:(UIGestureRecognizer *)recognizer
{
    flagButton = 2;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Cédula Profesional Trasera"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancelar"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:	@"Tomar Foto",
                                        @"Escoger de un Albúm",
                                        nil];
    
    //[photoSourcePicker showInView:self.view];
    [photoSourcePicker showFromTabBar:self.tabBarController.tabBar];
    //photoSourcePicker.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
}


- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
		{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:@"Este dispositivo no tiene camara"
                                                  delegate:self cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
                [alert show];
            }
			break;
		}
		case 1:
		{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:@"Este dispositivo no soporta la Foto Libreria."
                                                  delegate:self cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
                [alert show];
            }
			break;
		}
        default:
            break;
	}
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (flagButton == 1) {
        thumbCedFront = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(77.0, 85.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbCedFront drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectCedFront.image = [UIImage imageNamed:@"change-foto.png"];
        imageViewCedFront.image = newImage;
        
        
        imageOne = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 2) {
        thumbCedFront = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(77.0, 85.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbCedFront drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelecteCedBack.image = [UIImage imageNamed:@"change-foto.png"];
        imageViewCedBack.image = newImage;
        
        imageTwo = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    
    
    //NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    //NSString *imageName = [imageFileURL lastPathComponent];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [cedNumberTextField resignFirstResponder];
}


- (IBAction)nextButton:(id)sender {
    NSString *uuidString = [userInfoRequestDictionary valueForKey:@"uuid"];
    NSString *combined = [NSString stringWithFormat:@"%@-%@",uuidString, cedNumberTextField.text ];
    
    [userInfoRequestDictionary setValue:combined forKey:@"uuid"];    
    [userInfoRequestDictionary setValue:imageOne forKey:@"imagenCedulaFrontal"];
    [userInfoRequestDictionary setValue:imageTwo forKey:@"imagenCedulaTrasera"];
    [userInfoRequestDictionary setValue:cedNumberTextField.text forKey:@"numeroDeCedula"];
    
    [self performSegueWithIdentifier:@"cedulaToIdentity" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cedulaToIdentity"]){
        IdentityDocumentViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.requestObject = requestObject;
        destViewController.requestFlag = requestFlag;
        NSLog(@"Segue Cedula to Identity");
    }
}


@end
