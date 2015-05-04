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
#import "MainViewController.h"
#import "TerminosCondicionesViewController.h"

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
    exito = NO;
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
    exito = NO;
    self.datosUsuario = [DatosUsuario sharedInstance];
    productTourView = [[CRProductTour alloc] initWithFrame:self.view.frame];
    CRBubble *bubbleButton1;
   
    NSMutableArray *bubbleArray = [[NSMutableArray alloc] initWithObjects:bubbleButton1, /*bubbleButton2,*/ nil];
    [productTourView setBubbles:bubbleArray];
    [self.view addSubview:productTourView];
    
    NSArray *fields = @[self.txtNombre, self.txtContrasena, self.txtContrasenaConfirmar];
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    [self.keyboardControls setDelegate:self];
    [self.vistaInferior setHidden:YES];
    
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        bubbleButton1 = [[CRBubble alloc] initWithAttachedView:_txtContrasena title:@" Password" description:@"Must be 8 or more characters\n(letters and numbers)\nCan not contain the word infomovil" arrowPosition:CRArrowPositionBottom andColor:[UIColor whiteColor]];
    }else{
        bubbleButton1 = [[CRBubble alloc] initWithAttachedView:_txtContrasena title:@"Contraseña" description:@"Debe tener de 8 a 15 caracteres\n(letras y números)\nNo puede contener la palabra infomovil\nNo puede ser igual al correo" arrowPosition:CRArrowPositionBottom andColor:[UIColor whiteColor]];
    }
    
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        
        if(IS_STANDARD_IPHONE_6){
            self.leyenda1.frame = CGRectMake(47, 510, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(90, 533, 144, 21);
            self.leyenda2.frame = CGRectMake(190, 511, 80, 21);
            self.leyenda5.frame = CGRectMake(190,532, 83, 21);
        }else if(IS_IPAD){
            [self.leyenda1 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda2.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda3 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda4.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda5 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            
            self.leyenda1.frame = CGRectMake(240, 896, 250, 25);
            self.leyenda2.frame = CGRectMake(475, 897, 80, 25);
            self.leyenda3.frame = CGRectMake(230, 930, 40, 25);
            self.leyenda4.frame = CGRectMake(255, 930, 200, 25);
            self.leyenda5.frame = CGRectMake(385,930, 150, 25);
            
        }else if(IS_IPHONE_4){
            self.leyenda1.frame = CGRectMake(47, 410, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 432, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 433, 144, 21);
            self.leyenda2.frame = CGRectMake(217, 411, 80, 21);
            self.leyenda5.frame = CGRectMake(190,432, 83, 21);
        }else{
            self.leyenda1.frame = CGRectMake(47, 510, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda2.frame = CGRectMake(217, 511, 80, 21);
            self.leyenda5.frame = CGRectMake(190,532, 83, 21);
            
        }
        
    }else{
        
        if(IS_STANDARD_IPHONE_6){
            self.leyenda1.frame = CGRectMake(6, 510, 152, 21);
            self.leyenda2.frame = CGRectMake(160, 511, 152, 21);
            self.leyenda3.frame = CGRectMake(37, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda5.frame = CGRectMake(202,532, 83, 21);
        }else if(IS_IPAD){
            [self.leyenda1 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda2.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda3 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda4.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda5 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            
            self.leyenda1.frame = CGRectMake(190, 897, 210, 25);
            self.leyenda2.frame = CGRectMake(376, 898, 240, 25);
            self.leyenda3.frame = CGRectMake(214, 931, 40, 25);
            self.leyenda4.frame = CGRectMake(246, 932, 200, 25);
            self.leyenda5.frame = CGRectMake(385,931, 150, 25);
            
        }else if(IS_IPHONE_4){
            self.leyenda1.frame = CGRectMake(6, 410, 152, 21);
            self.leyenda2.frame = CGRectMake(160, 411, 152, 21);
            self.leyenda3.frame = CGRectMake(37, 432, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 433, 144, 21);
            self.leyenda5.frame = CGRectMake(202,432, 83, 21);
        }else{
            
            
            self.leyenda1.frame = CGRectMake(6, 510, 152, 21);
            self.leyenda2.frame = CGRectMake(160, 511, 152, 21);
            self.leyenda3.frame = CGRectMake(37, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda5.frame = CGRectMake(202,532, 83, 21);
        }
    }
    
    if(IS_IPHONE_4){
        [self.scrollView setContentSize:CGSizeMake(320, 420)];
    }else if(IS_IPHONE_5){
        [self.scrollView setContentSize:CGSizeMake(320, 480)];
    }else if(IS_STANDARD_IPHONE_6){
    
    }else if(IS_STANDARD_IPHONE_6_PLUS){
    
    }else if(IS_IPAD){
    
    }
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *color = [UIColor whiteColor];
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"public_profile", @"email"];
    if(IS_STANDARD_IPHONE_6){
        loginView.frame = CGRectMake(20, 130, 335, 50);
        self.raya1.frame = CGRectMake(20, 224, 155, 2);
        self.o.frame = CGRectMake(178, 216, 155, 20);
        self.raya2.frame = CGRectMake(195, 224, 155, 2);
        self.msjRegistrarConFacebook.frame = CGRectMake(20, 400, 335, 100);
    }else if(IS_STANDARD_IPHONE_6_PLUS){
        loginView.frame = CGRectMake(20, 180, 375, 50);
        self.raya1.frame = CGRectMake(20, 280, 175, 2);
        self.o.frame = CGRectMake(199, 272, 40, 20);
        self.raya2.frame = CGRectMake(215, 280, 175, 2);
        self.msjRegistrarConFacebook.frame = CGRectMake(24, 426, 371, 80);
    }else if(IS_IPAD){
        loginView.frame = CGRectMake(196, 520, 375, 61);
        UIImage *lineImg = [UIImage imageNamed:@"line@1x.png"];
        UIImageView * myImageView = [[UIImageView alloc] initWithImage:lineImg];
        CGRect myFrame = CGRectMake(146, 600, 475, 2);
        [myImageView setFrame:myFrame];
        [self.view addSubview:myImageView];
        self.msjRegistrarConFacebook.frame = CGRectMake(184, 800, 400, 160);
        [self.msjRegistrarConFacebook setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.raya1 setHidden:YES];
        [self.o setHidden:YES];
        [self.raya2 setHidden:YES];
    }else if(IS_IPHONE_4){
        loginView.frame = CGRectMake(20, 130, 280, 50);
        
    }else{
        loginView.frame = CGRectMake(20, 130, 280, 50);
    }
    
    for (id obj in loginView.subviews)
    {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage;
            if(IS_STANDARD_IPHONE_6){
                loginButton.frame =CGRectMake(0,0, 335, 55);
                loginImage = [UIImage imageNamed:@"btn_facebook_335_55.png"];
            }else if (IS_STANDARD_IPHONE_6_PLUS){
                loginButton.frame =CGRectMake(0,0, 375, 55);
                loginImage = [UIImage imageNamed:@"btn_facebook_375x55.png"];
            }else if(IS_IPAD){
                loginButton.frame =CGRectMake(0,0, 375, 55);
                loginImage = [UIImage imageNamed:@"btn_facebook_375x61.png"];
                
            }else{
                loginButton.frame =CGRectMake(0,0, 280, 55);
                loginImage = [UIImage imageNamed:@"btn_facebook_280x55.png"];
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
                loginLabel.frame =CGRectMake(0,0, 280, 50);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }
            
        }
        
    }
    
    [self.scrollView addSubview:loginView];
   
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
    [self.vistaInferior setHidden:YES];
    self.btnRegistrar.layer.cornerRadius = 10.0f;
    self.btnRegistrar.layer.borderWidth = 1.0f;
    self.btnRegistrar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtContrasena.layer.borderWidth = 1.0f;
    self.txtContrasena.layer.cornerRadius = 10.0f;
    self.txtContrasena.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"contrasenaRegistrar", nil) attributes:@{NSForegroundColorAttributeName: color}];
    [self.txtContrasena setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
    self.txtContrasenaConfirmar.layer.borderWidth = 1.0f;
    self.txtContrasenaConfirmar.layer.cornerRadius = 10.0f;
    self.txtContrasenaConfirmar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtContrasenaConfirmar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"confirmarContrasena", nil) attributes:@{NSForegroundColorAttributeName: color}];
    [self.txtContrasenaConfirmar setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
    self.txtNombre.layer.borderWidth = 1.0f;
    self.txtNombre.layer.cornerRadius = 10.0f;
    self.txtNombre.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtNombre.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" info@infomovil.com" attributes:@{NSForegroundColorAttributeName: color}];
    [self.txtNombre setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
    
  
    self.leyenda1.text = NSLocalizedString(@"inicioLeyenda1", nil);
    [self.leyenda2 setTitle:NSLocalizedString(@"inicioLeyenda2", nil) forState:UIControlStateNormal] ;
    self.leyenda3.text = NSLocalizedString(@"inicioLeyenda3", nil);
    [self.leyenda4 setTitle:NSLocalizedString(@"inicioLeyenda4", nil) forState:UIControlStateNormal] ;
    self.leyenda5.text = NSLocalizedString(@"inicioLeyenda5", nil);
    
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
/*
-(void) accionSi {

    if (self.modifico) {
        if ((self.txtNombre.text.length) > 0  && (self.txtContrasena.text.length > 0)) {
            exito = YES;
            self.datosUsuario = [DatosUsuario sharedInstance];
            self.datosUsuario.emailUsuario = [self.txtNombre text];
            self.datosUsuario.passwordUsuario = [self.txtContrasena text];
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"felicidades", @" ") message:NSLocalizedString(@"nombrarSitio", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"llenarCampos", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
}

*/


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
    NSLog(@"ENTRO AL METODO CHECANOMBRE");
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
    operacionWS = 1;
    WS_HandlerUsuario *handlerUsuario = [[WS_HandlerUsuario alloc] init];
    [handlerUsuario setWsHandlerDelegate:self];
    [handlerUsuario consultaUsuario:nombre];
    
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
            [self enviarEventoGAconCategoria:@"Registrar" yEtiqueta:@"Usuario"];
            // IRC Dominio
            ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
            
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
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}



-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorConsultaUsuario) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaUsuario {
    NSLog(@"REGRESO ERROR CONSULTAUSUARIO!!");
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    [self fbDidlogout];
   // [self viewWillAppear:YES];
    //[self.view setNeedsDisplay];
    
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
    NSLog(@"ENTRO DOS VECES ");
#ifdef _DEBUG
    NSLog(@"Entrando a loginViewFetchedUserInfo:user:");
    NSLog(@"el email es %@", self.datosUsuario.emailUsuario);
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

-(void) consultaLogin {
    NSLog(@"ENTRO A CONSULTA LOGIN");
    WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
    [login setLoginDelegate:self];
    [login setRedSocial:@"Facebook"];
    [login obtieneLogin:self.datosUsuario.emailUsuario conPassword:@" "];
}
/*
- (IBAction)llamarCrearCuentaAct:(id)sender{
    NSLog(@"SE LLAMO A LLAMARCREARCUENTAACT");
    FormularioRegistroViewController *registro = [[FormularioRegistroViewController alloc] initWithNibName:@"FormularioRegistroViewController" bundle:nil];
    [self.navigationController pushViewController:registro animated:YES];
}
*/

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


-(BOOL) validaCampos {
    if ((self.txtNombre.text.length) > 0 && (self.txtContrasena.text.length > 0) ){
        if (![CommonUtils validarEmail:self.txtNombre.text]) {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"emailIncorrecto", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            return NO;
        }
        
        if (![CommonUtils validarContrasena:self.txtNombre.text contrasena:self.txtContrasena.text]) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorPassword", Nil) andAlertViewType:AlertViewTypeInfo];
            [alert show];
            return NO;
        }
        if(![self.txtContrasena.text isEqualToString:self.txtContrasenaConfirmar.text]){
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"formularioPassword", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            return NO;
        }
        
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"llenarCampos", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
        return NO;
    }
    return YES;
}


- (IBAction)verificarNombre:(UIButton *)sender {
    if ([self validaCampos]) {
        nombre = self.txtNombre.text;
        password = self.txtContrasena.text;
        if ([codPromocion length] > 0 && ![CommonUtils validaCodigoRedimir:codPromocion]) {
            [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"txtErrorCodigo", nil) andAlertViewType:AlertViewTypeInfo] show];
        }
        
        else {
            
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
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag < 3){
        NSInteger nextTag = textField.tag + 1;
        // Try to find next responder
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder) {
            // Found next responder, so set it.
            [nextResponder becomeFirstResponder];
        }
    }
    else if (textField.tag == 3 && [self validaCampos]) {
        
        nombre = self.txtNombre.text;
        password = self.txtContrasena.text;
        
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
    [textField resignFirstResponder];
    return YES;
}


//////////////////////////////////////////// ESTO ES DEL FORMULARIO /////////////////////


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



-(void) crearDominio {
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
    operacionWS = 2;
    WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
    [dominioHandler setWSHandlerDelegate:self];
    codPromocion = codPromocion == nil?@"":codPromocion;
    codPromocion = [NSString trim:codPromocion];
    [dominioHandler crearUsuario:nombre conNombre:@"" password:password status:@"9" nombre:nil direccion1:nil direccion2:nil pais:nil codigoPromocion:codPromocion tipoDominio:dominioTipo idDominio:@""];
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.datosUsuario.tipoDeUsuario = @"normal";
    
}
/*
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
            [[AppsFlyerTracker sharedTracker] setCustomerUserID:self.txtNombre.text];
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Registro Usuario" withValue:@""];
            // IRC APPBOY //
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *launch =  [defaults objectForKey:@"launchingWithOptions"];
            [Appboy startWithApiKey:llaveAppboy
                      inApplication:[UIApplication sharedApplication]
                  withLaunchOptions:launch];
            [[Appboy sharedInstance] changeUser:self.txtNombre.text];
            
            
            [self enviarEventoGAconCategoria:@"Registrar" yEtiqueta:@"Usuario"];
            // IRC Dominio
            ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
            
            MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
            [self.navigationController pushViewController:menuPasos animated:YES];
        }
    }
    else {
        exito = NO;
        AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"errorEmail", Nil) message:NSLocalizedString(@"emailAsociado", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}
*/




- (IBAction)mostrarTerminos:(id)sender {
    TerminosCondicionesViewController *terminosCondiciones = [[TerminosCondicionesViewController alloc] initWithNibName:@"TerminosCondicionesViewController" bundle:Nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:terminosCondiciones];
    [terminosCondiciones setIndex:0];
    [self.navigationController presentViewController:navController animated:YES completion:Nil];
}

- (IBAction)mostrarCondiciones:(id)sender {
    TerminosCondicionesViewController *terminosCondiciones = [[TerminosCondicionesViewController alloc] initWithNibName:@"TerminosCondicionesViewController" bundle:Nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:terminosCondiciones];
    [terminosCondiciones setIndex:1];
    [self.navigationController presentViewController:navController animated:YES completion:Nil];
}
@end

