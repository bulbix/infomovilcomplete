//
//  WS_Moviliza.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/18/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Moviliza.h"

@implementation WS_Moviliza



-(void) moviliza:(NSString *)strMoviliza{
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
                             "<ws:generaHashMovilizaSitio>"
                             "<email>%@</email>"

                            "</ws:generaHashMovilizaSitio>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>",
                             aux
                             ];
    NSLog(@"Los valores enviados para moviliza es: %@",aux);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en redimirCodigo WS_RedimirCodigo %s", [dataResult bytes]);
    if (dataResult != nil) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
            [parser setDelegate:self];
            if ([parser parse]) {
                
                if([self.result isEqualToString:@""] || [self.result length] <= 0 || self.result == nil ){
                    [self.movilizaSitioDelegate resultadoMovilizaSitio:@"Error"];
                }else{
                    [self.movilizaSitioDelegate resultadoMovilizaSitio:self.result];
                }
                
            }else{
                [self.movilizaSitioDelegate errorConsultaWS];
            }
    }else{
        [self.movilizaSitioDelegate errorConsultaWS];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
  
    if ([elementName isEqualToString:@"RespuestaVO"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"resultado"]) {
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
    if ([elementName isEqualToString:@"RespuestaVO"]) {
        NSLog(@"ENTRO A RESPUESTA VO RespuestaVO");

    }else if ([elementName isEqualToString:@"resultado"]) {
        self.result = self.currentElementString;
        NSLog(@"ENTRO A RESULTADO Y ES: %@", self.currentElementString);
    }

}







@end
