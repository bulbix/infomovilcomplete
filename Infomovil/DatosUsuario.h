//
//  DatosUsuario.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 21/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "VideoModel.h"
#import "GaleriaImagenes.h"
#import "OffertRecord.h"
#import "PagoModel.h"

@interface DatosUsuario : NSObject <NSCoding>


@property (nonatomic, strong) NSString *nombreEmpresa;
@property (nonatomic, strong) NSString *descripcion;

@property (nonatomic, strong) UIColor *colorSeleccionado;
@property (nonatomic, strong) NSString *pathFondo;
@property BOOL eligioColor; //para determinar si en background uso color o imagen

@property (nonatomic, strong) NSMutableArray *arregloContacto;

@property (nonatomic, strong) NSMutableArray *direccion;
@property (nonatomic, strong) NSMutableArray *arregloEstatusEdicion;

@property (nonatomic, strong) NSMutableArray *arregloEstatusPromocion;

@property (nonatomic, strong) NSString *rutaImagenPromocion;

@property (nonatomic, strong) NSMutableArray *arregloGaleriaImagenes;

@property (nonatomic, strong) NSMutableArray *arregloEstatusPerfil;
@property (nonatomic, strong) NSMutableArray *arregloDatosPerfil;

@property (nonatomic, strong) NSMutableArray *arregloInformacionAdicional;

@property (nonatomic, strong) NSString *emailUsuario;
@property (nonatomic, strong) NSString *numeroUsuario;
@property (nonatomic, strong) NSString *passwordUsuario;

@property (nonatomic, strong) NSString *dominio;

@property (nonatomic, strong) CLLocation *localizacion;

@property (nonatomic, strong) VideoModel *videoSeleccionado;

@property (nonatomic, strong) NSString *urlVideo;
@property (nonatomic, strong) GaleriaImagenes *imagenLogo;

@property BOOL publicoSitio;
@property BOOL nombroSitio;
@property BOOL existeLogin;
@property BOOL editoPagina;
@property (nonatomic, strong) NSString *token;

@property NSInteger idDominio;


@property (nonatomic) BOOL tipoRegistro;

@property (nonatomic, strong) NSString * nombreOrganizacion;
@property (nonatomic, strong) NSString * servicioCliente;
@property (nonatomic, strong) NSString * numeroMovil;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * calleNumero;
@property (nonatomic, strong) NSString * poblacion;
@property (nonatomic, strong) NSString * ciudad;
@property (nonatomic, strong) NSString * estado;
@property (nonatomic, strong) NSString * cp;
@property (nonatomic, strong) NSString * pais;
@property (nonatomic, strong) NSString * codigoPais;

@property (nonatomic, strong) NSMutableArray * itemsDominio;
@property (nonatomic, strong) NSMutableArray *itemsTipoDominio;
@property (nonatomic, strong) NSMutableArray *dominiosUsuario;

@property (nonatomic, strong) NSDate* fechaConsulta;

@property (nonatomic, strong) NSMutableArray *arregloVisitas;
@property (nonatomic, strong) NSMutableArray *arregloVisitantes;

@property (nonatomic, strong) NSString * fechaInicial;
@property (nonatomic, strong) NSString * fechaFinal;

@property (nonatomic, strong) NSString * fechaInicialTel;
@property (nonatomic, strong) NSString * fechaFinalTel;

@property (nonatomic, strong) OffertRecord *promocionActual;

@property (nonatomic, strong) PagoModel *datosPago;

@property (nonatomic) NSInteger codigoError;
@property (nonatomic, strong) NSString *codigoRedimir;
@property (nonatomic) NSInteger vistaOrigen;

@property (nonatomic, strong) NSString *redSocial;
@property (nonatomic, strong) NSString *descripcionDominio;

//@property NSString

+ (id)sharedInstance;

- (id)initWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)automat;

- (void)copiaPropiedades:(DatosUsuario *) datosOrigen;
-(void) eliminarDatos;

@end
