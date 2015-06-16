//
//  WS_HandlerDominio.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 18/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"



@interface WS_HandlerDominio : WS_Handler <NSXMLParserDelegate>

@property (nonatomic, weak) id<WS_HandlerProtocol> wSHandlerDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *resultadoDominio;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *devToken;
@property (nonatomic, strong) NSString *telIni;
@property (nonatomic, strong) NSString *telFin;
@property (nonatomic, strong) NSString *fechaInicio;
@property (nonatomic, strong) NSString *fechaFinal;

@property (nonatomic, strong) DatosUsuario *datos;

-(void) consultaDominio:(NSString *)dominio;
-(void) consultaDominioCompra:(NSString *)dominio;

-(void) crearUsuario:(NSString *)email conNombre:(NSString *)user password:(NSString *)pass status:(NSString *)s nombre:(NSString *)nom direccion1:(NSString *)dir1 direccion2:(NSString *)dir2 pais:(NSString *) nPais codigoPromocion:(NSString *)codProm tipoDominio:(NSString *)domainType idDominio:(NSString *)idDominio emailPubli:(NSString *)emailPublicar;

@property (nonatomic, strong) NSMutableArray *arregloDominios;

//-(void) redimirCodigo:(NSString *)codProm;

	
-(void) consultaVisitasDominio;
-(void) consultaExpiracionDominio;
-(void) cancelarCuenta:(NSString *)motivo;
-(void) consultaSession:(NSString *) usuario;
-(void) cerrarSession:(NSString *) usuario;
-(void) consultaEstatusDominio;

@end
