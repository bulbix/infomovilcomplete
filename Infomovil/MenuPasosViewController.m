//
//  MenuPasosViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "MenuPasosViewController.h"
#import "CrearPaso1ViewController.h"
#import "PublicarViewController.h"
#import "DominioRegistradoViewController.h"
#import "IrAMiSitioViewController.h"
#import "TipsViewController.h"
#import "NombrarViewController.h"
#import "WS_HandlerDominio.h"
#import "InicioRapidoViewController.h"
#import "VerTutorialViewController.h"
#import "VerEjemploViewController.h"
#import "AppsFlyerTracker.h"
#import "AppDelegate.h"
#import "AppboyKit.h"
#import "ElegirPlantillaViewController.h"
#import "MainViewController.h"
#import "DominiosUsuario.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface MenuPasosViewController ()
{
BOOL banderaRegresar;
}
@property (nonatomic, strong) NSMutableArray *arregloDominios;
@end

@implementation MenuPasosViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        banderaRegresar = NO;
    }
    return self;
}

- (void)viewDidLoad{
	
    [super viewDidLoad];
    
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        self.botonFondo.frame = CGRectMake(45, 70, 270, 53);
        self.botonCrear.frame = CGRectMake(45, 160, 270, 53);
        self.botonPublicar.frame = CGRectMake(45, 250, 270, 53);
        self.botonEjemplo2.frame = CGRectMake(80, 30, 200, 40);
        self.inicioRapidobtn.frame = CGRectMake(50, 64, 280, 40);
        self.verTutorialbtn.frame = CGRectMake(50, 120, 137, 40);
        self.botonEjemplo.frame = CGRectMake(190, 120, 137, 40);
        self.dominio.frame = CGRectMake(0, 18, 375, 34);
        self.line1.frame = CGRectMake(45, 140, 280, 1);
        self.line2.frame = CGRectMake(45, 230, 280, 1);
        self.line3.frame = CGRectMake(45, 320, 280, 1);
    }else if(IS_IPAD){
        self.botonFondo.frame = CGRectMake(184, 150, 400, 75);
        self.botonCrear.frame = CGRectMake(184, 270, 400, 75);
        self.botonPublicar.frame = CGRectMake(184, 390, 400, 75);
        self.botonEjemplo2.frame = CGRectMake(209, 320, 350, 40);
        [self.botonEjemplo2.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.inicioRapidobtn.frame = CGRectMake(209, 12, 350, 40);
        [self.inicioRapidobtn.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.verTutorialbtn.frame = CGRectMake(209, 72, 170, 40);
        [self.verTutorialbtn.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.botonEjemplo.frame = CGRectMake(384, 72, 170, 40);
        [self.botonEjemplo.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.line1.frame = CGRectMake(184, 250, 400, 2);
        self.line2.frame = CGRectMake(184, 370, 400, 2);
        self.line3.frame = CGRectMake(184, 485, 400, 2);
        self.dominio.frame = CGRectMake(0, 40, 768, 40);
        [self.dominio.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:22]];
    
    }else if(IS_IPHONE_5){
        self.dominio.frame = CGRectMake(0, 0, 320, 50);
        self.botonFondo.frame = CGRectMake(25, 60, 270, 53);
        self.line1.frame = CGRectMake(20,125,280,1);
        self.botonCrear.frame = CGRectMake(25,143,270,53);
        self.line2.frame = CGRectMake(20,211,280,1);
        self.botonPublicar.frame = CGRectMake(25,229,270,53);
        self.line3.frame = CGRectMake(20,297,280,1);
        
    }else{
         self.dominio.frame = CGRectMake(0, 0, 320, 35);
        self.line1.frame = CGRectMake(20, 105, 280, 1);
        self.line2.frame = CGRectMake(20, 191, 280, 1);
        self.line3.frame = CGRectMake(20, 273, 280, 1);
    }
	
    self.datosUsuario				= [DatosUsuario sharedInstance];
    self.datosUsuario.editoPagina	= NO;
  
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.navigationItem.backBarButtonItem	= nil;
        self.navigationItem.rightBarButtonItem = Nil;
        self.navigationItem.hidesBackButton		= YES;
        self.navigationItem.leftBarButtonItem	= nil;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];

    
    
	
	((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView = self;
	
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
	
    self.verTutorialbtn.layer.cornerRadius = 10.0f;
    self.inicioRapidobtn.layer.cornerRadius = 10.0f;
    self.botonEjemplo.layer.cornerRadius = 10.0f;
	self.botonEjemplo2.layer.cornerRadius = 10.0f;
    
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirestilo-en.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"btncreateeditEn.png"] forState:UIControlStateNormal];
        NSLog(@"EL DOMINIO DEL USUARIO ES: %@",  self.datosUsuario.dominio);
        
        if ( self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"] ){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
           
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"btnnamepublishEn.png"] forState:UIControlStateNormal];
            
        }
        
    }else{
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirestilo-es.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"creareditar.png"] forState:UIControlStateNormal];
        if ( self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
         
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"nombrarpublicar.png"] forState:UIControlStateNormal];
        
        }
    }
    
    [self.vistaInferior setHidden:NO];
    
}

-(void)accionNo{
    banderaRegresar = NO;
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tituloVista setHidden:NO];
	banderaRegresar = NO;
    
    
#if DEBUG
        [self acomodarBarraNavegacionConTitulo:@"AMBIENTE DE QA" nombreImagen:@"barramorada.png"];
#else
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"", @" ") nombreImagen:@"barramorada.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"", @" ") nombreImagen:@"NBlila.png"];
    }
    
#endif
        self.datosUsuario = [DatosUsuario sharedInstance];
    
        if(self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            self.dominio.hidden	= NO;
            [self.viewDominioNoPublicado setHidden:YES];
            [self.viewDominioPublicado setHidden:NO];
           
            self.arregloDominios = self.datosUsuario.dominiosUsuario;
            [self.dominio setTitle:@"" forState:UIControlStateNormal];
            self.dominio.titleLabel.text = @"";
           
            for(int i= 0; i< [self.arregloDominios count]; i++){
                DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                
               
                if([usuarioDom.domainType isEqualToString:@"tel"]){
                  NSLog(@"EL USUARIO DOMAIN TEL ES: %@ con domainType %@", usuarioDom.domainName, usuarioDom.domainType);
                    if([usuarioDom.vigente isEqualToString:@"SI"] || [usuarioDom.vigente isEqualToString:@"si"]){
                        
                        
                        
                        if([usuarioDom.domainName isEqualToString:@""] || [usuarioDom.domainName length]<=0){
                        [self.dominio setTitle:[NSString stringWithFormat:@"www.%@.tel",self.datosUsuario.dominio] forState:UIControlStateNormal];
                            if([self.datosUsuario.dominio length] > 12 && !IS_IPAD){
                                [self.dominio.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
                            }
                        }else{
                            [self.dominio setTitle:[NSString stringWithFormat:@"www.%@.tel",usuarioDom.domainName] forState:UIControlStateNormal];
                            self.datosUsuario.dominio = usuarioDom.domainName;
                            if([usuarioDom.domainName length] > 12 && !IS_IPAD){
                                [self.dominio.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
                            }
                        }
                    }
                }
            }
           
            if([self.dominio.titleLabel.text isEqualToString:@""] || [self.dominio.titleLabel.text isEqualToString:@"(null)"] || self.dominio.titleLabel.text == nil ) {
                for(int i= 0; i< [self.arregloDominios count]; i++){
                    DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                    if([usuarioDom.domainType isEqualToString:@"recurso"]){
                    
                        if([self.datosUsuario.dominio length] > 12 && !IS_IPAD){
                            [self.dominio.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
                        }
                      
#if DEBUG
                         [self.dominio setTitle:[NSString stringWithFormat:@"qa.mobileinfo.io:8080/%@", self.datosUsuario.dominio] forState:UIControlStateNormal];
#else
                         [self.dominio setTitle:[NSString stringWithFormat:@"www.infomovil.com/%@", self.datosUsuario.dominio] forState:UIControlStateNormal];
                        
#endif
                        
                        
                    }
                }
            }
            
            
            
            
       
            if(IS_IPHONE5){
                self.viewDominioPublicado.frame = CGRectMake(0, 340, 320, 90);
            }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
                self.viewDominioPublicado.frame = CGRectMake(0, 320, 375, 90);
            }else if(IS_IPAD){
                self.viewDominioPublicado.frame = CGRectMake(0, 320, 400, 400);
                self.dominio.frame =CGRectMake(0, 70, 768, 40);
                [self.dominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-medium" size:21]];
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
                self.viewDominioNoPublicado.frame = CGRectMake(0, 330, 320, 90);
             }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS) {
                self.viewDominioNoPublicado.frame = CGRectMake(0, 320, 320, 140);
            }else if(IS_IPAD){
                self.viewDominioNoPublicado.frame = CGRectMake(0, 570, 768, 350);
                self.dominio.frame =CGRectMake(0, 60, 768, 40);
                [self.dominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-medium" size:21]];
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
        if ( self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"btnnamepublishEn.png"] forState:UIControlStateNormal];
            
        }
        
    }else{
        [self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirestilo-es.png"] forState:UIControlStateNormal];
        [self.botonCrear setBackgroundImage:[UIImage imageNamed:@"creareditar.png"] forState:UIControlStateNormal];
        if ( self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
            
        }else{
            [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"nombrarpublicar.png"] forState:UIControlStateNormal];
           
        }
    }
     [self.vistaInferior setHidden:NO];
	[self.navigationController.navigationBar setHidden:NO];
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


- (IBAction)elegirPlantilla:(UIButton *)sender {
    ElegirPlantillaViewController *elegirPlantillaBtn = [[ElegirPlantillaViewController alloc] initWithNibName:@"ElegirPlantillaViewController" bundle:Nil];
    [self.navigationController pushViewController:elegirPlantillaBtn animated:YES];
}




- (IBAction)crearEditar:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
	
    if (self.datosUsuario.eligioTemplate) {
        CrearPaso1ViewController *crear = [[CrearPaso1ViewController alloc] initWithNibName:@"CrearPaso1ViewController" bundle:nil];
        [self.navigationController pushViewController:crear animated:YES];
    }
    else {
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"eligeTemplate", Nil) andAlertViewType:AlertViewTypeInfo];
        [vistaNotificacion show];
    }
}

- (IBAction)publicar:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ( self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]) {
        
        TipsViewController *tipsController = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:Nil];
        [self.navigationController pushViewController:tipsController animated:YES];
        
    }else if( [self perfilEditado]) {
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


-(IBAction)regresar:(id)sender {
    if(banderaRegresar == NO){
        banderaRegresar = YES;
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"salirMensaje", Nil) andAlertViewType:AlertViewTypeQuestion];
        [alert show];
        
    }
}

-(void) accionSi {
   
    if(banderaRegresar == YES){
        banderaRegresar = NO;
        MainViewController *Inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
        [self.navigationController pushViewController:Inicio animated:YES];
        self.datosUsuario = [DatosUsuario sharedInstance];
        NSString *correo = self.datosUsuario.emailUsuario;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        WS_HandlerDominio *handlerDominio = [[WS_HandlerDominio alloc] init];
        [handlerDominio setWSHandlerDelegate:self];
        [handlerDominio cerrarSession:correo];
        [StringUtils deleteFile];
        [self.datosUsuario eliminarDatos];
    });
    
        
        if ([self.datosUsuario.redSocial isEqualToString:@"Facebook"]) {
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) fbDidlogout];
        }
        ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
    }
   
}



- (IBAction)IrAlDominio:(id)sender {
    if([self.dominio.titleLabel.text length] > 0){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         self.datosUsuario = [DatosUsuario sharedInstance];
#if DEBUG
        NSString *dominioAux = [NSString stringWithFormat:@"http://qa.mobileinfo.io:8080/%@", self.datosUsuario.dominio];
        [prefs setObject:dominioAux forKey:@"urlMisitio"];
#else
        [prefs setObject:[NSString stringWithFormat:@"http://%@", self.dominio.titleLabel.text] forKey:@"urlMisitio"];
#endif
        
        
        [prefs synchronize];
        IrAMiSitioViewController *verMiSitio = [[IrAMiSitioViewController alloc] initWithNibName:@"IrAMisitio" bundle:Nil];
        [self.navigationController pushViewController:verMiSitio animated:YES];
    
    }
    
}

- (IBAction)irInicioRapido:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
  
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