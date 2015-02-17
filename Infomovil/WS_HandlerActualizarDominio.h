//
//  WS_HandlerActualizarDominio.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"


#define k_UPDATE_TITULO @"updateTextRecord"
#define k_UPDATE_DESC_CORTA @"updateDesCorta"
#define k_UPDATE_BACKGRUOUND @"updateColor"

@interface WS_HandlerActualizarDominio : WS_Handler <WS_HandlerProtocol, NSXMLParserDelegate>

@property (nonatomic, strong) id<WS_HandlerProtocol> actualizarDominioDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;

@property (nonatomic, strong) NSString *nombre;
@property (nonatomic, strong) NSString *descripcion;

-(void) actualizarDominio:(NSString *)metodo;

@end
