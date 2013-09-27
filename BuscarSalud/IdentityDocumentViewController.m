//
//  IdentityDocumentViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/9/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "IdentityDocumentViewController.h"
#import "MultimediaViewController.h"

@interface IdentityDocumentViewController ()
{
    int flagButton;
    NSData *imageOne;
    NSData *imageTwo;
    UIImage *thumbCredFront;
    UIImage *thumbCredBack;
}

@end

@implementation IdentityDocumentViewController
@synthesize userInfoRequestDictionary, imageViewCredBack, imageViewCredFront, imageViewSelectCredBack, imageViewSelectCredFront, requestObject, requestOpenNoteLabel, requestFlag;

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
    
    if ([requestFlag isEqualToString:@"0"]) {
        requestOpenNoteLabel.hidden = NO;
    }
    
    [imageViewCredFront setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapCedFront =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCredFrontImage:)];
    [singleTapCedFront setNumberOfTapsRequired:1];
    [imageViewCredFront addGestureRecognizer:singleTapCedFront];
    
    [imageViewCredBack setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapCedBack =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCredBackImage:)];
    [singleTapCedBack setNumberOfTapsRequired:1];
    [imageViewCredBack addGestureRecognizer:singleTapCedBack];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectCredFrontImage:(UIGestureRecognizer *)recognizer
{
    flagButton = 1;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Credencial de Elector Frontal"
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

-(void)selectCredBackImage:(UIGestureRecognizer *)recognizer
{
    flagButton = 2;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Credencial de Elector Trasera"
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
        thumbCredFront = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(100.0, 75.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbCredFront drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectCredFront.image = [UIImage imageNamed:@"change-foto-credencial.png"];
        imageViewCredFront.image = newImage;
        
        
        imageOne = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 2) {
        thumbCredBack = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(100.0, 75.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbCredBack drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectCredBack.image = [UIImage imageNamed:@"change-foto-credencial.png"];
        imageViewCredBack.image = newImage;
        
        imageTwo = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    
    
    //NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    //NSString *imageName = [imageFileURL lastPathComponent];
}


- (IBAction)nextButton:(id)sender {
    [userInfoRequestDictionary setValue:imageOne forKey:@"imagenCredencialFrontal"];
    [userInfoRequestDictionary setValue:imageTwo forKey:@"imagenCredencialTrasera"];
    
    [self performSegueWithIdentifier:@"identityToMultimedia" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"identityToMultimedia"]){
        MultimediaViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.requestFlag = requestFlag;
        destViewController.requestObject = requestObject;
        NSLog(@"Segue Identity to Multimedia");
    }
}


@end
