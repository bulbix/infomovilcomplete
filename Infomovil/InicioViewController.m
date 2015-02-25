//
//  InicioViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 22/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InicioViewController.h"
#import "MainViewController.h"
#import "MenuPasosViewController.h"
#import "TerminosCondicionesViewController.h"
#import "WS_HandlerLogin.h"
#import "WS_ItemsDominio.h"
#import "WS_HandlerDominio.h"
#import "AlertView.h"
#import "ItemsDominio.h"
#import "FormularioRegistroViewController.h"
#import "AppsFlyerTracker.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "MenuRegistroViewController.h"

@interface InicioViewController () {
    BOOL loginExitoso, buscandoSesion, existeUnaSesion;
    NSInteger respuestaError;
}

@end

@implementation InicioViewController
@synthesize datosUsuario;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		self.leyenda1.frame = CGRectMake(47, 510, 200, 21);
		self.leyenda2.frame = CGRectMake(217, 511, 80, 21);
		
		self.leyenda3.frame = CGRectMake(45, 532, 28, 21);
		self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
		self.leyenda5.frame = CGRectMake(190,532, 83, 21);
	}else{
		self.leyenda1.frame = CGRectMake(6, 510, 152, 21);
		self.leyenda2.frame = CGRectMake(160, 511, 152, 21);
		
		self.leyenda3.frame = CGRectMake(37, 532, 28, 21);
		self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
		self.leyenda5.frame = CGRectMake(202,532, 83, 21);
		
		
	}
	((AppDelegate *)[[UIApplication sharedApplication] delegate]).logueado = NO;
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.vistaCircular setFrame:CGRectMake(0, 0, 320, 190)];
        [self mostrarLogo];
    }
    else {
		[self mostrarLogo6];
    }
	
	self.label.text = NSLocalizedString(@"inicioLabel", nil);
	[self.botonPruebalo setTitle:NSLocalizedString(@"inicioBotonPruebalo", nil) forState:UIControlStateNormal];
	[self.botonSesion setTitle:NSLocalizedString(@"inicioBotonSesion", nil) forState:UIControlStateNormal] ;
	
	self.leyenda1.text = NSLocalizedString(@"inicioLeyenda1", nil);
	[self.leyenda2 setTitle:NSLocalizedString(@"inicioLeyenda2", nil) forState:UIControlStateNormal] ;
	self.leyenda3.text = NSLocalizedString(@"inicioLeyenda3", nil);
	[self.leyenda4 setTitle:NSLocalizedString(@"inicioLeyenda4", nil) forState:UIControlStateNormal] ;
	self.leyenda5.text = NSLocalizedString(@"inicioLeyenda5", nil);
	
	self.version.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
	
	if (existeItems) {
        datosUsuario = [DatosUsuario sharedInstance];
        if ([CommonUtils hayConexion]) {
            if ([datosUsuario.fechaConsulta compare:[NSDate date]] == NSOrderedAscending || datosUsuario.fechaConsulta == nil) {
                datosUsuario.fechaConsulta = [NSDate date];
            }
        }

    }
    datosUsuario = [DatosUsuario sharedInstance];
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonPruebalo setBackgroundImage:[UIImage imageNamed:@"btnfreesiteEn.png"] forState:UIControlStateNormal];
	}
	
	((AppDelegate *)[[UIApplication sharedApplication] delegate]).logueado = NO;
	
	[self.vistaInferior setHidden:YES];
	
	self.datosUsuario = [DatosUsuario sharedInstance];
    ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) realizaConsultaItems {
    WS_ItemsDominio *itemsDominio = [[WS_ItemsDominio alloc] init];
    [itemsDominio actualizarItemsDominio];
}

- (IBAction)probarInfomovil:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self enviarEventoGAconCategoria:@"Pruebalo" yEtiqueta:@"pruebalo"];
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
	
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion = NO;
    MenuRegistroViewController *registro = [[MenuRegistroViewController alloc] initWithNibName:@"MenuRegistroViewController" bundle:nil];
    [self.navigationController pushViewController:registro animated:YES];
    
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Pruebalo ios" withValue:@""];
    
}

- (IBAction)loguearInfomovil:(UIButton *)sender {

        MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:mainController animated:YES];

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

-(void) mostrarActivity {
    self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}
-(void) ocultarActivity {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (buscandoSesion) {
        if (existeUnaSesion) {
            if (self.alerta)
            {
                [NSThread sleepForTimeInterval:1];
                [self.alerta hide];
            }
            self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"txtMsjSessionActiva", Nil) andAlertViewType:AlertViewTypeInfo3];
            [self.alerta show];
        }
        else {
            buscandoSesion = NO;
            [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
        }
    }
    else {
    if (loginExitoso) {
        self.datosUsuario.existeLogin = YES;
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion = YES;
        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
        [self.navigationController pushViewController:menuPasos animated:YES];
    }
    else {
        
        self.datosUsuario.existeLogin = NO;
        [StringUtils deleteResourcesWithExtension:@"jpg"];
        [StringUtils deleteFile];
        [self.datosUsuario eliminarDatos];
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

-(void) consultaLogin {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (buscandoSesion) {
        WS_HandlerDominio *handlerDominio = [[WS_HandlerDominio alloc] init];
        [handlerDominio setWSHandlerDelegate:self];
        [handlerDominio consultaSession:self.datosUsuario.emailUsuario ];
    }
    else {
    [StringUtils deleteResourcesWithExtension:@"jpg"];
    [StringUtils deleteFile];
    
    WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
    [login setLoginDelegate:self];
    [login obtieneLogin:self.datosUsuario.emailUsuario conPassword:self.datosUsuario.passwordUsuario];
    }
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

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorLogin) withObject:Nil waitUntilDone:YES];
}
-(void) errorLogin {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}

-(void) itemsActualizados:(BOOL)estado{
	if(estado){
        if (self.alerta)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alerta hide];
        }
		NSLog(@"Items Actualizados");
		self.datosUsuario = [DatosUsuario sharedInstance];
		if (self.datosUsuario.existeLogin) {
			[StringUtils deleteResourcesWithExtension:@"jpg"];
			[StringUtils deleteFile];
			[self.datosUsuario eliminarDatos];
		}
		((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion = NO;
		MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
		[self.navigationController pushViewController:menuPasos animated:YES];
	}else{
		if (self.alerta)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alerta hide];
        }
		NSLog(@"Items no actualizados");
		AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
		[alert show];
	}
}

#pragma mark AlertViewDelegate
-(void) accionAceptar2 {
    buscandoSesion = NO;
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];
}
-(void) accionCancelar {
}

- (IBAction)conoceMasAct:(id)sender {
}

- (IBAction)conoceMasPlayAct:(id)sender {
}
@end
