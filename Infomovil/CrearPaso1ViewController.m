
//
//  CrearPaso1ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "CrearPaso1ViewController.h"
#import "CrearPaso2ViewController.h"
#import "MapaUbicacionViewController.h"
#import "EditarPaso2ViewController.h"
#import "PromocionesViewController.h"
#import "VideoViewController.h"
#import "GaleriaImagenesViewController.h"
#import "PerfilViewController.h"
#import "InformacionAdicionalViewController.h"
#import "ListaTelefonosViewController.h"
#import "VistaPreviaWebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ItemsDominio.h"
#import "CuentaViewController.h"
#import "GaleriaPaso2ViewController.h"
#import "PerfilPaso2ViewController.h"
#import "NombrarViewController.h"
#import "AppsFlyerTracker.h"
#import "AppDelegate.h"


@interface CrearPaso1ViewController (){
	AlertView * alertaVideo;
	
}


@end

@implementation CrearPaso1ViewController
@synthesize arregloCampos;

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
    // Do any additional setup after loading the view from its nib.
    
    self.datosUsuario = [DatosUsuario sharedInstance];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"crearEditar", Nil) nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"crearEditar", Nil) nombreImagen:@"NBverde.png"];
	}
    
    
    if (existeItems) {
        arregloCampos = self.datosUsuario.itemsDominio;
      
    }
    else {
      
        NSArray *arregloAux = @[[[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"nombreEmpresa", @" ") andStatus:1],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"logo", @" ") andStatus:1],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"descripcionCorta", @" ") andStatus:1],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"contacto", @" ") andStatus:2],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"mapa", @" ") andStatus:1],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"video", @" ") andStatus:0],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"promociones", @" ") andStatus:1],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"galeriaImagenes", @" ") andStatus:2],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"perfil", @" ") andStatus:7],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"direccion", @" ") andStatus:7],
                                [[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"informacionAdicional", @" ") andStatus:1]];
        
        arregloCampos = [[NSMutableArray alloc] initWithArray:arregloAux];
        self.datosUsuario.itemsDominio = arregloCampos;
    }
   
    if ([self.datosUsuario.arregloEstatusEdicion count] == 0) {
     
        NSArray *arregloAux = @[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO];
        NSMutableArray *arregloEstatus = [[NSMutableArray alloc] init];
        [arregloEstatus addObjectsFromArray:arregloAux];
        self.datosUsuario.arregloEstatusEdicion = arregloEstatus;
    }
    
    self.tablaEditar.layer.cornerRadius = 5;
    
    UIImage *imagenBoton = [UIImage imageNamed:@"btnprevisualizar.png"];
    UIButton *botonPrevisualizar = [UIButton buttonWithType:UIButtonTypeCustom];
    [botonPrevisualizar setFrame:CGRectMake(0, 0, imagenBoton.size.width, imagenBoton.size.height)];
    [botonPrevisualizar setImage:imagenBoton forState:UIControlStateNormal];
    [botonPrevisualizar addTarget:self action:@selector(mostrarWeb:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *botonDerecha = [[UIBarButtonItem alloc] initWithCustomView:botonPrevisualizar];
    self.navigationItem.rightBarButtonItem = botonDerecha;
	
	int editados = 0;
	for(int i=0;i<[self.datosUsuario.arregloEstatusEdicion count];i++){
		if([[self.datosUsuario.arregloEstatusEdicion objectAtIndex:i] isEqual:@YES]){
			editados++;
		}
	}
	

	[self.vistaInferior setHidden:NO];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tituloVista setHidden:NO];
    self.datosUsuario = [DatosUsuario sharedInstance];

    [self.tablaEditar reloadData];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"crearEditar", Nil) nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"crearEditar", Nil) nombreImagen:@"NBverde.png"];
	}
	
	if (existeItems) {
        arregloCampos = self.datosUsuario.itemsDominio;
		    }
    
    if(IS_IPAD){
        [self.tablaEditar setFrame:CGRectMake(20, 20, 728, 830)];
    }else if(IS_IPHONE_5){
        [self.tablaEditar setFrame:CGRectMake(20, 15, 280, 440)];
    }else if(IS_IPHONE_4){
         [self.tablaEditar setFrame:CGRectMake(20, 15, 280, 350)];
    }else if(IS_STANDARD_IPHONE_6){
        [self.tablaEditar setFrame:CGRectMake(20, 15, 335, 540)];
    }else if(IS_STANDARD_IPHONE_6_PLUS){
         [self.tablaEditar setFrame:CGRectMake(20, 15, 374, 600)];
    }
    [self.vistaInferior setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( (self.datosUsuario.dominio == (id)[NSNull null])  && [CommonUtils perfilEditado]) {
        return [arregloCampos count] + 1;
    }
    return [arregloCampos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.datosUsuario = [DatosUsuario sharedInstance];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfo"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellInfo"];
    }

    if ( self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio]  && [CommonUtils perfilEditado] && indexPath.row == [arregloCampos count]) {
        [cell.imageView setImage:[UIImage imageNamed:@"noeditado.png"]];
        [cell.textLabel setTextColor:colorFuenteVerde];
        [cell.textLabel setText:NSLocalizedString(@"txtPublicar", Nil)];
    }
    else {
        if ([[self.datosUsuario.arregloEstatusEdicion objectAtIndex:indexPath.row]  isEqual:@NO]) {
            [cell.imageView setImage:[UIImage imageNamed:@"noeditado.png"]];
            [cell.textLabel setTextColor:colorFuenteVerde];
        }
        else {
            [cell.imageView setImage:[UIImage imageNamed:@"editado.png"]];
            [cell.textLabel setTextColor:colorFuenteAzul];
        }
            
        arregloCampos = self.datosUsuario.itemsDominio;
        [cell.textLabel setText:[[arregloCampos objectAtIndex:indexPath.row] descripcionIdioma]];
        
        UIImageView *imagenAccesory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnsiguiente.png"]];
        [cell setAccessoryView:imagenAccesory];


    }
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return 50;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (existeItems && indexPath.row < 12) {
        arregloCampos = self.datosUsuario.itemsDominio;
    }
	//IRC//
    ItemsDominio *itemSeleccionado;
    if (existeItems) {
        itemSeleccionado = [arregloCampos objectAtIndex:indexPath.row];
    }
    
    
    if (indexPath.row == 4) {
        ListaTelefonosViewController *listaTelefono = [[ListaTelefonosViewController alloc] initWithNibName:@"ListaTelefonosViewController" bundle:Nil];
        [listaTelefono setIndiceSeleccionado:indexPath.row];
        [self.navigationController pushViewController:listaTelefono animated:YES];
    }
    else if (indexPath.row == 5) {
        if([CLLocationManager locationServicesEnabled] &&
           [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            MapaUbicacionViewController *mapaUbicacion  = [[MapaUbicacionViewController alloc] initWithNibName:@"MapaUbicacionViewController" bundle:Nil];
            [self.navigationController pushViewController:mapaUbicacion animated:YES];
        } else {
            [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noGeolocalizacion", @"") andAlertViewType:AlertViewTypeInfo] show];
        }
        
    }
    else if (indexPath.row == 10) {
        EditarPaso2ViewController *editar2 = [[EditarPaso2ViewController alloc] initWithNibName:@"EditarPaso2ViewController" bundle:nil];
        [editar2 setIndex:indexPath.row];
        [self.navigationController pushViewController:editar2 animated:YES];
    }
    else if (indexPath.row == 7) {
        PromocionesViewController *promociones = [[PromocionesViewController alloc] initWithNibName:@"PromocionesViewController" bundle:nil];
        [self.navigationController pushViewController:promociones animated:YES];
    }
    else if (indexPath.row == 8) {
        GaleriaImagenesViewController *galeria = [[GaleriaImagenesViewController alloc] initWithNibName:@"GaleriaImagenesViewController" bundle:Nil];
        [galeria setIndiceItem:indexPath.row];
        [self.navigationController pushViewController:galeria animated:YES];
    }
    else if (indexPath.row == 6) {

        
        
        if (existeItems) {
            
            if ( [((AppDelegate *)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]) {
                VideoViewController *video = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
                [self.navigationController pushViewController:video animated:YES];
                
            }else {
                alertaVideo = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeNoVideo", Nil) andAlertViewType:AlertViewTypeQuestion];
				[alertaVideo show];
            }
            
        }
        else {
            VideoViewController *video = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
            [self.navigationController pushViewController:video animated:YES];
        }
        
        
    }
    else if (indexPath.row == 9) {
        PerfilViewController *perfil = [[PerfilViewController alloc] initWithNibName:@"PerfilViewController" bundle:Nil];
        [self.navigationController pushViewController:perfil animated:YES];
    }
    else if (indexPath.row == 11) {
        InformacionAdicionalViewController *info = [[InformacionAdicionalViewController alloc]            initWithNibName:@"InformacionAdicionalViewController" bundle:Nil];
        [self.navigationController pushViewController:info animated:YES];
    }
    else if (indexPath.row == 1) {
        GaleriaPaso2ViewController *galeriaPaso2 = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:Nil];
        [galeriaPaso2 setGaleryType:PhotoGaleryTypeLogo];
        [galeriaPaso2 setTituloPaso:NSLocalizedString(@"logo", nil)];
        [self.navigationController pushViewController:galeriaPaso2 animated:YES];
    }
    else if (indexPath.row == 2) {
        PerfilPaso2ViewController *perfilPaso2 = [[PerfilPaso2ViewController alloc] initWithNibName:@"PerfilPaso2ViewController" bundle:Nil];
        [perfilPaso2 setTituloPerfil:NSLocalizedString(@"perfinNegocioProfesion",nil)];
        [perfilPaso2 setIndex:6];
        [self.navigationController pushViewController:perfilPaso2 animated:YES];
    }
    else if (indexPath.row == 12) {
        NombrarViewController *nombrarView = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:Nil];
        self.datosUsuario.vistaOrigen = 12;
        [self.navigationController pushViewController:nombrarView animated:YES];
    }
    else {
        CrearPaso2ViewController *paso2;
        paso2 = [[CrearPaso2ViewController alloc] initWithNibName:@"CrearPaso2ViewController" bundle:nil];
        [paso2 setIndex:indexPath.row];
		if (existeItems) {
			if(indexPath.row == 0){
				[paso2 setTituloPaso:NSLocalizedString(@"nombreEmpresa", nil)];
			}else{
				[paso2 setTituloPaso:NSLocalizedString(@"descripcionCorta", nil)];
			}
			
		}
		else {
			[paso2 setTituloPaso:[arregloCampos objectAtIndex:indexPath.row]];
		}
        
        [self.navigationController pushViewController:paso2 animated:YES];
    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)mostrarWeb:(id)sender {
  
      self.datosUsuario	= [DatosUsuario sharedInstance];
     if ( self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         [prefs setObject:[NSString stringWithFormat:@"http://infomovil.com/%@?vistaPrevia=true", self.datosUsuario.dominio] forKey:@"urlVistaPrevia"];
         // IRC TEMPORAL
#if DEBUG
         [prefs setObject:[NSString stringWithFormat:@"http://172.17.3.181:8080/%@?vistaPrevia=true", self.datosUsuario.dominio] forKey:@"urlVistaPrevia"];
#endif
         
         [prefs synchronize];
         VistaPreviaWebViewController *vistaPrevia = [[VistaPreviaWebViewController alloc] initWithNibName:@"VistaPreviaWeb" bundle:Nil];
         [self.navigationController pushViewController:vistaPrevia animated:YES];
     }else if(self.datosUsuario.idDominio){
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         [prefs setObject:[NSString stringWithFormat:@"http://infomovil.com/xxx?vistaPrevia=true&idDominio=%ld", (long)self.datosUsuario.idDominio] forKey:@"urlVistaPrevia"];
#if DEBUG
      [prefs setObject:[NSString stringWithFormat:@"http://172.17.3.181:8080/xxx?vistaPrevia=true&idDominio=%ld", (long)self.datosUsuario.idDominio] forKey:@"urlVistaPrevia"];
#endif
         [prefs synchronize];
         VistaPreviaWebViewController *vistaPrevia = [[VistaPreviaWebViewController alloc] initWithNibName:@"VistaPreviaWeb" bundle:Nil];
         [self.navigationController pushViewController:vistaPrevia animated:YES];
     }
}




-(void) accionSi{
	[alertaVideo hide];
    CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
    [self.navigationController pushViewController:cuenta animated:YES];
}

-(void) accionNo{
	[alertaVideo hide];
}


@end
