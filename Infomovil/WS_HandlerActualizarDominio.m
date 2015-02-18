//
//  WS_HandlerActualizarDominio.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerActualizarDominio.h"

@implementation WS_HandlerActualizarDominio

-(void) actualizarDominio:(NSString *)metodo
{
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:%@>"
                     "<DomainVO>"
                     "<colour>%@</colour>"
                     "<displayString>%@</displayString>"
                     "<domainName>%@</domainName>"
                     "<textRecord>%@</textRecord>"
                     "</DomainVO>"
                     "<idDomain>%@</idDomain>"
                     "<token>%@</token>"
                     "</ws:%@>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",metodo, [StringUtils encriptar:[StringUtils hexFromUIColor:datos.colorSeleccionado] conToken:datos.token],
                     [StringUtils encriptar:self.descripcion conToken:datos.token],
                     [StringUtils encriptar:datos.dominio conToken:datos.token],
                     [StringUtils encriptar:self.nombre conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar],metodo];
    }
//    else {
//        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
//                     "<soapenv:Header/>"
//                     "<soapenv:Body>"
//                     "<ws:updateDomain>"
//                     "<DomainVO>"
//                     "<colour>%@</colour>"
//                     "<displayString>%@</displayString>"
//                     "<domainName>%@</domainName>"
//                     "<textRecord>%@</textRecord>"
//                     "</DomainVO>"
//                     "<idDomain>%i</idDomain>"
//                     "</ws:updateDomain>"
//                     "</soapenv:Body>"
//                     "</soapenv:Envelope>", [StringUtils hexFromUIColor:datos.colorSeleccionado], self.descripcion, datos.dominio, self.nombre, datos.idDominio];
//    }
    
    self.strSoapAction = @"WSInfomovilDomain";
     NSLog(@"La peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"WS_HandlerActualizarDominio La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
                if ( [metodo isEqualToString:k_UPDATE_TITULO] )
                    datos.nombreEmpresa = self.nombre;
                else if ( [metodo isEqualToString:k_UPDATE_DESC_CORTA] )
                    datos.descripcion = self.descripcion;
                
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                    [self.actualizarDominioDelegate errorToken];
                } else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.actualizarDominioDelegate sessionTimeout];
                else {
                    [self.actualizarDominioDelegate resultadoConsultaDominio:stringResult];
                }
                
            }
            else {
                [self.actualizarDominioDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.actualizarDominioDelegate errorConsultaWS];
        }
    }
    else {
        [self.actualizarDominioDelegate errorConsultaWS];
    }
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.actualizarDominioDelegate errorConsultaWS];
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
