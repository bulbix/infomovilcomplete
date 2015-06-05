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
@property BOOL eligioTemplate; //para determinar si en background uso color o imagen

@property (nonatomic, strong) NSMutableArray *arregloContacto;

@property (nonatomic, strong) NSMutableArray *direccion;
@property (nonatomic, strong) NSMutableArray *arregloEstatusEdicion;

@property (nonatomic, strong) NSMutableArray *arregloEstatusPromocion;

@property (nonatomic, strong) NSString *rutaImagenPromocion;

@property (nonatomic, strong) NSMutableArray *arregloGaleriaImagenes; // este no lo usare

// ESTOS SON LOS ARREGLOS PARA MANEJAR LAS IMAGENES DEL LOGO //
@property (nonatomic, strong) NSMutableArray *arregloUrlImagenes;
@property (nonatomic, strong) NSMutableArray *arregloIdImagen;
@property (nonatomic, strong) NSMutableArray *arregloDescripcionImagen;
@property (nonatomic, strong) NSMutableArray *arregloTipoImagen;
// ESTOS SON LOS ARREGLOS PARA MANEJAR LAS IMAGENES DE LA GALERIA //
@property (nonatomic, strong) NSMutableArray *arregloUrlImagenesGaleria;
@property (nonatomic, strong) NSMutableArray *arregloIdImagenGaleria;
@property (nonatomic, strong) NSMutableArray *arregloDescripcionImagenGaleria;
@property (nonatomic, strong) NSMutableArray *arregloTipoImagenGaleria;

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
@property (nonatomic, strong) NSMutableArray *imgGaleriaArray;
@property (nonatomic, strong) NSDate* fechaConsulta;

@property (nonatomic, strong) NSMutableArray *arregloVisitas;
@property (nonatomic, strong) NSMutableArray *arregloVisitantes;
// FECHAS PARA EL DOMINIO TEL Y RECURSO //
@property (nonatomic, strong) NSString *fechaDominioIni;
@property (nonatomic, strong) NSString *fechaDominioFin;

@property (nonatomic, strong) NSString * fechaInicial;
@property (nonatomic, strong) NSString * fechaFinal;



@property (nonatomic, strong) NSString * plantilla;
// PARA PROMOCIONES //
@property (nonatomic, strong) NSString *urlPromocion;
@property (nonatomic, strong) OffertRecord *promocionActual;

@property (nonatomic, strong) PagoModel *datosPago;

@property (nonatomic) NSInteger codigoError;
@property (nonatomic, strong) NSString *codigoRedimir;
@property (nonatomic) NSInteger vistaOrigen;

@property (nonatomic, strong) NSString *redSocial;
@property (nonatomic, strong) NSString *descripcionDominio;

@property (nonatomic, strong) NSString *nombreTemplate;

@property (nonatomic, strong) NSString *logoImg;

// Propiedades para el guardado de sesiones sin login //
@property (nonatomic, strong) NSString *auxStrSesionUser;
@property (nonatomic, strong) NSString *auxStrSesionPass;
@property (nonatomic) NSInteger auxSesionFacebook;
// ESTAS PROPIEDADES LAS USO PARA PUBLICAR //
@property (nonatomic, strong) NSString *tipoDeUsuario;
@property (nonatomic, strong) NSString *canal;
@property (nonatomic, strong) NSString *campania;

//// ESTAS SON LAS VARIABLES PARA CONSULTA DE USUARIO ///////

@property (nonatomic, strong) NSString *consultaStatusCtrlDominio;
@property (nonatomic, strong) NSString *consultaidDomain;
@property (nonatomic, strong) NSString *consultaFechaCtrlIni;
@property (nonatomic, strong) NSString *consultaVigente;
@property (nonatomic, strong) NSString *consultaidCtrlDomain;
@property (nonatomic, strong) NSString *consultaFechaCtrlFin;
@property (nonatomic, strong) NSString *consultaDomainType;
@property (nonatomic, strong) NSString *consultaDomainName;
@property (nonatomic, strong) NSString *consultaLista;

// COMPRA .TEL
@property (nonatomic, strong) NSString *voyAComprarTel;

+ (id)sharedInstance;

- (id)initWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)automat;

- (void)copiaPropiedades:(DatosUsuario *) datosOrigen;
-(void) eliminarDatos;

@end
