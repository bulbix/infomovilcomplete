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
    loginView.frame = CGRectMake(20, 130, 280, 55);
    
    for (id obj in loginView.subviews)
    {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            loginButton.frame =CGRectMake(0,0, 280, 55);
            UIImage *loginImage = [UIImage imageNamed:@"btn_RegistroFacebook"];
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
            loginLabel.frame =CGRectMake(15,6, 280, 45);
            [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
        }
        
    }
    
    
    [self.scrollLogin addSubview:loginView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.scrollLogin setContentSize:CGSizeMake(320, 420)];
    
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:@[self.txtEmail, self.txtPassword]];
    [self.keyboardControls setDelegate:self];
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
    [botonRegresar setBackgroundImage:[UIImage imageNamed:@"backNuevo.png"] forState:UIControlStateNormal];
    [botonRegresar setFrame:CGRectMake(10, 25, 36, 36)];
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
    }
    else {
        respuestaError = idDominio;
        loginExitoso = NO;
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
    [self.alerta show];
}
-(void) ocultarActivity {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (buscandoSesion) {
       
            buscandoSesion = NO;
            [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
        
    }
    else {
    if (loginExitoso) {  NSLog(@"ENTRO A LOGIN EXITOSO");
        [[Appboy sharedInstance] changeUser:self.txtEmail.text];
        self.datosUsuario.existeLogin = YES;
        if (![self.datosUsuario.redSocial isEqualToString:@"Facebook"]) {
            [self.datosUsuario setEmailUsuario:self.txtEmail.text];
        }
        
        [self.datosUsuario setPasswordUsuario:self.txtPassword.text];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion = YES;
        
        [[AppsFlyerTracker sharedTracker] setCustomerUserID:self.txtEmail.text];
       
        
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).logueado =YES;
        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
        [self.navigationController pushViewController:menuPasos animated:YES];
    }
    else {
        FBSession* session = [FBSession activeSession];
        [session closeAndClearTokenInformation];
        [session close];
        [FBSession setActiveSession:nil];
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
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"errorSimple", nil) andAlertViewType:AlertViewTypeInfo] show];
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
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
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
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollLogin] setContentInset:edgeInsets];
    [[self scrollLogin] setScrollIndicatorInsets:edgeInsets];
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
    
    if (!loginFacebook) {
        loginFacebook = YES;
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
    }
    
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
        NSLog(@"NO recordar!!");
        [prefs setInteger:0 forKey:@"intRecordar"];
        [prefs synchronize];
        [self.recordarLogin1 setBackgroundImage:[UIImage imageNamed:@"recordarOff.png"] forState:UIControlStateNormal];
    }else{
        NSLog(@"SI recordar!!");
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
}

@end
