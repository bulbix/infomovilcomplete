//
//  WS:ItemsDominio.h
//  Infomovil
//
//  Created by Ivan Peña on 08/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"

@interface WS_ItemsDominio : WS_Handler <WS_HandlerProtocol, NSXMLParserDelegate>

@property (nonatomic, weak) id<WS_HandlerProtocol> itemsDominioDelegate;
@property (nonatomic, strong) NSString *currentElementString;

-(void)actualizarItemsDominio;

@end
