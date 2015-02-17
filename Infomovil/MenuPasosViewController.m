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

- (void)viewDidLoad{
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
	
	
}




-(void) viewWillAppear:(BOOL)animated {
	self.datosUsuario = [DatosUsuario sharedInstance];
    [super viewWillAppear:animated];
    [self.tituloVista setHidden:NO];
	
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"creaSitio", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"creaSitio", @" ") nombreImagen:@"NBlila.png"];
	}
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && ![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio hasPrefix:@"Tramite"])
	{
        DominiosUsuario *dominioUsuario = [self.datosUsuario.dominiosUsuario objectAtIndex:0];
		self.dominio.hidden	= NO;
		NSLog(@"Dominio: %@",self.datosUsuario.dominio);
		self.dominio.text	= [NSString stringWithFormat:@"www.infomovil.com/%@", dominioUsuario.domainName];
        //[self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
    }
    else {
       // [self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"nombrarpublicar.png"] forState:UIControlStateNormal];
		self.dominio.hidden = YES;
    }
	
    [self.tituloVista setTextColor:[UIColor whiteColor]];
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonFondo setBackgroundImage:[UIImage imageNamed:@"btnbackgroundEn.png"] forState:UIControlStateNormal];
		[self.botonCrear setBackgroundImage:[UIImage imageNamed:@"btncreateeditEn.png"] forState:UIControlStateNormal];
		if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && ![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio hasPrefix:@"Tramite"]){
			[self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
		}else{
			[self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"btnnamepublishEn.png"] forState:UIControlStateNormal];
		}
		[self.botonEjemplo setBackgroundImage:[UIImage imageNamed:@"btnexampleEn.png"] forState:UIControlStateNormal];
	}else{
		[self.botonFondo setBackgroundImage:[UIImage imageNamed:@"elegirfondo.png"] forState:UIControlStateNormal];
		[self.botonCrear setBackgroundImage:[UIImage imageNamed:@"creareditar.png"] forState:UIControlStateNormal];
		if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && ![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio hasPrefix:@"Tramite"]){
			[self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
		}else{
			[self.botonPublicar setBackgroundImage:[UIImage imageNamed:@"nombrarpublicar.png"] forState:UIControlStateNormal];
		}
		[self.botonEjemplo setBackgroundImage:[UIImage imageNamed:@"verejemplo.png"] forState:UIControlStateNormal];
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)elegirFondo:(UIButton *)sender {
//    FondoPaso1ViewController *paso1 = [[FondoPaso1ViewController alloc] initWithNibName:@"FondoPaso1ViewController" bundle:nil];
//    [self.navigationController pushViewController:paso1 animated:YES];
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
//        DominioRegistradoViewController *dominioRegistrado = [[DominioRegistradoViewController alloc] initWithNibName:@"DominioRegistradoViewController" bundle:Nil];
//        [self.navigationController pushViewController:dominioRegistrado animated:YES];
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
       /* else {
            DominioRegistradoViewController *dominioRegistrado = [[DominioRegistradoViewController alloc] initWithNibName:@"DominioRegistradoViewController" bundle:Nil];
            [self.navigationController pushViewController:dominioRegistrado animated:YES];
        }*/
    }
    
}

- (IBAction)verEjemplo:(UIButton *)sender {
    
//    NSURL *url = [NSURL URLWithString:@"http://twitter.com/home/?status=Hola%20visita%20mi%20dominio"];
//    [[UIApplication sharedApplication] openURL:url];
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


-(IBAction)regresar:(id)sender {
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

@end