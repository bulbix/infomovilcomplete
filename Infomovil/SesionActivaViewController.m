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
#import "MainViewController.h"
#import "ItemsDominio.h"

@interface SesionActivaViewController (){}
@property (nonatomic, strong) AlertView *alerta;

@end

@implementation SesionActivaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datosUsuario = [DatosUsuario sharedInstance];
   // [self enviarEventoGAconCategoria:@"Pruebalo" yEtiqueta:@"pruebalo"];
    if (self.datosUsuario.existeLogin) {
        [StringUtils deleteResourcesWithExtension:@"jpg"];
        [StringUtils deleteFile];
        [self.datosUsuario eliminarDatos];
    }
    
    if([[self.datosUsuario.itemsDominio objectAtIndex:0] descripcionIdioma] == nil){
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSArray *arregloDescripcion = @[NSLocalizedString(@"nombreEmpresa", @" "), NSLocalizedString(@"logo", @" "), NSLocalizedString(@"descripcionCorta", @" "), NSLocalizedString(@"contacto", @" "), NSLocalizedString(@"mapa", @" "), NSLocalizedString(@"video", @" "), NSLocalizedString(@"promociones", @" "), NSLocalizedString(@"galeriaImagenes", @" "), NSLocalizedString(@"perfil", @" "), NSLocalizedString(@"direccion", @" "),  NSLocalizedString(@"informacionAdicional", @" ")];
        NSArray *arregloStatus = @[@"1",@"1",@"1",@"3",@"1",@"0",@"1",@"2",@"7",@"7",@"1"];
        
        for(int i = 0; i<11;i++){
            ItemsDominio * item = [[ItemsDominio alloc] init];
            [item setDescripcionItem:[arregloDescripcion objectAtIndex:i]];
            [item setDescripcionIdioma:[arregloDescripcion objectAtIndex:i]];
            [item setEstatus:[[arregloStatus objectAtIndex:i] integerValue]];
            
            [items addObject:item];
        }
        self.datosUsuario.itemsDominio = items;
    }
    
    
    [self.btnReintentarConexion setEnabled:YES];
    NSString *passLogin = nil;
    NSString *emailLogin = nil;
    NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
    
    WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
    [login setLoginDelegate:self];
    if ( [prefSesion integerForKey:@"intSesionFacebook"] == 1){
        [login setRedSocial:@"Facebook"];
    }
    
    passLogin = [prefSesion stringForKey:@"strSesionPass"];
    emailLogin = [prefSesion stringForKey:@"strSesionUser"];
    
    NSLog(@"EL USUARIO Y PASSWORD QUE ESTOY BUSCANDO SON: %@ Y %@", passLogin,emailLogin);
    
    [login obtieneLogin:emailLogin conPassword:passLogin];
    [self performSelectorOnMainThread:@selector(mostrarActividad) withObject:nil waitUntilDone:YES];
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
         [self.btnReintentarConexion.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.imgLine setFrame:CGRectMake(100, 580, 568, 2)];
        [self.btnSesionOtraCuenta setFrame:CGRectMake(100, 800, 568, 50)];
         [self.btnSesionOtraCuenta.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
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
    
    [self.vistaInferior setHidden:YES];
}

-(void)resultadoLogin:(NSInteger)idDominio{
    self.datosUsuario = [DatosUsuario sharedInstance];
#if DEBUG
    NSLog(@"Regreso resultadoLogin con Dominio %li", (long)idDominio);
#endif
    if (idDominio > 0) {
        NSLog(@"EL IDDOMINIO EN SESION ACTIVA ES: %li", (long)idDominio);
       
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).logueado =YES;
        self.datosUsuario.existeLogin = YES;
        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
        [self.navigationController pushViewController:menuPasos animated:YES];
      
        
    }else {
        NSString *strMensaje;
        switch (idDominio) {
            case -5:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            case -4:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            case -3:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            case -2:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            case -1:
                strMensaje = NSLocalizedString(@"errorLogin", Nil);
                break;
            default:
                strMensaje = NSLocalizedString(@"ocurrioError", Nil);
                break;
        }
        self.datosUsuario.existeLogin = NO;
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:strMensaje dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
       
        [self mostrarBotones];
    }
   [self performSelectorOnMainThread:@selector(ocultarActividad) withObject:nil waitUntilDone:NO];
}

-(void) errorConsultaWS { NSLog(@"Regreso error en la consulta!!");
    [self performSelectorOnMainThread:@selector(ocultarActividad) withObject:nil waitUntilDone:NO];
    if([self ExisteAlertaAbierta])
    {
        AlertView *alerta = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alerta show];
    }
    [self mostrarBotones];
}


- (IBAction)ReintentarConexion:(id)sender {
    if ([CommonUtils hayConexion]) {
        [self.btnReintentarConexion setEnabled:NO];
        NSString *passLogin = nil;
        NSString *emailLogin = nil;
        NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
        WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
        [login setLoginDelegate:self];
        if ( [prefSesion integerForKey:@"intSesionFacebook"] == 1){
            [login setRedSocial:@"Facebook"];
        }else{
            [login setRedSocial:@""];
        }
        passLogin = [prefSesion stringForKey:@"strSesionPass"];
        emailLogin = [prefSesion stringForKey:@"strSesionUser"];
        [login obtieneLogin:emailLogin conPassword:passLogin];
        [self performSelectorOnMainThread:@selector(mostrarActividad) withObject:nil waitUntilDone:YES];
    }else{
        AlertView *alerta = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alerta show];
    }
    
}


-(void)mostrarActividad{
    self.alerta = [AlertView initWithDelegate:self message:@"Actualizando datos" andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}

-(void)ocultarActividad{
    
    [self.alerta hide];
}


- (IBAction)IniciarSesionConOtraCuenta:(id)sender {
    MainViewController *Inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:Inicio animated:YES];
    
}

-(void)mostrarBotones{
    [self.btnReintentarConexion setEnabled:YES];
    [self.btnReintentarConexion setHidden:NO];
    [self.imgLine setHidden:NO];
    [self.btnSesionOtraCuenta setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) pantallaAcomodaPublicar {
    self.navigationItem.leftBarButtonItem = Nil;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
}

- (BOOL) ExisteAlertaAbierta {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            BOOL alert = [view isKindOfClass:[UIAlertView class]];
            BOOL action = [view isKindOfClass:[UIActionSheet class]];
            if (alert || action)
                return YES;
        }
    }
    return NO;
}


@end
