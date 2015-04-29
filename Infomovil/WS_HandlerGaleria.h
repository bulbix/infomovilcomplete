//
//  WS_HandlerGaleria.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import "GaleriaPaso2ViewController.h"

@class GaleriaImagenes;

@interface WS_HandlerGaleria : WS_Handler <WS_HandlerProtocol>

@property (nonatomic, strong) id<WS_HandlerProtocol> galeriaDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *urlResultado;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSMutableArray *arregloGaleria;
@property (nonatomic, strong) GaleriaImagenes *imagenInsertarAux;
@property (nonatomic, assign) NSInteger indiceSeleccionado;
@property (nonatomic, assign) PhotoGaleryType tipoGaleria;

@property (nonatomic, strong) DatosUsuario *datosUsuario;

-(void) actualizarGaleria;
-(void) actualizarGaleriaDescripcion:(NSInteger)indexImage descripcion:(NSString *)descImage;
-(void) eliminarImagen:(NSInteger)idImagen;
-(void) insertarImagen:(GaleriaImagenes *) imagenInsertar;



@end
