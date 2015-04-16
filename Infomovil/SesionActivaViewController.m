//
//  SesionActivaViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 4/15/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "SesionActivaViewController.h"
#import "WS_handlerLogin.h"
#import "MenuPasosViewController.h"
#import "InicioViewController.h"

@interface SesionActivaViewController (){}
@property (nonatomic, strong) AlertView *alerta;

@end

@implementation SesionActivaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alerta = [AlertView initWithDelegate:self message:Nil andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
    
    NSString *passLogin = nil;
    NSString *emailLogin = nil;
    NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
    self.datosUsuario = [DatosUsuario sharedInstance];
    WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
    [login setLoginDelegate:self];
    if ( [prefSesion integerForKey:@"intSesionFacebook"] == 1){
        [login setRedSocial:@"Facebook"];
    }
    
    passLogin = [prefSesion stringForKey:@"strSesionPass"];
    emailLogin = [prefSesion stringForKey:@"strSesionUser"];
    [login obtieneLogin:emailLogin conPassword:passLogin];
    [self mostrarLogo];
    [self.vistaInferior setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self pantallaAcomodaPublicar];
    self.navigationItem.hidesBackButton	= YES;
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btnReintentarConexion.layer.borderWidth = 1.0f;
    self.btnReintentarConexion.layer.cornerRadius = 15.0f;
    self.btnReintentarConexion.layer.borderColor = [UIColor whiteColor].CGColor;
    if(self.navigationController.navigationBar.hidden == NO){
        [self.navigationController.navigationBar setHidden:YES];
    }
    
    if(IS_IPAD){
        [self.imgBackground setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.btnReintentarConexion setFrame:CGRectMake(100, 400, 568, 50)];
        [self.imgLine setFrame:CGRectMake(100, 580, 568, 2)];
        [self.btnSesionOtraCuenta setFrame:CGRectMake(100, 800, 568, 50)];
    }else if(IS_STANDARD_IPHONE_6_PLUS){
        [self.imgBackground setFrame:CGRectMake(0, 0, 414, 736)];
        [self.btnReintentarConexion setFrame:CGRectMake(50, 300, 314, 45)];
        [self.imgLine setFrame:CGRectMake(50, 400, 315, 2)];
        [self.btnSesionOtraCuenta setFrame:CGRectMake(50, 600, 314, 45)];
    }else if(IS_STANDARD_IPHONE_6){
        [self.imgBackground setFrame:CGRectMake(0, 0, 375, 667)];
        [self.btnReintentarConexion setFrame:CGRectMake(30, 250, 315, 45)];
        [self.imgLine setFrame:CGRectMake(30, 320, 315, 2)];
        [self.btnSesionOtraCuenta setFrame:CGRectMake(30, 450, 315, 45)];
        
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
}

-(void)resultadoLogin:(NSInteger)idDominio{
    NSLog(@"Regreso resultadoLogin con Dominio %i", idDominio);
    if (idDominio > 0) {
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).logueado =YES;
        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
        [self.navigationController pushViewController:menuPasos animated:YES];
        
    }
    else {

        AlertView *alerta = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alerta show];
        [self.btnReintentarConexion setHidden:NO];
        [self.imgLine setHidden:NO];
        [self.btnSesionOtraCuenta setHidden:NO];
    }
   
    [self.alerta hide];
}

-(void) errorConsultaWS { NSLog(@"Regreso error en la consulta!!");
    AlertView *alertaConexion = [AlertView initWithDelegate:nil message:NSLocalizedString(@"noConexion", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertaConexion show];
    
    [self.alerta hide];
}


- (IBAction)ReintentarConexion:(id)sender {
    if ([CommonUtils hayConexion]) {
        NSString *passLogin = nil;
        NSString *emailLogin = nil;
        NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
        self.datosUsuario = [DatosUsuario sharedInstance];
        WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
        [login setLoginDelegate:self];
        if ( [prefSesion integerForKey:@"intSesionFacebook"] == 1){
            [login setRedSocial:@"Facebook"];
        }
    
        passLogin = [prefSesion stringForKey:@"strSesionPass"];
        emailLogin = [prefSesion stringForKey:@"strSesionUser"];
    
        [login obtieneLogin:emailLogin conPassword:passLogin];
    }else{
        AlertView *alerta = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alerta show];
    }
    
}

- (IBAction)IniciarSesionConOtraCuenta:(id)sender {
    InicioViewController *Inicio = [[InicioViewController alloc] initWithNibName:@"InicioViewController" bundle:Nil];
    [self.navigationController pushViewController:Inicio animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) pantallaAcomodaPublicar {
    self.navigationItem.leftBarButtonItem = Nil;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
}


@end
