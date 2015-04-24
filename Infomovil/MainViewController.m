//
//  MainViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "MainViewController.h"
#import "MenuPasosViewController.h"
#import "WS_HandlerLogin.h"
#import "WS_HandlerDominio.h"
#import "CambiarPasswordViewController.h"
#import "FormularioRegistroViewController.h"
#import "NombrarViewController.h"
#import "AppsFlyerTracker.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppboyKit.h"
@import LocalAuthentication;

@interface MainViewController () <FBLoginViewDelegate> {
    BOOL loginExitoso, loginFacebook;
    UITextField *textoEditado;
    BOOL buscandoSesion, existeUnaSesion;
    NSInteger respuestaError;
}

@end

@implementation MainViewController

@synthesize datosUsuario;

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
    [self.vistaInferior setHidden:YES];
    self.datosUsuario = [DatosUsuario sharedInstance];
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"public_profile", @"email"];
    
    
    
    
   
    if(IS_STANDARD_IPHONE_6){
        loginView.frame = CGRectMake(20, 130, 335, 55);
        self.raya1.frame = CGRectMake(20, 220, 155, 2);
        self.o.frame = CGRectMake(178, 212, 40, 20);
        self.raya2.frame = CGRectMake(195, 220, 155, 2);
        
        self.imgLogo.frame = CGRectMake(64, 58, 267, 49);
        [self.scrollLogin addSubview:self.imgLogo];
        [self.scrollLogin setContentSize:CGSizeMake(375, 580)];
        self.txtEmail.frame = CGRectMake(20,250, 335, 47);
        self.txtPassword.frame = CGRectMake(20, 305, 335, 47);
        self.boton.frame = CGRectMake(20, 410, 335, 50);
        self.label.frame = CGRectMake(185,360 ,165, 31);
        self.btnOlvidePass.frame = CGRectMake(190, 364, 170, 31);
        
    }
    //MBC
    else if(IS_STANDARD_IPHONE_6_PLUS){
        loginView.frame = CGRectMake(20, 180, 375, 55);
        self.raya1.frame = CGRectMake(20, 265, 175, 2);
        self.o.frame = CGRectMake(199, 257, 40, 20);
        self.raya2.frame = CGRectMake(215, 265, 175, 2);
        
        [self.scrollLogin setContentSize:CGSizeMake(414, 500)];
        self.txtEmail.frame = CGRectMake(20,300, 375, 47);
        self.txtPassword.frame = CGRectMake(20, 355, 375, 47);
        self.boton.frame = CGRectMake(20, 460, 375, 50);
        
        self.label.frame = CGRectMake(220,411 ,165, 31);
        self.btnOlvidePass.frame = CGRectMake(220, 411, 181, 31);
        
        self.recordarbtn.frame = CGRectMake(8, 411,124, 31);
        self.recordarLogin1.frame = CGRectMake( 20, 411, 22, 22);
        self.imgLogo.frame = CGRectMake(84, 58, 267, 49);
        [self.scrollLogin addSubview:self.imgLogo];
       
    }else if(IS_IPAD){
        loginView.frame = CGRectMake(196, 300, 375, 61);
        
        self.scrollLogin.frame = CGRectMake(0, 0, 768, 1024);
        [self.scrollLogin setContentSize:CGSizeMake(768, 1024)];
        
        self.txtEmail.frame = CGRectMake(196,430, 375, 61);
        [self.txtEmail setBackground:[UIImage imageNamed:@"input_semitrans@1x" ]];
        [self.txtEmail setBackgroundColor:[UIColor clearColor]];
        UIColor *color = [UIColor whiteColor];
        self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mainLabelCorreo", nil) attributes:@{NSForegroundColorAttributeName: color}];
        [self.txtEmail setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        UIImage *lineImg = [UIImage imageNamed:@"line@1x.png"];
        UIImageView * myImageView = [[UIImageView alloc] initWithImage:lineImg];
        CGRect myFrame = CGRectMake(146, 390, 475, 2);
        [myImageView setFrame:myFrame];
        [self.view addSubview:myImageView];
        self.txtPassword.frame = CGRectMake(196, 500, 375, 61);
        [self.txtPassword setBackgroundColor:[UIColor clearColor]];
        [self.txtPassword setBackground:[UIImage imageNamed:@"input_semitrans@1x" ]];
        self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"contrasena", nil) attributes:@{NSForegroundColorAttributeName: color}];
        [self.txtPassword setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        self.label.frame = CGRectMake(390,568 ,165, 31);
        self.btnOlvidePass.frame = CGRectMake(370, 570, 165, 31);
        
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            self.recordarbtn.frame = CGRectMake(210, 570,124, 31);
            [self.recordarbtn.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
            self.recordarLogin1.frame = CGRectMake( 210, 574, 22, 22);
        }else{
            self.recordarbtn.frame = CGRectMake(210, 570, 87, 31);
             [self.recordarbtn.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
            self.recordarLogin1.frame = CGRectMake( 210, 574, 22, 22);
        
        }
        
        self.boton.frame = CGRectMake(202, 640, 362, 48);
        [self.boton.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.boton setBackgroundColor:[UIColor clearColor]];
        self.boton.layer.borderWidth = 1.0f;
        self.boton.layer.cornerRadius = 15.0f;
        self.boton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self mostrarLogo];
        [self.raya1 setHidden:YES];
        [self.raya2 setHidden:YES];
        [self.o setHidden:YES];
        [self.imgLogo setHidden:YES];
    }else{
        loginView.frame = CGRectMake(20, 130, 280, 55);
        [self.scrollLogin setContentSize:CGSizeMake(320, 420)];
    }
    
    for (id obj in loginView.subviews)
    {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage;
            if(IS_STANDARD_IPHONE_6){
                loginButton.frame =CGRectMake(0,0, 335, 55);
                loginImage = [UIImage imageNamed:@"btn_RegistroFacebook_6iPhone.png"];
            }else if (IS_STANDARD_IPHONE_6_PLUS){
                loginButton.frame =CGRectMake(0,0, 375, 55);
                loginImage = [UIImage imageNamed:@"btn_RegistroFacebook_6iphonePlus.png"];
            }else if(IS_IPAD){
                loginButton.frame =CGRectMake(0, 0, 375, 61);
                loginImage = [UIImage imageNamed:@"btn_RegistroFacebook_6iphonePlus.png"];
            
            }else{
                loginButton.frame =CGRectMake(0,0, 280, 55);
                loginImage = [UIImage imageNamed:@"btn_RegistroFacebook.png"];
            }
            
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                loginLabel.text =@"Log In with Facebook";
            }else{
                loginLabel.text =@"Inicia sesión con Facebook";
            }
            loginLabel.textAlignment = NSTextAlignmentCenter;
            
            if(IS_STANDARD_IPHONE_6){
                loginLabel.frame =CGRectMake(15,6, 335, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }else if(IS_STANDARD_IPHONE_6_PLUS){
                loginLabel.frame =CGRectMake(25,6, 375, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            
            }else if(IS_IPAD){
                loginLabel.frame =CGRectMake(10,6, 375, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            }else{
                loginLabel.frame =CGRectMake(15,6, 280, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }
            
        }
        
    }
   
    [self.scrollLogin addSubview:loginView];
    
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:@[self.txtEmail, self.txtPassword]];
    [self.keyboardControls setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.txtEmail.layer.cornerRadius = 15.0f;
    self.txtPassword.layer.cornerRadius = 15.4f;
    
    self.boton.layer.cornerRadius = 12.0f;
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,10,50)];
    leftView.backgroundColor = [UIColor clearColor];
    self.txtEmail.leftView = leftView;
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    self.txtEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel * leftView2 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,10,50)];
    leftView2.backgroundColor = [UIColor clearColor];
    self.txtPassword.leftView = leftView2;
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    
    
    NSUserDefaults *prefsLogin = [NSUserDefaults standardUserDefaults];
    if( [prefsLogin integerForKey:@"intRecordar"] == 1 && ![[prefsLogin stringForKey:@"strRecordarUser"] isEqualToString:@""] && ![[prefsLogin stringForKey:@"strRecordarPass"] isEqualToString:@""]){
       self.txtEmail.text = [prefsLogin stringForKey:@"strRecordarUser"];
       self.txtPassword.text = [prefsLogin stringForKey:@"strRecordarPass"];
       [self.recordarLogin1 setBackgroundImage:[UIImage imageNamed:@"recordarOn.png"] forState:UIControlStateNormal];
    }else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // saving an NSString
        [prefs setObject:@"" forKey:@"strRecordarUser"];
        [prefs setObject:@"" forKey:@"strRecordarPass"];
        // saving an NSInteger
        [prefs setInteger:0 forKey:@"integerKey"];
        [prefs synchronize];
        [self.recordarLogin1 setBackgroundImage:[UIImage imageNamed:@"recordarOff.png"] forState:UIControlStateNormal];
    }
  
    
    
	
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
   
    UIButton *botonRegresar = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPAD){
        [botonRegresar setBackgroundImage:[UIImage imageNamed:@"btn_back_iPad"] forState:UIControlStateNormal];
        [botonRegresar setFrame:CGRectMake(25, 30, 65, 65)];
    }else{
        [botonRegresar setBackgroundImage:[UIImage imageNamed:@"backNuevo.png"] forState:UIControlStateNormal];
        [botonRegresar setFrame:CGRectMake(10, 25, 36, 36)];
    }
    
    [botonRegresar addTarget:self action:@selector(regresarMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:botonRegresar];
	
    [self.recordarbtn setTitle:NSLocalizedString(@"recordarCuenta", nil) forState:UIControlStateNormal]  ;
	self.txtEmail.placeholder = NSLocalizedString(@"mainLabelCorreo", nil);
	self.txtPassword.placeholder = NSLocalizedString(@"contrasena", nil);
	self.label.text = NSLocalizedString(@"mainLabel", nil);
	[self.boton setTitle:NSLocalizedString(@"mainBoton", nil) forState:UIControlStateNormal]  ;
	[self.vistaInferior setHidden:YES];
 
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regresarMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)iniciarSesion:(id)sender {

    if ([CommonUtils validarEmail:self.txtEmail.text] && ![self.txtPassword.text isEqualToString:@""]) {
        if ([CommonUtils hayConexion]) {
            self.datosUsuario.redSocial = @"";
            
            buscandoSesion = YES;
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
        }else{
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        
        
	}else{
		AlertView *alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"incompletos", @" ") andAlertViewType:AlertViewTypeInfo];
		[alert show];
	}
}

- (IBAction)cambiarPassword:(UIButton *)sender {
    CambiarPasswordViewController *cambiaPass = [[CambiarPasswordViewController alloc] initWithNibName:@"CambiarPasswordViewController" bundle:Nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cambiaPass];
    [self.navigationController presentViewController:navController animated:YES completion:Nil];
}


#pragma mark - WS_HandlerProtocol
-(void) resultadoLogin:(NSInteger) idDominio {
    if (idDominio > 0) {
        loginExitoso = YES;
        
        self.datosUsuario = [DatosUsuario sharedInstance];
        // Se guarda la sesion //
        NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
        [prefSesion setObject:self.datosUsuario.auxStrSesionUser forKey:@"strSesionUser"];
        [prefSesion setObject:self.datosUsuario.auxStrSesionPass forKey:@"strSesionPass"];
        [prefSesion setInteger:(long)self.datosUsuario.auxSesionFacebook forKey:@"intSesionFacebook"];
        [prefSesion setInteger:1 forKey:@"intSesionActiva"];
        [prefSesion synchronize];
  
    }
    else {
        respuestaError = idDominio;
        loginExitoso = NO;
         NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
        [prefSesion setInteger:1 forKey:@"intSesionActiva"];
        [prefSesion synchronize];
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        existeUnaSesion = YES;
    }
    else {
        existeUnaSesion = NO;
    }
    [self performSelectorInBackground:@selector(ocultarActivity) withObject:Nil];
}
-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorLogin) withObject:Nil waitUntilDone:YES];
}

-(void) mostrarActivity {
    self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgValidandoUsuario", Nil) andAlertViewType:AlertViewTypeActivity];
    //self.alerta.transform = CGAffineTransformTranslate( _alerta.transform, 20.0, 100.0 );
    [self.alerta show];
}
-(void) ocultarActivity {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (buscandoSesion) {
       
            buscandoSesion = NO;
            [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
        
    }
    else {
    if (loginExitoso) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *launch =  [defaults objectForKey:@"launchingWithOptions"];
        [Appboy startWithApiKey:llaveAppboy
                  inApplication:[UIApplication sharedApplication]
              withLaunchOptions:launch];
        [[Appboy sharedInstance] changeUser:self.txtEmail.text];
        self.datosUsuario.existeLogin = YES;
        
        if (![self.datosUsuario.redSocial isEqualToString:@"Facebook"]) {
            [self.datosUsuario setEmailUsuario:self.txtEmail.text];
        }
        
        [self.datosUsuario setPasswordUsuario:self.txtPassword.text];
       
        
        [[AppsFlyerTracker sharedTracker] setCustomerUserID:self.txtEmail.text];
       
        
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).logueado =YES;
        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
        [self.navigationController pushViewController:menuPasos animated:YES];
    }
    else {
        [self fbDidlogout]; // CErrar sesion de facebook
        NSString *strMensaje;
        switch (respuestaError) {
            case -4:
                strMensaje = NSLocalizedString(@"txtCuentaCancelada", Nil);
                break;
            case -3:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            case -2:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            case 0:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            default:
                strMensaje = NSLocalizedString(@"ocurrioError", Nil);
                break;
        }
        self.datosUsuario.existeLogin = NO;
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:strMensaje dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
    }
        if (self.alerta)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alerta hide];
        }
    }
}

-(void) errorLogin {
        NSLog(@"REGRESO ERROR CONSULTAUSUARIO!!");
        if (self.alerta)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alerta hide];
        }
        [self fbDidlogout];
}

-(void) consultaLogin {
    if (buscandoSesion) {
        WS_HandlerDominio *handlerDominio = [[WS_HandlerDominio alloc] init];
        [handlerDominio setWSHandlerDelegate:self];
        [handlerDominio consultaSession:self.txtEmail.text];
    }
    else {
        [StringUtils deleteResourcesWithExtension:@"jpg"];
        [StringUtils deleteFile];
        NSString *passLogin = @"";
        NSString *emailLogin = @"";
        WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
        [login setLoginDelegate:self];
        if ([self.datosUsuario.redSocial isEqualToString:@"Facebook"]) {
            [login setRedSocial:@"Facebook"];
            passLogin = @" ";
            emailLogin = self.datosUsuario.emailUsuario;
        }else{
            passLogin = self.txtPassword.text;
            emailLogin = self.txtEmail.text;
        }
        
        [login obtieneLogin:emailLogin conPassword:passLogin];
    }
}

#pragma mark - UITextFieldDelegate

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    textoEditado = textField;
    [self.keyboardControls setActiveField:textField];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
}

-(void) apareceElTeclado:(NSNotification*)aNotification {
    NSDictionary *infoNotificacion = [aNotification userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets edgeInsets;
    if(IS_IPHONE_4){
        edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+125, 0);
    }else if(IS_IPHONE_5){
        edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+40, 0);
    }else{
        edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    }
    [[self scrollLogin] setContentInset:edgeInsets];
    [[self scrollLogin] setScrollIndicatorInsets:edgeInsets];
    [[self scrollLogin] scrollRectToVisible:textoEditado.frame animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([self.txtEmail.text length] == 0 && [self.txtPassword.text length] == 0) {
        return NO;
    }
    [textField resignFirstResponder];
    [self iniciarSesion:Nil];
    return YES;
}

-(void) desapareceElTeclado:(NSNotification *)aNotificacion {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
   // CGPoint pt;
   // pt.x = 0;
   // pt.y = 0;
    //[self.scrollLogin setContentOffset:pt animated:YES];
     [[self scrollLogin] setContentInset:UIEdgeInsetsMake(0, 0,0, 0)];
    [UIView commitAnimations];
    
   
   
   
}

#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}

#pragma mark AlertViewDelegate
-(void) accionAceptar2 {
    buscandoSesion = NO;
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
}


#pragma mark - FBLoginViewDelegate
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
#ifdef _DEBUG
    NSLog(@"Entrando a loginView:handleError:");
    NSLog(@"El error de facebook es %@  ***********", [error description]);
#endif
    [[AlertView initWithDelegate:nil message:NSLocalizedString(@"sesionFaceCerrada", nil) andAlertViewType:AlertViewTypeInfo] show];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.datosUsuario.emailUsuario = [user objectForKey:@"email"];
    
#ifdef _DEBUG
    NSLog(@"Entrando a loginViewFetchedUserInfo:user:");
    NSLog(@"el email de facebook es: %@", self.datosUsuario.emailUsuario);
#endif
    self.datosUsuario.redSocial = @"Facebook";
    
    //if (!loginFacebook) {
        loginFacebook = YES;
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
    //}
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
#ifdef _DEBUG
    NSLog(@"Entrando a loginViewShowingLoggedInUser:");
#endif
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
#ifdef _DEBUG
    NSLog(@"Entrando a loginViewShowingLoggedOutUser:");
#endif
}

- (IBAction)recordarLoginAct1:(id)sender {
    [self cambiarStatusRecordar];
}

- (IBAction)recordarLoginAct2:(id)sender {
    [self cambiarStatusRecordar];
}
-(void)cambiarStatusRecordar{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey:@"intRecordar"] == 1){
        [prefs setInteger:0 forKey:@"intRecordar"];
        [prefs synchronize];
        [self.recordarLogin1 setBackgroundImage:[UIImage imageNamed:@"recordarOff.png"] forState:UIControlStateNormal];
    }else{
        [prefs setInteger:1 forKey:@"intRecordar"];
        [prefs synchronize];
        [self.recordarLogin1 setBackgroundImage:[UIImage imageNamed:@"recordarOn.png"] forState:UIControlStateNormal];
    }

}

- (void)fbDidlogout {
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
}

@end
