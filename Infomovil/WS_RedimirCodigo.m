//
//  WS_RedimirCodigo.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/15/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_RedimirCodigo.h"


@implementation WS_RedimirCodigo


-(void)redimeElCodigo:(NSString *)codigo{

    self.datosUsuario = [DatosUsuario sharedInstance];
    NSString * aux = nil;
    if([self.datosUsuario.email length]>0 && ![self.datosUsuario.email isEqualToString:@""] && self.datosUsuario.email != nil){
        self.datosUsuario.emailUsuario = self.datosUsuario.email;
        aux = self.datosUsuario.email;
    }else{
        self.datosUsuario.email = self.datosUsuario.emailUsuario;
        aux = self.datosUsuario.emailUsuario;
    }
    
    NSString *  stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<ws:insertUserCam>"
                             "<UserDomainVO>"
                             "<email>%@</email>"
                             "<phone></phone>"
                             "<password>%@</password>"
                             "<domainName>%@</domainName>"
                             "<status></status>"
                             "<sistema></sistema>"
                             "<typoDispositivo></typoDispositivo>"
                             "<notificacion></notificacion>"
                             "<tipoAction></tipoAction>"
                             "<pais></pais>"
                             "<canal></canal>"
                             "<sucursal></sucursal>"
                             "<folio></folio>"
                             "<nombre></nombre>"
                             "<direccion1></direccion1>"
                             "<direccion2></direccion2>"
                             "<nPais></nPais>"
                             "<codigoCamp>%@</codigoCamp>"
                             "<domainType></domainType>"
                             "<idDominio></idDominio>"
                             "<emailTel></emailTel>"
                             "</UserDomainVO>"
                             "</ws:insertUserCam>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>",
                 [StringUtils encriptar:aux conToken:passwordEncriptar],
                           [StringUtils encriptar:@"" conToken:self.datosUsuario.token],
                 [StringUtils encriptar:self.datosUsuario.dominio conToken:self.datosUsuario.token],
                
                [StringUtils encriptar:codigo conToken:self.datosUsuario.token]
                 ];
    NSLog(@"Los valores enviados son : %@   -   %@    -   %@   - %@" , aux, self.datosUsuario.dominio, codigo, self.datosUsuario.token);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en redimirCodigo WS_RedimirCodigo %s", [dataResult bytes]);
if (dataResult != nil) {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
    [parser setDelegate:self];
    dominioUsuario = [[DominiosUsuario alloc] init];
    self.arregloDominiosUsuario = [[NSMutableArray alloc] init];
    if ([parser parse]) {
        if ([self.arregloDominiosUsuario count] > 0) {
            self.datosUsuario.dominiosUsuario = self.arregloDominiosUsuario;
        }
        else {
            dominioUsuario = [[DominiosUsuario alloc] init];
        }
        
        if([self.result isEqualToString:@""] || [self.result length] <= 0 || self.result == nil ){
            [self.redimirCodigoDelegate resultadoRedimirCodigo:@"Error"];
        }else{
            [self.redimirCodigoDelegate resultadoRedimirCodigo:self.result];
        }
        
        
    }else {
        [self.redimirCodigoDelegate errorConsultaWS];
    }
}else {
    [self.redimirCodigoDelegate errorConsultaWS];
}

}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"codeError"]) {
     self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"token"]) {
       self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"resultado"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@""]) {
        self.currentElementString = [[NSMutableString alloc] init];
    } else if ([elementName isEqualToString:@"listUsuarioDominiosVO"]) {
        dominioUsuario = [[DominiosUsuario alloc] init];
    }
    else if ([elementName isEqualToString:@"domainCtrlName"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"domainType"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"fechaCtrlFin"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"fechaCtrlIni"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"vigente"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"idCtrlDomain"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"idDomain"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"statusCtrlDominio"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"listStatusDomainVO"]) {
        itemDominio = [[ItemsDominio alloc] init];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"descripcionItem"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"status"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"codeError"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.direccionDelegate errorConsultaWS];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"resultado"]) {
       // self.result = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
       // NSLog(@"1.- resultado: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"codeError"]) {
            self.result = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        if([self.result isEqualToString:@""] || [self.result length] <= 0 || self.result == nil ){
            self.result = [StringUtils desEncriptar:self.currentElementString conToken:self.datosUsuario.token];
        }
            NSLog(@"13.- codeError es: %@ y token: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token], self.token);
    }else if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
        if([self.token length]>0 && ![self.token isEqualToString:@""] && self.token != nil){
            self.datosUsuario.token = self.token;
        }
        NSLog(@"11.- token es: %@ y desencriptado es: %@ el string es: %@", self.token, [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar], self.currentElementString);
    }else if ([elementName isEqualToString:@"listUsuarioDominiosVO"]) {
        if (esRecurso) {
            [self.arregloDominiosUsuario insertObject:dominioUsuario atIndex:0];
        }
        else {
            [self.arregloDominiosUsuario addObject:dominioUsuario];
        }
       
    }else if ([elementName isEqualToString:@"domainCtrlName"]) {
        [dominioUsuario setDomainName:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
         NSLog(@"2.- domainCtrlName: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"domainType"]) {
        NSString *typeAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        if ([typeAux isEqualToString:@"recurso"]) {
            esRecurso = YES;
        }
        else {
            esRecurso = NO;
        }
        NSLog(@"3.- domainType: %@", typeAux);
        [dominioUsuario setDomainType:typeAux];
    }else if ([elementName isEqualToString:@"vigente"]) {
        NSString *typeAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setVigente:typeAux];
         NSLog(@"4.- vigente: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"fechaCtrlFin"]) {
        NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setFechaFin:auxOffer];
         NSLog(@"5.- fechaCtrlFin: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"fechaCtrlIni"]) {
        NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setFechaIni:auxOffer];
        NSLog(@"6.- fechaCtrlIni: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"idCtrlDomain"]) {
        NSString *strAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setIdCtrlDomain:[strAux integerValue]];
          NSLog(@"7.- idCtrlDomain: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"statusCtrlDominio"]) {
        [dominioUsuario setStatusDominio:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
         NSLog(@"8.- statusCtrlDominio: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"status"]) {
            itemDominio.estatus = [[StringUtils desEncriptar:self.currentElementString conToken:self.token] integerValue];
        NSLog(@"9.- status: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    } else if ([elementName isEqualToString:@"descripcionItem"]) {
            itemDominio.descripcionItem = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
            NSLog(@"10.- descripcionItem: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }
}









@end
