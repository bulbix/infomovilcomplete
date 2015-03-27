//
//  MenuRegistroViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 12/02/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//
#import "FormularioRegistroViewController.h"
#import "NombrarViewController.h"
#import "WS_HandlerUsuario.h"
#import "SelectorPaisViewController.h"
#import "WS_HandlerDominio.h"
#import "MenuPasosViewController.h"
#import "AppsFlyerTracker.h"
#import "WS_HandlerLogin.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MenuRegistroViewController.h"
@interface MenuRegistroViewController () <FBLoginViewDelegate> {
    UITextField *textoSeleccionado;
    BOOL exito, loginFacebook, loginExitoso;
    BOOL existeUsuario;
    BOOL seleccionoPais;
    
    NSInteger operacionWS;
    NSInteger idDominio, respuestaError;
    
    NSString * Pais;
    NSString * codPais;
    
    NSString * nombre;
    NSString * password;
    NSString * codPromocion;
    
}
@property (nonatomic, strong) AlertView *alerta;
@end

@implementation MenuRegistroViewController

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
    
    [self mostrarLogo];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"public_profile", @"email"];
    if(IS_STANDARD_IPHONE_6){
        loginView.frame = CGRectMake(20, 130, 335, 55);
        self.raya1.frame = CGRectMake(20, 224, 155, 2);
        self.o.frame = CGRectMake(178, 216, 155, 20);
        self.raya2.frame = CGRectMake(195, 224, 155, 2);
        self.llamarCrearCuenta.frame = CGRectMake(20, 276, 331, 51);
  
    }else if(IS_STANDARD_IPHONE_6_PLUS){
            loginView.frame = CGRectMake(20, 180, 375, 55);
            self.raya1.frame = CGRectMake(20, 280, 175, 2);
            self.o.frame = CGRectMake(199, 272, 40, 20);
            self.raya2.frame = CGRectMake(215, 280, 175, 2);
        
            self.llamarCrearCuenta.frame = CGRectMake(21, 326, 365, 47);
            self.msjRegistrarConFacebook.frame = CGRectMake(24, 426, 371, 80);
        
    }else if(IS_IPAD){
        loginView.frame = CGRectMake(196, 520, 375, 55);
        UIImage *lineImg = [UIImage imageNamed:@"line@1x.png"];
        UIImageView * myImageView = [[UIImageView alloc] initWithImage:lineImg];
        CGRect myFrame = CGRectMake(146, 600, 475, 2);
        [myImageView setFrame:myFrame];
        [self.view addSubview:myImageView];
        
        self.llamarCrearCuenta.frame = CGRectMake(204, 626, 360, 50);
        [self.llamarCrearCuenta.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        self.msjRegistrarConFacebook.frame = CGRectMake(184, 800, 400, 160);
        [self.msjRegistrarConFacebook setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.raya1 setHidden:YES];
        [self.o setHidden:YES];
        [self.raya2 setHidden:YES];
        
        self.slogan.frame = CGRectMake(100, 340, 568, 97);
        self.slogan.text = NSLocalizedString(@"inicioLabel", nil);
        [self.slogan setFont:[UIFont fontWithName:@"Avenir-Book" size:30]];
        
    }else{
        loginView.frame = CGRectMake(20, 130, 280, 55);
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
                loginButton.frame =CGRectMake(0,0, 375, 55);
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
                loginLabel.text =@"Log in using Facebook";
            }else{
                loginLabel.text =@"Regístrate usando Facebook";
            }
            loginLabel.textAlignment = NSTextAlignmentCenter;
            if(IS_STANDARD_IPHONE_6){
                loginLabel.frame =CGRectMake(15,6, 335, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }else if(IS_STANDARD_IPHONE_6_PLUS){
                loginLabel.frame =CGRectMake(25,6, 375, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }else if(IS_IPAD){
                loginLabel.frame =CGRectMake(15,6, 375, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            }else{
                loginLabel.frame =CGRectMake(15,6, 280, 45);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }
            
        }
        
    }
    
    [self.view addSubview:loginView];
   
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"FormularioViewController"
           value:@"Home Screen"];
    
    self.navigationItem.rightBarButtonItem = Nil;
    [self.scrollView setContentSize:CGSizeMake(320, 380)];
    exito = NO;
    self.datosUsuario = [DatosUsuario sharedInstance];
    productTourView = [[CRProductTour alloc] initWithFrame:self.view.frame];
    CRBubble *bubbleButton1;
   
    NSMutableArray *bubbleArray = [[NSMutableArray alloc] initWithObjects:bubbleButton1, /*bubbleButton2,*/ nil];
    
    [productTourView setBubbles:bubbleArray];
    
    [self.view addSubview:productTourView];
    
    self.llamarCrearCuenta.layer.borderWidth = 1.0f;
    self.llamarCrearCuenta.layer.cornerRadius = 15.0f;
    self.llamarCrearCuenta.layer.borderColor = [UIColor whiteColor].CGColor;
   
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    
    [self.llamarCrearCuenta setTitle:NSLocalizedString(@"crearCuentaRegistrar", nil) forState:UIControlStateNormal]  ;
    self.msjRegistrarConFacebook.text = NSLocalizedString(@"msjRegistrarUsuarioFB", nil);
    
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
    
   
    [self.boton setTitle:NSLocalizedString(@"mainBoton", nil) forState:UIControlStateNormal]  ;
    
    [self.vistaInferior setHidden:YES];
    
}
// Boton de regresar //
-(IBAction)regresarMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textoSeleccionado = textField;
    NSInteger textoLength = [textField.text length];
    [self.labelInfo setText:[NSString stringWithFormat:@"%i/%i", textoLength, 255]];
    [UIView animateWithDuration:0.4f animations:^{
        [self.labelInfo setFrame:CGRectMake(284, textField.frame.origin.y + textField.frame.size.height, 33, 21)];
    }];
    
    
    [self.keyboardControls setActiveField:textField];
    [self apareceElTeclado];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4f animations:^{
        [self.labelInfo setFrame:CGRectMake(284, 600, 33, 21)];
    }];
    
    [self desapareceElTeclado];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.modifico = YES;
    NSInteger maxLength = 255;
    NSInteger textoLength = [textField.text length];
    if (textoLength < maxLength) {
        if ([string isEqualToString:@"<"] && [string isEqualToString:@">"]) {
            return NO;
        }
        else {
            if ([string isEqualToString:@""]) {
                [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength-1, (long)maxLength]];
            }
            else {
                [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength+1, (long)maxLength]];
            }
            return YES;
        }
    }
    else {
        if ([string isEqualToString:@""]) {
            [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength-1, (long)maxLength]];
            return YES;
        }
        return NO;
    }
}

-(IBAction)guardarInformacion:(id)sender {
    [[self view] endEditing:YES];
    
        self.datosUsuario = [DatosUsuario sharedInstance];
        //Descomentar esto es para que realize las peticiones al servidor
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(checaNombre) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        
    
}

-(void) accionAceptar {
    if (exito) {
        NombrarViewController *nombrar = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:Nil];
        [self.navigationController pushViewController:nombrar animated:YES];
    }
    
}

-(void) accionSi {
    if (self.modifico) {
      
    }
}

-(void) accionNo {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) apareceElTeclado:(NSNotification*)aNotification {
    NSDictionary *infoNotificacion = [aNotification userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+15, 0);
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [[self scrollView] scrollRectToVisible:textoSeleccionado.frame animated:YES];
    
}
-(void) desapareceElTeclado:(NSNotification *)aNotificacion {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

-(void) apareceElTeclado{
    CGSize tamanioTeclado = CGSizeMake(320, 260);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+15, 0);
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [[self scrollView] scrollRectToVisible:textoSeleccionado.frame animated:YES];
}
-(void) desapareceElTeclado{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) mostrarActivity {
    self.alerta = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"cargando", @" ") message:Nil dominio:Nil andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}

-(void) checaNombre {
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
    operacionWS = 1;
    WS_HandlerUsuario *handlerUsuario = [[WS_HandlerUsuario alloc] init];
    [handlerUsuario setWsHandlerDelegate:self];
    [handlerUsuario consultaUsuario:nombre];
    
}

-(void) crearDominio {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
    operacionWS = 2;
    WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
    [dominioHandler setWSHandlerDelegate:self];
    codPromocion = codPromocion == nil?@"":codPromocion;
    codPromocion = [NSString trim:codPromocion];
    [dominioHandler crearUsuario:nombre conNombre:@"" password:password status:@"9" nombre:nil direccion1:nil direccion2:nil pais:nil codigoPromocion:codPromocion tipoDominio:dominioTipo idDominio:@""];
}

-(void) ocultarActivity {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    if (existeUsuario) {
        
        
        if (idDominio == 0) {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"errorCrearDominio", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }else{
            
            [[AppsFlyerTracker sharedTracker] setCustomerUserID:self.datosUsuario.emailUsuario];
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Registro Usuario" withValue:@""];
           
            // IRC APPBOY //
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *launch =  [defaults objectForKey:@"launchingWithOptions"];
            [Appboy startWithApiKey:llaveAppboy
                      inApplication:[UIApplication sharedApplication]
                  withLaunchOptions:launch];
             [[Appboy sharedInstance] changeUser:self.datosUsuario.emailUsuario];
           // [self enviarEventoGAconCategoria:@"Registrar" yEtiqueta:@"Usuario"];
            // IRC Dominio
            ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = YES;
            MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
            [self.navigationController pushViewController:menuPasos animated:YES];
        }
        
        
    }
    else {
        FBSession* session = [FBSession activeSession];
        [session closeAndClearTokenInformation];
        [session close];
        [FBSession setActiveSession:nil];
        exito = NO;
        AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"errorEmail", Nil) message:NSLocalizedString(@"emailAsociado", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
        
        
    }
    
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if(operacionWS == 1){
        if ([resultado isEqualToString:@"No existe"]) {
            existeUsuario = YES;
            [self crearDominio];
        }
        else {
            existeUsuario = NO;
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
    }else{
        DatosUsuario *datos = [DatosUsuario sharedInstance];
        idDominio = datos.idDominio;
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        
    }
}

-(void) resultadoLogin:(NSInteger) idDominioLogin {
    if (idDominioLogin > 0) {
        loginExitoso = YES;
        idDominio = idDominioLogin;
        existeUsuario = YES;
        self.datosUsuario.redSocial = @"Facebook";
    }
    else {
        respuestaError = idDominioLogin;
        loginExitoso = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorToken {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    self.alerta = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alerta show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sessionTimeout
{
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    self.alerta = [AlertView initWithDelegate:Nil
                                      message:NSLocalizedString(@"sessionCaduco", Nil)
                             andAlertViewType:AlertViewTypeInfo];
    [self.alerta show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorConsultaUsuario) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaUsuario {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
   // [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}



#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}


#pragma mark - FBLoginViewDelegate
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
#ifdef _DEBUG
    NSLog(@"Entrando a loginView:handleError:");
    NSLog(@"El error es %@  ***********", [error description]);
#endif
    [[AlertView initWithDelegate:nil message:@"Sesión cerrada" andAlertViewType:AlertViewTypeInfo] show];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.datosUsuario.emailUsuario = [user objectForKey:@"email"];
    
#ifdef _DEBUG
    NSLog(@"Entrando a loginViewFetchedUserInfo:user:");
    NSLog(@"el email es %@", self.datosUsuario.emailUsuario);
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

-(void) consultaLogin {
    WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
    [login setLoginDelegate:self];
    [login setRedSocial:@"Facebook"];
    [login obtieneLogin:self.datosUsuario.emailUsuario conPassword:@" "];
}

- (IBAction)llamarCrearCuentaAct:(id)sender{
    FormularioRegistroViewController *registro = [[FormularioRegistroViewController alloc] initWithNibName:@"FormularioRegistroViewController" bundle:nil];
    [self.navigationController pushViewController:registro animated:YES];
}

@end

