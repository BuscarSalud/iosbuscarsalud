//
//  MapDoctorsViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 3/2/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapDoctorsViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) NSDictionary *doctorsDictionary;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;


- (IBAction)setMapType:(id)sender;
- (IBAction)backButtonBarItem:(id)sender;




@end
