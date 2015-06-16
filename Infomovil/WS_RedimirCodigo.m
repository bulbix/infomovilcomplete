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
                 "<ws:getItemsGratisDomain/>"
                 "<UserDomainVO>"
                 "<email>%@</email>"
                 "<domainName>%@</domainName>"
                 "<password>%@</password>"
                 "<codigoCamp>%@</codigoCamp>"
                 "</UserDomainVO>"
                 "</soapenv:Body>"
                 "</soapenv:Envelope>",
                 [StringUtils encriptar:aux conToken:passwordEncriptar],
                 [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)self.datosUsuario.idDominio ] conToken:self.datosUsuario.token],
                [StringUtils encriptar:@"" conToken:self.datosUsuario.token],
                [StringUtils encriptar:codigo conToken:self.datosUsuario.token]
                 ];

    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
if (dataResult != nil) {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
    [parser setDelegate:self];
    if ([parser parse]) {
            NSInteger resultado = 0;
            [self.redimirCodigoDelegate resultadoRedimirCodigo:resultado];
        
    }else {
        [self.redimirCodigoDelegate errorConsultaWS];
    }
}else {
    [self.redimirCodigoDelegate errorConsultaWS];
}

}


    
    
    
  //  [self.redimirCodigoDelegate errorToken];

   // [self.redimirCodigoDelegate resultadoRedimirCodigo:1];



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"codeError"]) {
      self.currentElementString = [[NSString alloc] init];
    }else if ([elementName isEqualToString:@"token"]) {
       self.currentElementString = [[NSString alloc] init];
    }else if ([elementName isEqualToString:@"resultado"]) {
        self.currentElementString = [[NSString alloc] init];
    }else if ([elementName isEqualToString:@""]) {
        self.currentElementString = [[NSString alloc] init];
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
    else if ([elementName isEqualToString:@"codeCamp"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"resultado"]) {
        self.currentElementString = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
    }else if ([elementName isEqualToString:@"listUsuarioDominiosVO"]) {
        if (esRecurso) {
            [self.arregloDominiosUsuario insertObject:dominioUsuario atIndex:0];
        }
        else {
            [self.arregloDominiosUsuario addObject:dominioUsuario];
        }
    }else if ([elementName isEqualToString:@"domainCtrlName"]) {
        [dominioUsuario setDomainName:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }else if ([elementName isEqualToString:@"domainType"]) {
        NSString *typeAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        if ([typeAux isEqualToString:@"recurso"]) {
            esRecurso = YES;
        }
        else {
            esRecurso = NO;
        }
        NSLog(@"EL TIPO DE DOMINIO ES: %@", typeAux);
        [dominioUsuario setDomainType:typeAux];
    }else if ([elementName isEqualToString:@"vigente"]) {
        NSString *typeAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setVigente:typeAux];
    }else if ([elementName isEqualToString:@"fechaCtrlFin"]) {
        NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setFechaFin:auxOffer];
        
    }else if ([elementName isEqualToString:@"fechaCtrlIni"]) {
        NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setFechaIni:auxOffer];
        
    }else if ([elementName isEqualToString:@"idCtrlDomain"]) {
        NSString *strAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setIdCtrlDomain:[strAux integerValue]];
    }else if ([elementName isEqualToString:@"statusCtrlDominio"]) {
        [dominioUsuario setStatusDominio:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }else if ([elementName isEqualToString:@"status"]) {
        if (requiereEncriptar) {
            itemDominio.estatus = [[StringUtils desEncriptar:self.currentElementString conToken:self.token] integerValue];
        }
        else {
            itemDominio.estatus = [self.currentElementString integerValue];
        }
    } else if ([elementName isEqualToString:@"descripcionItem"]) {
        if (requiereEncriptar) {
            itemDominio.descripcionItem = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            itemDominio.descripcionItem = self.currentElementString;
        }
    }
}









@end
