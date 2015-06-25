//
//  WS_HandlerCambiarPassword.m
//  Infomovil
//
//  Created by Ivan Peña on 27/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerCambiarPassword.h"
#import "AppDelegate.h"

@implementation WS_HandlerCambiarPassword



-(void) actualizaPasswordConEmail:(NSString *) email {
	NSString *stringXML;
    stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                 "<soapenv:Header/>"
                 "<soapenv:Body>"
                 "<ws:generaHashCambioPassword>"
                 "<email>%@</email>"
                 "</ws:generaHashCambioPassword>"
                 "</soapenv:Body>"
                 "</soapenv:Envelope>",email];

    self.strSoapAction = @"WSInfomovilDomain";
	NSLog(@"La peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse])
        {
            
            if([self.code isEqualToString: @"0"]){
                [self.cambiarPasswordDelegate resultadoPassword:self.resultado];
            }else{
                [self.cambiarPasswordDelegate resultadoPassword:self.code];
            }
            
            
        }
        else {
            [self.cambiarPasswordDelegate errorConsultaWS];
        }
    }
    else {
        [self.cambiarPasswordDelegate errorConsultaWS];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.cambiarPasswordDelegate errorConsultaWS];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"resultado"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"codeError"]) {
       self.currentElementString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = self.currentElementString;
        NSLog(@"EL RESULTADO ES: %@", self.resultado);
    }
    else if ([elementName isEqualToString:@"codeError"]) {
        self.code = self.currentElementString;
        NSLog(@"EL CODIGO ES: %@", self.code);
    }
}

@end