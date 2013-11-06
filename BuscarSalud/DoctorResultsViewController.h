//
//  DoctorResultsViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/24/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "getInfoEngine.h"
#import "GADBannerView.h"

@interface DoctorResultsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    
    GADBannerView *bannerView_;
}

- (IBAction)goBack:(id)sender;

@property(strong, nonatomic)NSNumber *latitudeUser;
@property(strong, nonatomic)NSNumber *longitudeUser;
@property(retain, nonatomic)NSString *specialtyString;
@property (nonatomic, strong) NSMutableDictionary *user;
@property (nonatomic, strong) NSDictionary *userStatic;
@property (nonatomic, strong) NSDictionary *dic;
@property (retain, nonatomic)NSDictionary *statesDictionary;

@property (weak, nonatomic) IBOutlet UIImageView *loadMoreDataImage;
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

@property (retain, nonatomic)NSMutableArray *specialities;
//@property (weak, nonatomic) IBOutlet UITableView *tableViewSpec;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;

@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *optionLabelInPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerStates;
@property (weak, nonatomic) IBOutlet UIImageView *silderImageView;
@property (weak, nonatomic) IBOutlet UIView *mainView;


- (IBAction)searchButton:(id)sender;
- (IBAction)segmentSortingOptions:(id)sender;
- (IBAction)selectItem:(id)sender;
- (IBAction)cancelPicker:(id)sender;

@end
