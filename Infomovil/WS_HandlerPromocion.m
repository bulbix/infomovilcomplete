//
//  WS_HandlerPromocion.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerPromocion.h"
#import "Base64.h"

@implementation WS_HandlerPromocion



-(void) eliminaPromocion {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML = [NSMutableString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                                  "<soapenv:Header/>"
                                  "<soapenv:Body>"
                                  "<ws:deleteOfferRecord>"
                                  "<DomainId>%@</DomainId>"
                                  "<offerdId>%@</offerdId>"
                                  "<token>%@</token>"
                                  "</ws:deleteOfferRecord>"
                                  "</soapenv:Body>"
                                  "</soapenv:Envelope>",
                                  [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                                  [StringUtils encriptar:[NSString stringWithFormat:@"%i", self.oferta.idOffer] conToken:datos.token],
                                  [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            datos.token = self.token;
            NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
            if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                [self.promocionDelegate errorToken];
            }
            else {
                if ([stringResult isEqual:@"Exito"]) {
                    datos.promocionActual = [[OffertRecord alloc] init];
                    [self.promocionDelegate resultadoConsultaDominio:@"Exito"];
                }
                else {
                    [self.promocionDelegate resultadoConsultaDominio:@"No Exito"];
                }
            }
        }
    }
    
}

-(void) actualizaPromocion
{
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    //    NSMutableDictionary *dictOferta = datos.diccionarioPromocion;
    NSString *rutaImagenPromocion = [self.oferta pathImageOffer];
	
	NSString *endDate;
    if ([self.oferta endDateAux] != nil) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/YYYY"];
        endDate = [formatter stringFromDate:[self.oferta endDateAux]];
    }
    NSMutableString *stringXML;
    //    if (requiereEncriptar) {
    stringXML = [NSMutableString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                 "<soapenv:Header/>"
                 "<soapenv:Body>"
                 "<ws:updateinsertOfferRecord>"
                 "<domainid>%@</domainid>"
                 "<OffertRecordVO>"
                 "<descOffer>%@</descOffer>"
                 "<endDateOffer>%@</endDateOffer>" ,
                 [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                 [StringUtils encriptar:[self.oferta descOffer] conToken:datos.token],
                 [StringUtils encriptar:endDate conToken:datos.token]];
    
    
    if ( rutaImagenPromocion != nil )
    {
        NSData *dataImage = [NSData dataWithContentsOfFile:rutaImagenPromocion];
        [stringXML appendFormat:@"<imageClobOffer>%@</imageClobOffer>", [Base64 encode:dataImage]];
    }
    
    [stringXML appendFormat:@"<redeemOffer>%@</redeemOffer>"
     "<termsOffer>%@</termsOffer>"
     "<titleOffer>%@</titleOffer>"
     "</OffertRecordVO>"
     "<token>%@</token>"
     "</ws:updateinsertOfferRecord>"
     "</soapenv:Body>"
     "</soapenv:Envelope>",
     [StringUtils encriptar:[self.oferta redeemOffer] conToken:datos.token],
     [StringUtils encriptar:[self.oferta termsOffer] conToken:datos.token],
     [StringUtils encriptar:[self.oferta titleOffer] conToken:datos.token],
     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    if (dataResult != nil)
	{
        NSLog(@"La Respuesta es %s", [dataResult bytes]);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse])
		{
            datos.token = self.token;
            NSString *stringResult = [StringUtils desEncriptar:_resultado conToken:self.token];
            if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                [self.promocionDelegate errorToken];
            }
            else {
                NSInteger idAux = [stringResult integerValue];
                if (idAux > 0) {
                    self.oferta.idOffer = idAux;
                    datos.promocionActual = self.oferta;
                    [self.promocionDelegate resultadoConsultaDominio:@"Exito"];
                }
                else {
                    [self.promocionDelegate resultadoConsultaDominio:@"No Exito"];
                }
            }
            
        }
        else {
            [self.promocionDelegate errorConsultaWS];
        }
    }
    else {
        [self.promocionDelegate errorConsultaWS];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.promocionDelegate errorConsultaWS];
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
