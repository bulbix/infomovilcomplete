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
#import "MenuRegistroViewController.h"
#import "TerminosCondicionesViewController.h"


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
    [self fbDidlogout];
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
    
    else if(IS_STANDARD_IPHONE_6_PLUS){
        loginView.frame = CGRectMake(20, 180, 375, 55);
        self.raya1.frame = CGRectMake(20, 265, 175, 2);
        self.o.frame = CGRectMake(199, 257, 40, 20);
        self.raya2.frame = CGRectMake(215, 265, 175, 2);
        
        [self.scrollLogin setContentSize:CGSizeMake(414, 500)];
        self.txtEmail.frame = CGRectMake(20,300, 375, 50);
        self.txtPassword.frame = CGRectMake(20, 355, 375, 50);
        self.boton.frame = CGRectMake(20, 460, 375, 50);
        
        self.label.frame = CGRectMake(220,411 ,165, 31);
        self.btnOlvidePass.frame = CGRectMake(220, 411, 181, 31);
        
        self.recordarbtn.frame = CGRectMake(8, 411,124, 31);
        self.recordarLogin1.frame = CGRectMake( 20, 411, 22, 22);
        self.imgLogo.frame = CGRectMake(84, 58, 267, 49);
        [self.scrollLogin addSubview:self.imgLogo];
       
    }else if(IS_IPAD){
        loginView.frame = CGRectMake(196, 300, 375, 50);
        
        self.scrollLogin.frame = CGRectMake(0, 0, 768, 1024);
        [self.scrollLogin setContentSize:CGSizeMake(768, 1024)];
        UIColor *color = [UIColor whiteColor];
        self.txtEmail.frame = CGRectMake(196,430, 375, 61);
        [self.txtEmail setBackground:[UIImage imageNamed:@"input_semitrans@1x" ]];
        [self.txtEmail setBackgroundColor:[UIColor clearColor]];
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
            self.recordarbtn.frame = CGRectMake(210, 570,150, 31);
            [self.recordarbtn.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
            self.recordarLogin1.frame = CGRectMake( 210, 574, 22, 22);
        }else{
            self.recordarbtn.frame = CGRectMake(210, 570, 150, 31);
             [self.recordarbtn.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
            self.recordarLogin1.frame = CGRectMake( 210, 574, 22, 22);
        
        }
        
        self.boton.frame = CGRectMake(202, 640, 362, 50);
        [self.boton.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];

        [self.raya1 setHidden:YES];
        [self.raya2 setHidden:YES];
        [self.o setHidden:YES];
        [self.btnRegistrate setFrame:CGRectMake(196, 800, 375, 50)];
         [self.btnRegistrate.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
         [self.editaTuSitio setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.imgLogo setFrame:CGRectMake(250, 150, 267,50 )];
        [self.editaTuSitio setFrame:CGRectMake(196, 230, 375,33 )];
        [self.editaTuSitio setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
        
    }else if(IS_IPHONE_4){
        self.txtEmail.frame = CGRectMake(16,200, 288, 40);
        self.txtPassword.frame = CGRectMake(16, 240, 288, 40);
        [self.scrollLogin setContentSize:CGSizeMake(320, 420)];
         loginView.frame = CGRectMake(20, 120, 280, 40);
        UIColor *color = [UIColor whiteColor];
        [self.txtPassword setBackgroundColor:[UIColor clearColor]];
        [self.txtPassword setBackground:[UIImage imageNamed:@"input_semitrans@1x" ]];
        self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"contrasena", nil) attributes:@{NSForegroundColorAttributeName: color}];
        [self.txtEmail setBackground:[UIImage imageNamed:@"input_semitrans@1x" ]];
        [self.txtEmail setBackgroundColor:[UIColor clearColor]];
        self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mainLabelCorreo", nil) attributes:@{NSForegroundColorAttributeName: color}];
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            [self.recordarbtn setFrame:CGRectMake(22, 290, 174, 22)];
        }else{
            [self.recordarbtn setFrame:CGRectMake(22, 290, 155, 22)];
        }
        [self.btnRegistrate setFrame:CGRectMake(20, 400, 280, 30)];
        [self.boton setFrame:CGRectMake(20, 340, 280, 40)];
        self.raya1.frame = CGRectMake(20, 180, 122, 2);
        self.o.frame = CGRectMake(153, 172, 17, 21);
        self.raya2.frame = CGRectMake(177, 182, 122, 2);
        self.recordarLogin1.frame = CGRectMake( 20, 290, 22, 22);
        self.btnOlvidePass.frame = CGRectMake(111, 310, 189, 22);
        self.label.frame = CGRectMake(111, 310, 189, 22);
    }else{
        [self.scrollLogin setContentSize:CGSizeMake(320, 420)];
        loginView.frame = CGRectMake(20, 120, 280, 50);
        UIColor *color = [UIColor whiteColor];
        self.txtEmail.frame = CGRectMake(16,211, 288, 55);
        self.txtPassword.frame = CGRectMake(16, 266, 288, 55);
        [self.txtPassword setBackgroundColor:[UIColor clearColor]];
        [self.txtPassword setBackground:[UIImage imageNamed:@"input_semitrans@1x" ]];
        self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"contrasena", nil) attributes:@{NSForegroundColorAttributeName: color}];
        [self.txtEmail setBackground:[UIImage imageNamed:@"input_semitrans@1x" ]];
        [self.txtEmail setBackgroundColor:[UIColor clearColor]];
        self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mainLabelCorreo", nil) attributes:@{NSForegroundColorAttributeName: color}];
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            [self.recordarbtn setFrame:CGRectMake(22, 332, 174, 22)];
        }else{
            [self.recordarbtn setFrame:CGRectMake(22, 332, 155, 22)];
        }
    }
    
    for (id obj in loginView.subviews)
    {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage;
            if(IS_STANDARD_IPHONE_6){
                loginButton.frame =CGRectMake(0,0, 335, 50);
                loginImage = [UIImage imageNamed:@"btn_facebook_335_55.png"];
            }else if (IS_STANDARD_IPHONE_6_PLUS){
                loginButton.frame =CGRectMake(0,0, 375, 50);
                loginImage = [UIImage imageNamed:@"btn_facebook_375x55.png"];
            }else if(IS_IPAD){
                loginButton.frame =CGRectMake(0, 0, 375, 50);
                loginImage = [UIImage imageNamed:@"btn_facebook_375x55.png"];
            
            }else if(IS_IPHONE_4){
                loginButton.frame =CGRectMake(0,0, 280, 40);
                loginImage = [UIImage imageNamed:@"btn_facebook_280x40.png"];
            }else{
                loginButton.frame =CGRectMake(0,0, 280, 50);
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
                loginLabel.text =@"Log In with Facebook";
            }else{
                loginLabel.text =@"Inicia sesión con Facebook";
            }
            loginLabel.textAlignment = NSTextAlignmentCenter;
            
            if(IS_STANDARD_IPHONE_6){
                loginLabel.frame =CGRectMake(0,0, 335, 50);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }else if(IS_STANDARD_IPHONE_6_PLUS){
                loginLabel.frame =CGRectMake(0,0, 375, 50);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            
            }else if(IS_IPAD){
                loginLabel.frame =CGRectMake(0,0, 375, 50);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            }else if(IS_IPHONE_4){
                loginLabel.frame =CGRectMake(0,0, 280, 40);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }else{
                loginLabel.frame =CGRectMake(0,0, 280, 50);
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
  
    [self.recordarbtn setTitle:NSLocalizedString(@"recordarCuenta", nil) forState:UIControlStateNormal]  ;
	self.txtEmail.placeholder = NSLocalizedString(@"mainLabelCorreo", nil);
	self.txtPassword.placeholder = NSLocalizedString(@"contrasena", nil);
	self.label.text = NSLocalizedString(@"mainLabel", nil);
	[self.boton setTitle:NSLocalizedString(@"mainBoton", nil) forState:UIControlStateNormal]  ;
    [self.btnRegistrate setTitle:NSLocalizedString(@"cuentaTodavia",nil) forState:UIControlStateNormal];
    self.editaTuSitio.text = NSLocalizedString(@"editaTuSitio",nil);
    [self.vistaInferior setHidden:YES];
    self.boton.layer.cornerRadius = 10.0f;
    self.boton.layer.borderWidth = 1.0f;
    self.boton.layer.borderColor = [UIColor whiteColor].CGColor;
 
    
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
            self.leyenda1.frame = CGRectMake(47, 440, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 457, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 458, 144, 21);
            self.leyenda2.frame = CGRectMake(217, 441, 80, 21);
            self.leyenda5.frame = CGRectMake(190,457, 83, 21);
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
            self.leyenda1.frame = CGRectMake(10, 440, 200, 21);
            self.leyenda3.frame = CGRectMake(35, 457, 28, 21);
            self.leyenda4.frame = CGRectMake(60, 458, 144, 21);
            self.leyenda2.frame = CGRectMake(160, 441, 170, 21);
            self.leyenda5.frame = CGRectMake(197,457, 83, 21);
        }else{
            
            
            self.leyenda1.frame = CGRectMake(6, 510, 152, 21);
            self.leyenda2.frame = CGRectMake(160, 511, 152, 21);
            self.leyenda3.frame = CGRectMake(37, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda5.frame = CGRectMake(202,532, 83, 21);
        }
    }

    self.leyenda1.text = NSLocalizedString(@"inicioLeyenda1", nil);
    [self.leyenda2 setTitle:NSLocalizedString(@"inicioLeyenda2", nil) forState:UIControlStateNormal] ;
    self.leyenda3.text = NSLocalizedString(@"inicioLeyenda3", nil);
    [self.leyenda4 setTitle:NSLocalizedString(@"inicioLeyenda4", nil) forState:UIControlStateNormal] ;
    self.leyenda5.text = NSLocalizedString(@"inicioLeyenda5", nil);
    
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
            case -3:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            case -2:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            default:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
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

- (IBAction)irARegistrate:(id)sender {
    
    MenuRegistroViewController *registro = [[MenuRegistroViewController alloc] initWithNibName:@"MenuRegistroViewController" bundle:nil];
    [self.navigationController pushViewController:registro animated:YES];
}

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
