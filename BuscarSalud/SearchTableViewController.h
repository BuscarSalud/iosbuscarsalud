//
//  SearchTableViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/19/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Specialty.h"
#import "fileUploadEngine.h"
#import "getInfoEngine.h"
#import "GAITrackedViewController.h"

@interface SearchTableViewController : UITableViewController  <UITableViewDelegate, CLLocationManagerDelegate> {

}

@property (strong, nonatomic) IBOutlet UITableView *searchTable;
@property (weak, nonatomic) IBOutlet UILabel *specialtyNameLabel;
@property(retain,nonatomic)NSString *receiveName;
@property(retain,nonatomic)NSString *receiveDisplay;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBarController;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (strong, nonatomic) fileUploadEngine *categoriesUploadEngine;
@property (strong, nonatomic) MKNetworkOperation *flOperation;


@end
