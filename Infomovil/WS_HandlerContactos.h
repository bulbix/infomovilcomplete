//
//  WS_HandlerContactos.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 04/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import "ListaTelefonosViewController.h"
@class Contacto;

//typedef enum {
//    ContactosOperacionBorrar,
//    ContactosOperacionActualizar,
//    ContactosOperacionInsertar
//}ContactosOperacion;

@interface WS_HandlerContactos : WS_Handler

@property (nonatomic, weak) id<WS_HandlerProtocol> contactosDelegate;
@property (nonatomic) ContactosOperacion idOperacion;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSMutableArray *arregloContactos;

-(void) actualizaContacto:(NSInteger) idContacto contactosOperacion:(ContactosOperacion)operacion;
-(void) insertarContacto;
-(void) actualizarEstatusContacto;
-(void) actualizaConContacto:(Contacto *)contactoSel;
-(void) eliminarContacto:(NSInteger) idContacto;

@end
