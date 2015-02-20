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
#import "VistaPreviaViewController.h"
#import "TipsViewController.h"
#import "NombrarViewController.h"
#import "WS_HandlerDominio.h"
#import "AppboyKit.h"
#import "InicioRapidoViewController.h"
#import "VerTutorialViewController.h"

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
	NSLog(@"statusDominio: %@", ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio );
    [super viewDidLoad];
	
    self.datosUsuario				= [DatosUsuario sharedInstance];
    self.datosUsuario.editoPagina	= NO;
    
     [[Appboy sharedInstance] changeUser:self.datosUsuario.emailUsuario];
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
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"btnbackgroundEn.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"btncreateeditEn.png"] forState:UIControlStateNormal];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:NO];
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"btnnamepublishEn.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:YES];
        }
        
    }else{
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirfondo.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"creareditar.png"] forState:UIControlStateNormal];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null])){
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
        
        if(self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio]){
            self.dominio.hidden	= NO;
            [self.viewDominioNoPublicado setHidden:YES];
            [self.viewDominioPublicado setHidden:NO];
           
            for(int i= 0; [self.datosUsuario.dominiosUsuario count] > i ; i++){
                DominiosUsuario *dominioUsuario = [self.datosUsuario.dominiosUsuario objectAtIndex:i];
                if([dominioUsuario.domainType isEqualToString:@"tel"]){
                    self.dominio.text	= [NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio];
                }else{
                    self.dominio.text	= [NSString stringWithFormat:@"www.info-movil.com/%@", self.datosUsuario.dominio];
                }
            }
            
            if([self.dominio.text isEqualToString:@""] || self.dominio.text == nil || (self.datosUsuario.dominio == (id)[NSNull null]) ){
                self.dominio.text	= [NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio];
            }
            
            if(IS_IPHONE5){
                self.viewDominioPublicado.frame = CGRectMake(0, 320, 320, 90);
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
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"btnbackgroundEn.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"btncreateeditEn.png"] forState:UIControlStateNormal];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:NO];
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"btnnamepublishEn.png"] forState:UIControlStateNormal];
            [self.vistaInferior setHidden:YES];
        }
        
    }else{
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirfondo.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"creareditar.png"] forState:UIControlStateNormal];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null])){
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

- (IBAction)elegirFondo:(UIButton *)sender {

    ColorPickerViewController *colorPicker = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:Nil];
    [self.navigationController pushViewController:colorPicker animated:YES];
}

- (IBAction)crearEditar:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
#ifdef _DEBUG
	self.datosUsuario.eligioColor = YES;
#endif
    if (self.datosUsuario.eligioColor) {
        CrearPaso1ViewController *crear = [[CrearPaso1ViewController alloc] initWithNibName:@"CrearPaso1ViewController" bundle:nil];
        [self.navigationController pushViewController:crear animated:YES];
    }
    else {
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"eligeColor", Nil) andAlertViewType:AlertViewTypeInfo];
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
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && ![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio hasPrefix:@"Tramite"]) {

        TipsViewController *tipsController = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:Nil];
        [self.navigationController pushViewController:tipsController animated:YES];
    }
    else {
        if (!self.datosUsuario.nombroSitio) {
            if ([self perfilEditado]) {
                NombrarViewController *nombrar = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:nil];
                [self.navigationController pushViewController:nombrar animated:YES];
            }
            else {
                AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"editaPagina", Nil) andAlertViewType:AlertViewTypeInfo];
                [vistaNotificacion show];
            }
        }
       
    }
    
}

- (IBAction)verEjemplo:(UIButton *)sender {
    VistaPreviaViewController *vistaPrevia = [[VistaPreviaViewController alloc] initWithNibName:@"VistaPreviaViewController" bundle:Nil];
    [vistaPrevia setTipoVista:PreviewTypeEjemplo];
    [self.navigationController pushViewController:vistaPrevia animated:YES];
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

- (IBAction)irInicioRapido:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
#ifdef _DEBUG
    self.datosUsuario.eligioColor = YES;
#endif
    if (self.datosUsuario.eligioColor) {
        InicioRapidoViewController *inicioRapido = [[InicioRapidoViewController alloc] initWithNibName:@"InicioRapidoViewController" bundle:Nil];
        [self.navigationController pushViewController:inicioRapido animated:YES];
    }
    else {
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"eligeColor", Nil) andAlertViewType:AlertViewTypeInfo];
        [vistaNotificacion show];
    }
    
    
    
    
}



@end