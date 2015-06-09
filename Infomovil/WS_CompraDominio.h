//
//  WS_CompraDominio.h
//  Infomovil
//
//  Created by Ivan Peña on 25/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import <StoreKit/StoreKit.h>
//#import "DatosUsuario.h"

@interface WS_CompraDominio : WS_Handler <WS_HandlerProtocol, NSXMLParserDelegate>

@property (nonatomic, strong) id<WS_HandlerProtocol> compraDominioDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) DatosUsuario *datosUsuario;
@property (nonatomic, strong) SKPaymentTransaction *transaction;
@property (nonatomic, strong) NSMutableArray *arregloDominiosUsuario;
-(void) compraDominio;
-(void) compraDominioTel;
@end
