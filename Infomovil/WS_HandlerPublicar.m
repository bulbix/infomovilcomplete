//
//  WS_HandlerPublicar.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 26/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerPublicar.h"
#import "Contacto.h"
#import "GaleriaImagenes.h"
#import "Base64.h"
#import "NSStringUtiles.h"
#import "KeywordDataModel.h"
#import "InformacionAdicional.h"
#import "OffertRecord.h"

@implementation WS_HandlerPublicar

-(void) publicarDominio {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:createDomain>"
                     "<arg0>" ];
        [stringXML appendFormat:@"<idDomain>%@</idDomain>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:passwordEncriptar]];
        [stringXML appendString:@"<listDominioVO>"];
        if (datos.colorSeleccionado != Nil) {
            [stringXML appendFormat:@"<colour>%@</colour>", [StringUtils encriptar:[StringUtils hexFromUIColor:datos.colorSeleccionado] conToken:passwordEncriptar]];
        }
        if (datos.description != Nil) {
            [stringXML appendFormat:@"<displayString>%@</displayString>", [StringUtils encriptar:datos.descripcion conToken:passwordEncriptar]];
        }
        if (datos.dominio != Nil) {
            [stringXML appendFormat:@"<domainName>%@</domainName>", [StringUtils encriptar:datos.dominio conToken:passwordEncriptar]];
        }
        
        if (datos.nombreEmpresa != Nil) {
            [stringXML appendFormat:@"<textRecord>%@</textRecord>", [StringUtils encriptar:datos.nombreEmpresa conToken:passwordEncriptar]];
        }
        [stringXML appendString:@"</listDominioVO>"];
        if (datos.imagenLogo.rutaImagen != Nil) {
            NSData *dataImage = [NSData dataWithContentsOfFile:datos.imagenLogo.rutaImagen];
            [stringXML appendFormat:@"<listImagenVO><imagenClobGaleria>%@</imagenClobGaleria><typeImage>%@</typeImage>"
             "</listImagenVO>", [Base64 encode:dataImage], [StringUtils encriptar:@"LOGO" conToken:passwordEncriptar]];
        }
        
        if (datos.arregloGaleriaImagenes != Nil) {
            NSMutableArray *arregloImagenes = datos.arregloGaleriaImagenes;
            for (GaleriaImagenes *imagen in arregloImagenes) {
                NSData *dataImagen = [NSData dataWithContentsOfFile:imagen.rutaImagen];
                [stringXML appendFormat:@"<listImagenVO><descripcionImagen>%@</descripcionImagen><imagenClobGaleria>%@</imagenClobGaleria><typeImage>%@</typeImage>"
                 "</listImagenVO>", [StringUtils encriptar:imagen.pieFoto conToken:passwordEncriptar], [Base64 encode:dataImagen], [StringUtils encriptar:@"IMAGEN" conToken:passwordEncriptar]];
            }
            
        }
        
        if (datos.promocionActual != Nil) {
            OffertRecord *oferta = [datos promocionActual];
//            NSMutableDictionary *dictPromo = datos.diccionarioPromocion;
            [stringXML appendString:@"<listOffertRecordVO>"];
            if ([oferta descOffer] != nil) {
                [stringXML appendFormat:@"<descOffer>%@</descOffer>", [StringUtils encriptar:[oferta descOffer] conToken:passwordEncriptar]];
            }
            if ([oferta endDateAux] != nil) {
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd/MM/YYYY"];
                [stringXML appendFormat:@"<endDateOffer>%@</endDateOffer>", [StringUtils encriptar:[formatter stringFromDate:[oferta endDateAux]] conToken:passwordEncriptar]];
            }
            if (oferta.pathImageOffer != nil) {
                NSData *dataImage = [NSData dataWithContentsOfFile:oferta.pathImageOffer];
                [stringXML appendFormat:@"<imageClobOffer>%@</imageClobOffer>", [Base64 encode:dataImage]];
            }
            if ([oferta redeemOffer]!= nil) {
                [stringXML appendFormat:@"<redeemOffer>%@</redeemOffer>", [StringUtils encriptar:[oferta redeemOffer] conToken:passwordEncriptar]];
            }
            if ([oferta termsOffer] != nil) {
                [stringXML appendFormat:@"<termsOffer>%@</termsOffer>", [StringUtils encriptar:[oferta termsOffer] conToken:passwordEncriptar]];
            }
            if ([oferta titleOffer] != nil) {
                [stringXML appendFormat:@"<titleOffer>%@</titleOffer>", [StringUtils encriptar:[oferta titleOffer] conToken:passwordEncriptar]];
            }
            [stringXML appendString:@"</listOffertRecordVO>"];
        }
        
        //recuperacion de direccion
        // !!!: revisar
//        NSDictionary *dictCatalogo = nil;//[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CatalogoInformacion" ofType:@"plist"]];
        NSArray *arregloLLaves = nil;//[dictCatalogo objectForKey:@"direccion"];
        NSMutableArray *dictDireccion = datos.direccion;
        NSMutableString *stringDireccion = [[NSMutableString alloc] init];
        for (KeywordDataModel *key in dictDireccion) {
            NSDictionary *dictAuxiliar = [[NSDictionary alloc] initWithObjects:@[[StringUtils encriptar:key.keywordField conToken:passwordEncriptar], [StringUtils encriptar:key.keywordValue conToken:passwordEncriptar]] forKeys:@[@"keywordField", @"keywordValue"]];
            [stringDireccion appendFormat:@"<listKeywordVO>%@</listKeywordVO>", [self creaSoapData:dictAuxiliar ordenado:NO strAtribute:Nil]];
        }
        
        [stringXML appendString:stringDireccion];
        
        //recuperacion del perfil
        NSMutableArray *arregloPerfil = datos.arregloDatosPerfil;
        arregloLLaves = nil;//[dictCatalogo objectForKey:@"perfil"];
        NSMutableString *stringPerfil = [[NSMutableString alloc] init];
        //Revisar con el horario como enviarlo
        for (KeywordDataModel *key in arregloPerfil) {
            if (key.keywordValue != Nil) {
                NSDictionary *dictAuxiliar = [[NSDictionary alloc] initWithObjects:@[[StringUtils encriptar:key.keywordField conToken:passwordEncriptar], [StringUtils encriptar:key.keywordValue conToken:passwordEncriptar]] forKeys:@[@"keywordField", @"keywordValue"]];
                [stringPerfil appendFormat:@"<listKeywordVO>%@</listKeywordVO>", [self creaSoapData:dictAuxiliar ordenado:NO strAtribute:Nil]];
            }
        }
        [stringXML appendString:stringPerfil];
        
        //recuperacion de informacionAdicional
        NSMutableString *stringAdicional = [[NSMutableString alloc] init];
        NSMutableArray *arregloAdicional = datos.arregloInformacionAdicional;
        for (KeywordDataModel *infoAdicional in arregloAdicional) {
            NSDictionary *dictAux = [[NSDictionary alloc] initWithObjects:@[[StringUtils encriptar:infoAdicional.keywordField conToken:passwordEncriptar], [StringUtils encriptar:infoAdicional.keywordValue conToken:passwordEncriptar]] forKeys:@[@"keywordField", @"keywordValue"]];
            [stringAdicional appendFormat:@"<listKeywordVO>%@</listKeywordVO>", [self creaSoapData:dictAux ordenado:NO strAtribute:Nil]];
        }
        [stringXML appendString:stringAdicional];
        
        if (datos.localizacion != Nil) {
            [stringXML appendString:@"<listLatitud>"];
            [stringXML appendFormat:@"<latitudeLoc>%@</latitudeLoc>", [StringUtils encriptar:[NSString stringWithFormat:@"%f", datos.localizacion.coordinate.latitude] conToken:passwordEncriptar]];
            [stringXML appendFormat:@"<longitudeLoc>%@</longitudeLoc>", [StringUtils encriptar:[NSString stringWithFormat:@"%f", datos.localizacion.coordinate.longitude] conToken:passwordEncriptar]];
            [stringXML appendString:@"</listLatitud>"];
        }
        
        
        //recuperacion de contactos
        NSMutableArray *arregloContactos = datos.arregloContacto;
        NSMutableString *stringContactos = [[NSMutableString alloc] init];
        NSArray *arregloCatalogo = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
        for (Contacto *contacto in arregloContactos) {
            NSDictionary *diccionarioContacto = [arregloCatalogo objectAtIndex:contacto.indice];
            NSString *visible;
            if (contacto.habilitado) {
                visible = @"1";
            }
            else {
                visible = @"0";
            }
            NSString *regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:@[[StringUtils encriptar:contacto.descripcion conToken:passwordEncriptar], [StringUtils encriptar:regExpresion conToken:passwordEncriptar], [StringUtils encriptar:[diccionarioContacto objectForKey:@"servicio"] conToken:passwordEncriptar] , [StringUtils encriptar:[diccionarioContacto objectForKey:@"subcategoria"] conToken:passwordEncriptar], [StringUtils encriptar:visible conToken:passwordEncriptar]] forKeys:@[@"longLabelNaptr", @"regExp", @"servicesNaptr", @"subCategory", @"visible"]];
            
            [stringContactos appendFormat:@"<listRecordNaptrVo>%@</listRecordNaptrVo>", [self creaSoapData:dictionary ordenado:NO strAtribute:Nil]];
        }
        [stringXML appendString:stringContactos];
        
        if (datos.videoSeleccionado != Nil) {
            [stringXML appendFormat:@"<video>%@</video>", [StringUtils encriptar:datos.videoSeleccionado.linkSolo conToken:passwordEncriptar]];
        }
        
        [stringXML appendFormat:@"</arg0><token>%@</token>"
         "</ws:createDomain>"
         "</soapenv:Body>"
         "</soapenv:Envelope>", [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [[NSMutableString alloc] initWithString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:createDomain>"
                     "<arg0>" ];
        [stringXML appendFormat:@"<idDomain>%i</idDomain>", datos.idDominio];
        [stringXML appendString:@"<listDominioVO>"];
        if (datos.colorSeleccionado != Nil) {
            [stringXML appendFormat:@"<colour>%@</colour>", [StringUtils hexFromUIColor:datos.colorSeleccionado]];
        }
        if (datos.description != Nil) {
            [stringXML appendFormat:@"<displayString>%@</displayString>", datos.descripcion];
        }
        if (datos.dominio != Nil) {
            [stringXML appendFormat:@"<domainName>%@</domainName>", datos.dominio];
        }
        
        if (datos.nombreEmpresa != Nil) {
            [stringXML appendFormat:@"<textRecord>%@</textRecord>", datos.nombreEmpresa];
        }
        [stringXML appendString:@"</listDominioVO>"];
        if (datos.imagenLogo.rutaImagen != Nil) {
            NSData *dataImage = [NSData dataWithContentsOfFile:datos.imagenLogo.rutaImagen];
            [stringXML appendFormat:@"<listImagenVO><imagenClobGaleria>%@</imagenClobGaleria><typeImage>LOGO</typeImage>"
             "</listImagenVO>", [Base64 encode:dataImage]];
        }
        
        if (datos.arregloGaleriaImagenes != Nil) {
            NSMutableArray *arregloImagenes = datos.arregloGaleriaImagenes;
            for (GaleriaImagenes *imagen in arregloImagenes) {
                NSData *dataImagen = [NSData dataWithContentsOfFile:imagen.rutaImagen];
                [stringXML appendFormat:@"<listImagenVO><descripcionImagen>%@</descripcionImagen><imagenClobGaleria>%@</imagenClobGaleria><typeImage>IMAGEN</typeImage>"
                 "</listImagenVO>", imagen.pieFoto, [Base64 encode:dataImagen]];
            }
            
        }
        
//        if (datos.diccionarioPromocion != Nil) {
//            NSMutableDictionary *dictPromo = datos.diccionarioPromocion;
//            [stringXML appendString:@"<listOffertRecordVO>"];
//            if ([dictPromo objectForKey:@"descripcionPromocion"] != nil) {
//                [stringXML appendFormat:@"<descOffer>%@</descOffer>", [dictPromo objectForKey:@"descripcionPromocion"]];
//            }
//            if ([dictPromo objectForKey:@"fechaSeleccionada"] != nil) {
//                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//                [formatter setDateFormat:@"dd/MM/YYYY"];
//                [stringXML appendFormat:@"<endDateOffer>%@</endDateOffer>", [formatter stringFromDate:[dictPromo objectForKey:@"fechaSeleccionada"]]];
//            }
//            if (datos.rutaImagenPromocion != nil) {
//                NSData *dataImage = [NSData dataWithContentsOfFile:datos.rutaImagenPromocion];
//                [stringXML appendFormat:@"<imageClobOffer>%@</imageClobOffer>", [Base64 encode:dataImage]];
//            }
//            if ([dictPromo objectForKey:@"redencion"]!= nil) {
//                [stringXML appendFormat:@"<redeemOffer>%@</redeemOffer>", [dictPromo objectForKey:@"redencion"]];
//            }
//            if ([dictPromo objectForKey:@"informacionPromocion"] != nil) {
//                [stringXML appendFormat:@"<termsOffer>%@</termsOffer>", [dictPromo objectForKey:@"informacionPromocion"]];
//            }
//            if ([dictPromo objectForKey:@"tituloPromocion"] != nil) {
//                [stringXML appendFormat:@"<titleOffer>%@</titleOffer>", [dictPromo objectForKey:@"tituloPromocion"]];
//            }
//            [stringXML appendString:@"</listOffertRecordVO>"];
//        }
        
        //recuperacion de direccion
        NSDictionary *dictCatalogo = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CatalogoInformacion" ofType:@"plist"]];
        NSArray *arregloLLaves = [dictCatalogo objectForKey:@"direccion"];
        NSMutableArray *dictDireccion = datos.direccion;
        NSMutableString *stringDireccion = [[NSMutableString alloc] init];
        for (KeywordDataModel *key in dictDireccion) {
            NSDictionary *dictAuxiliar = [[NSDictionary alloc] initWithObjects:@[key.keywordField, key.keywordValue] forKeys:@[@"keywordField", @"keywordValue"]];
            [stringDireccion appendFormat:@"<listKeywordVO>%@</listKeywordVO>", [self creaSoapData:dictAuxiliar ordenado:NO strAtribute:Nil]];
        }
        
        [stringXML appendString:stringDireccion];
        
        //recuperacion del perfil
        NSMutableArray *arregloPerfil = datos.arregloDatosPerfil;
        arregloLLaves = [dictCatalogo objectForKey:@"perfil"];
        NSMutableString *stringPerfil = [[NSMutableString alloc] init];
        //Revisar con el horario como enviarlo
        for (KeywordDataModel *key in arregloPerfil) {
            if (key.keywordValue != Nil) {
                NSDictionary *dictAuxiliar = [[NSDictionary alloc] initWithObjects:@[key.keywordField, key.keywordValue] forKeys:@[@"keywordField", @"keywordValue"]];
                [stringPerfil appendFormat:@"<listKeywordVO>%@</listKeywordVO>", [self creaSoapData:dictAuxiliar ordenado:NO strAtribute:Nil]];
            }
        }
        [stringXML appendString:stringPerfil];
        
        //recuperacion de informacionAdicional
        NSMutableString *stringAdicional = [[NSMutableString alloc] init];
        NSMutableArray *arregloAdicional = datos.arregloInformacionAdicional;
        for (KeywordDataModel *infoAdicional in arregloAdicional) {
            NSDictionary *dictAux = [[NSDictionary alloc] initWithObjects:@[infoAdicional.keywordField, infoAdicional.keywordValue] forKeys:@[@"keywordField", @"keywordValue"]];
            [stringAdicional appendFormat:@"<listKeywordVO>%@</listKeywordVO>", [self creaSoapData:dictAux ordenado:NO strAtribute:Nil]];
        }
        [stringXML appendString:stringAdicional];
        
        if (datos.localizacion != Nil) {
            [stringXML appendString:@"<listLatitud>"];
            [stringXML appendFormat:@"<latitudeLoc>%f</latitudeLoc>", datos.localizacion.coordinate.latitude];
            [stringXML appendFormat:@"<longitudeLoc>%f</longitudeLoc>", datos.localizacion.coordinate.longitude];
            [stringXML appendString:@"</listLatitud>"];
        }
        
        
        //recuperacion de contactos
        NSMutableArray *arregloContactos = datos.arregloContacto;
        NSMutableString *stringContactos = [[NSMutableString alloc] init];
        NSArray *arregloCatalogo = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
        for (Contacto *contacto in arregloContactos) {
            NSDictionary *diccionarioContacto = [arregloCatalogo objectAtIndex:contacto.indice];
            NSString *visible;
            if (contacto.habilitado) {
                visible = @"1";
            }
            else {
                visible = @"0";
            }
            NSString *regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:@[contacto.descripcion, regExpresion, [diccionarioContacto objectForKey:@"servicio"], [diccionarioContacto objectForKey:@"subcategoria"], visible] forKeys:@[@"longLabelNaptr", @"regExp", @"servicesNaptr", @"subCategory", @"visible"]];
            
            [stringContactos appendFormat:@"<listRecordNaptrVo>%@</listRecordNaptrVo>", [self creaSoapData:dictionary ordenado:NO strAtribute:Nil]];
        }
        [stringXML appendString:stringContactos];
        
        if (datos.urlVideo != Nil) {
            [stringXML appendFormat:@"<video>%@</video>", datos.urlVideo];
        }
        
        [stringXML appendString:@"</arg0>"
         "</ws:createDomain>"
         "</soapenv:Body>"
         "</soapenv:Envelope>"];
    }
    
    
    
    self.strSoapAction = @"wsInfomovildomain";
    NSData *dataResult = [self getXmlRespuesta:[NSString codificaHtml:stringXML] conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    if (dataResult != nil) {
        NSLog(@"La respuesta es %s", [dataResult bytes]);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if ( stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wsHandlerDelegate errorToken];
                }else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wsHandlerDelegate sessionTimeout];
                else {
                    [self.wsHandlerDelegate resultadoConsultaDominio:stringResult];
                }
            }
            else {
                [self.wsHandlerDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.wsHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wsHandlerDelegate errorConsultaWS];
    }
   
//    [self.wsHandlerDelegate resultadoConsultaDominio:@"Exito"];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.wsHandlerDelegate errorConsultaWS];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"resultado"]) { //consulta de dominio
        self.currentElementString = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = [[NSString alloc] init];
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
