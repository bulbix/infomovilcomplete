//
//  WS_HandlerActualizarMapa.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"

@interface WS_HandlerActualizarMapa : WS_Handler

@property (nonatomic, strong) id<WS_HandlerProtocol> mapaDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) CLLocation *location;


-(void) actualizarMapa;
-(void) borrarMapa;

@end
