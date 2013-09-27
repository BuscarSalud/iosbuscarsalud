//
//  AccessDataViewController.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 7/16/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "AccessDataViewController.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"

@interface AccessDataViewController ()
{
    NSString *pass;
    NSString *repeatPass;
    NSData *imagenCedulaFrontal;
    NSData *imagenCedulaTrasera;
    NSData *imagenCredencialFrontal;
    NSData *imagenCredencialTrasera;
    NSData *imagenPerfil;
    NSData *imagenGaleria1;
    NSData *imagenGaleria2;
    NSData *imagenGaleria3;
    NSData *imagenGaleria4;
    NSData *imagenGaleria5;
    NSMutableDictionary *credentials;
    BOOL cedulaBool;
    BOOL galeriaBool;
    
    NSManagedObjectContext *context;
}

@end

@implementation AccessDataViewController
@synthesize userInfoRequestDictionary, passwordTextField, repeatPasswordTextField, userNameTextField, sendButton, passwordsMatchLabel, yesNoLabel, requestOpenNoteLabel, requestFlag, requestObject;

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
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    NSLog(@"%@", userInfoRequestDictionary);
    
    if ([requestFlag isEqualToString:@"0"]) {
        [userNameTextField setEnabled:NO];
        
        requestOpenNoteLabel.hidden = NO;
        userNameTextField.text = [requestObject valueForKey:@"username"];
        sendButton.hidden = YES;
    }
    
    [passwordTextField setDelegate:self];
    [repeatPasswordTextField setDelegate:self];
    [userNameTextField setDelegate:self];
    
    sendButton.enabled = NO;
    
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(handleTextChange:)
                                                  name:UITextFieldTextDidChangeNotification
                                                object:repeatPasswordTextField];
    passwordsMatchLabel.hidden = YES;
    yesNoLabel.hidden = YES;
    cedulaBool = NO;
    galeriaBool = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButton:(id)sender {
    [self startLoadingBox];
    imagenCedulaFrontal = nil;
    imagenCedulaTrasera = nil;
    imagenCredencialFrontal = nil;
    imagenCredencialTrasera = nil;
    imagenGaleria1 = nil;
    imagenGaleria2 = nil;
    imagenGaleria3 = nil;
    imagenGaleria4 = nil;
    imagenGaleria5 = nil;
    
    NSMutableDictionary *credencial = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *cedula = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *galeria = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *perfil = [[NSMutableDictionary alloc]init];
    
    
    [userInfoRequestDictionary setValue:userNameTextField.text forKey:@"username"];
    NSString *passwordMD5 = [passwordTextField.text MD5];
    [userInfoRequestDictionary setValue:passwordMD5 forKey:@"password"];
    
    NSLog(@"%@", userInfoRequestDictionary);
    
#pragma mark - Core Data: Request
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
    NSManagedObject *newRequest = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    
    NSDictionary *general = [userInfoRequestDictionary objectForKey:@"general"];
    NSDictionary *contact = [userInfoRequestDictionary objectForKey:@"contacto"];
    NSDictionary *address = [userInfoRequestDictionary objectForKey:@"domicilio"];
    NSDictionary *experience = [userInfoRequestDictionary objectForKey:@"experiencia"];
    NSDictionary *language1 = [[userInfoRequestDictionary objectForKey:@"idiomas"] objectForKey:@"0"];
    NSDictionary *language2 = [[userInfoRequestDictionary objectForKey:@"idiomas"] objectForKey:@"1"];
    NSDictionary *listings = [userInfoRequestDictionary objectForKey:@"listado"];
    NSDictionary *socialMedia = [userInfoRequestDictionary objectForKey:@"social_media"];
    
    [newRequest setValue:[userInfoRequestDictionary objectForKey:@"numeroDeCedula"] forKey:@"cedulaNum"];
    
    [newRequest setValue:[general objectForKey:@"nombre"] forKey:@"firstName"];
    [newRequest setValue:[general objectForKey:@"apellidos"] forKey:@"lastName"];
    [newRequest setValue:[general objectForKey:@"extracto"] forKey:@"extract"];
    [newRequest setValue:[general objectForKey:@"nickname"] forKey:@"nickname"];
    [newRequest setValue:[general objectForKey:@"extracto"] forKey:@"extract"];
    [newRequest setValue:[general objectForKey:@"titulo"] forKey:@"title"];
    
    [newRequest setValue:[contact objectForKey:@"celular"] forKey:@"cellphone"];
    [newRequest setValue:[contact objectForKey:@"email"] forKey:@"email"];
    [newRequest setValue:[contact objectForKey:@"telefono"] forKey:@"phone"];
    
    [newRequest setValue:[address objectForKey:@"callenumero"] forKey:@"streetNumber"];
    [newRequest setValue:[address objectForKey:@"ciudad"] forKey:@"city"];
    [newRequest setValue:[address objectForKey:@"codigopostal"] forKey:@"postalCode"];
    [newRequest setValue:[address objectForKey:@"colonia"] forKey:@"colonia"];
    [newRequest setValue:[address objectForKey:@"consultorio"] forKey:@"officeName"];
    int estadoTid = [[address objectForKey:@"estadotid"] intValue];
    NSNumber *estadotid = [NSNumber numberWithInt:estadoTid];
    [newRequest setValue:estadotid forKey:@"stateTid"];
    
    [newRequest setValue:[experience objectForKey:@"descripcion"] forKey:@"desc"];
    [newRequest setValue:[experience objectForKey:@"empresa"] forKey:@"company"];
    [newRequest setValue:[experience objectForKey:@"fecha_desde"] forKey:@"dateSince"];
    [newRequest setValue:[experience objectForKey:@"fecha_hasta"] forKey:@"dateUntil"];
    [newRequest setValue:[experience objectForKey:@"puesto"] forKey:@"job"];
    int empleoactual = [[experience objectForKey:@"puesto_actual"] intValue];
    NSNumber *puestoActual = [NSNumber numberWithInt:empleoactual];
    [newRequest setValue:puestoActual forKey:@"currentJob"];
    [newRequest setValue:[experience objectForKey:@"ubicacion"] forKey:@"jobLocality"];
    [newRequest setValue:[experience objectForKey:@"url_empresa"] forKey:@"urlCompany"];
    
    [newRequest setValue:[language1 objectForKey:@"idioma1"] forKey:@"language1"];
    [newRequest setValue:[language1 objectForKey:@"nivel_idioma_1"] forKey:@"languageLevel1"];
    [newRequest setValue:[language2 objectForKey:@"idioma2"] forKey:@"language2"];
    [newRequest setValue:[language2 objectForKey:@"nivel_idioma_2"] forKey:@"languageLevel2"];
    
    int tidEspecialidad = [[listings objectForKey:@"tidEspecialidadListado"] intValue];
    NSNumber *tidespecialidad = [NSNumber numberWithInt:tidEspecialidad];
    [newRequest setValue:tidespecialidad forKey:@"tidSpecialtyListing"];
    int tidState = [[listings objectForKey:@"tidEstadoListado"] intValue];
    NSNumber *tidstate = [NSNumber numberWithInt:tidState];
    [newRequest setValue:tidstate forKey:@"tidStateListing"];
    
    [newRequest setValue:[socialMedia objectForKey:@"facebook"] forKey:@"facebook"];
    [newRequest setValue:[socialMedia objectForKey:@"googleplus"] forKey:@"googleplus"];
    [newRequest setValue:[socialMedia objectForKey:@"linkedin"] forKey:@"linkedin"];
    [newRequest setValue:[socialMedia objectForKey:@"twitter"] forKey:@"twitter"];
    
    [newRequest setValue:[userInfoRequestDictionary objectForKey:@"username"] forKey:@"username"];
    [newRequest setValue:[userInfoRequestDictionary objectForKey:@"password"] forKey:@"password"];
    //int user = 2;
    //NSNumber *userNumber = [NSNumber numberWithInt:user];
    NSString *usrnum = [[userInfoRequestDictionary valueForKey:@"uuid"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [newRequest setValue:usrnum forKey:@"usernumber"];
    [newRequest setValue:[userInfoRequestDictionary valueForKey:@"uuid"] forKey:@"requestId"];
    
    
    
    NSError *error;
    [context save:&error];
    //--------------------------
    
    
#pragma mark - Core Data: Users
    NSEntityDescription *entityDescUSer = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    NSManagedObject *newUser = [[NSManagedObject alloc] initWithEntity:entityDescUSer insertIntoManagedObjectContext:context];
    
    [newUser setValue:[userInfoRequestDictionary objectForKey:@"username"] forKey:@"username"];
    [newUser setValue:[userInfoRequestDictionary objectForKey:@"password"] forKey:@"password"];
    [newUser setValue:usrnum forKey:@"usernumber"];
    
    NSError *usrError;
    [context save:&usrError];
    //--------------------------------------
    
#pragma mark - Set new defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"logged"];
    [defaults setObject:[userInfoRequestDictionary objectForKey:@"username"] forKey:@"user_logged"];
    [defaults setObject:usrnum forKey:@"usernum"];
    [defaults synchronize];
    //--------------------------
    
    
    if (userInfoRequestDictionary[@"imagenCedulaFrontal"]) {
        NSLog(@"Esta la img");
        cedulaBool = YES;
        imagenCedulaFrontal = userInfoRequestDictionary[@"imagenCedulaFrontal"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenCedulaFrontal"];
        [cedula setValue:@"images/cedula_frontal.jpg" forKey:@"0"];
    }else{NSLog(@"No esta la imagen");}
    if (userInfoRequestDictionary[@"imagenCedulaTrasera"]) {
        cedulaBool = YES;
        imagenCedulaTrasera = userInfoRequestDictionary[@"imagenCedulaTrasera"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenCedulaTrasera"];
        [cedula setValue:@"images/cedula_trasera.jpg" forKey:@"1"];
    }
    if (userInfoRequestDictionary[@"imagenCredencialFrontal"]) {
        imagenCredencialFrontal = userInfoRequestDictionary[@"imagenCredencialFrontal"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenCredencialFrontal"];
        [credencial setValue:@"images/credencial_frontal.jpg" forKey:@"0"];
    }
    if (userInfoRequestDictionary[@"imagenCredencialTrasera"]) {
        imagenCredencialTrasera = userInfoRequestDictionary[@"imagenCredencialTrasera"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenCredencialTrasera"];
        [credencial setValue:@"images/credencial_trasera" forKey:@"1"];
    }
    if (userInfoRequestDictionary[@"imagenPerfil"]) {
        imagenPerfil = userInfoRequestDictionary[@"imagenPerfil"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenPerfil"];
        [perfil setValue:@"images/imagen_perfil.jpg" forKey:@"0"];
    }
    if (userInfoRequestDictionary[@"imagenGaleria1"]) {
        galeriaBool = YES;
        imagenGaleria1 = userInfoRequestDictionary[@"imagenGaleria1"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenGaleria1"];
        [galeria setValue:@"images/imagen_galeria1.jpg" forKey:@"0"];
    }
    if (userInfoRequestDictionary[@"imagenGaleria2"]) {
        galeriaBool = YES;
        imagenGaleria2 = userInfoRequestDictionary[@"imagenGaleria2"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenGaleria2"];
        [galeria setValue:@"images/imagen_galeria2.jpg" forKey:@"1"];
    }
    if (userInfoRequestDictionary[@"imagenGaleria3"]) {
        galeriaBool = YES;
        imagenGaleria3 = userInfoRequestDictionary[@"imagenGaleria3"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenGaleria3"];
        [galeria setValue:@"images/imagen_galeria3.jpg" forKey:@"2"];
    }
    if (userInfoRequestDictionary[@"imagenGaleria4"]) {
        galeriaBool = YES;
        imagenGaleria4 = userInfoRequestDictionary[@"imagenGaleria4"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenGaleria4"];
        [galeria setValue:@"images/imagen_galeria4.jpg" forKey:@"3"];
    }
    if (userInfoRequestDictionary[@"imagenGaleria5"]) {
        galeriaBool = YES;
        imagenGaleria5 = userInfoRequestDictionary[@"imagenGaleria5"];
        [userInfoRequestDictionary removeObjectForKey:@"imagenGaleria5"];
        [galeria setValue:@"images/imagen_galeria5.jpg" forKey:@"4"];
    }
    
    if (cedulaBool == YES) {
        [userInfoRequestDictionary setValue:cedula forKey:@"cedula"];
    }
    if (galeriaBool == YES) {
        [userInfoRequestDictionary setValue:galeria forKey:@"galeria"];
    }
    [userInfoRequestDictionary setValue:credencial forKey:@"credencial"];
    [userInfoRequestDictionary setValue:perfil forKey:@"imagen_perfil"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:userInfoRequestDictionary options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:nil];
    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    
    self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:@"ws.buscarsalud.com" customHeaderFields:nil];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    //[postParams setValue:cedNumber forKey:@"cedula"];
    [postParams setValue:JSONString forKey:@"allData"];
    
    self.flOperation = [self.flUploadEngine postDataToServer:postParams path:@"upload_info.php"];
    
    if (imagenCedulaFrontal != nil) {
        [self.flOperation addData:imagenCedulaFrontal forKey:@"imagenCedulaFrontal" mimeType:@"image/jpeg" fileName:@"cedula_frontal.jpg"];
    }else{NSLog(@"No tienen nada variable imagenCedulaFrontal");}
    if (imagenCedulaTrasera != nil) {
        [self.flOperation addData:imagenCedulaTrasera forKey:@"imagenCedulaTrasera" mimeType:@"image/jpeg" fileName:@"cedula_trasera.jpg"];
    }else{NSLog(@"No tienen nada variable imagenCedulaTrasera");}
    if (imagenCredencialFrontal != nil) {
        [self.flOperation addData:imagenCredencialFrontal forKey:@"imagenCredencialFrontal" mimeType:@"image/jpeg" fileName:@"credencial_frontal.jpg"];
    }else{NSLog(@"No tienen nada variable imagenCredencialFrontal");}
    if (imagenCredencialTrasera != nil) {
        [self.flOperation addData:imagenCredencialTrasera forKey:@"imagenCredencialTrasera" mimeType:@"image/jpeg" fileName:@"credencial_trasera.jpg"];
    }else{NSLog(@"No tienen nada variable imagenCredencialTrasera");}
    if (imagenPerfil != nil) {
        [self.flOperation addData:imagenPerfil forKey:@"imagenPerfil" mimeType:@"image/jpeg" fileName:@"imagen_perfil.jpg"];
    }else{NSLog(@"No tienen nada variable imagenPerfil");}
    if (imagenGaleria1 != nil) {
        [self.flOperation addData:imagenGaleria1 forKey:@"imagenGaleria1" mimeType:@"image/jpeg" fileName:@"imagen_galeria1.jpg"];
    }else{NSLog(@"No tienen nada variable imagenGaleria1");}
    if (imagenGaleria2 != nil) {
        [self.flOperation addData:imagenGaleria2 forKey:@"imagenGaleria2" mimeType:@"image/jpeg" fileName:@"imagen_galeria2.jpg"];
    }else{NSLog(@"No tienen nada variable imagenGaleria2");}
    if (imagenGaleria3 != nil) {
        [self.flOperation addData:imagenGaleria3 forKey:@"imagenGaleria3" mimeType:@"image/jpeg" fileName:@"imagen_galeria3.jpg"];
    }else{NSLog(@"No tienen nada variable imagenGaleria3");}
    if (imagenGaleria4 != nil) {
        [self.flOperation addData:imagenGaleria4 forKey:@"imagenGaleria4" mimeType:@"image/jpeg" fileName:@"imagen_galeria4.jpg"];
    }else{NSLog(@"No tienen nada variable imagenGaleria4");}
    if (imagenGaleria5 != nil) {
        [self.flOperation addData:imagenGaleria5 forKey:@"imagenGaleria5" mimeType:@"image/jpeg" fileName:@"imagen_galeria5.jpg"];
    }else{NSLog(@"No tienen nada variable imagenGaleria5");}
    
    
    //[self.flOperation addData:imageTwo forKey:@"image2" mimeType:@"image/jpeg" fileName:@"image2.jpg"];
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
        NSLog(@"%@", [operation responseString]);
        [weakSelf finishLoadingBox];
        // This is where you handle a successful 200 response
        
    }
                              errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                  NSLog(@"%@", error);
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:[error localizedDescription]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Dismiss"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }];
    
    [self.flUploadEngine enqueueOperation:self.flOperation ];
    
    
     
}

-(void)handleTextChange:(NSNotification *)notification{
    if ([repeatPasswordTextField.text length] <= 0) {
        passwordsMatchLabel.hidden = YES;
        yesNoLabel.hidden = YES;
    } else{
        passwordsMatchLabel.hidden = NO;
        yesNoLabel.hidden = NO;
    }
    NSLog(@"%@", repeatPasswordTextField.text);
    if ([repeatPasswordTextField.text isEqualToString:passwordTextField.text]) {
        NSLog(@"Passwords Match");
        sendButton.enabled = YES;
        [yesNoLabel setText:@"Sí"];
    }else if(![repeatPasswordTextField.text isEqualToString:passwordTextField.text]){
        NSLog(@"No coinciden!");
        sendButton.enabled = NO;
        [yesNoLabel setText:@"No"];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [passwordTextField resignFirstResponder];
    [repeatPasswordTextField resignFirstResponder];
    [userNameTextField resignFirstResponder];
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
    [self performSegueWithIdentifier:@"accessDataToGreetingsMessage" sender:self];
}

@end
