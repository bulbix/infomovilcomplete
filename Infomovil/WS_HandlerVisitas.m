//
//  ws_HandlerVisitas.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 11/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerVisitas.h"
#import "StringUtils.h"

@interface WS_HandlerVisitas () {
    BOOL consultaVisitantes;
    BOOL consultaTotales;
}

@end

@implementation WS_HandlerVisitas

-(void) consultaVisitasDominio:(NSString* )dominio conOpcionConsulta:(NSInteger)opcionSeleccionada {
	DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:getEstadisticas>"
                           "<Domain>%@</Domain>"
                           "<TipoConsulta>%li</TipoConsulta>"
						   "<token>%@</token>"
                           "</ws:getEstadisticas>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>", [StringUtils encriptar:dominio conToken:datosUsuario.token], (long)opcionSeleccionada, [StringUtils encriptar:datosUsuario.emailUsuario conToken:passwordEncriptar]];
    consultaVisitantes = NO;
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        self.arregloVisitas = [[NSMutableArray alloc] init];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (self.token == nil) {
                [self.wSHandlerDelegate errorToken];
            }
            
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                datos.arregloVisitas = self.arregloVisitas;
                [self.wSHandlerDelegate resultadoConsultaDominio:@"Exito"];
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}

-(void) consultarVisitantesDominio:(NSString *)dominio {
	DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:getEstadisticas>"
                           "<Domain>%@</Domain>"
                           "<TipoConsulta>7</TipoConsulta>"
						   "<token>%@</token>"
                           "</ws:getEstadisticas>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>", [StringUtils encriptar:dominio conToken:datosUsuario.token],[StringUtils encriptar:datosUsuario.emailUsuario conToken:passwordEncriptar]];
    consultaVisitantes = YES;
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        self.arregloVisitas = [[NSMutableArray alloc] init];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (self.token == nil) {
                [self.wSHandlerDelegate errorToken];
            }
            
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                datos.arregloVisitantes = self.arregloVisitas;
                [self.wSHandlerDelegate resultadoConsultaDominio:@"Exito"];
            
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}

-(void) consultaVisitantesUnicosDominio:(NSString *)dominio {
	DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:getEstadisticas>"
                           "<Domain>%@</Domain>"
                           "<TipoConsulta>7</TipoConsulta>"
                           "<TipoConsulta>8</TipoConsulta>"
						   "<token>%@</token>"
                           "</ws:getEstadisticas>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>", [StringUtils encriptar:dominio conToken:datosUsuario.token],[StringUtils encriptar:datosUsuario.emailUsuario conToken:passwordEncriptar]];
    consultaVisitantes = YES;
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        self.arregloVisitas = [[NSMutableArray alloc] init];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (self.token == nil) {
                [self.wSHandlerDelegate errorToken];
            }
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                datos.arregloVisitantes = self.arregloVisitas;
                [self.wSHandlerDelegate resultadoConsultaDominio:@"Exito"];
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.wSHandlerDelegate errorConsultaWS];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.currentElemenString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"VisitasVO"]) {
        self.visitaActual = [[VisitasModel alloc] init];
    }
    else if ([elementName isEqualToString:@"descripcionVisitas"]) {
        self.currentElemenString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"fecha"]) {
        self.currentElemenString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"numeroFecha"]) {
        self.currentElemenString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"visitas"]) {
        self.currentElemenString = [[NSMutableString alloc] init];
    }
	else if ([elementName isEqualToString:@"token"]) {
        self.currentElemenString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"resultado"]) {
        self.currentElemenString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	self.datosUsuario = [DatosUsuario sharedInstance];
    if ([elementName isEqualToString:@"VisitasVO"]) {
        [self.arregloVisitas addObject:self.visitaActual];
    }
    else if ([elementName isEqualToString:@"descripcionVisitas"]) {
		if(requiereEncriptar){
			NSString *auxString = [StringUtils desEncriptar:self.currentElemenString conToken:self.datosUsuario.token];
			[self.visitaActual setDescripcion:auxString];
		}else{
			[self.visitaActual setDescripcion:self.currentElemenString];
		}
    }
    else if ([elementName isEqualToString:@"fecha"]) {
		if(requiereEncriptar){
			NSString *auxString = [StringUtils desEncriptar:self.currentElemenString conToken:self.datosUsuario.token];
			[self.visitaActual setFecha:auxString];
		}else{
			[self.visitaActual setFecha:self.currentElemenString];
		}
    }
    else if ([elementName isEqualToString:@"numeroFecha"]) {
		if(requiereEncriptar){
			NSString *auxString = [StringUtils desEncriptar:self.currentElemenString conToken:self.datosUsuario.token];
			[self.visitaActual setDia:[auxString integerValue]];
		}else{
			[self.visitaActual setDia:[self.currentElemenString integerValue]];
		}
    }
    else if ([elementName isEqualToString:@"visitas"]) {
		if(requiereEncriptar){
			NSString *auxString = [StringUtils desEncriptar:self.currentElemenString conToken:self.datosUsuario.token];
			[self.visitaActual setVisitas:[auxString integerValue]];
		}else{
			[self.visitaActual setVisitas:[self.currentElemenString integerValue]];
		}
    }
	else if ([elementName isEqualToString:@"token"]) {
        self.token  = [StringUtils desEncriptar:self.currentElemenString conToken:passwordEncriptar];
    } else if ([elementName isEqualToString:@"resultado"]){
        self.resultado = [StringUtils desEncriptar:self.currentElemenString conToken:passwordEncriptar];
    }
}

@end
