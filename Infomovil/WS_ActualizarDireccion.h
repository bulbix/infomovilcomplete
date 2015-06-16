//
//  WS_ActualizarDireccion.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import "KeywordDataModel.h"

@interface WS_ActualizarDireccion : WS_Handler

@property (nonatomic, weak) id<WS_HandlerProtocol> direccionDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *posActualizar;
@property (nonatomic, strong) NSString *idDominio;


@property (nonatomic, strong) NSMutableArray *arregloPerfil;
@property NSInteger idPerfil;
@property NSInteger indexSeleccionado;
@property NSInteger tipoInfo;

@property (nonatomic, strong) NSMutableArray *arregloDireccion;

-(void) actualizarDireccion;
-(void) insertarDireccion;
-(void) actualizarInformacion;
-(void) actualizarPerfil;
-(void) actualizarElementoPerfil:(KeywordDataModel*) keywordModel;
-(void) insertarPerfil:(NSInteger) indicePerfil;
-(void) insertarInformacion;
-(void) eliminarKeywordConId:(NSInteger) idKeyword;

@end
