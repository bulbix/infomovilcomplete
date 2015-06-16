//
//  WS_HandlerUsuario.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 25/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
@interface WS_HandlerUsuario : WS_Handler <NSXMLParserDelegate>

@property (nonatomic, weak) id<WS_HandlerProtocol> wsHandlerDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *token;

-(void) consultaUsuario:(NSString *)usuario;



@end
