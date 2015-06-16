//
//  WS_HandlerCambiarPassword.h
//  Infomovil
//
//  Created by Ivan Peña on 27/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"

@interface WS_HandlerCambiarPassword : WS_Handler <WS_HandlerProtocol, NSXMLParserDelegate>

@property (nonatomic, weak) id<WS_HandlerProtocol> cambiarPasswordDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;

-(void) actualizaPassword;
-(void) actualizaPasswordConEmail:(NSString *) email;

@end
