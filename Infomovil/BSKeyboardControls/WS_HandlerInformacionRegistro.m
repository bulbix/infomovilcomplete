//
//  WS_HandlerInformacionRegistro.m
//  Infomovil
//
//  Created by Ivan Peña on 27/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerInformacionRegistro.h"

@implementation WS_HandlerInformacionRegistro

-(void) actualizaInformacionRegistro {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
	NSString *stringXML;
	if (requiereEncriptar) {
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
						   "<soapenv:Header/>"
						   "<soapenv:Body>"
						   "<ws:insertUpdateInfoUser>"
						   "<ListInfoUser>"
						   "<calleNum>%@</calleNum>"
						   "<canal>%@</canal>"
						   "<ciudad>%@</ciudad>"
						   "<correo>%@</correo>"
						   "<cp>%@</cp>"
						   "<estado>%@</estado>"
						   "<nameEmpresa>%@</nameEmpresa>"
						   "<nombre>%@</nombre>"
						   "<pais>%@</pais>"
						   "<poblacion>%@</poblacion>"
						   "<tel>%@</tel>"
						   "<userName>%@</userName>"
						   "</ListInfoUser>"
						   "<token>%@</token>"
						   "</ws:insertUpdateInfoUser>"
						   "</soapenv:Body>"
						   "</soapenv:Envelope>",[StringUtils encriptar:datos.calleNumero conToken:datos.token],
                           [StringUtils encriptar:@"0" conToken:datos.token],
                           [StringUtils encriptar:datos.ciudad conToken:datos.token],
                           [StringUtils encriptar:datos.email conToken:datos.token],
                           [StringUtils encriptar:datos.cp conToken:datos.token],
						   [StringUtils encriptar:datos.estado conToken:datos.token],
						   [StringUtils encriptar:datos.nombreOrganizacion conToken:datos.token],
						   [StringUtils encriptar:datos.servicioCliente conToken:datos.token],
						   [StringUtils encriptar:[datos.codigoPais stringByReplacingOccurrencesOfString:@"+" withString:@""] conToken:datos.token],
						   [StringUtils encriptar:datos.poblacion conToken:datos.token],
						   [StringUtils encriptar:datos.numeroMovil conToken:datos.token],
						   [StringUtils encriptar:datos.emailUsuario conToken:datos.token],
                           [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
	}else{
		
		
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
						   "<soapenv:Header/>"
						   "<soapenv:Body>"
						   "<ws:insertUpdateInfoUser>"
						   "<ListInfoUser>"
						   "<calleNum>%@</calleNum>"
						   "<canal>%@</canal>"
						   "<ciudad>%@</ciudad>"
						   "<correo>%@</correo>"
						   "<cp>%@</cp>"
						   "<estado>%@</estado>"
						   "<nameEmpresa>%@</nameEmpresa>"
						   "<nombre>%@</nombre>"
						   "<pais>%@</pais>"
						   "<poblacion>%@</poblacion>"
						   "<tel>%@</tel>"
						   "<userName>%@</userName>"
						   "</ListInfoUser>"
						   "</ws:insertUpdateInfoUser>"
						   "</soapenv:Body>"
						   "</soapenv:Envelope>",datos.calleNumero,
						   @"0",
                           datos.ciudad,
                           datos.email,
                           datos.cp,
						   datos.estado,
						   datos.nombreOrganizacion,
						   datos.servicioCliente,
						   [datos.codigoPais stringByReplacingOccurrencesOfString:@"+" withString:@""],
						   datos.poblacion,
						   datos.numeroMovil,
						   datos.emailUsuario];
	}
    self.strSoapAction = @"WSInfomovilDomain";
	NSLog(@"La peticion es %@, %@", stringXML,datos.nombreOrganizacion);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
			if(requiereEncriptar){
                datos = [DatosUsuario sharedInstance];
                NSString *stringResult = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.informacionRegistroDelegate errorToken];
                }
                else {
                    [self.informacionRegistroDelegate resultadoInformacionRegistro:stringResult];
                }
			}else{
				[self.informacionRegistroDelegate resultadoInformacionRegistro:self.currentElementString];
			}
        }
        else {
            [self.informacionRegistroDelegate errorConsultaWS];
        }
    }
    else {
        [self.informacionRegistroDelegate errorConsultaWS];
    }
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.informacionRegistroDelegate errorConsultaWS];
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
