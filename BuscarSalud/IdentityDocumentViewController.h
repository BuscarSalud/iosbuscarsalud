//
//  IdentityDocumentViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/9/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentityDocumentViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCredFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectCredFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCredBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectCredBack;
@property (weak, nonatomic) IBOutlet UILabel *requestOpenNoteLabel;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)nextButton:(id)sender;
@end
