//
//  DatosUsuario.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 21/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "DatosUsuario.h"
#import "StringUtils.h"

#define strKey @"DatosUsuario"

@implementation DatosUsuario

+(id) sharedInstance {
    static DatosUsuario *datosUsuario = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        datosUsuario = [[DatosUsuario alloc] initWithContentsOfFile:@"datos.plist"];
    });
    return datosUsuario;
}

-(id) initWithContentsOfFile:(NSString *)path {
    if (self = [super init]) {
        NSString *pathDocuments = [StringUtils pathForDocumentsDirectory];
        NSData *data = [[NSData alloc] initWithContentsOfFile:[pathDocuments stringByAppendingPathComponent:path]];
        if (data) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            DatosUsuario *datosOrigen = [unarchiver decodeObjectForKey:strKey];
            [unarchiver finishDecoding];
            [self copiaPropiedades:datosOrigen];
        }
    }
    return self;
}

-(BOOL)writeToFile:(NSString *)path atomically:(BOOL)automat {
    BOOL exito;
    NSString *pathDocuments = [StringUtils pathForDocumentsDirectory];
    NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self forKey:strKey];
	[archiver finishEncoding];
	exito = [data writeToFile:[pathDocuments stringByAppendingPathComponent:path] atomically:automat];
    return exito;
}



-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    

    self.emailUsuario = [aDecoder decodeObjectForKey:@"emailUsuario"];
    self.numeroUsuario = [aDecoder decodeObjectForKey:@"numeroUsuario"];
    self.passwordUsuario = [aDecoder decodeObjectForKey:@"passUsuario"];
    self.existeLogin = [aDecoder decodeBoolForKey:@"existeLogin"];
 
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.emailUsuario forKey:@"emailUsuario"];
    [aCoder encodeObject:self.numeroUsuario forKey:@"numeroUsuario"];
    [aCoder encodeObject:self.passwordUsuario forKey:@"passUsuario"];
	[aCoder encodeBool:self.existeLogin forKey:@"existeLogin"];
   
}

-(void)copiaPropiedades:(DatosUsuario *) datosOrigen {

    self.emailUsuario = datosOrigen.emailUsuario;
    self.numeroUsuario = datosOrigen.numeroUsuario;
    self.passwordUsuario = datosOrigen.passwordUsuario;
	self.existeLogin = datosOrigen.existeLogin;

}

-(void) eliminarDatos {
    self.nombreEmpresa = Nil;
    self.descripcion = Nil;
    self.colorSeleccionado = Nil;
    self.pathFondo = Nil;
    self.eligioTemplate = NO;
    self.direccion = Nil;
    self.arregloEstatusEdicion = Nil;
    self.arregloEstatusPromocion = Nil;
    self.rutaImagenPromocion = Nil;
    self.promocionActual = Nil;
    self.arregloGaleriaImagenes = Nil;
    self.arregloContacto = Nil;
    self.arregloEstatusPerfil = Nil;
    self.arregloDatosPerfil = Nil;
    self.arregloInformacionAdicional = Nil;
    self.emailUsuario = Nil;
    self.numeroUsuario = Nil;
    self.passwordUsuario = Nil;
	self.existeLogin = NO;
    self.dominio = Nil;
    self.localizacion = Nil;
    self.videoSeleccionado = Nil;
    self.publicoSitio = NO;
    self.nombroSitio = NO;
    self.idDominio = NO;
    self.existeLogin = NO;
    self.imagenLogo = NO;
    self.editoPagina = NO;
	self.tipoRegistro = NO;
	self.nombreOrganizacion = Nil;
	self.servicioCliente = Nil;
	self.numeroMovil = Nil;
	self.email = Nil;
	self.calleNumero = Nil;
	self.poblacion = Nil;
	self.ciudad = Nil;
	self.estado = Nil;
	self.cp = Nil;
	self.pais = Nil;
	self.codigoPais = Nil;
    self.urlVideo = Nil;
    self.fechaConsulta = Nil;
	self.fechaInicial = Nil;
	self.fechaFinal = Nil;
    self.fechaDominioIni = nil;
    self.fechaDominioFin = nil;
    self.descripcionDominio = Nil;
    self.plantilla = Nil;
    self.imgGaleriaArray = Nil;
    self.auxStrSesionUser = Nil;
    self.auxStrSesionPass = Nil;
    self.urlPromocion = Nil;
    self.nombreTemplate = Nil;
    self.redSocial = Nil;
    self.tipoDeUsuario = Nil;
    self.canal = Nil;
    self.campania = Nil;
    self.consultaStatusCtrlDominio = Nil;
    self.consultaidDomain = Nil;
    self.consultaFechaCtrlIni = Nil;
    self.consultaVigente = Nil;
    self.consultaidCtrlDomain = Nil;
    self.consultaFechaCtrlFin = Nil;
    self.consultaDomainType = Nil;
    self.consultaDomainName = Nil;
    self.consultaLista = Nil;
    self.arregloGaleriaImagenes = Nil;

    self.arregloUrlImagenes = Nil;
    self.arregloDescripcionImagen = Nil;
    self.arregloIdImagen = Nil;
    self.arregloTipoImagen = nil;
    
    self.arregloUrlImagenesGaleria = Nil;
    self.arregloTipoImagenGaleria = Nil;
    self.arregloIdImagenGaleria = Nil;
    self.arregloDescripcionImagenGaleria = Nil;
    
    
    
    
}

@end
