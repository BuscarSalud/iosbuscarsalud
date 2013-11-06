//
//  MultimediaViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/13/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultimediaViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)NSMutableDictionary *userInfoRequestDictionary;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectProfileImage;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewGalleryImage1;
@property (weak, nonatomic) IBOutlet UILabel *GalleryImageLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectGalleryImage1;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewGalleryImage2;
@property (weak, nonatomic) IBOutlet UILabel *galleryImageLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectGalleryImage2;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewGalleryImage3;
@property (weak, nonatomic) IBOutlet UILabel *galleryImageLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectGalleryImage3;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewGalleryImage4;
@property (weak, nonatomic) IBOutlet UILabel *galleryImageLabel4;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectGalleryImage4;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewGalleryImage5;
@property (weak, nonatomic) IBOutlet UILabel *galleryImageLabel5;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectGalleryImage5;

@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSString *requestFlag;

- (IBAction)nextButton:(id)sender;

@end
