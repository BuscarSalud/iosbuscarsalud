//
//  Annotation.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 3/2/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, copy) NSString *nid; 

@end
