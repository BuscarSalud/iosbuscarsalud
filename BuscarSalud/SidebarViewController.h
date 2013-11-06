//
//  SidebarViewController.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 10/9/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UITableViewController

@property (nonatomic, strong) NSArray *menuItems;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;

@end
