//
//  BuscaDireccionViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 05/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import <MapKit/MapKit.h>

@protocol BuscaDireccionProtocol;


@interface BuscaDireccionViewController : InfomovilViewController <UITextFieldDelegate>

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UITextField *cajaBusqueda;
@property (weak, nonatomic) id<BuscaDireccionProtocol> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labelBuscaDireccion;

@end


@protocol BuscaDireccionProtocol <NSObject>

-(void) buscaDireccionViewController:(BuscaDireccionViewController *)controller conLocalizacion:(CLLocation *)location yDireccion:(NSString *)direccion;

@end