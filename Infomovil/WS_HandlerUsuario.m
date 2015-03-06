//
//  WS_HandlerUsuario.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 25/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerUsuario.h"

@implementation WS_HandlerUsuario

-(void) consultaUsuario:(NSString *)usuario {
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:getExistUser>"
                     "<userName>%@</userName>"
                     "</ws:getExistUser>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", [StringUtils encriptar:usuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:getExistUser>"
                     "<userName>%@</userName>"
                     "</ws:getExistUser>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", usuario];
    }
    
    NSLog(@"La peticion es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
				//datos.emailUsuario = usuario;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wsHandlerDelegate errorToken];
                }else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wsHandlerDelegate sessionTimeout];
                else {
                    self.resultado = stringResult;
                    [self.wsHandlerDelegate resultadoConsultaDominio:self.resultado];
                }
                
            }
            else {
                [self.wsHandlerDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.wsHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wsHandlerDelegate errorConsultaWS];
    }
    
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.wsHandlerDelegate errorConsultaWS];
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"resultado"]) { //consulta de dominio
        self.currentElementString = [[NSString alloc] init];
    }
    if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = [[NSString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = self.currentElementString;
    }
    if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
    }
    
}

@end
