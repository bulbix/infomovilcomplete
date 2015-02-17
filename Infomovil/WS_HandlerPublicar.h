//
//  WS_HandlerPublicar.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 26/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"

@interface WS_HandlerPublicar : WS_Handler <NSXMLParserDelegate>

@property (nonatomic, strong) id<WS_HandlerProtocol> wsHandlerDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;
-(void) publicarDominio;

@end
