//
//  getDominioGratuito.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/30/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_getDominioGratuito.h"


@implementation getDominioGratuito





-(void) getDominiosGratuitos{
    self.datosUsuario = [DatosUsuario sharedInstance];
   
    
    NSString *  stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<ws:catalogoDominiosResponse>"
                             "</ws:catalogoDominiosResponse>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>"
                             ];
   
   
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en redimirCodigo WS_RedimirCodigo %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            
            if([self.result isEqualToString:@""] || [self.result length] <= 0 || self.result == nil ){
                [self.dominioGratuitoDelegate resultadoDominioGratuito:@"Error"];
            }else{
                [self.dominioGratuitoDelegate resultadoDominioGratuito:@"Exito"];
            }
            
        }else{
            [self.dominioGratuitoDelegate errorConsultaWS];
        }
    }else{
        [self.dominioGratuitoDelegate errorConsultaWS];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"CatalogoDominios"]) {
       self.dominiosGratuitosCatalogo = [[catalogoDominiosGratuitos alloc] init];
    }else if ([elementName isEqualToString:@"id"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"descripcion"]) {
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
    if ([elementName isEqualToString:@"CatalogoDominios"]) {
        [self.arrayAuxDominios addObject:self.dominiosGratuitosCatalogo];
        
    }else if ([elementName isEqualToString:@"id"]) {
        self.result = self.currentElementString;
        NSLog(@"ENTRO A id Y ES: %@", self.currentElementString);
        [self.dominiosGratuitosCatalogo setId:self.result];
    }
    else if ([elementName isEqualToString:@"descripcion"]) {
        self.result = self.currentElementString;
        NSLog(@"ENTRO A DESCRIPCION Y ES: %@", self.currentElementString);
        [self.dominiosGratuitosCatalogo setDescripcion:self.result];
    }
    
}



@end
