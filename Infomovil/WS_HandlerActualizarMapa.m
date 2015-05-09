//
//  WS_HandlerActualizarMapa.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerActualizarMapa.h"

@implementation WS_HandlerActualizarMapa

-(void) actualizarMapa {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateInserLocRecord>"
                     "<domainId>%@</domainId>"
                     "<localizacionVO>"
                     "<latitudeLoc>%@</latitudeLoc>"
                     "<longitudeLoc>%@</longitudeLoc>"
                     "</localizacionVO>"
                     "<token>%@</token>"
                     "</ws:updateInserLocRecord>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datosUsuario.idDominio] conToken:datosUsuario.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%f", self.location.coordinate.latitude] conToken:datosUsuario.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] conToken:datosUsuario.token],
                     [StringUtils encriptar:datosUsuario.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateInserLocRecord>"
                     "<domainId>%li</domainId>"
                     "<localizacionVO>"
                     "<latitudeLoc>%f</latitudeLoc>"
                     "<longitudeLoc>%f</longitudeLoc>"
                     "</localizacionVO>"
                     "</ws:updateInserLocRecord>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", (long)datosUsuario.idDominio, self.location.coordinate.latitude, self.location.coordinate.longitude];
    }
    
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"WS_ActualizarMapa La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datosUsuario = [DatosUsuario sharedInstance];
                datosUsuario.token = self.token;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datosUsuario.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.mapaDelegate errorToken];
                }
                else {
                    datosUsuario.localizacion = self.location;
                    [self.mapaDelegate resultadoConsultaDominio:stringResult];
                }
            }
            else {
                [self.mapaDelegate resultadoConsultaDominio:self.resultado];
            }
        }
        else {
            [self.mapaDelegate errorConsultaWS];
        }
    }
    else {
        [self.mapaDelegate errorConsultaWS];
    }
}

-(void) borrarMapa {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteLocRecord>"
                     "<domainId>%@</domainId>"
                     "<token>%@</token>"
                     "</ws:deleteLocRecord>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datosUsuario.idDominio] conToken:datosUsuario.token],
                     [StringUtils encriptar:datosUsuario.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteLocRecord>"
                     "<domainId>%li</domainId>"
                     "</ws:deleteLocRecord>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", (long)datosUsuario.idDominio];
    }
    
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datosUsuario = [DatosUsuario sharedInstance];
                datosUsuario.token = self.token;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datosUsuario.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.mapaDelegate errorToken];
                }
                else {
                    datosUsuario.localizacion = nil;
                    [self.mapaDelegate resultadoConsultaDominio:stringResult];
                }
				
            }
            else {
                [self.mapaDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.mapaDelegate errorConsultaWS];
        }
    }
    else {
        [self.mapaDelegate errorConsultaWS];
    }
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.mapaDelegate errorConsultaWS];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"resultado"]) {
        self.currentElementString = @" ";
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = @" ";
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = self.currentElementString;
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
    }
}

@end
