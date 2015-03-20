//
//  MenuPasosViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "MenuPasosViewController.h"
#import "ColorPickerViewController.h"
#import "CrearPaso1ViewController.h"
#import "FormularioRegistroViewController.h"
#import "PublicarViewController.h"
#import "DominioRegistradoViewController.h"
#import "IrAMiSitioViewController.h"
#import "TipsViewController.h"
#import "NombrarViewController.h"
#import "WS_HandlerDominio.h"
#import "AppboyKit.h"
#import "InicioRapidoViewController.h"
#import "VerTutorialViewController.h"
#import "VerEjemploViewController.h"
#import "AppsFlyerTracker.h"
#import "AppDelegate.h"
#import "AppboyKit.h"
#import "ElegirPlantillaViewController.h"


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface MenuPasosViewController ()

@end

@implementation MenuPasosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{ NSLog(@"ViewDidload MenuPasosViewController");
	NSLog(@"statusDominio : %@", ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio );
    [super viewDidLoad];
    
    //MBC
    if(IS_STANDARD_IPHONE_6){
        self.botonFondo.frame = CGRectMake(45, 28, 270, 53);
        self.botonCrear.frame = CGRectMake(45, 123, 270, 53);
        self.botonPublicar.frame = CGRectMake(45, 209, 270, 53);
        self.botonEjemplo2.frame = CGRectMake(80, 250, 200, 50);
        self.inicioRapidobtn.frame = CGRectMake(50, 24, 280, 35);
        self.verTutorialbtn.frame = CGRectMake(50, 72, 137, 35);
        self.botonEjemplo.frame = CGRectMake(193, 72, 137, 35);
        self.dominio.frame = CGRectMake(0, 4, 375, 34);
    }
    else if(IS_STANDARD_IPHONE_6_PLUS){
        self.botonFondo.frame = CGRectMake(70, 46, 270, 53);
        self.botonCrear.frame = CGRectMake(70, 130, 270, 53);
        self.botonPublicar.frame = CGRectMake(70, 214, 270, 53);
        self.botonEjemplo2.frame = CGRectMake(100, 250, 200, 50);
        self.inicioRapidobtn.frame = CGRectMake(70, 24, 280, 35);
        self.verTutorialbtn.frame = CGRectMake(70, 72, 137, 35);
        self.botonEjemplo.frame = CGRectMake(213, 72, 137, 35);
        self.line1.frame = CGRectMake(70, 105, 280, 3);
        self.line2.frame = CGRectMake(70, 191, 280, 3);
        self.line3.frame = CGRectMake(70, 277, 280, 3);
        self.dominio.frame = CGRectMake(0, 4, 420, 34);
    }
	
    self.datosUsuario				= [DatosUsuario sharedInstance];
    self.datosUsuario.editoPagina	= NO;
    [self.navigationItem hidesBackButton];
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion)
	{
        self.navigationItem.backBarButtonItem	= Nil;
        self.navigationItem.leftBarButtonItem	= Nil;
        self.navigationItem.hidesBackButton		= YES;
    }
    
    self.navigationItem.rightBarButtonItem = Nil;
	
	((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView = self;
	
	
	self.navigationItem.hidesBackButton = YES;
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    if (self.datosUsuario.codigoError > 0) {
        NSString *strMensaje;
        switch (self.datosUsuario.codigoError) {
            case 99:
                strMensaje = NSLocalizedString(@"error99", nil);
                break;
            case 666:
                strMensaje = NSLocalizedString(@"error666", nil);
                break;
            case 999:
                strMensaje = NSLocalizedString(@"error999", nil);
                break;
            case 555:
                strMensaje = NSLocalizedString(@"error555", nil);
                break;
            case 55:
                strMensaje = NSLocalizedString(@"error55", nil);
                break;
            case 44:
                strMensaje = NSLocalizedString(@"error44", nil);
                break;
            case 66:
                strMensaje = NSLocalizedString(@"error66", nil);
                break;
            default:
                strMensaje = NSLocalizedString(@"errorCampanaGen", nil);
                break;
        }
        [[AlertView initWithDelegate:nil message:strMensaje andAlertViewType:AlertViewTypeInfo] show];
    }
	
    self.verTutorialbtn.layer.cornerRadius = 15.0f;
    self.inicioRapidobtn.layer.cornerRadius = 15.0f;
    self.botonEjemplo.layer.cornerRadius = 15.0f;
	self.botonEjemplo2.layer.cornerRadius = 15.0f;
    
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirestilo-en.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"btncreateeditEn.png"] forState:UIControlStateNormal];
       
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"] ){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:NO];
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"btnnamepublishEn.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:YES];
        }
        
    }else{
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirestilo-es.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"creareditar.png"] forState:UIControlStateNormal];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:NO];
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"nombrarpublicar.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:YES];
        }
    }
}




-(void) viewWillAppear:(BOOL)animated { NSLog(@"Entro a viewwillAppear de MenuPasosViewController");
	self.datosUsuario = [DatosUsuario sharedInstance];
    [super viewWillAppear:animated];
    [self.tituloVista setHidden:NO];
	
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"creaSitio", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"creaSitio", @" ") nombreImagen:@"NBlila.png"];
	}
    
        self.datosUsuario = [DatosUsuario sharedInstance];
    
            NSLog(@"MenuPasosViewController - Dominio: %@ ",self.datosUsuario.dominio);
        
        if(self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            self.dominio.hidden	= NO;
            [self.viewDominioNoPublicado setHidden:YES];
            [self.viewDominioPublicado setHidden:NO];
           
            for(int i= 0; [self.datosUsuario.dominiosUsuario count] > i ; i++){
             //   DominiosUsuario *dominioUsuario = [self.datosUsuario.dominiosUsuario objectAtIndex:i];
             //   if([dominioUsuario.domainType isEqualToString:@"tel"]){
            [self.dominio setTitle:[NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio] forState:UIControlStateNormal];
#if DEBUG
                [self.dominio setTitle:[NSString stringWithFormat:@"www.info-movil.com/%@", self.datosUsuario.dominio] forState:UIControlStateNormal];
#endif
             /*  }else{
                    self.dominio.text	= [NSString stringWithFormat:@"www.info-movil.com/%@", self.datosUsuario.dominio];
                }
              */
            }
            
            if([self.dominio.titleLabel.text isEqualToString:@""] || self.dominio.titleLabel.text == nil || (self.datosUsuario.dominio == (id)[NSNull null]) || ![CommonUtils validarEmail:self.datosUsuario.dominio] || ![self.datosUsuario.dominio isEqualToString:@"(null)"] ){
                [self.dominio setTitle:[NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio] forState:UIControlStateNormal];
#if DEBUG
                [self.dominio setTitle:[NSString stringWithFormat:@"www.info-movil.com/%@", self.datosUsuario.dominio] forState:UIControlStateNormal];
#endif
            }
            
            if(IS_IPHONE5){
                self.viewDominioPublicado.frame = CGRectMake(0, 320, 320, 90);
            }else if (IS_STANDARD_IPHONE_6_PLUS){
                self.viewDominioPublicado.frame = CGRectMake(0, 100, 320, 90);
            }else if(IS_STANDARD_IPHONE_6){

                
            }else{
                self.viewDominioPublicado.frame = CGRectMake(0, 300, 320, 90);
            }
            [self.view addSubview:self.viewDominioPublicado];
        }else{
            self.datosUsuario.dominio = nil;
            [self.viewDominioPublicado setHidden:YES];
            [self.viewDominioNoPublicado setHidden:NO];
            self.dominio.hidden = YES;
            if(IS_IPHONE5){
                self.viewDominioNoPublicado.frame = CGRectMake(0, 310, 320, 90);
            }else if (IS_STANDARD_IPHONE_6_PLUS){
                self.viewDominioNoPublicado.frame = CGRectMake(0, 320, 320, 90);
            }else if(IS_STANDARD_IPHONE_6){
                self.viewDominioNoPublicado.frame = CGRectMake(0, 320, 320, 90);
                
            }else{
                self.viewDominioNoPublicado.frame = CGRectMake(0, 280, 320, 90);
            }
            [self.view addSubview:self.viewDominioNoPublicado];
        }
  
	
    [self.tituloVista setTextColor:[UIColor whiteColor]];
    [self.inicioRapidobtn setTitle:NSLocalizedString(@"inicioRapido", Nil) forState:UIControlStateNormal];
    [self.verTutorialbtn setTitle:NSLocalizedString(@"verTutorial", Nil) forState:UIControlStateNormal];
    [self.botonEjemplo setTitle:NSLocalizedString(@"verEjemplo", Nil) forState:UIControlStateNormal];
    [self.botonEjemplo2 setTitle:NSLocalizedString(@"verEjemplo", Nil) forState:UIControlStateNormal];
	
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirestilo-en.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"btncreateeditEn.png"] forState:UIControlStateNormal];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:NO];
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"btnnamepublishEn.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:YES];
        }
        
    }else{
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirestilo-es.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"creareditar.png"] forState:UIControlStateNormal];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:NO];
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"nombrarpublicar.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:YES];
        }
    }
   
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)verTutorialAct:(id)sender {
       VerTutorialViewController *tutorial = [[VerTutorialViewController alloc] initWithNibName:@"VerTutorialViewController" bundle:nil];
        [self.navigationController pushViewController:tutorial animated:YES];
    
    
}
// IRC se deshabilito para Templates
/*
- (IBAction)elegirFondo:(UIButton *)sender {

    ColorPickerViewController *colorPicker = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:Nil];
    [self.navigationController pushViewController:colorPicker animated:YES];
}
*/

- (IBAction)elegirPlantilla:(UIButton *)sender {
    ElegirPlantillaViewController *elegirPlantillaBtn = [[ElegirPlantillaViewController alloc] initWithNibName:@"ElegirPlantillaViewController" bundle:Nil];
    [self.navigationController pushViewController:elegirPlantillaBtn animated:YES];
}




- (IBAction)crearEditar:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];

	self.datosUsuario.eligioTemplate = YES;

    
    if (self.datosUsuario.eligioTemplate) {
        CrearPaso1ViewController *crear = [[CrearPaso1ViewController alloc] initWithNibName:@"CrearPaso1ViewController" bundle:nil];
        [self.navigationController pushViewController:crear animated:YES];
    }
    else {
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"eligeTemplate", Nil) andAlertViewType:AlertViewTypeInfo];
        [vistaNotificacion show];
    }
}

- (IBAction)nombrar:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (!self.datosUsuario.nombroSitio) {
        if ([self perfilEditado]) {
            FormularioRegistroViewController *nombrar = [[FormularioRegistroViewController alloc] initWithNibName:@"FormularioRegistroViewController" bundle:nil];
            [self.navigationController pushViewController:nombrar animated:YES];
        }
        else {
            AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"editaPagina", Nil) andAlertViewType:AlertViewTypeInfo];
            [vistaNotificacion show];
        }
    }
    else {
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"yaNombro", Nil) andAlertViewType:AlertViewTypeInfo];
        [vistaNotificacion show];
    }
}

- (IBAction)publicar:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSLog(@" EL VALOR DE STATUS DOMINIO ES: %@", ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio);
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]) {
        
        TipsViewController *tipsController = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:Nil];
        [self.navigationController pushViewController:tipsController animated:YES];
        
    }else if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && [self perfilEditado]) {
        NombrarViewController *nombrar = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:nil];
        [self.navigationController pushViewController:nombrar animated:YES];
    }else{
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"editaPagina", Nil) andAlertViewType:AlertViewTypeInfo];
        [vistaNotificacion show];
    }    }

- (IBAction)verEjemplo:(UIButton *)sender {
   VerEjemploViewController *verEjemplo = [[VerEjemploViewController alloc] initWithNibName:@"VerEjemplo" bundle:Nil];
    [self.navigationController pushViewController:verEjemplo animated:YES];
}

-(BOOL) perfilEditado {
    BOOL fueEditado = NO;
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([self.datosUsuario.arregloEstatusEdicion count] > 0) {
        for (int i = 0; i < [self.datosUsuario.arregloEstatusEdicion count]; i++) {
            if ([[self.datosUsuario.arregloEstatusEdicion objectAtIndex:i]  isEqual: @YES]) {
                fueEditado = YES;
                break;
            }
        }
    }
    return fueEditado;
}


-(IBAction)regresar:(id)sender { NSLog(@"Alerta de Cerrar sesión!");
	[[AlertView initWithDelegate:self message:NSLocalizedString(@"salirMensaje", nil)
				andAlertViewType:AlertViewTypeQuestion] show];
}

-(void) accionSi {
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSString *correo = self.datosUsuario.emailUsuario;
    if ([self.datosUsuario.redSocial isEqualToString:@"Facebook"]) {
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) fbDidlogout];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        WS_HandlerDominio *handlerDominio = [[WS_HandlerDominio alloc] init];
        [handlerDominio setWSHandlerDelegate:self];
        [handlerDominio cerrarSession:correo];
    });

    ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) pantallaAcomodaPublicar {
    self.navigationItem.leftBarButtonItem = Nil;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.vistaInferior setHidden:NO];
}

- (IBAction)IrAlDominio:(id)sender {
    NSLog(@"LA URL A CARGAR es: %@", self.dominio.titleLabel.text);
    if([self.dominio.titleLabel.text length] > 0){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSString stringWithFormat:@"http://%@", self.dominio.titleLabel.text] forKey:@"urlMisitio"];
        [prefs synchronize];
        IrAMiSitioViewController *verMiSitio = [[IrAMiSitioViewController alloc] initWithNibName:@"IrAMisitio" bundle:Nil];
        [self.navigationController pushViewController:verMiSitio animated:YES];
    
    }
    
}

- (IBAction)irInicioRapido:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    /*
#ifdef _DEBUG
    self.datosUsuario.eligioTemplate = YES;
#endif
     */
    if (self.datosUsuario.eligioTemplate) {
        InicioRapidoViewController *inicioRapido = [[InicioRapidoViewController alloc] initWithNibName:@"InicioRapidoViewController" bundle:Nil];
        [self.navigationController pushViewController:inicioRapido animated:YES];
    }
    else {
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"eligeTemplate", Nil) andAlertViewType:AlertViewTypeInfo];
        [vistaNotificacion show];
    }
    
    
    
    
}



@end