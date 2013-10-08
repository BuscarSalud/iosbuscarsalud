//
//  ProfileInRequestViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 8/21/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "ProfileInRequestViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileInRequestViewController ()
{
    NSDictionary *idiomas;
    NSDictionary *experiencia;
    NSDictionary *cedulas;
    int limit;
    int baseLineVariable;
    int fl;
}

#define BASE_LINE 150
#define BASE_SEPARATOR 8
#define BASE_HEADING 13
#define BASE_ITEMS 12
#define BASE_BLOCK 20
#define BASE_EMPTY 10
#define BASE_ITEM_SEPARATOR 12
#define BASE_SEPARATOR_ITEM 6
#define ITEM_HEIGHT 12
#define HEADING_HEIGHT 20
#define MARGIN_HEADING 15
#define MARGIN_ITEM 15
#define MARGIN_SECOND_ITEM 210

@end

@implementation ProfileInRequestViewController
@synthesize nidReceived, phoneLabel, imageProfile, streetLabel, coloniaLabel, specialtyLabel, fromMap, subTitleLabel, stateLabel, loginSuccess, doctorInfo, phoneImageView;

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
	// Do any additional setup after loading the view.
    
    phoneImageView.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    if ([loginSuccess isEqualToString:@"1"]) {
        subTitleLabel.text = [doctorInfo objectForKey:@"name"];
        [self setDoctor:doctorInfo];
        [self loadDynamicData];
    }else{
        [self startLoadingBox];
        NSLog(@"Nid received: %@", nidReceived);
        [self getDoctor:nidReceived];
        //[sendMail setAlpha:0.0];
    }
    [self.tabBarItem setTitle:@"Mi Perfil"];
    
    UIFont *sourceSansProSemibold = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    UIFont *sourceSansProSemiboldHeader = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16];
    
    UILabel *educationHeaderLabel = (UILabel *)[self.view viewWithTag:101];
    UILabel *languagesHeaderLabel = (UILabel *)[self.view viewWithTag:102];
    UILabel *experienceHeaderLabel = (UILabel *)[self.view viewWithTag:103];
    
    [subTitleLabel setFont:sourceSansProSemibold];
    [educationHeaderLabel setFont:sourceSansProSemiboldHeader];
    [languagesHeaderLabel setFont:sourceSansProSemiboldHeader];
    [experienceHeaderLabel setFont:sourceSansProSemiboldHeader];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDoctor:(NSString *)nid
{
    /*
     [iOSRequest getDoctor:nid onCompletion:^(NSDictionary *doctor){
     dispatch_async(dispatch_get_main_queue(), ^{
     if (doctor == nil) {
     //warningLabel.text = @"Error, Please Try Again";
     // warningLabel.hidden = NO;
     UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:@"Alerta"
     message:@"Error de Conexión. Por favor intente de nuevo."
     delegate:nil
     cancelButtonTitle:@"Cancelar"
     otherButtonTitles:nil];
     
     [alert show];
     
     }
     [self setDoctor:doctor];
     doctorInfo = doctor;
     //[self loadDynamicData];
     [self performSelector:@selector(finishLoadingBox) withObject:nil afterDelay:1.0];
     subTitleLabel.text = [doctor objectForKey:@"name"];
     });
     }];*/
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    [postParams setValue:nid forKey:@"nid"];
    
    [ApplicationDelegate.infoEngine getDoctor:postParams completionHandler:^(NSDictionary *categories){
        if (categories == nil) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alerta"
                                  message:@"Error de Conexión. Por favor intente de nuevo."
                                  delegate:nil
                                  cancelButtonTitle:@"Cancelar"
                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
        [self setDoctor:categories];
        doctorInfo = categories;
        //[self loadDynamicData];
        [self performSelector:@selector(finishLoadingBox) withObject:nil afterDelay:1.0];
        subTitleLabel.text = [doctorInfo objectForKey:@"name"];
    } errorHandler:^(NSError* error){
    }];
}

-(void)setDoctor:(NSDictionary *)doc
{
    if (_doc != doc) {
        _doc = doc;
    }
    /*if ([[_doc objectForKey:@"latitude"] isKindOfClass:[NSNull class]]) {
        mapButton.enabled = NO;
    }else{
        mapButton.enabled = YES;
    }*/
    NSLog(@"%@", _doc);
    [self createInfoDisplay:_doc];
    specialtyLabel.text = [[[_doc objectForKey:@"cedulas"] objectForKey:@"1"] objectForKey:@"degree"];;
    
    UILabel *schoolItemLabel = (UILabel *)[self.view viewWithTag:106];
    schoolItemLabel.text = [_doc objectForKey:@"school"];
    
    if ([[_doc objectForKey:@"phone"] isKindOfClass:[NSNull class]]){
        phoneLabel.hidden = YES;
    }else{
        phoneLabel.text = [_doc objectForKey:@"phone"];
    }
    if ([[_doc objectForKey:@"street"] isKindOfClass:[NSNull class]]){
        streetLabel.hidden = YES;
    }else{
        streetLabel.text = [_doc objectForKey:@"street"];
    }
    
    if ([[_doc objectForKey:@"colonia"] isKindOfClass:[NSNull class]]){
        coloniaLabel.hidden = YES;
    }else{
        coloniaLabel.text = [_doc objectForKey:@"colonia"];
    }
    
    if ([[_doc objectForKey:@"locality"] isKindOfClass:[NSNull class]]){
        stateLabel.hidden = YES;
    }else{
        stateLabel.text = [_doc objectForKey:@"locality"];
    }
    
    if ([[_doc objectForKey:@"photo"] isKindOfClass:[NSNull class]]){
        [imageProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
        [imageProfile setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [imageProfile setAlpha:1.0];
        [UIView commitAnimations];
    }else{
        NSString *photoURL = [NSString stringWithFormat:@"http://www.buscarsalud.com/sites/default/files/styles/perfil_medium/public/%@",[_doc objectForKey:@"photo"]];
        [imageProfile setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [imageProfile setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [imageProfile setAlpha:1.0];
        [UIView commitAnimations];
    }
    
    //Points
    if ([[_doc objectForKey:@"points"] isKindOfClass:[NSNull class]]){
        NSLog(@"No points");
    }else{
        UIFont *verdanaPoints = [UIFont fontWithName:@"Verdana-Bold" size:12];
        UILabel *pointsLabel = [[UILabel alloc]init];
        UIImage *pointsContainerImage = [UIImage imageNamed:@"points-container.png"];
        UIImageView *pointsContainerView = [[UIImageView alloc]initWithImage:pointsContainerImage];
        pointsContainerView.frame = CGRectMake(114, 98, pointsContainerView.frame.size.width, pointsContainerView.frame.size.height);
        [pointsLabel setText:[_doc objectForKey:@"points"]];
        [pointsLabel setFont:verdanaPoints];
        pointsLabel.frame = CGRectMake(115, 115, pointsContainerView.frame.size.width - 2, 10);
        pointsLabel.textAlignment = NSTextAlignmentCenter;
        [pointsLabel setBackgroundColor:[UIColor clearColor]];
        [pointsLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:174.0/255.0 blue:100.0/255.0 alpha:1.0]];
        [scroller addSubview:pointsContainerView];
        [scroller addSubview:pointsLabel];
    }
    phoneImageView.hidden = NO;
    
}
- (IBAction)goBack:(id)sender {
    if ([fromMap isEqualToString:@"no"] ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([fromMap isEqualToString:@"yes"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)butttonSendMail:(id)sender {
    NSString *subject = [[NSString alloc]initWithFormat:@"Mensaje para el doctor %@", [doctorInfo objectForKey:@"name"]];
    MFMailComposeViewController *mailcontroller = [[MFMailComposeViewController alloc] init];
    [mailcontroller setMailComposeDelegate:self];
    NSString *email = [doctorInfo objectForKey:@"email"];
    NSArray *emailArray = [[NSArray alloc] initWithObjects:email, nil];
    [mailcontroller setToRecipients:emailArray];
    [mailcontroller setSubject:subject];
    [self presentViewController:mailcontroller animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)startLoadingBox{
    NSLog(@"Empiexza loading box");
    UIImage *statusImage = [UIImage imageNamed:@"loading-background"];
    UIActivityIndicatorView *activitIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    containerView = [[UIImageView alloc] init];
    UIImageView *activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    activitIndicator.center = activityImageView.center;
    [activitIndicator startAnimating];
    [containerView addSubview:activityImageView];
    [containerView addSubview:activitIndicator];
    
    [containerView setAlpha:0.0];
    [self.navigationController.view addSubview:containerView];
    [UIView beginAnimations:nil context:nil];
    [containerView setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)finishLoadingBox{
    [containerView setAlpha:1.0];
    [UIView beginAnimations:nil context:nil];
    [containerView setAlpha:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDelegate:containerView];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
    [self loadDynamicData];
}

- (void)createInfoDisplay:(NSDictionary *)info{
    UILabel *degreeItemLabel = (UILabel *)[self.view viewWithTag:104];
    degreeItemLabel.text = [_doc objectForKey:@"degree"];
    
    CGRect frame = degreeItemLabel.frame;
    NSLog(@"Frame origin x = %f and Y = %f", frame.origin.x, frame.origin.y);
    frame.origin.y = 500;
    degreeItemLabel.frame = frame;
}


# pragma mark - Prepare Data for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
    if ([segue.identifier isEqualToString:@"goToSingleDoctorMap"]) {
        NSString *address = [NSString stringWithFormat:@"%@ %@",[_doc objectForKey:@"street"], [_doc objectForKey:@"colonia"]];
        SingleDoctorMapViewController *destViewController = segue.destinationViewController;
        destViewController.latReceived = [_doc objectForKey:@"latitude"];
        destViewController.lonReceived = [_doc objectForKey:@"longitude"];
        destViewController.addressReceived = address;
        destViewController.nameReceived = [_doc objectForKey:@"name"];
    }*/
}



-(void)viewDidAppear:(BOOL)animated
{
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, limit)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [scroller setContentOffset:CGPointMake(0, 0)];
    
}

-(void)loadDynamicData
{
    UIFont *sourceSansProSemiboldHeader = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16];
    UIFont *verdana = [UIFont fontWithName:@"Verdana" size:10];
    UIImage *separatorImage = [UIImage imageNamed:@"line-divider-profile.png"];
    UIImage *separatorItemImage = [UIImage imageNamed:@"line-divider-items-profile.png"];
    
    if ([[doctorInfo objectForKey:@"email"] isKindOfClass:[NSNull class]]){
        NSLog(@"No Email");
        baseLineVariable = 150;
    }else{
        baseLineVariable = BASE_LINE + 18;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        //[sendMail setAlpha:1.0];
        [UIView commitAnimations];
    }
    UIImageView *separatorViewEducation = [[UIImageView alloc] initWithImage:separatorImage];
    
    // Extract block
    fl = 0;
    if (![[doctorInfo objectForKey:@"subtitle"] isKindOfClass:[NSNull class]]) {
        UILabel *subtitleLabel = [[UILabel alloc]init];
        [subtitleLabel setFont:verdana];
        [subtitleLabel setText:[doctorInfo objectForKey:@"subtitle"]];
        [subtitleLabel setAlpha:0.0];
        [scroller addSubview:subtitleLabel];
        subtitleLabel.frame = CGRectMake(MARGIN_ITEM, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        fl = 1;
        subtitleLabel.numberOfLines = 0;
        [subtitleLabel sizeToFit];
        limit = baseLineVariable + BASE_ITEMS + 5;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [subtitleLabel setAlpha:1.0];
        [UIView commitAnimations];
    }
    
    if (![[doctorInfo objectForKey:@"summary"] isKindOfClass:[NSNull class]]) {
        UILabel *summaryLabel = [[UILabel alloc]init];
        [summaryLabel setFont:verdana];
        [summaryLabel setText:[doctorInfo objectForKey:@"summary"]];
        [summaryLabel setAlpha:0.0];
        [scroller addSubview:summaryLabel];
        if (fl == 1) {
            summaryLabel.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + BASE_ITEMS;
        }else{
            summaryLabel.frame = CGRectMake(MARGIN_ITEM, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + baseLineVariable;
            fl = 1;
        }
        summaryLabel.numberOfLines = 0;
        [summaryLabel sizeToFit];
        limit = limit + 5 + summaryLabel.frame.size.height;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [summaryLabel setAlpha:1.0];
        [UIView commitAnimations];
    }else{
        if (fl == 1) {
            limit = limit + 5;
        }
    }
    
    if (![[doctorInfo objectForKey:@"state"] isKindOfClass:[NSNull class]]) {
        UILabel *stateSubtitleLabel = [[UILabel alloc]init];
        [stateSubtitleLabel setFont:verdana];
        [stateSubtitleLabel setText:[doctorInfo objectForKey:@"state"]];
        [stateSubtitleLabel setAlpha:0.0];
        [scroller addSubview:stateSubtitleLabel];
        if (fl == 1) {
            stateSubtitleLabel.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + BASE_ITEMS + 5;
        }else{
            stateSubtitleLabel.frame = CGRectMake(MARGIN_ITEM, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = baseLineVariable + BASE_ITEMS + 5;
            fl = 1;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [stateSubtitleLabel setAlpha:1.0];
        [UIView commitAnimations];
    }
    
    if (![[doctorInfo objectForKey:@"specialty"] isKindOfClass:[NSNull class]]) {
        UILabel *specialtySubtitleLabel = [[UILabel alloc]init];
        [specialtySubtitleLabel setFont:verdana];
        [specialtySubtitleLabel setText:[doctorInfo objectForKey:@"specialty"]];
        [specialtySubtitleLabel setAlpha:0.0];
        [scroller addSubview:specialtySubtitleLabel];
        if (fl == 1 ){
            specialtySubtitleLabel.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + BASE_BLOCK;
        }else{
            specialtySubtitleLabel.frame = CGRectMake(MARGIN_ITEM, baseLineVariable, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
            limit = limit + baseLineVariable;
            fl = 1;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.4];
        [specialtySubtitleLabel setAlpha:1.0];
        [UIView commitAnimations];
    }
    
    
    
    
    //--------------
    
    
    //Education block
    
    UILabel *educacionLabel = [[UILabel alloc]init];
    [educacionLabel setText:@"Educación"];
    [educacionLabel setFont:sourceSansProSemiboldHeader];
    educacionLabel.backgroundColor = [UIColor clearColor];
    [educacionLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [scroller addSubview:educacionLabel];
    [scroller addSubview:separatorViewEducation];
    [educacionLabel setAlpha:0.0];
    [separatorViewEducation setAlpha:0.0];
    if (fl == 1){
        educacionLabel.frame = CGRectMake(MARGIN_HEADING, limit, 100, HEADING_HEIGHT);
        limit = limit + BASE_HEADING;
    }else{
        educacionLabel.frame = CGRectMake(MARGIN_HEADING, baseLineVariable, 100, HEADING_HEIGHT);
        limit = baseLineVariable + BASE_HEADING;
    }
    separatorViewEducation.frame = CGRectMake(9, limit, separatorViewEducation.frame.size.width, separatorViewEducation.frame.size.height);
    limit = limit + BASE_SEPARATOR;
    //limit = limit + BASE_HEADING;
    
    int cedulaCounter = 0;
    cedulas = [doctorInfo objectForKey:@"cedulas"];
    for (NSDictionary *cedulaItems in [cedulas allValues]){
        UIImageView *separatorViewItems = [[UIImageView alloc]initWithImage:separatorItemImage];
        
        UILabel *educationDegreeItem = [[UILabel alloc]init];
        UILabel *educationSchoolItem = [[UILabel alloc]init];
        UILabel *educationYearItem = [[UILabel alloc]init];
        
        educationDegreeItem.tag = cedulaCounter + 1;
        educationSchoolItem.tag = cedulaCounter + 1;
        educationYearItem.tag = cedulaCounter + 1;
        
        [educationDegreeItem setText:[cedulaItems objectForKey:@"degree"]];
        [educationSchoolItem setText:[cedulaItems objectForKey:@"school"]];
        [educationYearItem setText:[cedulaItems objectForKey:@"year"]];
        
        [educationDegreeItem setFont:verdana];
        [educationSchoolItem setFont:verdana];
        [educationYearItem setFont:verdana];
        
        [educationDegreeItem setAlpha:0.0];
        [educationSchoolItem setAlpha:0.0];
        [educationYearItem setAlpha:0.0];
        
        [scroller addSubview:educationDegreeItem];
        [scroller addSubview:educationSchoolItem];
        [scroller addSubview:educationYearItem];
        
        
        if (cedulaCounter == 0) {
            limit = limit + BASE_SEPARATOR;
        }else{
            if (cedulaCounter < [[doctorInfo objectForKey:@"cedulas"] count]) {
                limit = limit + BASE_ITEMS;
                [separatorViewItems setAlpha:0.0];
                [scroller addSubview:separatorViewItems];
                separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
                limit = limit + BASE_SEPARATOR_ITEM + 5;
            }
        }
        educationDegreeItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        educationSchoolItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        educationSchoolItem.numberOfLines = 0;
        [educationSchoolItem sizeToFit];
        limit = limit + educationSchoolItem.frame.size.height;
        educationYearItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        
        if (cedulaCounter < [[cedulaItems objectForKey:@"cedulas"] count]) {
            limit = limit + educationYearItem.frame.size.height + 15;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationDuration:0.4];
        [educationDegreeItem setAlpha:1.0];
        [educationSchoolItem setAlpha:1.0];
        [educationYearItem setAlpha:1.0];
        [separatorViewItems setAlpha:1.0];
        [UIView commitAnimations];
        cedulaCounter++;
    }
    limit = limit + BASE_BLOCK;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationDuration:0.4];
    [educacionLabel setAlpha:1.0];
    [separatorViewEducation setAlpha:1.0];
    [UIView commitAnimations];
    
    //Languages Block
    UIImageView *separatorViewLanguages = [[UIImageView alloc]initWithImage:separatorImage];
    UILabel *languagesHeaderLabel = [[UILabel alloc]init];
    [languagesHeaderLabel setText:@"Idiomas"];
    [languagesHeaderLabel setFont:sourceSansProSemiboldHeader];
    languagesHeaderLabel.backgroundColor = [UIColor clearColor];
    [languagesHeaderLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [scroller addSubview:languagesHeaderLabel];
    [scroller addSubview:separatorViewLanguages];
    [languagesHeaderLabel setAlpha:0.0];
    [separatorViewLanguages setAlpha:0.0];
    languagesHeaderLabel.frame = CGRectMake(MARGIN_HEADING, limit, 100, HEADING_HEIGHT);
    limit = limit + BASE_HEADING;
    separatorViewLanguages.frame = CGRectMake(9, limit, separatorViewLanguages.frame.size.width, separatorViewLanguages.frame.size.height);
    //Language Items
    if ([[doctorInfo objectForKey:@"languages"] isKindOfClass:[NSNull class]]){
        NSLog(@"No tiene idiomas registrados");
        limit = limit + BASE_EMPTY;
    }else{
        int i = 0;
        idiomas = [doctorInfo objectForKey:@"languages"];
        //NSLog(@"%@", [idiomas allValues]);
        for (NSDictionary *languageItems in [idiomas allValues]) {
            
            UIImageView *separatorViewItems = [[UIImageView alloc]initWithImage:separatorItemImage];
            UILabel *languageItem = [[UILabel alloc]init];
            UILabel *languageLevel = [[UILabel alloc]init];
            languageItem.tag = i + 1;
            languageLevel.tag = i + 1;
            [languageItem setText:[languageItems objectForKey:@"name"]];
            [languageLevel setText:[languageItems objectForKey:@"level"]];
            [languageItem setFont:verdana];
            [languageLevel setFont:verdana];
            
            [scroller addSubview:languageItem];
            [scroller addSubview:languageLevel];
            [languageLevel setAlpha:0.0];
            [languageItem setAlpha:0.0];
            [separatorViewItems setAlpha:0.0];
            if (i == 0) {
                limit = limit + BASE_SEPARATOR;
            }else{
                if (i <= [[doctorInfo objectForKey:@"languages"] count]) {
                    [scroller addSubview:separatorViewItems];
                    separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
                    limit = limit + BASE_SEPARATOR_ITEM;
                }
            }
            languageItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewLanguages.frame.size.width, ITEM_HEIGHT);
            languageLevel.frame = CGRectMake(MARGIN_SECOND_ITEM, limit, 160, ITEM_HEIGHT);
            if (i < [[doctorInfo objectForKey:@"languages"] count] - 1) {
                limit = limit + BASE_ITEM_SEPARATOR;
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.25];
            [UIView setAnimationDuration:0.4];
            [languageItem setAlpha:1.0];
            [separatorViewItems setAlpha:1.0];
            [languageLevel setAlpha:1.0];
            [UIView commitAnimations];
            i++;
        }
    }
    limit = limit + BASE_BLOCK;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.25];
    [UIView setAnimationDuration:0.4];
    [languagesHeaderLabel setAlpha:1.0];
    [separatorViewLanguages setAlpha:1.0];
    [UIView commitAnimations];
    
    //Experience block
    UIImageView *separatorViewExperience = [[UIImageView alloc]initWithImage:separatorImage];
    UILabel *experienceHeaderLabel = [[UILabel alloc]init];
    [experienceHeaderLabel setText:@"Experiencia"];
    [experienceHeaderLabel setFont:sourceSansProSemiboldHeader];
    experienceHeaderLabel.backgroundColor = [UIColor clearColor];
    [experienceHeaderLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [scroller addSubview:experienceHeaderLabel];
    [scroller addSubview:separatorViewExperience];
    [separatorViewExperience setAlpha:0.0];
    [experienceHeaderLabel setAlpha:0.0];
    experienceHeaderLabel.frame = CGRectMake(MARGIN_HEADING, limit, 100, HEADING_HEIGHT);
    limit = limit + BASE_HEADING;
    separatorViewExperience.frame = CGRectMake(9, limit, separatorViewExperience.frame.size.width, separatorViewExperience.frame.size.height);
    if ([[doctorInfo objectForKey:@"experience"] isKindOfClass:[NSNull class]]){
        limit = limit + BASE_EMPTY + 10;
    }else{
        int i = 0;
        experiencia = [doctorInfo objectForKey:@"experience"];
        for (NSDictionary *experienceItems in [experiencia allValues]){
            UIImageView *separatorViewItems = [[UIImageView alloc]initWithImage:separatorItemImage];
            UILabel *experienceTitle = [[UILabel alloc]init];
            UILabel *experienceCompany = [[UILabel alloc]init];
            UILabel *experienceDescription = [[UILabel alloc]init];
            UILabel *experiencePeriod = [[UILabel alloc]init];
            experienceTitle.tag = i + 1;
            experienceCompany.tag = i + 1;
            experienceDescription.tag = i + 1;
            experiencePeriod.tag = i + 1;
            [experienceTitle setText:[experienceItems objectForKey:@"title"]];
            if (![[experienceItems objectForKey:@"company"] isKindOfClass:[NSNull class]]) {
                [experienceCompany setText:[experienceItems objectForKey:@"company"]];
            }
            if (![[experienceItems objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
                [experienceDescription setText:[experienceItems objectForKey:@"description"]];
            }
            [experiencePeriod setText:[experienceItems objectForKey:@"period"]];
            [experienceTitle setFont:verdana];
            [experienceCompany setFont:verdana];
            [experienceDescription setFont:verdana];
            [experiencePeriod setFont:verdana];
            
            [experienceTitle setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:245.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [experiencePeriod setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:245.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [experienceCompany setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:245.0/255.0 blue:253.0/255.0 alpha:1.0]];
            [experienceTitle setAlpha:0.0];
            [experienceCompany setAlpha:0.0];
            [experienceDescription setAlpha:0.0];
            [experiencePeriod setAlpha:0.0];
            [scroller addSubview:experienceTitle];
            [scroller addSubview:experienceCompany];
            [scroller addSubview:experienceDescription];
            [scroller addSubview:experiencePeriod];
            
            if (i == 0) {
                limit = limit + BASE_SEPARATOR;
            }else{
                if (i <= [[doctorInfo objectForKey:@"experience"] count]) {
                    [scroller addSubview:separatorViewItems];
                    separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
                    limit = limit + BASE_SEPARATOR_ITEM + 5;
                }
            }
            
            experienceTitle.frame = CGRectMake(MARGIN_ITEM, limit, 294, ITEM_HEIGHT);
            experiencePeriod.frame = CGRectMake(MARGIN_SECOND_ITEM, limit, 99, ITEM_HEIGHT);
            limit = limit + BASE_ITEM_SEPARATOR;
            experienceCompany.frame = CGRectMake(MARGIN_ITEM, limit, 294, ITEM_HEIGHT);
            limit = limit + BASE_ITEM_SEPARATOR + 3;
            experienceDescription.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewItems.frame.size.width, experienceDescription.frame.size.height);
            experienceDescription.numberOfLines = 0;
            [experienceDescription sizeToFit];
            //limit = limit + experienceDescription.frame.size.height;
            //separatorViewItems.frame = CGRectMake(9, limit, separatorViewItems.frame.size.width, separatorViewItems.frame.size.height);
            
            //[scroller addSubview:separatorViewItems];
            
            NSLog(@"Val i: %d   Val Dic: %d", i, [[doctorInfo objectForKey:@"experience"] count]);
            if (i < [[doctorInfo objectForKey:@"experience"] count]) {
                limit = limit + experienceDescription.frame.size.height + 15;
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.25];
            [UIView setAnimationDuration:0.4];
            [experienceTitle setAlpha:1.0];
            [experienceCompany setAlpha:1.0];
            [experienceDescription setAlpha:1.0];
            [experiencePeriod setAlpha:1.0];
            [UIView commitAnimations];
            i++;
            
        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:0.4];
    [separatorViewExperience setAlpha:1.0];
    [experienceHeaderLabel setAlpha:1.0];
    [UIView commitAnimations];
    
    limit = limit + 10;
    
    //Contact Information Block
    UIImageView *separatorViewContactInfo = [[UIImageView alloc]initWithImage:separatorImage];
    UILabel *contactInfoHeaderLabel = [[UILabel alloc]init];
    [contactInfoHeaderLabel setText:@"Información de Contacto"];
    [contactInfoHeaderLabel setFont:sourceSansProSemiboldHeader];
    contactInfoHeaderLabel.backgroundColor = [UIColor clearColor];
    [contactInfoHeaderLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:164.0/255.0 blue:100.0/255.0 alpha:1.0]];
    [scroller addSubview:contactInfoHeaderLabel];
    [scroller addSubview:separatorViewContactInfo];
    [separatorViewContactInfo setAlpha:0.0];
    [contactInfoHeaderLabel setAlpha:0.0];
    contactInfoHeaderLabel.frame = CGRectMake(MARGIN_HEADING, limit, 300, HEADING_HEIGHT);
    limit = limit + BASE_HEADING;
    separatorViewContactInfo.frame = CGRectMake(9, limit, separatorViewExperience.frame.size.width, separatorViewExperience.frame.size.height);
    limit = limit + BASE_SEPARATOR;
    //Address Name Item
    if ([[doctorInfo objectForKey:@"address_name"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin nombre en direccion");
    }else{
        UILabel *contactInfoNameItem = [[UILabel alloc]init];
        [contactInfoNameItem setText:[doctorInfo objectForKey:@"address_name"]];
        [contactInfoNameItem setFont:verdana];
        [scroller addSubview:contactInfoNameItem];
        [contactInfoNameItem setAlpha:0.0];
        contactInfoNameItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoNameItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    //Address Street Item
    if ([[doctorInfo objectForKey:@"street"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoStreetItem = [[UILabel alloc]init];
        [contactInfoStreetItem setText:[doctorInfo objectForKey:@"street"]];
        [contactInfoStreetItem setFont:verdana];
        [scroller addSubview:contactInfoStreetItem];
        [contactInfoStreetItem setAlpha:0.0];
        contactInfoStreetItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoStreetItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    //Address Colonia Item
    if ([[doctorInfo objectForKey:@"colonia"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoColoniaItem = [[UILabel alloc]init];
        [contactInfoColoniaItem setText:[doctorInfo objectForKey:@"colonia"]];
        [contactInfoColoniaItem setFont:verdana];
        [scroller addSubview:contactInfoColoniaItem];
        [contactInfoColoniaItem setAlpha:0.0];
        contactInfoColoniaItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoColoniaItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    //Address Localty Item
    if ([[doctorInfo objectForKey:@"locality"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoLocalityItem = [[UILabel alloc]init];
        [contactInfoLocalityItem setText:[doctorInfo objectForKey:@"locality"]];
        [contactInfoLocalityItem setFont:verdana];
        [scroller addSubview:contactInfoLocalityItem];
        [contactInfoLocalityItem setAlpha:0.0];
        contactInfoLocalityItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoLocalityItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    //Address Posta Code Item
    if ([[doctorInfo objectForKey:@"postal_code"] isKindOfClass:[NSNull class]]){
        NSLog(@"Sin calle");
    }else{
        UILabel *contactInfoPostalCodeItem = [[UILabel alloc]init];
        [contactInfoPostalCodeItem setText:[doctorInfo objectForKey:@"postal_code"]];
        [contactInfoPostalCodeItem setFont:verdana];
        [scroller addSubview:contactInfoPostalCodeItem];
        [contactInfoPostalCodeItem setAlpha:0.0];
        contactInfoPostalCodeItem.frame = CGRectMake(MARGIN_ITEM, limit, separatorViewEducation.frame.size.width, ITEM_HEIGHT);
        limit = limit + BASE_ITEMS;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.35];
        [UIView setAnimationDuration:0.4];
        [contactInfoPostalCodeItem setAlpha:1.0];
        [UIView commitAnimations];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.35];
    [UIView setAnimationDuration:0.4];
    [separatorViewContactInfo setAlpha:1.0];
    [contactInfoHeaderLabel setAlpha:1.0];
    [UIView commitAnimations];
    
    [scroller setContentSize:CGSizeMake(320, limit + 10)];
}



@end
