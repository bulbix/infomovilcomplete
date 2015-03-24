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
#import "VerTutorialViewController.h"

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
		
        if(IS_STANDARD_IPHONE_6){
            self.leyenda1.frame = CGRectMake(47, 510, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(90, 533, 144, 21);
            self.leyenda2.frame = CGRectMake(190, 511, 80, 21);
            self.leyenda5.frame = CGRectMake(190,532, 83, 21);
        }else if(IS_IPAD){
            [self.leyenda1 setFont: [UIFont systemFontOfSize:18]];
            [self.leyenda2.titleLabel setFont: [UIFont systemFontOfSize:18]];
            [self.leyenda3 setFont: [UIFont systemFontOfSize:18]];
            [self.leyenda4.titleLabel setFont:[UIFont systemFontOfSize:18]];
            [self.leyenda5 setFont: [UIFont systemFontOfSize:18]];
            
            self.leyenda1.frame = CGRectMake(240, 896, 250, 25);
            self.leyenda2.frame = CGRectMake(475, 900, 80, 25);
            self.leyenda3.frame = CGRectMake(230, 930, 40, 25);
            self.leyenda4.frame = CGRectMake(255, 930, 200, 25);
            self.leyenda5.frame = CGRectMake(385,930, 150, 25);
            
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
            [self.leyenda1 setFont: [UIFont systemFontOfSize:18]];
            [self.leyenda2.titleLabel setFont: [UIFont systemFontOfSize:18]];
            [self.leyenda3 setFont: [UIFont systemFontOfSize:18]];
            [self.leyenda4.titleLabel setFont:[UIFont systemFontOfSize:18]];
            [self.leyenda5 setFont: [UIFont systemFontOfSize:18]];
            
            self.leyenda1.frame = CGRectMake(235, 900, 250, 25);
            self.leyenda2.frame = CGRectMake(475, 900, 80, 25);
            self.leyenda3.frame = CGRectMake(235, 930, 40, 25);
            self.leyenda4.frame = CGRectMake(255, 930, 200, 25);
            self.leyenda5.frame = CGRectMake(385,930, 150, 25);
      
      }else{
            self.leyenda1.frame = CGRectMake(6, 510, 152, 21);
            self.leyenda2.frame = CGRectMake(160, 511, 152, 21);
            self.leyenda3.frame = CGRectMake(37, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda5.frame = CGRectMake(202,532, 83, 21);
        }
		
	
		
	}
    [self.navigationController.navigationBar setHidden:YES];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self mostrarLogo];
    }
    
    
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
   
    [self.conoceMas setTitle:NSLocalizedString(@"conoceMasInicio", nil) forState:UIControlStateNormal] ;
	
	self.label.text = NSLocalizedString(@"inicioLabel", nil);
	[self.botonPruebalos setTitle:NSLocalizedString(@"inicioBotonPruebalo", nil) forState:UIControlStateNormal];
	[self.botonSesions setTitle:NSLocalizedString(@"inicioBotonSesion", nil) forState:UIControlStateNormal] ;
	
	self.leyenda1.text = NSLocalizedString(@"inicioLeyenda1", nil);
	[self.leyenda2 setTitle:NSLocalizedString(@"inicioLeyenda2", nil) forState:UIControlStateNormal] ;
	self.leyenda3.text = NSLocalizedString(@"inicioLeyenda3", nil);
	[self.leyenda4 setTitle:NSLocalizedString(@"inicioLeyenda4", nil) forState:UIControlStateNormal] ;
	self.leyenda5.text = NSLocalizedString(@"inicioLeyenda5", nil);
	
	self.version.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
	 datosUsuario = [DatosUsuario sharedInstance];
	if (existeItems) {
       
        if ([CommonUtils hayConexion]) {
            if ([datosUsuario.fechaConsulta compare:[NSDate date]] == NSOrderedAscending || datosUsuario.fechaConsulta == nil) {
                datosUsuario.fechaConsulta = [NSDate date];
            }
        }

    }
   
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonPruebalos setBackgroundImage:[UIImage imageNamed:@"btnfreesiteEn.png"] forState:UIControlStateNormal];
	}
	
	((AppDelegate *)[[UIApplication sharedApplication] delegate]).logueado = NO;
	 ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = NO;
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).logueado = NO;
    
    if(self.navigationController.navigationBar.hidden == NO){
        [self.navigationController.navigationBar setHidden:YES];
    }
   
    if( IS_IPHONE_4 ){
        self.conoceMas.frame = CGRectMake(126, 380, 143 , 30);
        self.conoceMasPlay.frame = CGRectMake(83, 375, 35, 35);
        self.botonPruebalos.frame = CGRectMake(30, 220, 260, 55);
        self.botonSesions.frame = CGRectMake(32, 290, 256, 55);
        NSLog(@"el boton pruebalo es: %f", self.botonPruebalos.frame.origin.y);
        self.label.frame = CGRectMake(20, 118, 280, 97);
    }else if(IS_STANDARD_IPHONE_6){
        self.conoceMas.frame = CGRectMake(170, 380, 143 , 30);
        self.conoceMasPlay.frame = CGRectMake(120, 375, 35, 35);
        self.botonPruebalos.frame = CGRectMake(35, 220, 305, 55);
        self.botonSesions.frame = CGRectMake(35, 290, 305, 55);
        self.label.frame = CGRectMake(30, 118, 315, 97);
        
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            self.leyenda1.frame = CGRectMake(74, 510, 200, 21);
            self.leyenda2.frame = CGRectMake(244, 511, 80, 21);
            
        }else{
            self.leyenda1.frame = CGRectMake(50, 510, 200, 21);
            self.leyenda2.frame = CGRectMake(220, 511, 80, 21);
            
        }
        self.leyenda3.frame = CGRectMake(70, 532, 28, 21);
        self.leyenda4.frame = CGRectMake(90, 533, 144, 21);
        self.leyenda5.frame = CGRectMake(216,532, 83, 21);
        
    }
    //MBC
    else if(IS_STANDARD_IPHONE_6_PLUS){
        self.label.frame = CGRectMake(50, 118, 315, 97);
        self.conoceMas.frame = CGRectMake(190, 420, 143 , 30);
       if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
           self.leyenda1.frame = CGRectMake(94, 510, 200, 21);
           self.leyenda2.frame = CGRectMake(264, 511, 80, 21);
           
       }else{
           self.leyenda1.frame = CGRectMake(70, 510, 200, 21);
           self.leyenda2.frame = CGRectMake(240, 511, 80, 21);
       
       }
        self.leyenda3.frame = CGRectMake(90, 532, 28, 21);
        self.leyenda4.frame = CGRectMake(110, 533, 144, 21);
        self.leyenda5.frame = CGRectMake(236,532, 83, 21);
    }
   
    [self.vistaInferior setHidden:YES];
    

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
       /*if (existeUnaSesion) {
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
        */
        buscandoSesion = NO;
        [self performSelectorInBackground:@selector(consultaLogin) withObject:Nil];

        
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
    [self videoConoceMas];
}

- (IBAction)conoceMasPlayAct:(id)sender {
    [self videoConoceMas];
}

-(void)videoConoceMas{
    VerTutorialViewController *verTutorial = [[VerTutorialViewController alloc] initWithNibName:@"VerTutorialViewController" bundle:nil];
    [self.navigationController pushViewController:verTutorial animated:YES];

}


@end
