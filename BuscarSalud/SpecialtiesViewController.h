//
//  SpecialtiesViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/21/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialtiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    double lat;
    double lon;
}

- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//@property (retain, nonatomic)NSArray *spec;
@property (retain, nonatomic)NSDictionary *specialtiesDictionary;
@property(strong, nonatomic)NSNumber *latitudeSpec;
@property(strong, nonatomic)NSNumber *longitudeSpec;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *subTextLabel;


@end
