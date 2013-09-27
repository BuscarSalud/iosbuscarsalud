//
//  SingleDoctorMapViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 3/6/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SingleDoctorMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) NSDictionary *doctorsDictionary;
@property(nonatomic, strong) NSString *latReceived;
@property(nonatomic, strong) NSString *lonReceived;
@property(nonatomic, strong) NSString *nameReceived;
@property(nonatomic, strong) NSString *addressReceived;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)backButton:(id)sender;
@end
