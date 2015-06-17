//
//  WS_RedimirCodigo.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/15/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import "DominiosUsuario.h"
#import "ItemsDominio.h"


@interface WS_RedimirCodigo : WS_Handler<WS_HandlerProtocol, NSXMLParserDelegate>
{
    DominiosUsuario *dominioUsuario;
    BOOL esRecurso;
    ItemsDominio *itemDominio;
}
@property (nonatomic, weak) id<WS_HandlerProtocol> redimirCodigoDelegate;
@property (nonatomic, strong) DatosUsuario *datosUsuario;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) NSString * codeCampania;
@property (nonatomic, strong) NSMutableArray *arregloDominiosUsuario;
-(void) redimeElCodigo:(NSString *)codigo;

@end
