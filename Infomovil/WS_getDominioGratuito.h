//
//  getDominioGratuito.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/30/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import "catalogoDominiosGratuitos.h"
#import "DatosUsuario.h"

@interface getDominioGratuito : WS_Handler<WS_HandlerProtocol, NSXMLParserDelegate>
{
    
}



@property (nonatomic, weak) id<WS_HandlerProtocol> dominioGratuitoDelegate;
@property (nonatomic, strong) DatosUsuario *datosUsuario;
@property (nonatomic, strong) catalogoDominiosGratuitos *dominiosGratuitosCatalogo;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) NSMutableArray * arrayAuxDominios;

-(void) getDominiosGratuitos;


@end
