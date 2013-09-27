//
//  DoctorResultsViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/24/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "DoctorResultsViewController.h"
#import "AppDelegate.h"
#import "iOSRequest.h"
#import "ProfileViewController.h"
#import "MapDoctorsViewController.h"
#import "States.h"
#import "Specialty.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface DoctorResultsViewController (){
    NSIndexPath *prevPathSpec;
    NSIndexPath *prevPathBack;
    NSString *specTableSelectedValue;
    NSString *backTableSelectedValue;
    NSString *specLabelCellString;
    NSString *specialtySafeName;
    NSString *stateSafeName;
    NSString *selectedStateName;
    NSString *selectedStateTid;
    NSDictionary *specialtiesDictionary;
    NSDictionary *statesDictionary;
    BOOL firstHitOnState;
    BOOL selectedBeforeState;
    BOOL firstHitOnSpec;
    int sortingOptionNum;
    
}
#define VIEW_HIDDEN 230

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@end

@implementation DoctorResultsViewController
@synthesize latitudeUser, longitudeUser, specialtyString, myTableView, myNavigation, subTitleLabel, subtitleString, layerPosition, mapButton, backButton, topNavBar, stat, specialities, searchButton, sortingControl, displayLabel, statesDictionary, picker,pickerViewContainer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[self tableViewBack]setDelegate:self];
    //[[self tableViewBack]setDataSource:self];
    UIFont *sourceSansProSemibold = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    [displayLabel setFont:sourceSansProSemibold ];
    subTitleLabel.hidden = YES;
    specTableSelectedValue = @"";
    backTableSelectedValue = @"Todos";
    firstHitOnSpec = NO;
    self.layerPosition = self.topLayer.frame.origin.x;
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar-background"];
    [topNavBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    //UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    //NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    /*
    [segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segControl setAlpha:0.0];
    [stateSelected setAlpha:0.0];
    [specSelected setAlpha:0.0];
    */
    //[self.tableViewBack setAlpha:0.0];
    //[self.tableViewSpec setAlpha:0.0];
    //[self.searchButton setAlpha:0.0];
    
    subTitleLabel.text = subtitleString;
    displayLabel.text = subtitleString;
    specLabelCellString = subtitleString;
    specialtySafeName = specialtyString;
    stateSafeName = @"";
    [sortingControl setSelectedSegmentIndex:0];
    
    [self getLocations:[latitudeUser stringValue] andLongitude:[longitudeUser stringValue] andSpecialty:specialtyString andState:@"" andOrder:@""];

    // Assign our own backgroud for the view
    self.topLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.myTableView.backgroundColor = [UIColor clearColor];
    //self.tableViewBack.backgroundColor = [UIColor clearColor];
    //self.tableViewSpec.backgroundColor = [UIColor clearColor];

    
    // Remove table cell separator
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    myTableView.contentInset = inset;
    //tableViewBack.contentInset = inset;
    //tableViewSpec.contentInset = inset;
    [myTableView reloadData];
    //[self.loading startAnimating];
   
/*
    States *s33 = [States new];
    s33.display = @"Zacatecas";
    s33.name = @"31";
    
    stat = [NSArray arrayWithObjects:s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, s32, s33, nil];
    */
    
    NSDictionary *stateInDictionary = [[NSDictionary alloc]init];
    stat = [[NSMutableArray alloc]init];
    
    for (int i =0; i<=[statesDictionary count]; i++) {
        NSString *index = [NSString stringWithFormat:@"estado%d",i];
        stateInDictionary = [statesDictionary objectForKey:index];
        States *stateItem = [States new];
        stateItem.display = [stateInDictionary objectForKey:@"nombre"];
        stateItem.name = [NSString stringWithFormat:@"%@", [stateInDictionary objectForKey:@"tid"]];;
        [stat addObject:stateItem];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Function to get Doctors

-(void)getLocations:(NSString *)latitude andLongitude:(NSString *)longitude andSpecialty:(NSString *)specialty andState:(NSString *)state andOrder:(NSString *)order
{
    [self.loading startAnimating];
    /*
    [iOSRequest getLocations:latitude andLongitude:longitude andSpecialty:specialty andState:state andOrder:order onCompletion:^(NSDictionary *user1){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (user1 == nil) {
                
                //warningLabel.text = @"Error, Please Try Again";
                // warningLabel.hidden = NO;
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Alerta"
                                      message:@"Esta categoria esta vacia."
                                      delegate:nil
                                      cancelButtonTitle:@"Cancelar"
                                      otherButtonTitles:nil];
                
                [alert show];
                self.mapButton.enabled = NO;
                
            }else self.mapButton.enabled = YES;
            
            [myTableView setAlpha:0.0];
            [UIView beginAnimations:nil context:nil];
            [myTableView setAlpha:1.0];
            [UIView commitAnimations];

            
            [self.loading stopAnimating];
            if ([user1 isKindOfClass:[NSNull class]]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Alerta"
                                      message:@"No hay medicos de esa especialidad en esta region"
                                      delegate:nil
                                      cancelButtonTitle:@"Cancelar"
                                      otherButtonTitles:nil];
                
                [alert show];
                myTableView.hidden = YES;
            }else{
                [self setUser:user1];
                [self.myTableView reloadData];
                [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionNone animated:NO];
                myTableView.hidden = NO;
            }
        });
    }];*/
    
    //-----------------------
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    
    if ([state isEqualToString:@""]) {
        if ([order isEqualToString:@""]){
            //fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@",latitude, longitude, specialty];
            [postParams setValue:latitude forKey:@"lat"];
            [postParams setValue:longitude forKey:@"lon"];
            [postParams setValue:specialty forKey:@"especialidad"];
        }else{
            if ([order isEqualToString:@"distancia"]) {
                //fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@&orden=%@", latitude, longitude,specialty, order];
                [postParams setValue:latitude forKey:@"lat"];
                [postParams setValue:longitude forKey:@"lon"];
                [postParams setValue:specialty forKey:@"especialidad"];
                [postParams setValue:order forKey:@"orden"];
            }else{
                //fullPath = [basePath stringByAppendingFormat:@"especialidad=%@&orden=%@", specialty, order];
                [postParams setValue:specialty forKey:@"especialidad"];
                [postParams setValue:order forKey:@"orden"];
            }
        }
    }else{
        if ([order isEqualToString:@""]){
            //fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@&estado=%@",latitude, longitude, specialty, state];
            [postParams setValue:latitude forKey:@"lat"];
            [postParams setValue:longitude forKey:@"lon"];
            [postParams setValue:specialty forKey:@"especialidad"];
            [postParams setValue:state forKey:@"estado"];
        }else{
            if ([order isEqualToString:@"distancia"]) {
                //fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@&estado=%@&orden=%@", latitude, longitude, specialty, state, order];
                [postParams setValue:latitude forKey:@"lat"];
                [postParams setValue:longitude forKey:@"lon"];
                [postParams setValue:specialty forKey:@"especialidad"];
                [postParams setValue:state forKey:@"estado"];
                [postParams setValue:order forKey:@"orden"];
            }else{
                //fullPath = [basePath stringByAppendingFormat:@"especialidad=%@&estado=%@&orden=%@", specialty, state, order];
                [postParams setValue:specialty forKey:@"especialidad"];
                [postParams setValue:state forKey:@"estado"];
                [postParams setValue:order forKey:@"orden"];
            }
        }
    }
    
    NSLog(@"%@", postParams);
    [ApplicationDelegate.infoEngine getDoctorsList:postParams completionHandler:^(NSDictionary *categories){
        
        if (categories == nil) {
            
            //warningLabel.text = @"Error, Please Try Again";
            // warningLabel.hidden = NO;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta"
                                  message:@"Esta categoria esta vacia."
                                  delegate:nil
                                  cancelButtonTitle:@"Cancelar"
                                  otherButtonTitles:nil];
            
            [alert show];
            self.mapButton.enabled = NO;
            
        }else self.mapButton.enabled = YES;
        
        [myTableView setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [myTableView setAlpha:1.0];
        [UIView commitAnimations];
        
        
        [self.loading stopAnimating];
        if ([categories isKindOfClass:[NSNull class]]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta"
                                  message:@"No hay medicos de esa especialidad en esta region"
                                  delegate:nil
                                  cancelButtonTitle:@"Cancelar"
                                  otherButtonTitles:nil];
            
            [alert show];
            myTableView.hidden = YES;
        }else{
            if (_user != categories) {
                _user = categories;
            }
            [self.myTableView reloadData];
            [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                               atScrollPosition:UITableViewScrollPositionNone animated:NO];
            myTableView.hidden = NO;
        }
    } errorHandler:^(NSError* error){
        [self.loading stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alerta"
                              message:@"Ha ocurrido un error, vuelve a intentarlo"
                              delegate:nil
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil];
        
        [alert show];

    }];
}

-(void)setUser:(NSDictionary *)user
{
    if (_user != user) {
        _user = user;
    }
    NSLog(@"Especialidad : %@", specialtyString);
    NSLog(@"valor de diccionario en Doctor results: %@", user);
    NSLog(@"Diccionario _user count: %d", [_user count]);
}


#pragma mark - TableView Data Source methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if (tableView == myTableView) {
        return _user.count;
    /*} else if (tableView == tableViewBack) {
        return [stat count]-1;
    }else{
        return [specialities count];
    }*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:(93/255.0) green:(153/255.0) blue:(41/255.0) alpha:1]];

    
    if (tableView == myTableView) {
//        int doctorIndex = indexPath.row;
        //NSString *doctorIndex = [[_user allKeys] objectAtIndex:indexPath.row];
        NSString *doctor = [NSString stringWithFormat:@"doctor%d",indexPath.row];
        NSLog(@"Path del objeto en el diccionario es: %@", doctor);
        NSLog(@"%d", indexPath.row);
        
        UIFont *sourceSansProBold = [UIFont fontWithName:@"SourceSansPro-Bold" size:14];
        UILabel *doctorNameLabel = (UILabel *)[cell viewWithTag:101];
        doctorNameLabel.text = [[_user objectForKey:doctor] objectForKey:@"nombre"];
        [doctorNameLabel setFont:sourceSansProBold];
        NSLog(@"%@", [[_user objectForKey:doctor] objectForKey:@"nombre"]);
        doctorNameLabel.layer.cornerRadius = 5;
        
        UILabel *doctorAddressLabel = (UILabel *)[cell viewWithTag:102];
        if ([[[_user objectForKey:doctor] objectForKey:@"calle"] isKindOfClass:[NSNull class]] ) {
            doctorAddressLabel.text = @"";
        }else{
            doctorAddressLabel.text = [[_user objectForKey:doctor] objectForKey:@"calle"];
        }
        
        UILabel *doctorLocalityLabel = (UILabel *)[cell viewWithTag:103];
        if ([[[_user objectForKey:doctor] objectForKey:@"ciudad"] isKindOfClass:[NSNull class]]) {
            doctorLocalityLabel.text = @"";
        }else{
            doctorLocalityLabel.text = [[_user objectForKey:doctor] objectForKey:@"ciudad"];
        }
        
        UILabel *doctorColoniaLabel = (UILabel *)[cell viewWithTag:104];
        if ([[[_user objectForKey:doctor] objectForKey:@"colonia"] isKindOfClass:[NSNull class]]) {
            doctorColoniaLabel.text = @"";
        }else{
            doctorColoniaLabel.text = [[_user objectForKey:doctor] objectForKey:@"colonia"];
        }
        
        UILabel *doctorPuntosLabel = (UILabel *)[cell viewWithTag:105];
        if ([[[_user objectForKey:doctor] objectForKey:@"puntos"] isKindOfClass:[NSNull class]]) {
            doctorPuntosLabel.text = @"";
        }else{
            doctorPuntosLabel.text = [[_user objectForKey:doctor] objectForKey:@"puntos"];
        }
        
        UILabel *doctorDegreeLabel = (UILabel *)[cell viewWithTag:106];
        if ([[[_user objectForKey:doctor] objectForKey:@"titulo"] isKindOfClass:[NSNull class]]) {
            doctorDegreeLabel.text = @"";
        }else{
            doctorDegreeLabel.text = [[_user objectForKey:doctor] objectForKey:@"titulo"];
        }
        
        UIImageView *doctorPhoto = (UIImageView *)[cell viewWithTag:100];
        if ([[[_user objectForKey:doctor] objectForKey:@"img"] isKindOfClass:[NSNull class]]){
            [doctorPhoto setImage:[UIImage imageNamed:@"placeholder.png"]];
        }else{
            NSString *photo = [[_user objectForKey:doctor] objectForKey:@"img"];
            NSString *photoURL = [NSString stringWithFormat:@"http://www.buscarsalud.com/sites/default/files/styles/perfil_medium/public/%@",photo];
            [doctorPhoto setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        
        UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
        
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
        cellBackgroundView.image = background;
        cell.backgroundView = cellBackgroundView;
        
        // change background color of selected cell
        [cell setSelectedBackgroundView:bgColorView];
        

    }
    /*
    if (tableView == tableViewBack) {
        States *estados = [stat objectAtIndex:indexPath.row];
        UILabel *stateNameLabel = (UILabel *)[cell viewWithTag:201];
        
        stateNameLabel.text = estados.display;

        // change background color of selected cell
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    if (tableView == tableViewSpec) {
        Specialty *specialties = [specialities objectAtIndex:indexPath.row];
        UILabel *specNameLabel = (UILabel *)[cell viewWithTag:301];
        specNameLabel.text = specialties.display;
        
        // change background color of selected cell
        [cell setSelectedBackgroundView:bgColorView];

    }*/

    return cell;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [myTableView numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewSpec) {
        UITableViewCell *cellSpec = [tableViewSpec cellForRowAtIndexPath:indexPath];
        NSLog(@"Row selected: %d", indexPath.row);
        for (UIView *view in cellSpec.contentView.subviews) {
            UILabel *textLabelCell = (UILabel *)view;
            specLabelCellString = textLabelCell.text;
            specTableSelectedValue = textLabelCell.text;
            //specSelected.text = specTableSelectedValue;
        }
        
        NSLog(@"Valor de spec: %@", specTableSelectedValue);
        NSLog(@"Valor de state: %@", backTableSelectedValue);
        
        [self.loading startAnimating];        
        
        //+++++++++++++++++
        for (Specialty *specialtySelectedReadyToSend in specialities) {
            if ([specialtySelectedReadyToSend.display isEqualToString:specTableSelectedValue]) {
                specialtySafeName = specialtySelectedReadyToSend.name;
            }
        }
        
        NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
        [postParams setValue:specialtySafeName forKey:@"especialidad"];

        
        [ApplicationDelegate.infoEngine getInfo:postParams completionHandler:^(NSDictionary *categories){
            statesDictionary = categories;
            NSLog(@"statesDictionary = %@", statesDictionary);
            NSDictionary *stateInDictionary = [[NSDictionary alloc]init];
            stat = [[NSMutableArray alloc]init];
            
            for (int i =0; i<=[statesDictionary count]; i++) {
                NSString *index = [NSString stringWithFormat:@"estado%d",i];
                stateInDictionary = [statesDictionary objectForKey:index];
                States *stateItem = [States new];
                stateItem.display = [stateInDictionary objectForKey:@"nombre"];
                stateItem.name = [NSString stringWithFormat:@"%@", [stateInDictionary objectForKey:@"tid"]];
                [stat addObject:stateItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewBack reloadData];
            });
        } errorHandler:^(NSError* error){
        }];
        
        
        //+++++++++++++++++
           // [self getSpecialtiesStates:specTableSelectedValue andState:@""];
        
           
        
    }
    if (tableView == tableViewBack) {
        UITableViewCell *cellBack = [tableViewBack cellForRowAtIndexPath:indexPath];
        for (UIView *view in cellBack.contentView.subviews) {
            UILabel *textLabelCell = (UILabel *)view;
            backTableSelectedValue = textLabelCell.text;
        }
        if (indexPath.row != prevPathBack.row){
            NSLog(@"Last indexpath: %@", prevPathBack);
            prevPathBack = indexPath;
            //stateSelected.text = backTableSelectedValue;
            selectedBeforeState = NO;
        } else {
            if (selectedBeforeState) {
                //stateSelected.text = backTableSelectedValue;
                selectedBeforeState = NO;
            } else {
                [tableViewBack deselectRowAtIndexPath:indexPath animated:YES];
                NSLog(@"Same selected row");
                backTableSelectedValue = @"";
                //stateSelected.text = @"Estado";
                selectedBeforeState = YES;
            }
        }
        NSLog(@"Valor de state: %@", backTableSelectedValue);
        NSLog(@"Valor de spec: %@", specTableSelectedValue);

    }
}*/

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [stat count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    States *estados = [stat objectAtIndex:row];
    return estados.display;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    States *estados = [stat objectAtIndex:row];
    selectedStateName = estados.display;
    selectedStateTid = estados.name;
    
    NSLog(@"Selected state %@", estados.name);
}


# pragma mark - Prepare Data for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goToProfile"]) {
        ProfileViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        //NSString *doctor = [[_user allKeys] objectAtIndex:indexPath.row];
        NSString *doctor = [NSString stringWithFormat:@"doctor%d",indexPath.row];
        destViewController.nidReceived = [[_user objectForKey:doctor] objectForKey:@"nid"];
        destViewController.fromMap = @"no";
        [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if([segue.identifier isEqualToString:@"goToMapDoctors"]){
        MapDoctorsViewController *destViewController = segue.destinationViewController;
        destViewController.doctorsDictionary = _user;
    }
}


#pragma mark - Animate Layer like FB layout

-(void) animateLayerToPoint:(CGFloat)x
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.topLayer.frame;
                         frame.origin.x = x;
                         self.topLayer.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.layerPosition = self.topLayer.frame.origin.x;
                         if (x == 230 && finished == 1){
                            backButton.enabled = NO;
                             self.myTableView.userInteractionEnabled = NO;
                             int i = 0;
                             int arrayPath;
                             int a = 0;
                             int arrayPathStates;
                             
                             NSLog(@"%d", finished);
                             
                             for (Specialty *specArray in specialities){
                                 i++;
                                 if ([specArray.display isEqualToString:subtitleString]) {
                                     arrayPath = i;
                                     specTableSelectedValue = subtitleString;
                                 }
                             }
                             for (States *statesArray in stat) {
                                 a++;
                                 if ([statesArray.display isEqualToString:backTableSelectedValue]) {
                                     arrayPathStates = a;
                                 }
                             }
                             
                             //[tableViewSpec scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrayPath-1 inSection:0]
                                               //   atScrollPosition:UITableViewScrollPositionNone animated:YES];
                             //[tableViewSpec selectRowAtIndexPath:[NSIndexPath indexPathForRow:arrayPath-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                             //[tableViewBack selectRowAtIndexPath:[NSIndexPath indexPathForRow:arrayPathStates-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                         } else{
                             NSLog(@"%d", finished);
                             backButton.enabled = YES;
                             //[sortingControl setSelectedSegmentIndex:sortingOptionNum];
                             self.myTableView.userInteractionEnabled = YES;
                         }
                     }];
}

- (IBAction)panLayer:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.topLayer];
        CGRect frame = self.topLayer.frame;
        frame.origin.x = self.layerPosition + point.x;
        if (frame.origin.x < 0) frame.origin.x = 0;
        self.topLayer.frame = frame;
    }
    if(pan.state == UIGestureRecognizerStateEnded){
        if (self.topLayer.frame.origin.x <= 120) {
            [self animateLayerToPoint:0];
            subTitleLabel.text = specLabelCellString;
            displayLabel.text = specLabelCellString;
        } else{
            [self animateLayerToPoint: VIEW_HIDDEN];
            subtitleString = subTitleLabel.text;
        }
    }
}


/*
#pragma mark - Segment button actions
-(IBAction)segmentBtnPressed:(UISegmentedControl*)sender{
    //[self.tableViewBack reloadData];
    if([segControl selectedSegmentIndex] == 0){
        
        [tableViewSpec setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [tableViewBack setAlpha:0.0];
        [tableViewSpec setAlpha:1.0];
        [searchButton setAlpha:1.0];
        [UIView commitAnimations];
        specSelected.textColor = [UIColor whiteColor];
        stateSelected.textColor = [UIColor blackColor];
        
        if (!firstHitOnSpec) {
            int i = 0;
            int arrayPath;
            
            for (Specialty *specArray in specialities){
                i++;
                if ([specArray.display isEqualToString:subtitleString]) {
                    arrayPath = i;
                }
            }
            [tableViewSpec scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrayPath-1 inSection:0]
                                 atScrollPosition:UITableViewScrollPositionNone animated:YES];
            [tableViewSpec selectRowAtIndexPath:[NSIndexPath indexPathForRow:arrayPath-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            
            prevPathSpec = [NSIndexPath indexPathForRow:arrayPath-1 inSection:0];
            
            UITableViewCell *cellSpec = [tableViewSpec cellForRowAtIndexPath:prevPathSpec];
            for (UIView *view in cellSpec.contentView.subviews) {
                UILabel *textLabelCell = (UILabel *)view;
                specTableSelectedValue = textLabelCell.text;
                specSelected.text = specTableSelectedValue;
            }
            firstHitOnSpec = YES;
        }

        
       UITableViewCell *cell = [tableViewSpec cellForRowAtIndexPath:prevPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if ([segControl selectedSegmentIndex] == 1) {
        [tableViewBack setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [tableViewBack setAlpha:1.0];
        [searchButton setAlpha:1.0];
        [tableViewSpec setAlpha:0.0];
        [UIView commitAnimations];
        
        stateSelected.textColor = [UIColor whiteColor];
        specSelected.textColor = [UIColor blackColor];
        selectedBeforeState = NO;
        
        if (!firstHitOnState) {
            specTableSelectedValue = subTitleLabel.text;
            firstHitOnState = YES;
            NSLog(@"Valor de state: %@", backTableSelectedValue);
            NSLog(@"Valor de spec: %@", specTableSelectedValue);
        }
    }
}*/

#pragma mark - Search button actions
- (IBAction)searchButton:(id)sender {
    /*
    NSLog(@"*******************");
    NSLog(@"Especialidad a mandar: %@", specTableSelectedValue);
    NSLog(@"Estado a mandar: %@", backTableSelectedValue);
    
    [UIView beginAnimations:nil context:nil];
    [myTableView setAlpha:1.0];
    [myTableView setAlpha:0.0];
    [UIView commitAnimations];

    for (Specialty *specialtySelectedReadyToSend in specialities) {
        if ([specialtySelectedReadyToSend.display isEqualToString:specTableSelectedValue]) {
            specialtySafeName = specialtySelectedReadyToSend.name;
        }
    }
    
    if ([backTableSelectedValue isEqualToString:@""]) {
        stateSafeName = @"";
        sortingOptionNum = 0;
        backTableSelectedValue = @"Todos";
    }else{
        for (States *stateSelectedReadyToSend in stat) {
            if ([stateSelectedReadyToSend.display isEqualToString:backTableSelectedValue]) {
                stateSafeName = stateSelectedReadyToSend.name;
            }
        }
        sortingOptionNum = 1;
    }
    
    [self getLocations:[latitudeUser stringValue] andLongitude:[longitudeUser stringValue] andSpecialty:specialtySafeName andState:stateSafeName andOrder:@""];
    
    subTitleLabel.text = specLabelCellString;
    if ([stateSafeName isEqualToString:@""]) {
        displayLabel.text = specLabelCellString;
    }else{
        displayLabel.text = [NSString stringWithFormat:@"%@ en %@", specLabelCellString, backTableSelectedValue];
    }
    
    [self animateLayerToPoint:0];
    */
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        pickerViewContainer.frame = CGRectMake(0, 151, 320, 260);
        //scroller.frame = CGRectMake(0, -138, scroller.frame.size.width, scroller.frame.size.height);
    }];
}

#pragma mark - Sorting Options segment buttons
- (IBAction)segmentSortingOptions:(id)sender {
    if([sortingControl selectedSegmentIndex] == 0){
        [UIView beginAnimations:nil context:nil];
        [myTableView setAlpha:1.0];
        [myTableView setAlpha:0.0];
        [UIView commitAnimations];

        [self getLocations:[latitudeUser stringValue] andLongitude:[longitudeUser stringValue] andSpecialty:specialtySafeName andState:@"" andOrder:@"distancia"];
        if ([specTableSelectedValue isEqualToString:@""]) {
            displayLabel.text = subtitleString;
        }else{
            displayLabel.text = specTableSelectedValue;
        }
    }
    if ([sortingControl selectedSegmentIndex] == 1) {
        [UIView beginAnimations:nil context:nil];
        [myTableView setAlpha:1.0];
        [myTableView setAlpha:0.0];
        [UIView commitAnimations];

        [self getLocations:[latitudeUser stringValue] andLongitude:[longitudeUser stringValue] andSpecialty:specialtySafeName andState:stateSafeName andOrder:@"puntos"];
    }
    if ([sortingControl selectedSegmentIndex] == 2) {
        [UIView beginAnimations:nil context:nil];
        [myTableView setAlpha:1.0];
        [myTableView setAlpha:0.0];
        [UIView commitAnimations];

        [self getLocations:[latitudeUser stringValue] andLongitude:[longitudeUser stringValue] andSpecialty:specialtySafeName andState:stateSafeName andOrder:@"nombre"];
    }
}

- (IBAction)selectItem:(id)sender {
}

- (IBAction)cancelPicker:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewContainer.frame = CGRectMake(0, 460, 320, 260);        
    }];
}
// 

/*
#pragma mark - Function Get Specialties and States
-(void)getSpecialtiesStates:(NSString *)spec andState:(NSString *)state{
    
    if ([state isEqualToString:@""]) {
        NSLog(@"Specialty selected");
        for (Specialty *specialtySelectedReadyToSend in specialities) {
            if ([specialtySelectedReadyToSend.display isEqualToString:spec]) {
                specialtySafeName = specialtySelectedReadyToSend.name;
            }
        }
        NSLog(@"Before dispatch, specialtySafeName: %@", specialtySafeName);
        
        

        [iOSRequest getSpecialtiesAndStates:specialtySafeName andState:@"" andAll:@"" onCompletion:^(NSDictionary *specialtiesOrStates){
            dispatch_async(dispatch_get_main_queue(), ^{
                statesDictionary = specialtiesOrStates;
                //[self getSpecAndStat:specialtiesOrStates];
                            stat = [[NSMutableArray alloc]init];
                NSDictionary *stateInDictionary = [[NSDictionary alloc]init];

                for (int i =0; i<=[statesDictionary count]; i++) {
                    NSString *index = [NSString stringWithFormat:@"estado%d",i];
                    stateInDictionary = [statesDictionary objectForKey:index];
                    States *stateItem = [States new];
                    stateItem.display = [stateInDictionary objectForKey:@"nombre"];
                    stateItem.name = [NSString stringWithFormat:@"%@", [stateInDictionary objectForKey:@"tid"]];
                    [stat addObject:stateItem];
                }
                NSLog(@"New states when specialty clicked: %@", stat);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.2];
            [UIView setAnimationDuration:0.4];
            [self.tableViewBack setAlpha:0.0];
            [UIView commitAnimations];
            [self.tableViewBack reloadData];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.2];
            [UIView setAnimationDuration:0.4];
            [self.tableViewBack setAlpha:1.0];
            [UIView commitAnimations];

            
            });
         
        }];

        
        
    }
    if ([spec isEqualToString:@""]) {
        NSLog(@"State selected");
        for (States *stateSelectedReadyToSend in stat) {
            if ([stateSelectedReadyToSend.display isEqualToString:state]) {
                stateSafeName = stateSelectedReadyToSend.name;
            }
        }
        [iOSRequest getSpecialtiesAndStates:@"" andState:stateSafeName andAll:@"" onCompletion:^(NSDictionary *specialtiesOrStates){
            dispatch_async(dispatch_get_main_queue(), ^{
                specialtiesDictionary = specialtiesOrStates;
            });
        }];
    }
}
*/



@end
