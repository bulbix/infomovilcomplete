//
//  WS_HandlerPromocion.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import "OffertRecord.h"

@interface WS_HandlerPromocion : WS_Handler

@property (nonatomic, weak) id<WS_HandlerProtocol> promocionDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *urlPromocion;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) OffertRecord *oferta;

-(void) actualizaPromocion;
//-(void) actualizaPromocion:(NSMutableDictionary *)dictOferta paraUsuario:(NSString *)emailUsuario
//			  conDominioId:(NSInteger)idDominio conToken:(NSString *)tokenEncript;

-(void) eliminaPromocion;

@end
