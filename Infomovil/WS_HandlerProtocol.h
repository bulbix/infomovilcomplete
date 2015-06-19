//
//  WS_HandlerProtocol.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 25/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WS_HandlerProtocol <NSObject>

@optional
-(void) resultadoConsultaDominio:(NSString *)resultado;
-(void) resultadoLogin:(NSInteger) idDominio;
-(void) resultadoInsertarDireccion:(NSString *) diccionarioID;
-(void) errorConsultaWS;
-(void) resultadoInformacionRegistro:(NSString *)resultado;
-(void) resultadoPassword:(NSString *)resultado;
-(void) itemsActualizados:(BOOL)estado;
-(void) resultadoCompraDominio:(BOOL)estado;
-(void) errorToken;

-(void) resultadoVideo:(NSMutableArray*)arregloVideos;
-(void) errorBusqueda;
-(void) resultadoRedimirCodigo:(NSString *)idDominio;
-(void) resultadoMovilizaSitio:(NSString *)resultado;
@end
