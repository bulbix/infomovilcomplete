//
//  ws_HandlerVisitas.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 11/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import "VisitasModel.h"

#define k_dia 1
#define k_semana 2
#define k_mes 3
#define k_3meses 4
#define k_6mese 5
#define k_year 6

@interface WS_HandlerVisitas : WS_Handler <NSXMLParserDelegate>

@property (nonatomic) NSInteger opcionSeleccionada;
@property (nonatomic, strong) id<WS_HandlerProtocol> wSHandlerDelegate;
@property (nonatomic, strong) NSMutableString *currentElemenString;
@property (nonatomic, strong) VisitasModel *visitaActual;
@property (nonatomic, strong) NSMutableArray *arregloVisitas;
@property (nonatomic, strong) DatosUsuario *datosUsuario;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;

-(void) consultaVisitasDominio:(NSString *)dominio conOpcionConsulta:(NSInteger)opcionSeleccionada;
-(void) consultarVisitantesDominio:(NSString *)dominio;
-(void) consultaVisitantesUnicosDominio:(NSString *)dominio;

@end
