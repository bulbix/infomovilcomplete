//
//  MapaUbicacionViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import <MapKit/MapKit.h>
#import "BuscaDireccionViewController.h"
#import "WS_HandlerProtocol.h"

@interface MapaUbicacionViewController : InfomovilViewController <BuscaDireccionProtocol, MKMapViewDelegate, MKAnnotation, CLLocationManagerDelegate, AlertViewDelegate, WS_HandlerProtocol>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *btnBuscar;
@property (weak, nonatomic) IBOutlet UIButton *btnUbicar;
@property (weak, nonatomic) IBOutlet UIButton *btnEliminar;


-(IBAction)buscarDireccion:(id)sender;
-(IBAction)guardarDireccion:(id)sender;
-(IBAction)borrarDireccion:(id)sender;

@end
