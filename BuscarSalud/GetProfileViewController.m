//
//  GetProfileViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 4/30/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "GetProfileViewController.h"
#import "ProfileContactInfoViewController.h"
#import "AppDelegate.h"
#import "States.h"

@interface GetProfileViewController ()
{
    CGRect nameFieldFrame;
    CGRect lastnameFieldFrame;
    CGRect nicknameFieldFrame;
    CGRect extractFieldFrame;
    CGRect titleFieldFrame;
    CGRect nameLabelFrame;
    CGRect lastnameLabelFrame;
    CGRect nicknameLabelFrame;
    CGRect titleLabelFrame;
    CGRect extractLabelFrame;
    CGRect nicknameDescriptionFrame;
    CGRect titleDescriptionFrame;
    CGRect extractDescriptionFrame;
    CGRect charsRemainingTextFrame;
    CGRect charsRemainingNumberFrame;
    NSData *imageOne;
    NSData *imageTwo;
    int flagButton;
    NSDictionary *statesDictionary;
}

#define POSITION_VARIABLE_EXTRACT 130
#define POSITION_VARIABLE_TITLE 25

@end

@implementation GetProfileViewController

@synthesize flOperation, flUploadEngine, nameTextField, lastNameTextField, titleTextField, nicknameTextField, extractTextView, nameLabel, lastnameLabel, nicknameLabel, nicknameDescriptionLabel, titleLabel, titleDescriptionLabel, extractDescriptionLabel, extractLabel, charsRemainingNumberLabel, charsRemainingTextLabel, buttonNext, userInfoRequestDictionary, stat, requestObject, passFlag, uuid, requestOpenNoteLabel;

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
    //self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem.title = @"Atras";
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar-background"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    titleTextField.delegate = self;
    nameTextField.delegate = self;
    lastNameTextField.delegate = self;
    nicknameTextField.delegate = self;
    extractTextView.delegate = self;
    flagButton = 0;
    
    requestOpenNoteLabel.frame = CGRectMake(20, 370, 191, 28);

    
    [[extractTextView layer] setBorderColor:[[UIColor colorWithRed:170/256.0 green:170/256.0 blue:170/256.0 alpha:1.0] CGColor]];
    [[extractTextView layer] setBorderWidth:2.3];
    [[extractTextView layer] setCornerRadius:10];
    [extractTextView setClipsToBounds: YES];
    [extractTextView setEditable:YES];
    
    if ([passFlag isEqualToString:@"0"]) {
        [extractTextView setEditable:NO];
        [titleTextField setEnabled:NO];
        requestOpenNoteLabel.alpha = 0.0;
        requestOpenNoteLabel.hidden = NO;
        [UIView animateWithDuration:0.7
                              delay:1.5
                            options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
            //[UIView setAnimationBeginsFromCurrentState:YES];
            requestOpenNoteLabel.alpha = 1.0;
            requestOpenNoteLabel.frame = CGRectMake(20, 50, 191, 28);
        }
        completion:^(BOOL finished){
            
        }];
        nameTextField.text = [requestObject valueForKey:@"firstName"];
        lastNameTextField.text = [requestObject valueForKey:@"lastName"];
        nicknameTextField.text = [requestObject valueForKey:@"nickname"];
        titleTextField.text = [requestObject valueForKey:@"title"];
        extractTextView.text = [requestObject valueForKey:@"extract"];
        NSLog(@"Name passed through: %@", [requestObject valueForKey:@"firstName"]);
        
    }
    
	// Do any additional setup after loading the view.
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:@"estado" forKey:@"disponible"];
    
    [ApplicationDelegate.infoEngine getInfo:postParams completionHandler:^(NSDictionary *categories){
        statesDictionary = categories;
        
        NSDictionary *stateInDictionary = [[NSDictionary alloc]init];
        stat = [[NSMutableArray alloc]init];
        
        for (int i =0; i<=[statesDictionary count]; i++) {
            NSString *index = [NSString stringWithFormat:@"estado%d",i];
            stateInDictionary = [statesDictionary objectForKey:index];
            States *stateItem = [States new];
            stateItem.display = [stateInDictionary objectForKey:@"nombre"];
            stateItem.name = [NSString stringWithFormat:@"%@", [stateInDictionary objectForKey:@"tid"]];;
            [stat addObject:stateItem];
        }
        NSLog(@"Stat array %@", stat);
    } errorHandler:^(NSError* error){
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    /*if (nameTextField.text == @"" && lastNameTextField.text == @"") {
        buttonNext.enabled = NO;
    }*/
    
}

-(void)startLoadingBox{
    NSLog(@"Empiexza loading box");
    UIImage *statusImage = [UIImage imageNamed:@"loading-background"];
    UIActivityIndicatorView *activitIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    containerView = [[UIImageView alloc] init];
    UIImageView *activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    activitIndicator.center = activityImageView.center;
    [activitIndicator startAnimating];
    [containerView addSubview:activityImageView];
    [containerView addSubview:activitIndicator];
    
    [containerView setAlpha:0.0];
    [self.navigationController.view addSubview:containerView];
    [UIView beginAnimations:nil context:nil];
    [containerView setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)finishLoadingBox{
    [containerView setAlpha:1.0];
    [UIView beginAnimations:nil context:nil];
    [containerView setAlpha:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDelegate:containerView];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)uploadPhoto:(id)sender {
    flagButton = 1;
    UIActionSheet *photoSourcePicker = [[UIActionSheet alloc] initWithTitle:@"Cédula Profesional"
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

- (IBAction)uploadPhotoTwo:(id)sender {
    flagButton = 2;
    UIActionSheet *photoSourcePickerOther = [[UIActionSheet alloc] initWithTitle:@"Crencial de Elector"
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancelar"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:	@"Tomar Foto",
                                           @"Escoger de un Albúm",
                                           nil];
    
    //[photoSourcePickerTwo showInView:self.view];
    [photoSourcePickerOther showFromTabBar:self.tabBarController.tabBar];
    //photoSourcePickerOther.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
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
        imageOne = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    if (flagButton == 2) {
        imageTwo = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.01f);
    }
    
    
    NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    NSString *imageName = [imageFileURL lastPathComponent];
    
      
    
}*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [nicknameTextField resignFirstResponder];
    [titleTextField resignFirstResponder];
    [extractTextView resignFirstResponder];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if ([passFlag isEqualToString:@"0"]) {
        [textField setEnabled:NO];
    }
    nameFieldFrame = nameTextField.frame;
    lastnameFieldFrame = lastNameTextField.frame;
    nicknameFieldFrame = nicknameTextField.frame;
    titleFieldFrame = titleTextField.frame;
    nameLabelFrame = nameLabel.frame;
    lastnameLabelFrame = lastnameLabel.frame;
    nicknameLabelFrame = nicknameLabel.frame;
    titleLabelFrame  = titleLabel.frame;
    extractLabelFrame = extractLabel.frame;
    nicknameDescriptionFrame = nicknameDescriptionLabel.frame;
    titleDescriptionFrame = titleDescriptionLabel.frame;
    NSLog(@"Field focus in Titulo, orginal: %f", titleLabelFrame.origin.y);

    switch (textField.tag) {
        case 401:
            nameFieldFrame.origin.y = nameFieldFrame.origin.y - POSITION_VARIABLE_TITLE;
            lastnameFieldFrame.origin.y = lastnameFieldFrame.origin.y - POSITION_VARIABLE_TITLE;
            nicknameFieldFrame.origin.y = nicknameFieldFrame.origin.y - POSITION_VARIABLE_TITLE;
            titleFieldFrame.origin.y = titleFieldFrame.origin.y - POSITION_VARIABLE_TITLE;
            nameLabelFrame.origin.y = nameLabelFrame.origin.y - POSITION_VARIABLE_TITLE;
            lastnameLabelFrame.origin.y = lastnameLabelFrame.origin.y - POSITION_VARIABLE_TITLE;
            nicknameLabelFrame.origin.y = nicknameLabelFrame.origin.y - POSITION_VARIABLE_TITLE;
            titleLabelFrame.origin.y = titleLabelFrame.origin.y - POSITION_VARIABLE_TITLE;
            nicknameDescriptionFrame.origin.y = nicknameDescriptionFrame.origin.y - POSITION_VARIABLE_TITLE;
            titleDescriptionFrame.origin.y = titleDescriptionFrame.origin.y - POSITION_VARIABLE_TITLE;            
            NSLog(@"Field focus in Titulo, %f", titleLabelFrame.origin.y);
            break;
        case 101:
            NSLog(@"Field focus in Nombre");
            if (![nameTextField.text isEqualToString:@""]) {
                nameLabel.textColor = [UIColor blackColor];
            }
            break;
        case 201:
            NSLog(@"Field focus in Apellido");
            if (![lastNameTextField.text isEqualToString:@""]) {
                lastnameLabel.textColor = [UIColor blackColor];
            }
            break;
        case 301:
            NSLog(@"Field focus in Nickname");
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"Animate!  Frame: %f", titleFieldFrame.origin.y);
        nameTextField.frame = nameFieldFrame;
        lastNameTextField.frame = lastnameFieldFrame;
        nicknameTextField.frame = nicknameFieldFrame;
        titleTextField.frame = titleFieldFrame;
        nameLabel.frame = nameLabelFrame;
        lastnameLabel.frame = lastnameLabelFrame;
        nicknameLabel.frame = nicknameLabelFrame;
        titleLabel.frame = titleLabelFrame;
        nicknameDescriptionLabel.frame = nicknameDescriptionFrame;
        titleDescriptionLabel.frame = titleDescriptionFrame;
        
    }];

    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    nameFieldFrame = nameTextField.frame;
    lastnameFieldFrame = lastNameTextField.frame;
    nicknameFieldFrame = nicknameTextField.frame;
    titleFieldFrame = titleTextField.frame;
    nameLabelFrame = nameLabel.frame;
    lastnameLabelFrame = lastnameLabel.frame;
    nicknameLabelFrame = nicknameLabel.frame;
    titleLabelFrame  = titleLabel.frame;
    extractLabelFrame = extractLabel.frame;
    nicknameDescriptionFrame = nicknameDescriptionLabel.frame;
    titleDescriptionFrame = titleDescriptionLabel.frame;
    
    
    switch (textField.tag) {
        case 401:
            nameFieldFrame.origin.y = nameFieldFrame.origin.y + POSITION_VARIABLE_TITLE;
            lastnameFieldFrame.origin.y = lastnameFieldFrame.origin.y + POSITION_VARIABLE_TITLE;
            nicknameFieldFrame.origin.y = nicknameFieldFrame.origin.y + POSITION_VARIABLE_TITLE;
            titleFieldFrame.origin.y = titleFieldFrame.origin.y + POSITION_VARIABLE_TITLE;
            nameLabelFrame.origin.y = nameLabelFrame.origin.y - POSITION_VARIABLE_TITLE;
            lastnameLabelFrame.origin.y = lastnameLabelFrame.origin.y + POSITION_VARIABLE_TITLE;
            nicknameLabelFrame.origin.y = nicknameLabelFrame.origin.y + POSITION_VARIABLE_TITLE;
            titleLabelFrame.origin.y = titleLabelFrame.origin.y + POSITION_VARIABLE_TITLE;
            nicknameDescriptionFrame.origin.y = nicknameDescriptionFrame.origin.y + POSITION_VARIABLE_TITLE;
            titleDescriptionFrame.origin.y = titleDescriptionFrame.origin.y + POSITION_VARIABLE_TITLE;
            break;
        case 101:
            NSLog(@"Field focus in Nombre");
            if (![nameTextField.text isEqualToString:@""]) {
                nameLabel.textColor = [UIColor blackColor];
            }
            break;
        case 201:
            NSLog(@"Field focus in Apellido");
            if (![lastNameTextField.text isEqualToString:@""]) {
                lastnameLabel.textColor = [UIColor blackColor];
            }
            break;
        case 301:
            NSLog(@"Field focus out Nickname");
            break;
            
        default:
            break;
    }
        
        
   // }
    [UIView animateWithDuration:0.3 animations:^{
        nameTextField.frame = nameFieldFrame;
        lastNameTextField.frame = lastnameFieldFrame;
        nicknameTextField.frame = nicknameFieldFrame;
        titleTextField.frame = titleFieldFrame;
        nameLabel.frame = nameLabelFrame;
        lastnameLabel.frame = lastnameLabelFrame;
        nicknameLabel.frame = nicknameLabelFrame;
        titleLabel.frame = titleLabelFrame;
        nicknameDescriptionLabel.frame = nicknameDescriptionFrame;
        titleDescriptionLabel.frame = titleDescriptionFrame;
        
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    extractFieldFrame = extractTextView.frame;
    nameFieldFrame = nameTextField.frame;
    lastnameFieldFrame = lastNameTextField.frame;
    nicknameFieldFrame = nicknameTextField.frame;
    titleFieldFrame = titleTextField.frame;
    nameLabelFrame = nameLabel.frame;
    lastnameLabelFrame = lastnameLabel.frame;
    nicknameLabelFrame = nicknameLabel.frame;
    titleLabelFrame  = titleLabel.frame;
    extractLabelFrame = extractLabel.frame;
    nicknameDescriptionFrame = nicknameDescriptionLabel.frame;
    titleDescriptionFrame = titleDescriptionLabel.frame;
    extractDescriptionFrame = extractDescriptionLabel.frame;
    charsRemainingNumberFrame = charsRemainingNumberLabel.frame;
    charsRemainingTextFrame = charsRemainingTextLabel.frame;

    
    nameFieldFrame.origin.y = nameFieldFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    lastnameFieldFrame.origin.y = lastnameFieldFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    nicknameFieldFrame.origin.y = nicknameFieldFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    titleFieldFrame.origin.y = titleFieldFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    extractFieldFrame.origin.y = extractFieldFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    nameLabelFrame.origin.y = nameLabelFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    lastnameLabelFrame.origin.y = lastnameLabelFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    nicknameLabelFrame.origin.y = nicknameLabelFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    titleLabelFrame.origin.y = titleLabelFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    extractLabelFrame.origin.y = extractLabelFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    nicknameDescriptionFrame.origin.y = nicknameDescriptionFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    titleDescriptionFrame.origin.y = titleDescriptionFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    extractDescriptionFrame.origin.y = extractDescriptionFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    charsRemainingTextFrame.origin.y = charsRemainingTextFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    charsRemainingNumberFrame.origin.y = charsRemainingNumberFrame.origin.y - POSITION_VARIABLE_EXTRACT;
    
    [UIView animateWithDuration:0.2 animations:^{
        nameTextField.frame = nameFieldFrame;
        lastNameTextField.frame = lastnameFieldFrame;
        nicknameTextField.frame = nicknameFieldFrame;
        titleTextField.frame = titleFieldFrame;
        extractTextView.frame = extractFieldFrame;
        nameLabel.frame = nameLabelFrame;
        lastnameLabel.frame = lastnameLabelFrame;
        nicknameLabel.frame = nicknameLabelFrame;
        titleLabel.frame = titleLabelFrame;
        extractLabel.frame = extractLabelFrame;
        nicknameDescriptionLabel.frame = nicknameDescriptionFrame;
        titleDescriptionLabel.frame = titleDescriptionFrame;
        extractDescriptionLabel.frame = extractDescriptionFrame;
        charsRemainingNumberLabel.frame = charsRemainingNumberFrame;
        charsRemainingTextLabel.frame = charsRemainingTextFrame;
    }];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    nameFieldFrame.origin.y = nameFieldFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    lastnameFieldFrame.origin.y = lastnameFieldFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    nicknameFieldFrame.origin.y = nicknameFieldFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    titleFieldFrame.origin.y = titleFieldFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    extractFieldFrame.origin.y = extractFieldFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    nameLabelFrame.origin.y = nameLabelFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    lastnameLabelFrame.origin.y = lastnameLabelFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    nicknameLabelFrame.origin.y = nicknameLabelFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    titleLabelFrame.origin.y = titleLabelFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    extractLabelFrame.origin.y = extractLabelFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    nicknameDescriptionFrame.origin.y = nicknameDescriptionFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    titleDescriptionFrame.origin.y = titleDescriptionFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    extractDescriptionFrame.origin.y = extractDescriptionFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    charsRemainingTextFrame.origin.y = charsRemainingTextFrame.origin.y + POSITION_VARIABLE_EXTRACT;
    charsRemainingNumberFrame.origin.y = charsRemainingNumberFrame.origin.y + POSITION_VARIABLE_EXTRACT;

    
    [UIView animateWithDuration:0.2 animations:^{
        nameTextField.frame = nameFieldFrame;
        lastNameTextField.frame = lastnameFieldFrame;
        nicknameTextField.frame = nicknameFieldFrame;
        titleTextField.frame = titleFieldFrame;
        extractTextView.frame = extractFieldFrame;
        nameLabel.frame = nameLabelFrame;
        lastnameLabel.frame = lastnameLabelFrame;
        nicknameLabel.frame = nicknameLabelFrame;
        titleLabel.frame = titleLabelFrame;
        extractLabel.frame = extractLabelFrame;
        nicknameDescriptionLabel.frame = nicknameDescriptionFrame;
        titleDescriptionLabel.frame = titleDescriptionFrame;
        extractDescriptionLabel.frame = extractDescriptionFrame;
        charsRemainingNumberLabel.frame = charsRemainingNumberFrame;
        charsRemainingTextLabel.frame = charsRemainingTextFrame;
    }];
}


- (void)textViewDidChange:(UITextView *)textView {
    //create NSString containing the text from the UITextView
    NSString *substring = [NSString stringWithString:textView.text];
    
    //if message has text show label and update with number of characters using the NSString.length function
    if (substring.length > 0) {
        int remaining;
        remaining = 140 - substring.length;
        charsRemainingNumberLabel.text = [NSString stringWithFormat:@"%d", remaining];
    }
    //if message has no text hide label
    if (substring.length == 0) {
        charsRemainingNumberLabel.text = @"140";
    }
    //if message length is equal to 140 characters display alert view
    if (substring.length == 140) {
        //if character count is over max number change label to red text
        charsRemainingNumberLabel.textColor = [UIColor redColor];
    }
    //if message is less than 140 characters change font to black
    if (substring.length < 140) {
        charsRemainingNumberLabel.textColor = [UIColor blackColor];
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.text.length < 140 && ![text isEqualToString:@""]){
        
        return YES;
    }
    if (text.length == 0) {
        return YES;
    }
    return NO;
}

- (IBAction)buttonNext:(id)sender {
   
    if ([nameTextField.text isEqualToString:@""] || [lastNameTextField.text isEqualToString:@""]) {
        if ([nameTextField.text isEqualToString:@""]) {
            nameLabel.textColor = [UIColor redColor];
        }else{
            nameLabel.textColor = [UIColor blackColor];
        }
        if ([lastNameTextField.text isEqualToString:@""]) {
            lastnameLabel.textColor = [UIColor redColor];
        }else{
            nameLabel.textColor = [UIColor blackColor];
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alerta"
                              message:@"Por favor llene los campos obligatorios"
                              delegate:nil
                              cancelButtonTitle:@"Regresar"
                              otherButtonTitles:nil];
        
        [alert show];
    }else{
        NSMutableDictionary *generalInfo = [[NSMutableDictionary alloc]init];
        userInfoRequestDictionary = [[NSMutableDictionary alloc]init];
        
        [generalInfo setValue:nameTextField.text forKey:@"nombre"];
        [generalInfo setValue:lastNameTextField.text forKey:@"apellidos"];
        if (![nicknameTextField.text isEqualToString:@""]) {
            [generalInfo setValue:nicknameTextField.text forKey:@"nickname"];
        }
        if (![titleTextField.text isEqualToString:@""]) {
            [generalInfo setValue:titleTextField.text forKey:@"titulo"];
        }
        if (![extractTextView.text isEqualToString:@""]) {
            [generalInfo setValue:extractTextView.text forKey:@"extracto"];
        }
        
        [userInfoRequestDictionary setValue:generalInfo forKey:@"general"];
        [userInfoRequestDictionary setValue:uuid forKey:@"uuid"];
        
        // **************************
        /*
        self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:@"ws.buscarsalud.local" customHeaderFields:nil];
        
        NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
        [postParams setValue:nameTextField.text forKey:@"nombre"];
        [postParams setValue:lastNameTextField.text forKey:@"apellido"];
        
        self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"upload_info.php"];
        [self.flOperation addData:imageOne forKey:@"image" mimeType:@"image/jpeg" fileName:@"image1.jpg"];
        [self.flOperation addData:imageTwo forKey:@"image2" mimeType:@"image/jpeg" fileName:@"image2.jpg"];
        
        [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
            NSLog(@"%@", [operation responseString]);
         
            // This is where you handle a successful 200 response
         
        }
                                  errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                      NSLog(@"%@", error);
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                      message:[error localizedDescription]
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"Dismiss"
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                  }];
        
        [self.flUploadEngine enqueueOperation:self.flOperation ];
        
        // ***************************
    */
        
        [self performSegueWithIdentifier:@"generalToContactInfo" sender:self];
    } 
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"generalToContactInfo"]){
        ProfileContactInfoViewController *destViewController = segue.destinationViewController;
        destViewController.userInfoRequestDictionary = userInfoRequestDictionary;
        destViewController.stat = stat;
        destViewController.requestFlag = passFlag;
        destViewController.requestObject = requestObject;
        NSLog(@"Segue!!");
    }
}
@end
