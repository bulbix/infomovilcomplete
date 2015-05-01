//
//  WS_HandlerContactos.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 04/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerContactos.h"
#import "Contacto.h"

@interface WS_HandlerContactos (){
	int i;
	NSMutableArray * ids;
}

@end

@implementation WS_HandlerContactos
	


-(void) actualizaContacto:(NSInteger) idContacto contactosOperacion:(ContactosOperacion)operacion {
    ids = [[NSMutableArray alloc] init];
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    Contacto *contacto = [self.arregloContactos objectAtIndex:idContacto];
    self.idOperacion = operacion;
    NSString *visible;
    if (contacto.habilitado) {
        visible = @"1";
    }
    else {
        visible = @"0";
    }
    NSArray *arregloCatalogo = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
    NSDictionary *diccionarioContacto = [arregloCatalogo objectAtIndex:contacto.indice];
    NSString *regExpresion = nil;//[NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
    if (contacto.idPais) {
        regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
    }
    else {
        regExpresion = [NSString stringWithFormat:@"%@%@!", [diccionarioContacto objectForKey:@"expresion"], contacto.noContacto];
    }
    NSString *stringXML;
//	NSString * aux;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateRecordNaptr>"
                     "<domain_id>%@</domain_id>"
                     "<RecordNaptrVO>"
                     "<claveContacto>%@</claveContacto>"
                     "<longLabelNaptr>%@</longLabelNaptr>"
                     "<regExp>%@</regExp>"
                     "<servicesNaptr>%@</servicesNaptr>"
                     "<subCategory>%@</subCategory>"
                     "<visible>%@</visible>"
                     "</RecordNaptrVO>"
                     "<token>%@</token>"
                     "</ws:updateRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", contacto.idContacto] conToken:datos.token],
                     [StringUtils encriptar:contacto.descripcion conToken:datos.token],
                     [StringUtils encriptar:regExpresion conToken:datos.token],
                     [StringUtils encriptar:[diccionarioContacto objectForKey:@"servicio"] conToken:datos.token],
                     [StringUtils encriptar:[diccionarioContacto objectForKey:@"subcategoria"] conToken:datos.token],
                     [StringUtils encriptar:visible conToken:datos.token],
                     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];

		
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateRecordNaptr>"
                     "<domain_id>%i</domain_id>"
                     "<RecordNaptrVO>"
                     "<claveContacto>%i</claveContacto>"
                     "<longLabelNaptr>%@</longLabelNaptr>"
                     "<regExp>%@</regExp>"
                     "<servicesNaptr>%@</servicesNaptr>"
                     "<subCategory>%@</subCategory>"
                     "<visible>%@</visible>"
                     "</RecordNaptrVO>"
                     "</ws:updateRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", datos.idDominio, contacto.idContacto, contacto.descripcion, regExpresion, [diccionarioContacto objectForKey:@"servicio"], [diccionarioContacto objectForKey:@"subcategoria"], visible];
    }
    
    
    NSLog(@"WS_HandlerContactos 1: El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"WS_HandlerContactos La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                if (self.token == nil || [[self.token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                    [self.contactosDelegate errorToken];
                }
                else {
                    datos.arregloContacto = self.arregloContactos;
                    
                    NSString *stringResult = ([ids count] > 0) ? @"Exito" : [StringUtils desEncriptar:self.resultado conToken:datos.token];
                    if(stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]){
                        [self.contactosDelegate errorToken];
                    }
                    else{
                        [self.contactosDelegate resultadoConsultaDominio:[StringUtils desEncriptar:self.resultado conToken:datos.token]];
                    }
                }
				
            }
            else {
                [self.contactosDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.contactosDelegate errorConsultaWS];
        }
    }
    else {
        [self.contactosDelegate errorConsultaWS];
    }
    
}
-(void) actualizaConContacto:(Contacto *)contactoSel {
    ids = [[NSMutableArray alloc] init];
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    Contacto *contacto = contactoSel;
    NSString *visible;
    if (contacto.habilitado) {
        visible = @"1";
    }
    else {
        visible = @"0";
    }
    NSArray *arregloCatalogo = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
    NSDictionary *diccionarioContacto = [arregloCatalogo objectAtIndex:contacto.indice];
    NSString *regExpresion = nil;//[NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
    if (contacto.idPais) {
        regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
    }
    else {
        regExpresion = [NSString stringWithFormat:@"%@%@!", [diccionarioContacto objectForKey:@"expresion"], contacto.noContacto];
    }
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateRecordNaptr>"
                     "<domain_id>%@</domain_id>"
                     "<RecordNaptrVO>"
                     "<claveContacto>%@</claveContacto>"
                     "<longLabelNaptr>%@</longLabelNaptr>"
                     "<regExp>%@</regExp>"
                     "<servicesNaptr>%@</servicesNaptr>"
                     "<subCategory>%@</subCategory>"
                     "<visible>%@</visible>"
                     "</RecordNaptrVO>"
                     "<token>%@</token>"
                     "</ws:updateRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", contacto.idContacto] conToken:datos.token],
                     [StringUtils encriptar:contacto.descripcion conToken:datos.token],
                     [StringUtils encriptar:regExpresion conToken:datos.token],
                     [StringUtils encriptar:[diccionarioContacto objectForKey:@"servicio"] conToken:datos.token],
                     [StringUtils encriptar:[diccionarioContacto objectForKey:@"subcategoria"] conToken:datos.token],
                     [StringUtils encriptar:visible conToken:datos.token],
                     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateRecordNaptr>"
                     "<domain_id>%i</domain_id>"
                     "<RecordNaptrVO>"
                     "<claveContacto>%i</claveContacto>"
                     "<longLabelNaptr>%@</longLabelNaptr>"
                     "<regExp>%@</regExp>"
                     "<servicesNaptr>%@</servicesNaptr>"
                     "<subCategory>%@</subCategory>"
                     "<visible>%@</visible>"
                     "</RecordNaptrVO>"
                     "</ws:updateRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", datos.idDominio, contacto.idContacto, contacto.descripcion, regExpresion, [diccionarioContacto objectForKey:@"servicio"], [diccionarioContacto objectForKey:@"subcategoria"], visible];
    }
    
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_HandlerContactos La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                NSString *stringResult = ([ids count] > 0) ? @"Exito" : [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if ( stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.contactosDelegate errorToken];
                }
                else {
                    [self.contactosDelegate resultadoConsultaDominio:stringResult];
                }
                
            }
            else {
                [self.contactosDelegate resultadoConsultaDominio:self.resultado];
            }
        }
        else {
            [self.contactosDelegate errorConsultaWS];
        }
    }
    else {
        [self.contactosDelegate errorConsultaWS];
    }
}

-(void) insertarContacto {
    self.idOperacion = ContactosOperacionAgregar;
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    Contacto *contacto = [self.arregloContactos lastObject];
    NSArray *arregloCatalogo = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
    NSDictionary *diccionarioContacto = [arregloCatalogo objectAtIndex:contacto.indice];
    NSString *regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
    NSString *stringXML;
#ifdef _DEBUG
	NSLog(@"Token: %@",datos.token);
#endif
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertRecordNaptr>"
                     "<domain_id>%@</domain_id>"
                     "<RecordNaptrVO>"
                     "<longLabelNaptr>%@</longLabelNaptr>"
                     "<regExp>%@</regExp>"
                     "<servicesNaptr>%@</servicesNaptr>"
                     "<subCategory>%@</subCategory>"
                     "<visible>%@</visible>"
                     "</RecordNaptrVO>"
                     "<token>%@</token>"
                     "</ws:insertRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:contacto.descripcion conToken:datos.token],
                     [StringUtils encriptar:regExpresion conToken:datos.token],
                     [StringUtils encriptar:[diccionarioContacto objectForKey:@"servicio"] conToken:datos.token],
                     [StringUtils encriptar:[diccionarioContacto objectForKey:@"subcategoria"] conToken:datos.token],
                     [StringUtils encriptar:@"1" conToken:datos.token],
                     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertRecordNaptr>"
                     "<domain_id>%i</domain_id>"
                     "<RecordNaptrVO>"
                     "<longLabelNaptr>%@</longLabelNaptr>"
                     "<regExp>%@</regExp>"
                     "<servicesNaptr>%@</servicesNaptr>"
                     "<subCategory>%@</subCategory>"
                     "<visible>1</visible>"
                     "</RecordNaptrVO>"
                     "</ws:insertRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", datos.idDominio, contacto.descripcion, regExpresion, [diccionarioContacto objectForKey:@"servicio"], [diccionarioContacto objectForKey:@"subcategoria"]];
    }
    
    
    NSLog(@"WS_HandlerContactos 2: El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_HandlerContactos La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 || [stringResult isEqualToString:@"Error de token"]) {
                    [self.contactosDelegate errorToken];
                }
                else {
                    contacto.idContacto = [stringResult intValue];
                    datos.arregloContacto = self.arregloContactos;
                    [self.contactosDelegate resultadoConsultaDominio:@"Exito"];
                }
            }
            else {
                [self.contactosDelegate resultadoConsultaDominio:@"Exito"];
            }
            
        }
        else {
            [self.contactosDelegate errorConsultaWS];
        }
    }
    else {
        [self.contactosDelegate errorConsultaWS];
    }
    
}

-(void) actualizarEstatusContacto {
	ids = [[NSMutableArray alloc] init];
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableArray *arregloContactos = datos.arregloContacto;
    NSMutableString *stringXML;
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateRecordNaptr>"
                     "<domain_id>%@</domain_id>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token]];
        
        for (Contacto *contacto in arregloContactos) {
            NSString *visible;
            if (contacto.habilitado) {
                visible = @"1";
            }
            else {
                visible = @"0";
            }
            NSArray *arregloCatalogo = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
            NSDictionary *diccionarioContacto = [arregloCatalogo objectAtIndex:contacto.indice];
            NSString *regExpresion = nil;//[NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
            if (contacto.idPais) {
                regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
            }
            else {
                regExpresion = [NSString stringWithFormat:@"%@%@!", [diccionarioContacto objectForKey:@"expresion"], contacto.noContacto];
            }
            [stringXML appendFormat:@"<RecordNaptrVO>"
             "<claveContacto>%@</claveContacto>"
             "<longLabelNaptr>%@</longLabelNaptr>"
             "<regExp>%@</regExp>"
             "<servicesNaptr>%@</servicesNaptr>"
             "<subCategory>%@</subCategory>"
             "<visible>%@</visible>"
             "</RecordNaptrVO>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", contacto.idContacto] conToken:datos.token],
             [StringUtils encriptar:contacto.descripcion conToken:datos.token],
             [StringUtils encriptar:regExpresion conToken:datos.token],
             [StringUtils encriptar:[diccionarioContacto objectForKey:@"servicio"] conToken:datos.token],
             [StringUtils encriptar:[diccionarioContacto objectForKey:@"subcategoria"] conToken:datos.token],
             [StringUtils encriptar:visible conToken:datos.token]];
        }
        [stringXML appendFormat:@"<token>%@</token></ws:updateRecordNaptr></soapenv:Body></soapenv:Envelope>", [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [[NSMutableString alloc] initWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateRecordNaptr>"
                     "<domain_id>%i</domain_id>", datos.idDominio ];
        
        for (Contacto *contacto in arregloContactos) {
            NSString *visible;
            if (contacto.habilitado) {
                visible = @"1";
            }
            else {
                visible = @"0";
            }
            NSArray *arregloCatalogo = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
            NSDictionary *diccionarioContacto = [arregloCatalogo objectAtIndex:contacto.indice];
            NSString *regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
            if (contacto.idPais) {
                regExpresion = [NSString stringWithFormat:@"%@%@%@!", [diccionarioContacto objectForKey:@"expresion"],contacto.idPais, contacto.noContacto];
            }
            else {
                regExpresion = [NSString stringWithFormat:@"%@%@!", [diccionarioContacto objectForKey:@"expresion"], contacto.noContacto];
            }
            [stringXML appendFormat:@"<RecordNaptrVO>"
             "<claveContacto>%i</claveContacto>"
             "<longLabelNaptr>%@</longLabelNaptr>"
             "<regExp>%@</regExp>"
             "<servicesNaptr>%@</servicesNaptr>"
             "<subCategory>%@</subCategory>"
             "<visible>%@</visible>"
             "</RecordNaptrVO>", contacto.idContacto, contacto.descripcion, regExpresion, [diccionarioContacto objectForKey:@"servicio"], [diccionarioContacto objectForKey:@"subcategoria"], visible];
        }
        [stringXML appendString:@"</ws:updateRecordNaptr></soapenv:Body></soapenv:Envelope>"];
    }
    
    
    NSLog(@"WS_HandlerContactos 3: El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
   // NSLog(@"WS_HandlerContactos La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
				
                if (self.token == nil || [[self.token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                    [self.contactosDelegate errorToken];
                }
                else {
                    for(int x = 0;x < ids.count;x++){
                        Contacto * contacto = [datos.arregloContacto objectAtIndex:x];
                        
                        contacto.idContacto = [[StringUtils desEncriptar:[ids objectAtIndex:x] conToken:datos.token] integerValue];
                    }
                    if(self.resultado == nil){
                        [self.contactosDelegate resultadoConsultaDominio:@"Exito"];
                    }else{
                        NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                        if (stringResult == nil){
                            stringResult = [StringUtils desEncriptar:self.resultado conToken:self.token];
                        }
                        
                            [self.contactosDelegate resultadoConsultaDominio:stringResult];
                    }
                }
            }
            else {
                [self.contactosDelegate resultadoConsultaDominio:self.resultado];
            }
        }
        else {
            [self.contactosDelegate errorConsultaWS];
        }
    }
    else {
        [self.contactosDelegate errorConsultaWS];
    }
    
}

-(void) eliminarContacto:(NSInteger) idContacto {
    DatosUsuario *usuarioDatos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteRecordNaptr>"
                     "<idDomain>%@</idDomain>"
                     "<naptrId>%@</naptrId>"
                     "<token>%@</token>"
                     "</ws:deleteRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", usuarioDatos.idDominio] conToken:usuarioDatos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", idContacto] conToken:usuarioDatos.token],
                     [StringUtils encriptar:usuarioDatos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteRecordNaptr>"
                     "<idDomain>%i</idDomain>"
                     "<naptrId>%i</naptrId>"
                     "</ws:deleteRecordNaptr>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", usuarioDatos.idDominio, idContacto];
    }
    
    NSLog(@"WS_HandlerContactos 4: El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"WS_HandlerContactos La Respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                if (self.token == nil || [[self.token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                    [self.contactosDelegate errorToken];
                }
                else {
                    usuarioDatos.arregloContacto = self.arregloContactos;
                    NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                    [self.contactosDelegate resultadoConsultaDominio:stringResult];
                }
				
            }
            else {
                [self.contactosDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.contactosDelegate errorConsultaWS];
        }
    }
    else {
        [self.contactosDelegate errorConsultaWS];
    }
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.contactosDelegate errorConsultaWS];
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
	else if([elementName isEqualToString:@"claveContacto"]){
		self.currentElementString = @" ";
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = self.currentElementString;
    }
    if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
    }
	else if([elementName isEqualToString:@"claveContacto"]){
//		DatosUsuario *datos = [DatosUsuario sharedInstance];
//		NSMutableArray *arregloContactos = datos.arregloContacto;
//		Contacto *contacto = [arregloContactos objectAtIndex:i];
//		if(requiereEncriptar){
			[ids addObject:self.currentElementString];
//		}else{
//			contacto.idContacto = [self.currentElementString integerValue];
//		}
		i++;
	}
}

@end
