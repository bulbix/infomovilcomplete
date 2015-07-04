//
//  MapaUbicacionViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "MapaUbicacionViewController.h"
#import "WS_HandlerActualizarMapa.h"
#import "MainViewController.h"

@interface MapaUbicacionViewController () <CLLocationManagerDelegate>{
    BOOL borrar;
    BOOL exito;
    BOOL mostroElimar;
    BOOL mostroCambiar;
    BOOL hayAnotacion;
    CLLocation *auxLocation;;
	NSInteger contador;
}

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) AlertView *alertaMapa;

@end

@implementation MapaUbicacionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.btnBuscar setFrame:CGRectMake(73, 0, 78, 55)];
        [self.btnUbicar setFrame:CGRectMake(151, 0, 78, 55)];
        [self.btnEliminar setFrame:CGRectMake(229, 0, 78, 55)];
   
     }else if(IS_IPAD){
        [self.btnBuscar setFrame:CGRectMake(267, 0, 78, 55)];
        [self.btnUbicar setFrame:CGRectMake(345, 0, 78, 55)];
        [self.btnEliminar setFrame:CGRectMake(423, 0, 78, 55)];
    
    }
  

		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"mapa", @" ") nombreImagen:@"barraverde.png"];
	
    mostroCambiar = NO;
    mostroElimar = NO;
    
    self.alertaMapa = [AlertView initWithDelegate:nil message:NSLocalizedString(@"txtInfoMapa", Nil) andAlertViewType:AlertViewInfoMapa];
    [self.alertaMapa show];
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    self.modifico = NO;
    borrar = NO;
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.datosUsuario.localizacion == Nil || (self.datosUsuario.localizacion.coordinate.latitude == 0.0 && self.datosUsuario.localizacion.coordinate.longitude == 0.0)) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        hayAnotacion = NO;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        if([CLLocationManager locationServicesEnabled]){
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    }
    else {
        self.location = self.datosUsuario.localizacion;
        if (CLLocationCoordinate2DIsValid(self.location.coordinate)) {
            hayAnotacion = YES;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 200, 200);
            [self.mapView setRegion:region];
            [self.mapView addAnnotation:self];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"mapa", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"mapa", @" ") nombreImagen:@"NBverde.png"];
	}
	[super viewWillAppear:YES];
	[self.vistaInferior setHidden:YES];
	contador = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buscarDireccion:(id)sender {
    BuscaDireccionViewController *buscar = [[BuscaDireccionViewController alloc] initWithNibName:@"BuscaDireccionViewController" bundle:Nil];
    [buscar setDelegate:self];
    [self.navigationController pushViewController:buscar animated:YES];
}

-(IBAction)guardarDireccion:(id)sender {
    if (!hayAnotacion) {
        CLLocationCoordinate2D loc = self.mapView.centerCoordinate;
        self.location = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
        self.modifico = YES;
        if (CLLocationCoordinate2DIsValid(self.location.coordinate)) {
            hayAnotacion = YES;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 200, 200);
            [self.mapView setRegion:region];
            [self.mapView addAnnotation:self];
        }
    }
    else {
        if (!mostroCambiar && contador == 0) {
         
			[self accionAceptar2];
            contador = 1;
			
        }
		else{
			[self.mapView removeAnnotation:self];
			CLLocationCoordinate2D loc = self.mapView.centerCoordinate;
			self.location = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
			self.modifico = YES;
			if (CLLocationCoordinate2DIsValid(self.location.coordinate)) {
				hayAnotacion = YES;
				MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 200, 200);
				[self.mapView setRegion:region];
				[self.mapView addAnnotation:self];
			}
		}
        
        
    }
    
}

-(void)accionAceptar2{
	[self.mapView removeAnnotation:self];
	CLLocationCoordinate2D loc = self.mapView.centerCoordinate;
	self.location = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
	self.modifico = YES;
	if (CLLocationCoordinate2DIsValid(self.location.coordinate)) {
		hayAnotacion = YES;
		MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 200, 200);
		[self.mapView setRegion:region];
		[self.mapView addAnnotation:self];
	}
}

-(void)accionCancelar{
	
}


-(IBAction)borrarDireccion:(id)sender {
	if(self.location != nil){
		borrar = YES;
		AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"eliminarUbicacion", @" ") andAlertViewType:AlertViewTypeQuestion];
		[alert show];
	}
}

#pragma mark - BuscaDireccionProtocol
-(void)buscaDireccionViewController:(BuscaDireccionViewController *)controller conLocalizacion:(CLLocation *)location yDireccion:(NSString *)direccion {

        self.location = location;
        if (CLLocationCoordinate2DIsValid(location.coordinate)) {
            self.modifico = YES;
            hayAnotacion = YES;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200);
            [self.mapView setRegion:region];
            [self.mapView addAnnotation:self];
        }

}

-(IBAction)guardarInformacion:(id)sender {
    if (self.modifico) {
        self.datosUsuario = [DatosUsuario sharedInstance];
        auxLocation = self.location;
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.modifico = NO;
      
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarMapa) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        
    }
	else if(self.location == nil){

        AlertView *alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"elijeUbicacion",nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
        
	}
	else{
        
        AlertView *alertView = [AlertView initWithDelegate:nil message:NSLocalizedString(@"elijeUbicacion", @" ") andAlertViewType:AlertViewTypeInfo];
        [alertView show];
	}
}

#pragma mark - MKAnnotation Protocol (for map pin)

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

- (NSString *)title
{
    return @" ";
}

-(NSString *) subtitle {
    return @"Infomovil";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.location = newLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    AlertView *alertView;
    if (self.modifico && [CommonUtils hayConexion]) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) accionNo {
    if (borrar) {
        borrar = NO;
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void) accionSi {
    if (borrar) {
        [self.mapView removeAnnotation:self];
        hayAnotacion = NO;
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:5 withObject:@NO];
       
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarMapa) withObject:Nil];
				//borrar = NO;
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        
       
    }
    else {
        [self guardarInformacion:Nil];

    }
}
-(void) accionAceptar {
    if (!borrar) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) mostrarActivity {
    self.alertaMapa = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarMapa", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaMapa show];
}

-(void) ocultarActivity {
    if (self.alertaMapa)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaMapa hide];
    }
    if (exito) {
        if (!borrar) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
	[self.navigationController popViewControllerAnimated:YES];
    
}

-(void) actualizarMapa {
   
        if (borrar) {
            WS_HandlerActualizarMapa *actualizaMapa = [[WS_HandlerActualizarMapa alloc] init];
            [actualizaMapa setMapaDelegate:self];
            [actualizaMapa borrarMapa];
        }
        else {
            WS_HandlerActualizarMapa *actualizaMapa = [[WS_HandlerActualizarMapa alloc] init];
            [actualizaMapa setMapaDelegate:self];
            [actualizaMapa setLocation:auxLocation];
            [actualizaMapa actualizarMapa];
        }
    
    
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        exito = YES;
		
		if(!borrar){
      
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Mapa"];
				[self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:5 withObject:@YES];
		}else{
       
            [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Mapa"];
			[self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:5 withObject:@NO];
			borrar = NO;
		}
    }
    else {
        exito = NO;
    }
	
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertaMapa)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaMapa hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}


-(void) revertirGuardado {
    
}

@end
