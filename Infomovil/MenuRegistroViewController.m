//
//  MenuRegistroViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 12/02/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

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
        loginFacebook = YES;
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
    [tracker set:@"MenuRegistroViewController"
           value:@"Home Screen"];
  
    self.navigationItem.rightBarButtonItem = Nil;
    exito = NO;
    self.datosUsuario = [DatosUsuario sharedInstance];
   
    NSArray *fields = @[self.txtNombre, self.txtContrasena, self.txtContrasenaConfirmar];
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    [self.keyboardControls setDelegate:self];
    [self.vistaInferior setHidden:YES];
    
    
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            self.leyenda1.frame = CGRectMake(77, 600, 200, 21);
            self.leyenda3.frame = CGRectMake(75, 622, 28, 21);
            self.leyenda4.frame = CGRectMake(93, 623, 144, 21);
            self.leyenda2.frame = CGRectMake(245, 601, 80, 21);
            self.leyenda5.frame = CGRectMake(220,622, 83, 21);
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
        /*}else if(IS_STANDARD_IPHONE_6_PLUS){
            self.leyenda1.frame = CGRectMake(77, 670, 200, 21);
            self.leyenda3.frame = CGRectMake(75, 692, 28, 21);
            self.leyenda4.frame = CGRectMake(93, 693, 144, 21);
            self.leyenda2.frame = CGRectMake(245, 671, 80, 21);
            self.leyenda5.frame = CGRectMake(220,692, 83, 21);
        */
         }else{
            self.leyenda1.frame = CGRectMake(47, 510, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda2.frame = CGRectMake(217, 511, 80, 21);
            self.leyenda5.frame = CGRectMake(190,532, 83, 21);
            
        }
        
    }else{
        
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            self.leyenda1.frame = CGRectMake(30, 600, 152, 21);
            self.leyenda2.frame = CGRectMake(184, 601, 152, 21);
            self.leyenda3.frame = CGRectMake(61, 622, 28, 21);
            self.leyenda4.frame = CGRectMake(89, 622, 144, 21);
            self.leyenda5.frame = CGRectMake(226,622, 83, 21);
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
      /*  }else if(IS_STANDARD_IPHONE_6_PLUS){
            self.leyenda1.frame = CGRectMake(60, 680, 270, 21);
            self.leyenda3.frame = CGRectMake(75, 702, 28, 21);
            self.leyenda4.frame = CGRectMake(100, 703, 144, 21);
            self.leyenda2.frame = CGRectMake(203, 681, 180, 21);
            self.leyenda5.frame = CGRectMake(240,702, 83, 21);
       */
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
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.scrollView setContentSize:CGSizeMake(375, 500)];
   /* }else if(IS_STANDARD_IPHONE_6_PLUS){
        [self.scrollView setContentSize:CGSizeMake(414, 700)];
    */
    }else if(IS_IPAD){
        [self.scrollView setContentSize:CGSizeMake(768, 700)];
    }
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *color = [UIColor whiteColor];
     [self fbDidlogout];
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"public_profile", @"email"];
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        loginView.frame = CGRectMake(20, 160, 335, 50);
        self.raya1.frame = CGRectMake(20, 264, 155, 2);
        self.o.frame = CGRectMake(178, 256, 155, 20);
        self.raya2.frame = CGRectMake(195, 264, 155, 2);
        self.msjRegistrarConFacebook.frame = CGRectMake(20, 180, 335, 100);
        
        [self.txtNombre setFrame:CGRectMake(22, 280, 330, 50)];
        [self.txtContrasena setFrame:CGRectMake(22, 340, 330, 50)];
        [self.txtContrasenaConfirmar setFrame:CGRectMake(22, 400, 330, 50)];
        [self.btnRegistrar setFrame:CGRectMake(22, 460, 330, 50)];
        self.imgLogoInfo.frame = CGRectMake(64, 58, 267, 49);
        [self.scrollView addSubview:self.imgLogoInfo];
         self.msjCreaTuSitio.frame = CGRectMake(20, 100, 335, 55);
       
   /* }else if(IS_STANDARD_IPHONE_6_PLUS){
        loginView.frame = CGRectMake(20, 180, 375, 50);
        self.raya1.frame = CGRectMake(20, 280, 175, 2);
        self.o.frame = CGRectMake(199, 272, 40, 20);
        self.raya2.frame = CGRectMake(215, 280, 175, 2);
        self.msjRegistrarConFacebook.frame = CGRectMake(24, 210, 371, 80);
        self.txtNombre.frame = CGRectMake(20, 300, 374, 50);
        self.txtContrasena.frame = CGRectMake(20, 370, 374, 50);
        self.txtContrasenaConfirmar.frame = CGRectMake(20, 440, 374, 50);
        self.btnRegistrar.frame = CGRectMake(20, 530, 374, 50);
        [self.imgLogoInfo setFrame:CGRectMake(80, 50, 267,50 )];
        [self.msjCreaTuSitio setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
        [self.msjCreaTuSitio setFrame:CGRectMake(20, 120, 375,40 )];
        self.scrollView.frame = CGRectMake(0, 0, 414, 736);
    */
    }else if(IS_IPAD){
        loginView.frame = CGRectMake(196, 300, 375, 50);
        UIImage *lineImg = [UIImage imageNamed:@"line@1x.png"];
        UIImageView * myImageView = [[UIImageView alloc] initWithImage:lineImg];
        CGRect myFrame = CGRectMake(146, 450, 475, 3);
        [myImageView setFrame:myFrame];
        [self.scrollView addSubview:myImageView];
        self.msjRegistrarConFacebook.frame = CGRectMake(184, 800, 400, 160);
        [self.msjRegistrarConFacebook setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.raya1 setHidden:YES];
        [self.o setHidden:YES];
        [self.raya2 setHidden:YES];
        [self.txtNombre setFrame:CGRectMake(196, 500, 375, 50)];
        [self.txtContrasena setFrame:CGRectMake(196, 560, 375, 50)];
        [self.txtContrasenaConfirmar setFrame:CGRectMake(196, 620, 375, 50)];
        [self.btnRegistrar setFrame:CGRectMake(196, 700, 375, 50)];
        [self.imgLogoInfo setFrame:CGRectMake(250, 150, 267,50 )];
        [self.msjCreaTuSitio setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
        [self.msjCreaTuSitio setFrame:CGRectMake(196, 230, 375,33 )];
        [self.msjRegistrarConFacebook setFrame:CGRectMake(180, 380, 402, 50)];
        [self.txtNombre setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.txtContrasena setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.txtContrasenaConfirmar setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.btnRegistrar.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
        
        
    }else if(IS_IPHONE_4){
        loginView.frame = CGRectMake(20, 75, 280, 45);
        [self.msjRegistrarConFacebook setFrame:CGRectMake(0, 115, 320, 40)];
        self.raya1.frame = CGRectMake(24, 163, 122, 2);
        self.o.frame = CGRectMake(154,153,12,21);
        self.raya2.frame = CGRectMake(174, 163, 124, 2);
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
           [self.msjRegistrarConFacebook setFont:[UIFont fontWithName:@"Avenir-Book" size:12]];
        }else{
             [self.msjRegistrarConFacebook setFont:[UIFont fontWithName:@"Avenir-Book" size:13]];
        }
       
    }else{
        loginView.frame = CGRectMake(20, 110, 280, 45);
    }
    
    for (id obj in loginView.subviews)
    {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage;
            if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
                loginButton.frame =CGRectMake(0,0, 335, 50);
                loginImage = [UIImage imageNamed:@"btn_facebook_335_55.png"];
           /* }else if (IS_STANDARD_IPHONE_6_PLUS){
                loginButton.frame =CGRectMake(0,0, 375, 50);
                loginImage = [UIImage imageNamed:@"btn_facebook_375x55.png"];
            */
            }else if(IS_IPAD){
                loginButton.frame =CGRectMake(0,0, 375, 50);
                loginImage = [UIImage imageNamed:@"btn_facebook_375x55.png"];
                
            }else if(IS_IPHONE_4){
                loginButton.frame =CGRectMake(0,0, 280, 40);
                loginImage = [UIImage imageNamed:@"btn_facebook_280x40.png"];
            }else{
                loginButton.frame =CGRectMake(0,0, 280, 45);
                loginImage = [UIImage imageNamed:@"btn_facebook_280x40.png"];
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
            if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
                loginLabel.frame =CGRectMake(0,0, 335, 50);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            /*}else if(IS_STANDARD_IPHONE_6_PLUS){
                loginLabel.frame =CGRectMake(0,0, 375, 50);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            */
             }else if(IS_IPAD){
                loginLabel.frame =CGRectMake(0,0, 375, 50);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            }else if(IS_IPHONE_4){
                loginLabel.frame =CGRectMake(0,0, 280, 40);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }else{
                loginLabel.frame =CGRectMake(0,0, 280, 40);
                [loginLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
            }
            
        }
        
    }
    
    [self.scrollView addSubview:loginView];
   
    self.msjRegistrarConFacebook.text = NSLocalizedString(@"msjRegistrarUsuarioFB", nil);
    [self.navigationController.navigationBar setHidden:YES];
    UIButton *botonRegresar = [UIButton buttonWithType:UIButtonTypeCustom];
     [botonRegresar setTitle:NSLocalizedString(@"yaTienesCuenta", nil) forState:UIControlStateNormal] ;
    if(IS_IPAD){
        [botonRegresar setFrame:CGRectMake(196, 800, 375, 50)];
        [botonRegresar.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
    }else if(IS_IPHONE_4){
        [botonRegresar setFrame:CGRectMake(10, 390, 300, 40)];
        [botonRegresar.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
    }else if(IS_IPHONE_5){
        [botonRegresar setFrame:CGRectMake(0, 450, 320, 45)];
        [botonRegresar.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [botonRegresar setFrame:CGRectMake(20, 525, 335, 50)];
        [botonRegresar.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    }
    /*else if(IS_STANDARD_IPHONE_6_PLUS){
        [botonRegresar setFrame:CGRectMake(20, 600, 360, 50)];
        [botonRegresar.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
    }
    */
    
    [botonRegresar addTarget:self action:@selector(regresarMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:botonRegresar];
    
    if(IS_IPHONE_4){
        [self.txtNombre setFrame:CGRectMake(22, 180,274,40)];
        [self.txtContrasena setFrame:CGRectMake(22, 230, 274, 40)];
        [self.txtContrasenaConfirmar setFrame:CGRectMake(22, 280, 274, 40)];
        [self.btnRegistrar setFrame:CGRectMake(22, 340, 274, 40)];
        [self.msjCreaTuSitio setHidden:YES];
    }
    
    [self.vistaInferior setHidden:YES];
    self.btnRegistrar.layer.cornerRadius = 10.0f;
    self.btnRegistrar.layer.borderWidth = 1.0f;
    self.btnRegistrar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtContrasena.layer.borderWidth = 1.0f;
    self.txtContrasena.layer.cornerRadius = 10.0f;
    self.txtContrasena.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"contrasenaRegistrar", nil) attributes:@{NSForegroundColorAttributeName: color}];
  
    self.txtContrasenaConfirmar.layer.borderWidth = 1.0f;
    self.txtContrasenaConfirmar.layer.cornerRadius = 10.0f;
    self.txtContrasenaConfirmar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtContrasenaConfirmar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"confirmarContrasena", nil) attributes:@{NSForegroundColorAttributeName: color}];
   
    self.txtNombre.layer.borderWidth = 1.0f;
    self.txtNombre.layer.cornerRadius = 10.0f;
    self.txtNombre.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtNombre.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" info@infomovil.com" attributes:@{NSForegroundColorAttributeName: color}];
    
    
  
    self.leyenda1.text = NSLocalizedString(@"inicioLeyenda1", nil);
    [self.leyenda2 setTitle:NSLocalizedString(@"inicioLeyenda2", nil) forState:UIControlStateNormal] ;
    self.leyenda3.text = NSLocalizedString(@"inicioLeyenda3", nil);
    [self.leyenda4 setTitle:NSLocalizedString(@"inicioLeyenda4", nil) forState:UIControlStateNormal] ;
    self.leyenda5.text = NSLocalizedString(@"inicioLeyenda5", nil);
    [self.btnRegistrar setTitle:NSLocalizedString(@"formularioBoton", nil) forState:UIControlStateNormal] ;
    self.msjCreaTuSitio.text = NSLocalizedString(@"creaSitio", nil);
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
    [self.labelInfo setText:[NSString stringWithFormat:@"%li/%i", (long)textoLength, 255]];
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
                [self.labelInfo setText:[NSString stringWithFormat:@"%li/%li",  (long)(textoLength-1), (long)maxLength]];
            }
            else {
                [self.labelInfo setText:[NSString stringWithFormat:@"%li/%li", (long) (textoLength+1), (long)maxLength]];
            }
            return YES;
        }
    }
    else {
        if ([string isEqualToString:@""]) {
            [self.labelInfo setText:[NSString stringWithFormat:@"%li/%li",  (long)(textoLength-1), (long)maxLength]];
            return YES;
        }
        return NO;
    }
}

-(IBAction)guardarInformacion:(id)sender {
    [[self view] endEditing:YES];
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
   regresar:
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



-(void) ocultarActivity {
    
   self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    if (existeUsuario) {
        loginFacebook = NO;
        if (idDominio <= 0) {
            loginFacebook = YES;
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"errorCrearDominio", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }else{
            loginFacebook = NO;
            [[AppsFlyerTracker sharedTracker] setCustomerUserID:self.datosUsuario.emailUsuario];
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Registro Usuario" withValue:@""];
           
            // IRC APPBOY //
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *launch =  [defaults objectForKey:@"launchingWithOptions"];
            //  IRC //
            [Appboy startWithApiKey:llaveAppboy
                      inApplication:[UIApplication sharedApplication]
                  withLaunchOptions:launch];
         
             [[Appboy sharedInstance] changeUser:self.datosUsuario.emailUsuario];
             [Appboy sharedInstance].user.email = self.datosUsuario.emailUsuario;
            if([self.datosUsuario.emailUsuario isEqualToString:@""] || self.datosUsuario.emailUsuario == nil){
                [[Appboy sharedInstance] changeUser:self.datosUsuario.auxStrSesionUser];
                [Appboy sharedInstance].user.email = self.datosUsuario.auxStrSesionUser;
            }
        
            [self enviarEventoGAconCategoria:@"Registrar" yEtiqueta:@"Usuario"];
            ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
            
            NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
            NSLog(@"LOS VALORES QUE GUARDARA SON: %@  %@   %li ", self.datosUsuario.auxStrSesionUser, self.datosUsuario.auxStrSesionPass,(long)self.datosUsuario.auxSesionFacebook);
            [prefSesion setObject:self.datosUsuario.auxStrSesionUser forKey:@"strSesionUser"];
            [prefSesion setObject:self.datosUsuario.auxStrSesionPass forKey:@"strSesionPass"];
            [prefSesion setInteger:(long)self.datosUsuario.auxSesionFacebook forKey:@"intSesionFacebook"];
            [prefSesion setInteger:1 forKey:@"intSesionActiva"];
            [prefSesion synchronize];
            
            
            MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
            [self.navigationController pushViewController:menuPasos animated:YES];
        }
    }
    else {
        loginFacebook = YES;
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
 
    if(operacionWS == 1 ){
        if ([resultado isEqualToString:@"No existe"]) {
            existeUsuario = YES;
            loginFacebook = NO;
            [self crearDominio];
        }else {
            existeUsuario = NO;
            if (self.alerta)
            {
                [NSThread sleepForTimeInterval:1];
                [self.alerta hide];
            }
            loginFacebook = YES;
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"emailAsociado", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }else{
        loginFacebook = NO;
        DatosUsuario *datos = [DatosUsuario sharedInstance];
        idDominio = datos.idDominio;
        if (self.alerta)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alerta hide];
        }
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }
}

-(void) resultadoLogin:(NSInteger) idDominioLogin {
   
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (idDominioLogin > 0) {
        loginExitoso = YES;
        loginFacebook = NO;
        idDominio = idDominioLogin;
        existeUsuario = YES;
        self.datosUsuario.redSocial = @"Facebook";
        // Se guarda la sesion //
       
    }
    else {
        loginFacebook = YES;
        respuestaError = idDominioLogin;
        loginExitoso = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorToken {
  
    loginFacebook = YES;
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
    loginFacebook = YES;
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    [self fbDidlogout];
    
}



#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}


#pragma mark - FBLoginViewDelegate
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
#if DEBUG
    NSLog(@"Entrando a loginView:handleError:");
    NSLog(@"El error es %@  ***********", [error description]);
#endif
    [[AlertView initWithDelegate:nil message:@"Sesión cerrada" andAlertViewType:AlertViewTypeInfo] show];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
  
    
    if([[user objectForKey:@"email"] isEqualToString:@""] || [user objectForKey:@"email"] == nil){
        self.datosUsuario.emailUsuario = [user objectForKey:@"id"];
    }else{
        self.datosUsuario.emailUsuario = [user objectForKey:@"email"];
    }
#if DEBUG
    NSLog(@"Entrando a loginViewFetchedUserInfo:user:");
    NSLog(@"el email es %@", self.datosUsuario.emailUsuario);
#endif
    self.datosUsuario.redSocial = @"Facebook";
    NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
     NSLog(@"El valor de sesion activa es: %ld", (long)[prefSesion integerForKey:@"intSesionActiva"]);
    if(loginFacebook == YES && [prefSesion integerForKey:@"intSesionActiva"] != 1) {
        loginFacebook = NO;
        [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
    }
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
#if DEBUG
    NSLog(@"Entrando a loginViewShowingLoggedInUser MENUREGISTROVIEWCONTROLLER:");
#endif
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
#if DEBUG
    NSLog(@"Entrando a loginViewShowingLoggedOutUser MENUREGISTROVIEWCONTROLLER: ");
#endif
}

-(void) consultaLogin {
  
    if(loginFacebook == YES){
        WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
        [login setLoginDelegate:self];
        [login setRedSocial:@"Facebook"];
        [login obtieneLogin:self.datosUsuario.emailUsuario conPassword:@" "];
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


-(BOOL) validaCampos {
   
    if ((self.txtNombre.text.length) > 0 && (self.txtContrasena.text.length > 0) ){
        if (![CommonUtils validarEmail:self.txtNombre.text]) {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"emailIncorrecto", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            return NO;
        }
        
        if (![CommonUtils validarContrasena:self.txtNombre.text contrasena:self.txtContrasena.text]) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorPassword", Nil) andAlertViewType:AlertViewTypeInfoPassword];
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

