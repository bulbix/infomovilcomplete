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

-(void) actualizaPassword {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
	NSString *stringXML;
	if (requiereEncriptar) {
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
					 "<soapenv:Header/>"
					 "<soapenv:Body>"
					 "<ws:cambioPassword>"
					 "<Usuario>%@</Usuario>"
					 //"<dominio>%@</dominio>"
					 "<token>%@</token>"
					 "</ws:cambioPassword>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>",[StringUtils encriptar:datos.emailUsuario conToken:datos.token],
					 //[StringUtils encriptar:datos.dominio conToken:datos.token],
					 //[StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
					 [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
	}else{
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
					 "<soapenv:Header/>"
					 "<soapenv:Body>"
					 "<ws:cambioPassword>"
					 "<Usuario>%@</Usuario>"
					 //"<dominio>%@</dominio>"
					 "</ws:cambioPassword>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>",datos.emailUsuario];//,
					 //datos.dominio];
	}
    self.strSoapAction = @"WSInfomovilDomain";
	NSLog(@"La peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
			if(requiereEncriptar){
                datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.cambiarPasswordDelegate errorToken];
                }
                else {
                    [self.cambiarPasswordDelegate resultadoPassword:stringResult];
                }
			}else{
				[self.cambiarPasswordDelegate resultadoPassword:self.currentElementString];
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

-(void) actualizaPasswordConEmail:(NSString *) email {
    DatosUsuario *datos = nil;//[DatosUsuario sharedInstance];
	NSString *stringXML;
    stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                 "<soapenv:Header/>"
                 "<soapenv:Body>"
                 "<ws:cambioPassword>"
                 "<Usuario>%@</Usuario>"
                 "<token>%@</token>"
                 "</ws:cambioPassword>"
                 "</soapenv:Body>"
                 "</soapenv:Envelope>",[StringUtils encriptar:email conToken:passwordEncriptar],
                 [StringUtils encriptar:email conToken:passwordEncriptar]];

    self.strSoapAction = @"WSInfomovilDomain";
	NSLog(@"La peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse])
        {
            datos = [DatosUsuario sharedInstance];
            datos.token = self.token;
            //[self.cambiarPasswordDelegate resultadoPassword:[StringUtils desEncriptar:self.currentElementString conToken:datos.token]];
            NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
            if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                [self.cambiarPasswordDelegate errorToken];
            } 
            else {
                [self.cambiarPasswordDelegate resultadoPassword:stringResult];
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