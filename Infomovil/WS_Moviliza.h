//
//  WS_Moviliza.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/18/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"

@interface WS_Moviliza : WS_Handler<WS_HandlerProtocol, NSXMLParserDelegate>
{

}


@property (nonatomic, weak) id<WS_HandlerProtocol> movilizaSitioDelegate;
@property (nonatomic, strong) DatosUsuario *datosUsuario;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString * result;


-(void) moviliza:(NSString *)strMoviliza;


@end
