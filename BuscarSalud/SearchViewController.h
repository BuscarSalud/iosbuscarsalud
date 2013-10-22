//
//  SearchViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 10/9/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Specialty.h"
#import "fileUploadEngine.h"
#import "getInfoEngine.h"
#import "GAITrackedViewController.h"

@interface SearchViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *topSidebarButton;

@property (weak, nonatomic) IBOutlet UILabel *specialtyNameLabel;
@property(retain,nonatomic)NSString *receiveName;
@property(retain,nonatomic)NSString *receiveDisplay;

@property (weak, nonatomic) IBOutlet UITabBarItem *tabBarController;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
- (IBAction)searchButton:(id)sender;
- (IBAction)searchButtonTouchDown:(id)sender;
- (IBAction)searchButtonTouchDragOutside:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;



@end
