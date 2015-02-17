//
//  WS_HandlerInformacionRegistro.h
//  Infomovil
//
//  Created by Ivan Peña on 27/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"

@interface WS_HandlerInformacionRegistro : WS_Handler <WS_HandlerProtocol, NSXMLParserDelegate>

@property (nonatomic, strong) id<WS_HandlerProtocol> informacionRegistroDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;

-(void) actualizaInformacionRegistro;

@end
