//
//  MultimediaViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/13/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "MultimediaViewController.h"
#import "ExperienceViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface MultimediaViewController ()
{
    int flagButton;
    NSData *imageOne;
    NSData *imageTwo;
    NSData *imageThree;
    NSData *imageFour;
    NSData *imageFive;
    NSData *imageProfile;
    UIImage *thumbOne;
    UIImage *thumbTwo;
    UIImage *thumbThree;
    UIImage *thumbFour;
    UIImage *thumbFive;
    UIImage *thumbProfile;
}

@end

@implementation MultimediaViewController
@synthesize userInfoRequestDictionary, imageViewGalleryImage1, imageViewGalleryImage2, imageViewGalleryImage3, imageViewGalleryImage4, imageViewGalleryImage5, imageViewProfileImage, imageViewSelectGalleryImage1, imageViewSelectGalleryImage2, imageViewSelectGalleryImage3, imageViewSelectGalleryImage4, imageViewSelectGalleryImage5, imageViewSelectProfileImage, galleryImageLabel2, galleryImageLabel3, galleryImageLabel4, galleryImageLabel5, GalleryImageLabel1, requestObject, requestFlag;

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
    
    [imageViewProfileImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapProfileImage =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProfileImage:)];
    [singleTapProfileImage setNumberOfTapsRequired:1];
    [imageViewProfileImage addGestureRecognizer:singleTapProfileImage];
    
    [imageViewGalleryImage1 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapGalleryImage1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGalleryImage1:)];
    [singleTapGalleryImage1 setNumberOfTapsRequired:1];
    [imageViewGalleryImage1 addGestureRecognizer:singleTapGalleryImage1];
    
    [imageViewGalleryImage2 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapGalleryImage2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGalleryImage2:)];
    [singleTapGalleryImage2 setNumberOfTapsRequired:1];
    [imageViewGalleryImage2 addGestureRecognizer:singleTapGalleryImage2];
    
    [imageViewGalleryImage3 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapGalleryImage3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGalleryImage3:)];
    [singleTapGalleryImage3 setNumberOfTapsRequired:1];
    [imageViewGalleryImage3 addGestureRecognizer:singleTapGalleryImage3];
    
    [imageViewGalleryImage4 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapGalleryImage4 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGalleryImage4:)];
    [singleTapGalleryImage4 setNumberOfTapsRequired:1];
    [imageViewGalleryImage4 addGestureRecognizer:singleTapGalleryImage4];
    
    [imageViewGalleryImage5 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapGalleryImage5 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGalleryImage5:)];
    [singleTapGalleryImage5 setNumberOfTapsRequired:1];
    [imageViewGalleryImage5 addGestureRecognizer:singleTapGalleryImage5];
}

-(void)viewDidAppear:(BOOL)animated
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Claim Profile - Multimedia Screen"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectProfileImage:(UIGestureRecognizer *)recognizer
{
    flagButton = 1;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Imagen De Perfil"
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

-(void)selectGalleryImage1:(UIGestureRecognizer *)recognizer
{
    flagButton = 2;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Imagen 1"
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

-(void)selectGalleryImage2:(UIGestureRecognizer *)recognizer
{
    flagButton = 3;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Imagen 2"
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

-(void)selectGalleryImage3:(UIGestureRecognizer *)recognizer
{
    flagButton = 4;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Imagen 3"
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

-(void)selectGalleryImage4:(UIGestureRecognizer *)recognizer
{
    flagButton = 5;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Imagen 4"
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

-(void)selectGalleryImage5:(UIGestureRecognizer *)recognizer
{
    flagButton = 6;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Imagen 5"
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
        thumbProfile = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(75.0, 83.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbProfile drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectProfileImage.image = [UIImage imageNamed:@"change-foto-galeria.png"];
        imageViewProfileImage.image = newImage;
        
        
        imageProfile = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 2) {
        thumbOne = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(85.0, 50.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbOne drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectGalleryImage1.image = [UIImage imageNamed:@"change-foto-galeria.png"];
        imageViewGalleryImage1.image = newImage;
        
        imageOne = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 3) {
        thumbTwo = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(85.0, 50.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbTwo drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectGalleryImage2.image = [UIImage imageNamed:@"change-foto-galeria.png"];
        imageViewGalleryImage2.image = newImage;
        
        imageTwo = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 4) {
        thumbThree = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(85.0, 50.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbThree drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectGalleryImage3.image = [UIImage imageNamed:@"change-foto-galeria.png"];
        imageViewGalleryImage3.image = newImage;
        
        imageThree = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 5) {
        thumbFour = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(85.0, 50.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbFour drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectGalleryImage4.image = [UIImage imageNamed:@"change-foto-galeria.png"];
        imageViewGalleryImage4.image = newImage;
        
        imageFour = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 6) {
        thumbFive = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize destinationSize = CGSizeMake(85.0, 50.0);
        UIGraphicsBeginImageContext(destinationSize);
        [thumbFive drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        imageViewSelectGalleryImage5.image = [UIImage imageNamed:@"change-foto-galeria.png"];
        imageViewGalleryImage5.image = newImage;
        
        imageFive = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    
    //NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    //NSString *imageName = [imageFileURL lastPathComponent];
}

- (IBAction)nextButton:(id)sender {
    [userInfoRequestDictionary setValue:imageProfile forKey:@"imagenPerfil"];
    [userInfoRequestDictionary setValue:imageOne forKey:@"imagenGaleria1"];
    [userInfoRequestDictionary setValue:imageTwo forKey:@"imagenGaleria2"];
    [userInfoRequestDictionary setValue:imageThree forKey:@"imagenGaleria3"];
    [userInfoRequestDictionary setValue:imageFour forKey:@"imagenGaleria4"];
    [userInfoRequestDictionary setValue:imageFive forKey:@"imagenGaleria5"];

    [self performSegueWithIdentifier:@"multimediaToExperience" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"multimediaToExperience"]){
        ExperienceViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.requestObject = requestObject;
        destViewController.requestFlag = requestFlag;
        NSLog(@"Segue Multimedia to Experience");
    }
}

@end
