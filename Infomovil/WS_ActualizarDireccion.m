//
//  WS_ActualizarDireccion.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_ActualizarDireccion.h"
#import "KeywordDataModel.h"

@interface WS_ActualizarDireccion ()

@property (nonatomic, strong) NSMutableArray *diccionarioId;
@property (nonatomic, strong) KeywordDataModel *keyModel;

@end

@implementation WS_ActualizarDireccion

-(void) actualizarDireccion {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    //NSMutableArray *arregloDireccion = datos.direccion;
    NSMutableString *stringXML;
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"];
        for (KeywordDataModel *keywordModel in self.arregloDireccion) {
            [stringXML appendFormat:@"<KeywordVO><idKeyword>%@</idKeyword><keywordField>%@</keywordField><keywordPos>%@</keywordPos><keywordValue>%@</keywordValue></KeywordVO>",
             [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)keywordModel.idKeyword] conToken:datos.token],
             [StringUtils encriptar:keywordModel.keywordField conToken:datos.token],
			 [StringUtils encriptar:keywordModel.KeywordPos conToken:datos.token],
             [StringUtils encriptar:keywordModel.keywordValue conToken:datos.token]];
        }
        
        [stringXML appendFormat:@"<domainId>%@</domainId><token>%@</token></ws:updateKeyWordData></soapenv:Body></soapenv:Envelope>",
         [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
         [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"];
        for (KeywordDataModel *keywordModel in self.arregloDireccion) {
            [stringXML appendFormat:@"<KeywordVO><idKeyword>%li</idKeyword><keywordField>%@</keywordField><keywordValue>%@</keywordValue></KeywordVO>", (long)keywordModel.idKeyword, keywordModel.keywordField, [keywordModel.keywordValue length]>0?keywordModel.keywordValue:@" "];
        }
        
        [stringXML appendFormat:@"<domainId>%li</domainId></ws:updateKeyWordData></soapenv:Body></soapenv:Envelope>", (long)datos.idDominio];
    }
    
    //NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_ActualizarDireccion: La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.direccionDelegate errorToken];
                }
                else {
                    datos.direccion = self.arregloDireccion;
                    [self.direccionDelegate resultadoConsultaDominio:stringResult];
                }
				
            }
            else {
                [self.direccionDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
}

-(void) insertarDireccion {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    //NSMutableArray *arregloDireccion = datos.direccion;
    NSMutableString *stringXML;
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertKeywordDataAddress>"];
        
        for (KeywordDataModel *keywordModel in self.arregloDireccion) {
            [stringXML appendFormat:@"<ListKeyword><keywordField>%@</keywordField><keywordValue>%@</keywordValue></ListKeyword>",
             [StringUtils encriptar:keywordModel.keywordField conToken:datos.token],
             [StringUtils encriptar:keywordModel.keywordValue conToken:datos.token]];
        }
        
        [stringXML appendFormat:@"<idDomain>%@</idDomain><token>%@</token></ws:insertKeywordDataAddress></soapenv:Body></soapenv:Envelope>",
         [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
         [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertKeywordDataAddress>"];
        
        for (KeywordDataModel *keywordModel in self.arregloDireccion) {
            [stringXML appendFormat:@"<ListKeyword><keywordField>%@</keywordField><keywordValue>%@</keywordValue></ListKeyword>", keywordModel.keywordField, [keywordModel.keywordValue length]>0?keywordModel.keywordValue:@" "];
        }
        
        [stringXML appendFormat:@"<idDomain>%li</idDomain></ws:insertKeywordDataAddress></soapenv:Body></soapenv:Envelope>", (long)datos.idDominio];
    }
    
   // NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
   // NSLog(@"WS_ActualizarDireccion La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        self.diccionarioId = [[NSMutableArray alloc] init];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];

                if (self.token == nil) {
                    [self.direccionDelegate errorToken];
                }
                    if (self.diccionarioId!= nil && [self.diccionarioId count] == 7 ) {
                        datos.direccion = self.diccionarioId;
                        [self.direccionDelegate resultadoInsertarDireccion:@"Exito"];
                       
                    }else{
                        [self.direccionDelegate resultadoInsertarDireccion:@"No Exito"];
                    }
            }
            else {
                [self.direccionDelegate resultadoInsertarDireccion:@"Exito"];
            }
            
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
}

-(void) actualizarInformacion {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    KeywordDataModel *keywordModel = [self.arregloPerfil objectAtIndex:self.indexSeleccionado];
    NSMutableString *stringXML;
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"];
        //    for (KeywordDataModel *keywordModel in arregloDireccion) {
        [stringXML appendFormat:@"<KeywordVO><idKeyword>%@</idKeyword><keywordField>%@</keywordField><keywordPos>%@</keywordPos><keywordValue>%@</keywordValue></KeywordVO>",
         [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)keywordModel.idKeyword] conToken:datos.token],
         [StringUtils encriptar:keywordModel.keywordField conToken:datos.token], [StringUtils encriptar:keywordModel.KeywordPos conToken:datos.token],
         [StringUtils encriptar:keywordModel.keywordValue conToken:datos.token]];
        //    }
        
        [stringXML appendFormat:@"<domainId>%@</domainId><token>%@</token></ws:updateKeyWordData></soapenv:Body></soapenv:Envelope>",
         [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
         [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"];
        //    for (KeywordDataModel *keywordModel in arregloDireccion) {
        [stringXML appendFormat:@"<KeywordVO><idKeyword>%li</idKeyword><keywordField>%@</keywordField><keywordValue>%@</keywordValue></KeywordVO><domainId>%li</domainId>", (long)keywordModel.idKeyword, keywordModel.keywordField, keywordModel.keywordValue, (long)datos.idDominio];
        //    }
        
        [stringXML appendString:@"</ws:updateKeyWordData></soapenv:Body></soapenv:Envelope>"];
    }
   // NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_ActualizarDireccion La Respuesta es %s", [dataResult bytes]);
    
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.direccionDelegate errorToken];
                }
                else {
                    if ([stringResult isEqualToString:@"Exito"]) {
                        [datos setArregloInformacionAdicional:self.arregloPerfil];
                        [self.direccionDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else {
                        [self.direccionDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
            }
            else {
                [self.direccionDelegate resultadoConsultaDominio:self.resultado];
            }
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
}

-(void) actualizarPerfil {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableArray *arregloDireccion = datos.arregloDatosPerfil;
    NSMutableString *stringXML;
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"];
        for (KeywordDataModel *keywordModel in arregloDireccion) {
            [stringXML appendFormat:@"<KeywordVO><idKeyword>%@</idKeyword><keywordField>%@</keywordField><keywordPos>%@</keywordPos><keywordValue>%@</keywordValue></KeywordVO>",
             [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)keywordModel.idKeyword] conToken:datos.token],
             [StringUtils encriptar:keywordModel.keywordField conToken:datos.token],[StringUtils encriptar:@"0" conToken:datos.token],
             [StringUtils encriptar:keywordModel.keywordValue conToken:datos.token]];
        }
        
        [stringXML appendFormat:@"<domainId>%@</domainId><token>%@</token></ws:updateKeyWordData></soapenv:Body></soapenv:Envelope>",
         [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
         [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"];
        for (KeywordDataModel *keywordModel in arregloDireccion) {
            [stringXML appendFormat:@"<KeywordVO><idKeyword>%li</idKeyword><keywordField>%@</keywordField><keywordValue>%@</keywordValue></KeywordVO>", (long)keywordModel.idKeyword, keywordModel.keywordField, keywordModel.keywordValue];
        }
        
        [stringXML appendFormat:@"<domainId>%li</domainId></ws:updateKeyWordData></soapenv:Body></soapenv:Envelope>", (long)datos.idDominio];
    }
    
    //NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@" WS_ActualizarDireccionLa Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                
                if (stringResult == nil)
                    stringResult = [StringUtils desEncriptar:self.resultado conToken:self.token];
                
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.direccionDelegate errorToken];
                }
                else {
                    [self.direccionDelegate resultadoConsultaDominio:stringResult];
                }
            }
            else {
                [self.direccionDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
}

-(void) actualizarElementoPerfil:(KeywordDataModel*) keywordModel {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"
					 "<KeywordVO>"
					 "<idKeyword>%@</idKeyword>"
					 "<keywordField>%@</keywordField>"
                     "<keywordPos>%@</keywordPos>"
					 "<keywordValue>%@</keywordValue>"
					 "</KeywordVO>"
					 "<domainId>%@</domainId>"
					 "<token>%@</token>"
					 "</ws:updateKeyWordData>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>",
					 [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)keywordModel.idKeyword] conToken:datos.token],
					 [StringUtils encriptar:keywordModel.keywordField conToken:datos.token],
                     [StringUtils encriptar:keywordModel.KeywordPos conToken:datos.token],
					 [StringUtils encriptar:keywordModel.keywordValue conToken:datos.token],
					 [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
					 [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];

    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateKeyWordData>"
					 "<KeywordVO>"
					 "<idKeyword>%li</idKeyword>"
					 "<keywordField>%@</keywordField>"
					 "<keywordValue>%@</keywordValue>"
					 "</KeywordVO>"
					 "<domainId>%li</domainId>"
					 "</ws:updateKeyWordData>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>",
					 (long)keywordModel.idKeyword,
					 keywordModel.keywordField,
					 keywordModel.keywordValue,
					 (long)datos.idDominio];
		
    }
    
    //NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_ActualizarDireccion La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.direccionDelegate errorToken];
                }
                else {
                    if ([stringResult isEqualToString:@"Exito"]) {
                        [self.arregloPerfil replaceObjectAtIndex:self.indexSeleccionado withObject:keywordModel];
                        [datos setArregloDatosPerfil:self.arregloPerfil];
                        [self.direccionDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else {
                        [self.direccionDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
            }
            else {
                [self.direccionDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
}

-(void) insertarInformacion {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    KeywordDataModel *dataModel = [self.arregloPerfil lastObject];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertKeyWordData>"
                     "<KeywordVO>"
                     "<keywordField>%@</keywordField>"
                     "<keywordValue>%@</keywordValue>"
                     "</KeywordVO>"
                     "<domainId>%@</domainId>"
                     "<token>%@</token>"
                     "</ws:insertKeyWordData>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:dataModel.keywordField conToken:datos.token],
                     [StringUtils encriptar:dataModel.keywordValue conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertKeyWordData>"
                     "<KeywordVO>"
                     "<keywordField>%@</keywordField>"
                     "<keywordValue>%@</keywordValue>"
                     "</KeywordVO>"
                     "<domainId>%li</domainId>"
                     "</ws:insertKeyWordData>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", dataModel.keywordField, dataModel.keywordValue, (long)datos.idDominio];
    }
    
   // NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_ActualizarDireccion La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.direccionDelegate errorToken];
                }
                else {
                    NSInteger idAux = [stringResult integerValue];
                    NSString* posAux = [StringUtils desEncriptar:self.posActualizar conToken:datos.token] ;
                    if (idAux > 0) {
                        [(KeywordDataModel *) [self.arregloPerfil lastObject] setIdKeyword:idAux];
                        [(KeywordDataModel *) [self.arregloPerfil lastObject] setKeywordPos:posAux];
                        datos = [DatosUsuario sharedInstance];
                        [datos setArregloInformacionAdicional:self.arregloPerfil];
                        [self.direccionDelegate resultadoConsultaDominio:[StringUtils desEncriptar:self.resultado conToken:datos.token]];
                    }
                    else {
                        [self.direccionDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
            }
            else {
                [self.direccionDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
    
}

-(void) insertarPerfil:(NSInteger) indicePerfil {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    KeywordDataModel *dataPerfil = [self.arregloPerfil objectAtIndex:indicePerfil];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertKeyWordData>"
                     "<KeywordVO>"
                     "<keywordField>%@</keywordField>"
                     "<keywordValue>%@</keywordValue>"
                     "</KeywordVO>"
                     "<domainId>%@</domainId>"
                     "<token>%@</token>"
                     "</ws:insertKeyWordData>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:dataPerfil.keywordField conToken:datos.token],
                     [StringUtils encriptar:dataPerfil.keywordValue conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertKeyWordData>"
                     "<KeywordVO>"
                     "<keywordField>%@</keywordField>"
                     "<keywordValue>%@</keywordValue>"
                     "</KeywordVO>"
                     "<domainId>%li</domainId>"
                     "</ws:insertKeyWordData>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", dataPerfil.keywordField, dataPerfil.keywordValue, (long)datos.idDominio];
    }
    
    //NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_ActualizarDireccion La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            datos = [DatosUsuario sharedInstance];
            if (requiereEncriptar) {

                //NSString *x = [StringUtils desEncriptar:self.idDominio conToken:self.token];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.direccionDelegate errorToken];
                }
                else {
                    NSInteger idRespuesta = [[StringUtils desEncriptar:self.resultado conToken:datos.token] integerValue];
                    
                    if (idRespuesta > 0) {
                        [[self.arregloPerfil objectAtIndex:self.indexSeleccionado] setIdKeyword:idRespuesta];
                        [[self.arregloPerfil objectAtIndex:self.indexSeleccionado] setKeywordPos:[StringUtils desEncriptar:self.posActualizar conToken:datos.token]];
                        [datos setArregloDatosPerfil:self.arregloPerfil];
                        [self.direccionDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else {
                        [self.direccionDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
            }
            else {
                [self.direccionDelegate resultadoConsultaDominio:self.resultado];
            }
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
}

-(void) eliminarKeywordConId:(NSInteger) idKeyword {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteKeyWordData>"
                     "<idDomain>%@</idDomain>"
                     "<keywordId>%@</keywordId>"
                     "<token>%@</token>"
                     "</ws:deleteKeyWordData>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)idKeyword] conToken:datos.token],
                     [StringUtils encriptar:datos.email conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteKeyWordData>"
                     "<idDomain>%li</idDomain>"
                     "<keywordId>%li</keywordId>"
                     "</ws:deleteKeyWordData>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", (long)datos.idDominio, (long)idKeyword];
    }
    
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    if (dataResult != nil) {
       // NSLog(@"WS_ActualizarDireccion La Respuesta es %s", [dataResult bytes]);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
			datos = [DatosUsuario sharedInstance];
            if (requiereEncriptar) {
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.direccionDelegate errorToken];
                } 
                else {
                    if ([stringResult isEqualToString:@"Exito"]) {
                        if (self.tipoInfo == 2) {
                            [self.arregloPerfil removeObjectAtIndex:self.indexSeleccionado];
                            [datos setArregloInformacionAdicional:self.arregloPerfil];
                        }
                        else {
                            KeywordDataModel *dataAux = [[KeywordDataModel alloc] init];
                            [self.arregloPerfil replaceObjectAtIndex:self.indexSeleccionado withObject:dataAux];
                            [datos setArregloDatosPerfil:self.arregloPerfil];
                        }
                        
                        [self.direccionDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else {
                        [self.direccionDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
                
            }else{
				[self.direccionDelegate resultadoConsultaDominio:self.resultado];
			}
        }
        else {
            [self.direccionDelegate errorConsultaWS];
        }
    }
    else {
        [self.direccionDelegate errorConsultaWS];
    }
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.direccionDelegate errorConsultaWS];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"resultado"]) {
        self.currentElementString = @" ";
    }
    else if ([elementName isEqualToString:@"listKeywordVO"]) {
        self.keyModel = [[KeywordDataModel alloc] init];
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = @" ";
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"resultado"]) {
//        [self.direccionDelegate resultadoConsultaDominio:self.currentElementString];
        self.resultado = self.currentElementString;
    }
    else if ([elementName isEqualToString:@"idKeyword"]) {
        self.resultado = self.currentElementString;
        [self.keyModel setIdKeyword:[[StringUtils desEncriptar:self.currentElementString conToken:self.token] integerValue]];
    }
	else if ([elementName isEqualToString:@"keywordValue"]) {
        [self.keyModel setKeywordValue:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }
	else if ([elementName isEqualToString:@"keywordPos"]) {
        self.posActualizar = self.currentElementString;
        [self.keyModel setKeywordPos:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }
    else if ([elementName isEqualToString:@"keywordField"]) {
        [self.keyModel setKeywordField:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }
    else if ([elementName isEqualToString:@"listKeywordVO"]) {
        [self.diccionarioId addObject:self.keyModel];
    }
    else if ([elementName isEqualToString:@"token"]) {
        
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
        NSLog(@"EL TOKEN RECIBIDO ES: %@",self.currentElementString );
        NSLog(@"********************************************************");
        
        
        
    }else if ([elementName isEqualToString:@"idDomain"]){
        self.idDominio = self.currentElementString;//[StringUtils desEncriptar:self.currentElementString conToken:self.token];
    }
}

@end
