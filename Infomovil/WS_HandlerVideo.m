//
//  WS_HandlerVideo.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerVideo.h"
#import "NSStringUtiles.h"

@implementation WS_HandlerVideo

-(void) eliminarVideo {
    DatosUsuario *usuario = [DatosUsuario sharedInstance];
    
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteVideo>"
                     "<idDomain>%@</idDomain>"
                     "<token>%@</token>"
                     "</ws:deleteVideo>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", usuario.idDominio] conToken:usuario.token],
                     [StringUtils encriptar:usuario.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteVideo>"
                     "<idDomain>%i</idDomain>"
                     "</ws:deleteVideo>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", usuario.idDominio];
    }
    
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                usuario = [DatosUsuario sharedInstance];
                usuario.token = self.token;
                [self.videoDelegate resultadoConsultaDominio:[StringUtils desEncriptar:self.resultado conToken:self.token]];
            }
            else {
                [self.videoDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.videoDelegate errorConsultaWS];
        }
    }
    else {
        [self.videoDelegate errorConsultaWS];
    }
}

-(void) insertarVideo {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertVideo>"
                     "<idDomain>%@</idDomain>"
                     "<url>%@</url>"
                     "<token>%@</token>"
                     "</ws:insertVideo>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", datosUsuario.idDominio] conToken:datosUsuario.token],
                     [StringUtils encriptar:datosUsuario.urlVideo conToken:datosUsuario.token],
                     [StringUtils encriptar:datosUsuario.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertVideo>"
                     "<idDomain>%i</idDomain>"
                     "<url>%@</url>"
                     "</ws:insertVideo>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", datosUsuario.idDominio, datosUsuario.urlVideo];
    }
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:[NSString codificaHtml:stringXML] conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datosUsuario = [DatosUsuario sharedInstance];
                datosUsuario.token = self.token;
                [self.videoDelegate resultadoConsultaDominio:[StringUtils desEncriptar:self.resultado conToken:datosUsuario.token]];
            }
            else {
                [self.videoDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.videoDelegate errorConsultaWS];
        }
    }
    else {
        [self.videoDelegate errorConsultaWS];
    }
}

//-(void) insertarVideo:(VideoModel *) videoSeleccionado {
////    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
////    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
////                           "<soapenv:Header/>"
////                           "<soapenv:Body>"
////                           "<ws:insertVideo>"
////                           "<idDomain>%@</idDomain>"
////                           "<VideoVO>"
////                           "<descripcion>%@</descripcion>"
////                           "<proveedor>%@</proveedor>"
////                           "<titulo>?</titulo>"
////                           "<video>?</video>"
////                           "</VideoVO>"
////                           "<token>?</token>"
////                           "</ws:insertVideo>"
////                           "</soapenv:Body>"
////                           "</soapenv:Envelope>", [StringUtils encriptar:@"329" conToken:datosUsuario.token],
////                           [StringUtils encriptar:@"Probando titulo de video" conToken:datosUsuario.token],
////                           [StringUtils encriptar:@"1" conToken:datosUsuario.token]];
//}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.videoDelegate errorConsultaWS];
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