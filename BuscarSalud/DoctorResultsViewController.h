//
//  DoctorResultsViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/24/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "getInfoEngine.h"

@interface DoctorResultsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)goBack:(id)sender;

@property(strong, nonatomic)NSNumber *latitudeUser;
@property(strong, nonatomic)NSNumber *longitudeUser;
@property(retain, nonatomic)NSString *specialtyString;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSDictionary *dic;
@property (retain, nonatomic)NSDictionary *statesDictionary;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property(retain, nonatomic)NSString *subtitleString;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@property (weak, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigation;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingControl;

@property (weak, nonatomic) IBOutlet UIView *topLayer;
@property(nonatomic) CGFloat layerPosition;
//@property (weak, nonatomic) IBOutlet UITableView *tableViewBack;
@property (retain, nonatomic)NSMutableArray *stat;

@property (retain, nonatomic)NSArray *specialities;
//@property (weak, nonatomic) IBOutlet UITableView *tableViewSpec;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)searchButton:(id)sender;
- (IBAction)segmentSortingOptions:(id)sender;
- (IBAction)selectItem:(id)sender;
- (IBAction)cancelPicker:(id)sender;

@end
