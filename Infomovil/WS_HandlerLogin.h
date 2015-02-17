//
//  WS_HandlerLogin.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "Contacto.h"
#import "GaleriaImagenes.h"
#import "WS_HandlerProtocol.h"
#import "OffertRecord.h"

@interface WS_HandlerLogin : WS_Handler <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableString *currentElementString;
@property (nonatomic, strong) DatosUsuario *datosUsuario;
@property (nonatomic, strong) Contacto *contactoActual;
@property (nonatomic, strong) NSMutableArray *arregloContactos;
//@property (nonatomic, strong) NSMutableDictionary *diccionarioPromocion;
@property (nonatomic, strong) GaleriaImagenes *galeria;
@property (nonatomic, strong) NSMutableArray *arregloImagenes;
@property (nonatomic, strong) id<WS_HandlerProtocol> loginDelegate;
@property (nonatomic) NSInteger idDominio;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) OffertRecord *promocionElegida;
@property (nonatomic, strong) NSString *redSocial;


-(void) obtieneLogin:(NSString *)usuario conPassword:(NSString *)password;

@end
