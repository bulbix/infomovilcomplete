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
    NSLog(@"EL TOKEN CON EL QUE ENCRIPTA ES: %@", datos.token);
   
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:%@>"
                     "<DomainVO>"
                     "<template>%@</template>"
                     "<displayString>%@</displayString>"
                     "<domainName>%@</domainName>"
                     "<textRecord>%@</textRecord>"
                     "</DomainVO>"
                     "<idDomain>%@</idDomain>"
                     "<token>%@</token>"
                     "</ws:%@>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",metodo,
                     [StringUtils encriptar:datos.nombreTemplate conToken:datos.token],
                     [StringUtils encriptar:self.descripcion conToken:datos.token],
                     [StringUtils encriptar:datos.dominio conToken:datos.token],
                     [StringUtils encriptar:self.nombre conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:datos.email conToken:passwordEncriptar],
                     metodo];
    

    
    self.strSoapAction = @"WSInfomovilDomain";
     NSLog(@"La peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"WS_HandlerActualizarDominio La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if(self.token != nil && [self.token length] > 0 && ![self.token isEqualToString:@" "]){
                datos.token = self.token;
            }
                if ( [metodo isEqualToString:k_UPDATE_TITULO] )
                    datos.nombreEmpresa = self.nombre;
                else if ([metodo isEqualToString:k_UPDATE_DESC_CORTA] )
                    datos.descripcion = self.descripcion;
            
                NSLog(@"EL TOKEN CON EL QUE TRATA DE DESENCRIPTAR ES: %@", datos.token);
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                    [self.actualizarDominioDelegate errorToken];
                }
                else {
                    [self.actualizarDominioDelegate resultadoConsultaDominio:stringResult];
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
        NSLog(@"EL RESULTADO ES EN HANDLERACTUALIZARDOMINIO: %@", self.resultado);
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
    
    }
}

@end
