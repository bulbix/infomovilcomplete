 //
//  WS_HandlerDominio.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 18/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerDominio.h"
#import "NSStringUtiles.h"
#import "AppDelegate.h"
#import "NSDateFormatterUtiles.h"
#import "ItemsDominio.h"

@interface WS_HandlerDominio () {
    ItemsDominio *itemDominio;
    NSString *codigoError;
    NSString *statusDominio;
    NSString *codigoPromocional;
}

@property (nonatomic, strong) NSMutableArray *arregloItems;

@end

@implementation WS_HandlerDominio

@synthesize datos;

-(void) consultaDominio:(NSString *) dominio {
    self.datos = [DatosUsuario sharedInstance];
    NSString *dominioAux;
    if([self.datos.tipoDeUsuario isEqualToString:@"canal"]){
        dominioAux = @"tel";
    }else if([self.datos.tipoDeUsuario isEqualToString:@"normal"]){
        dominioAux = @"recurso";
    
    }
    
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                               "<soapenv:Header/>"
                               "<soapenv:Body>"
                               "<ws:getExistDomain>"
                               "<domainName>%@</domainName>"
                               "<domainType>%@</domainType>"
                               "</ws:getExistDomain>"
                               "</soapenv:Body>"
                               "</soapenv:Envelope>", [StringUtils encriptar:dominio conToken:passwordEncriptar], [StringUtils encriptar:dominioAux conToken:passwordEncriptar]];
    
    NSLog(@"el string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta de WS_HandlerDominio consultaDominio es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                [StringUtils deleteResourcesWithExtension:@"js"];
                [StringUtils deleteResourcesWithExtension:@"css"];
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:passwordEncriptar];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                    NSLog(@"HUBO UN ERROR DE TOKEN EN CONSULTADOMINIO !");
                } 
                else {
                    NSLog(@"El resultado regresado es: %@", stringResult);
                    [self.wSHandlerDelegate resultadoConsultaDominio:stringResult];
                }
                
            }
            else {
                [self.wSHandlerDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}

-(void) consultaDominio:(NSString *)dominio conTipo:(NSString *)tipo {
   
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:getExistDomain>"
                           "<domainName>%@</domainName>"
                           "<domainType>%@</domainType>"
                           "</ws:getExistDomain>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>", dominio, tipo];
    self.strSoapAction = @"wsInfomovildomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
}


-(void) crearUsuario:(NSString *)email conNombre:(NSString *)user password:(NSString *)pass status:(NSString *)s nombre:(NSString *)nom direccion1:(NSString *)dir1 direccion2:(NSString *)dir2 pais:(NSString *) nPais codigoPromocion:(NSString *)codProm tipoDominio:(NSString *)domainType idDominio:(NSString *)idDominio {
    self.datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
		
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
					 "<soapenv:Header/>"
					 "<soapenv:Body>"
					 "<ws:insertUserDomain1>"
					 "<UserDomainVO>"
					 "<email>%@</email>"
					 "<phone>%@</phone>"
					 "<password>%@</password>"
					 "<domainName>%@</domainName>"
					 "<status>%@</status>"
					 "<sistema>%@</sistema>"
					 "<typoDispositivo>%@</typoDispositivo>"
					 "<notificacion>%@</notificacion>"
					 "<tipoAction>%@</tipoAction>"
					 "<pais>%@</pais>"
					 "<canal>%@</canal>"
					 "<sucursal>%@</sucursal>"
					 "<folio>%@</folio>"
					 "<nombre>%@</nombre>"
					 "<direccion1>%@</direccion1>"
					 "<direccion2>%@</direccion2>"
					 "<nPais>%@</nPais>"
                     "<codigoCamp>%@</codigoCamp>"
                     "<domainType>%@</domainType>"
                     "<idDominio>%@</idDominio>"
					 "</UserDomainVO>"
					 "</ws:insertUserDomain1>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>", //[StringUtils encriptar:dominio conToken:passwordEncriptar],
                     [StringUtils encriptar:email conToken:passwordEncriptar],
					 [StringUtils encriptar:@"0" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//phone
                     [StringUtils encriptar:pass conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//password
                     [StringUtils encriptar:user conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//domainName
                     [StringUtils encriptar:s conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//status
					 [StringUtils encriptar:@"IOS" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//sistema
					 [StringUtils encriptar:@"0" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//tipoDispositivo
					 [StringUtils encriptar:@"0" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//notificacion
					 [StringUtils encriptar:@"5" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//tipoAction
					 [StringUtils encriptar:@"1" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//Pais
					 [StringUtils encriptar:@"0" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//Canal
					 [StringUtils encriptar:@"1" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//Sucursal
					 [StringUtils encriptar:@"0" conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//Folio
					 [StringUtils encriptar:nom conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//nombre
					 [StringUtils encriptar:dir1 conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//dir1
					 [StringUtils encriptar:dir2 conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//dir2
					 [StringUtils encriptar:nPais conToken:self.datos.token != nil ? self.datos.token : passwordEncriptar],//npais
                     [StringUtils encriptar:codProm conToken:self.datos.token != nil ? self.datos.token: passwordEncriptar],//codProm
                     [StringUtils encriptar:domainType conToken:self.datos.token != nil ? self.datos.token: passwordEncriptar],
                     [StringUtils encriptar:idDominio conToken:self.datos.token != nil ? self.datos.token: passwordEncriptar]];
    
    NSLog(@"EL DOMINIO ENVIADO ES: %@", domainType);
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en CrearUsuario WS_HandelDominio crearUsuario %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        self.arregloItems = [[NSMutableArray alloc] init];
        if ([parser parse]) {
            if (requiereEncriptar) {
               self.datos = [DatosUsuario sharedInstance];
               
                //self.datos.codigoRedimir = codigoPromocional;
                
                NSLog(@"LOS VALORES QUE ME CAUSAN RUIDO SON %@ Y EL OTRO ES: %@", self.datos.token,[StringUtils desEncriptar:self.resultado conToken:self.datos.token] );
                
                NSString * stringResult = [StringUtils desEncriptar:self.resultado conToken:self.datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    NSLog(@"HUBO UN ERROR DE TOKEN AL CREAR AL USUARIO crearUsuario !");
                    [self.wSHandlerDelegate errorToken];
                    
                }
                else {
                    NSInteger respuestaInt = [stringResult integerValue];
                    if (respuestaInt > 0) {
                        self.datos.emailUsuario = email;
                        self.datos.passwordUsuario = pass;
                        self.datos.itemsDominio = [StringUtils ordenarItems:self.arregloItems];
                        self.datos.idDominio = [stringResult intValue];
                        self.datos.codigoError = codigoError.length > 0 ? codigoError.intValue : 0;
                        self.datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telIni
                                                                                                           conToken:self.datos.token]
                                                                                     from:@"yyyy-MM-dd"
                                                                                       to:@"dd-MM-yyy"];
                        self.datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telFin
                                                                                                         conToken:self.datos.token]
                                                                                   from:@"yyyy-MM-dd"
                                                                                     to:@"dd-MM-yyy"];

                        self.datos.fechaInicial = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaInicio conToken:self.datos.token]
                                                                                  from:@"yyyy-MM-dd"
                                                                                    to:@"dd-MM-yyy"];

                        self.datos.fechaFinal = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaFinal
                                                                                                      conToken:self.datos.token]
                                                                                from:@"yyyy-MM-dd"
                                                                                  to:@"dd-MM-yyy"];
                        self.datos.idDominio = respuestaInt;
                        self.datos.dominio = user;
                        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                        if ([statusDominio hasSuffix:@"PRO"]) {
                            NSArray *arrayAux = [statusDominio componentsSeparatedByString:@" "];
                            if ([arrayAux count] ==2) {
                                if ([[arrayAux objectAtIndex:0] isEqualToString:@"Tramite"]) {
                                    appDelegate.statusDominio = statusDominio;
                                }
                                else {
                                    appDelegate.statusDominio = @"Pago";
                                }
                            }
                        }
                        else {
                            appDelegate.statusDominio = statusDominio;
                        }
                      
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        [prefs setObject:user forKey:@"dominioPublicado"];
                        [prefs synchronize];
                        [self.wSHandlerDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else if (respuestaInt == -3 || respuestaInt == -5) {
                        self.datos.emailUsuario = email;
                        self.datos.passwordUsuario = pass;
                        self.datos.idDominio = [stringResult intValue];
                        self.datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telIni
                                                                                                           conToken:self.datos.token]
                                                                                     from:@"yyyy-MM-dd"
                                                                                       to:@"dd-MM-yyy"];
                        self.datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telFin
                                                                                                         conToken:self.datos.token]
                                                                                   from:@"yyyy-MM-dd"
                                                                                     to:@"dd-MM-yyy"];
                        self.datos.idDominio = respuestaInt;
                        self.datos.dominio = user;
                        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = @"Pendiente";
                        [self.wSHandlerDelegate resultadoConsultaDominio:@"Error Publicar"];
                    }
                    else if (respuestaInt == -4) {
                        [self.wSHandlerDelegate resultadoConsultaDominio:@"Usuario Existe"];
                    }
                    else {
                        [self.wSHandlerDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
            }
            else {
                [self.wSHandlerDelegate resultadoConsultaDominio:@"No Exito"];
            }
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}

-(void) consultaVisitasDominio {
    self.datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                               "<soapenv:Header/>"
                               "<soapenv:Body>"
                               "<ws:getNumVisitas>"
                               "<idDomain>%@</idDomain>"
                               "<token>%@</token>"
                               "</ws:getNumVisitas>"
                               "</soapenv:Body>"
                               "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", self.datos.idDominio] conToken:self.datos.token],
                               [StringUtils encriptar:self.datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:getNumVisitas>"
                     "<Domain>%@</Domain>"
                     "</ws:getNumVisitas>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", self.datos.dominio];
    }
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en ws_handlerdominio consultaVisitasDominio %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                self.datos = [DatosUsuario sharedInstance];
               
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:self.datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                }
                else {
                    [self.wSHandlerDelegate resultadoConsultaDominio:stringResult];
                }
                
            }
            else {
                [self.wSHandlerDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}
-(void) consultaExpiracionDominio {
    self.datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                               "<soapenv:Header/>"
                               "<soapenv:Body>"
                               "<ws:getFechaExpiracion>"
                               "<idDomain>%@</idDomain>"
                               "<token>%@</token>"
                               "</ws:getFechaExpiracion>"
                               "</soapenv:Body>"
                               "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", self.datos.idDominio] conToken:self.datos.token],
                               [StringUtils encriptar:self.datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:getFechaExpiracion>"
                     "<Domain>%@</Domain>"
                     "</ws:getFechaExpiracion>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", self.datos.dominio];
    }
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en ws_handlerdominio consultaExpiraciondominio %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                self.datos = [DatosUsuario sharedInstance];
               
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:self.datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                }
                else {
                    [self.wSHandlerDelegate resultadoConsultaDominio:stringResult];
                }
            }
            else {
                [self.wSHandlerDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}

-(void) cancelarCuenta:(NSString *)motivo {
    self.datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
      
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
					 "<soapenv:Header/>"
					 "<soapenv:Body>"
					 "<ws:cancelarCuenta>"
					 "<domain>%@</domain>"
					 "<Usuario>%@</Usuario>"
					 "<descripcion>%@</descripcion>"
					 "<password>%@</password>"
					 "<token>%@</token>"
					 "</ws:cancelarCuenta>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>", [StringUtils encriptar:self.datos.dominio conToken:self.datos.token], [StringUtils encriptar:self.datos.emailUsuario conToken:self.datos.token], [StringUtils encriptar:motivo conToken:self.datos.token],[StringUtils encriptar:self.datos.passwordUsuario conToken:self.datos.token],[StringUtils encriptar:self.datos.emailUsuario conToken:passwordEncriptar]];
	
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:cancelarCuenta>"
                     "<Usuario>%@</Usuario>"
                     "<descripcion>%@</descripcion>"
                     "</ws:cancelarCuenta>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", self.datos.emailUsuario, motivo];
    }
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en ws_handlerDominio cancelarcuenta %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                self.datos = [DatosUsuario sharedInstance];
                
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:self.datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                }
                else {
                    [self.wSHandlerDelegate resultadoConsultaDominio:stringResult];
                }
            }
            else {
                [self.wSHandlerDelegate resultadoConsultaDominio:self.resultado];
            }
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}
-(void) consultaSession:(NSString *) usuario {
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:sessionActiva>"
                           "<email>%@</email>"
                           "</ws:sessionActiva>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>", [StringUtils encriptar:usuario conToken:passwordEncriptar]];
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en ws_handlerdominio consultasession %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:self.token];
            NSLog(@"WS_handlerdominio:  El resultado de la pregunta de si tiene la sesion abierta es: %@", stringResult);
                [self.wSHandlerDelegate resultadoConsultaDominio:stringResult];

        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}
-(void) cerrarSession:(NSString *) usuario {
    self.datos = [DatosUsuario sharedInstance];
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:cerrarSession>"
                           "<email>%@</email>"
                           "<token>%@</token>"
                           "</ws:cerrarSession>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>", [StringUtils encriptar:usuario conToken:passwordEncriptar],
                           [StringUtils encriptar:self.datos.token conToken:passwordEncriptar]];
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en ws_handlerdominio cerrar sesion %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {

            [StringUtils deleteResourcesWithExtension:@"jpg"];
            [StringUtils deleteFile];
            [self.datos eliminarDatos];
        }
    }
    // Se cierra la sesion //
    NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
    [prefSesion setObject:nil forKey:@"strSesionUser"];
    [prefSesion setObject:nil forKey:@"strSesionPass"];
    [prefSesion setInteger:0 forKey:@"intSesionFacebook"];
    [prefSesion setInteger:0 forKey:@"intSesionActiva"];
    [prefSesion synchronize];
}

-(void) consultaEstatusDominio {
    self.datos = [DatosUsuario sharedInstance];
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:statusDominio>"
                           "<domainId>%@</domainId>"
                           "<email>%@</email>"
                           "</ws:statusDominio>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>",
                           [StringUtils encriptar:[NSString stringWithFormat:@"%i", self.datos.idDominio] conToken:self.datos.token],
                           [StringUtils encriptar:self.datos.emailUsuario conToken:passwordEncriptar]];
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en ws_handlerdominio consultaEstatusDominio %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
                self.datos = [DatosUsuario sharedInstance];
            
                NSString * stringResult = [StringUtils desEncriptar:self.resultado conToken:self.datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                }
                else {
                    self.datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaInicio
                                                                                                       conToken:self.datos.token]
                                                                                 from:@"yyyy-MM-dd"
                                                                                   to:@"dd-MM-yyy"];
                    self.datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaFinal
                                                                                                     conToken:self.datos.token]
                                                                               from:@"yyyy-MM-dd"
                                                                                 to:@"dd-MM-yyy"];
                    
                    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = stringResult;
                    [self.wSHandlerDelegate resultadoConsultaDominio:@"Exito"];
                }
				
            
        }
        else {
            [self.wSHandlerDelegate errorConsultaWS];
        }
    }
    else {
        [self.wSHandlerDelegate errorConsultaWS];
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
#if DEBUG
    NSLog(@"Veamos que pone de error %@ y el code es: %i", parseError.userInfo, parseError.code);
#endif
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"getExistDomainReturn"]) {
        self.currentElementString = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString:@"resultado"]) {//creacion de usuario y dominio
        self.currentElementString = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = [[NSString alloc] init];
    }
	else if ([elementName isEqualToString:@"fTelNamesIni"]){
		self.currentElementString = [[NSString alloc] init];
	}
	else if ([elementName isEqualToString:@"fTelNamesFin"]){
		self.currentElementString = [[NSString alloc] init];
	}
    else if ([elementName isEqualToString:@"fechaIni"]){
		self.currentElementString = [[NSString alloc] init];
	}
	else if ([elementName isEqualToString:@"fechaFin"]){
		self.currentElementString = [[NSString alloc] init];
	}
    else if ([elementName isEqualToString:@"statusDominio"]) {
        self.currentElementString = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString:@"listStatusDomainVO"]) {
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
    if ([elementName isEqualToString:@"getExistDomainReturn"]) {
        self.resultado = self.currentElementString;
        NSLog(@"EL RESULTADO ES GETEXISTDOMAINRETURN: %@", [StringUtils desEncriptar:self.resultado conToken:self.datos.token]);
        NSLog(@"EL RESULTADO ES GETEXISTDOMAINRETURN CON OTRO TOKEN: %@", [StringUtils desEncriptar:self.resultado conToken:self.token]);
    }
    else if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = self.currentElementString;
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
    }
	else if ([elementName isEqualToString:@"fTelNamesIni"]){
		self.telIni= self.currentElementString;
	}
	else if ([elementName isEqualToString:@"fTelNamesFin"]){
		self.telFin = self.currentElementString;
	}
    else if ([elementName isEqualToString:@"fechaIni"]){
        self.fechaInicio = self.currentElementString;
	}
	else if ([elementName isEqualToString:@"fechaFin"]){
        self.fechaFinal = self.currentElementString;
	}
    else if ([elementName isEqualToString:@"statusDominio"]) {
        statusDominio = [StringUtils desEncriptar:self.currentElementString conToken:self.token];

    }
    else if ([elementName isEqualToString:@"listStatusDomainVO"]) {
        [self.arregloItems addObject:itemDominio];
    }
    else if ([elementName isEqualToString:@"descripcionItem"]) {
        if (requiereEncriptar) {
            itemDominio.descripcionItem = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            itemDominio.descripcionItem = self.currentElementString;
        }
    }
    else if ([elementName isEqualToString:@"status"]) {
        if (requiereEncriptar) {
            itemDominio.estatus = [[StringUtils desEncriptar:self.currentElementString conToken:self.token] integerValue];
        }
        else {
            itemDominio.estatus = [self.currentElementString integerValue];
        }
    }
    else if ([elementName isEqualToString:@"codeError"]) {
        codigoError = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
    }
    else if ([elementName isEqualToString:@"codeCamp"]) {

        codigoPromocional = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
    }
    
    else if ([elementName isEqualToString:@"domainType"]) {
#if DEBUG
        NSLog(@"WS_ HANDLERDOMINIO DOMAINTYPE %@" ,[StringUtils desEncriptar:self.currentElementString conToken:self.token]);
#endif
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	self.devToken = [[[[deviceToken description]
								stringByReplacingOccurrencesOfString: @"<" withString: @""]
							   stringByReplacingOccurrencesOfString: @">" withString: @""]
							  stringByReplacingOccurrencesOfString: @" " withString: @""];
#ifdef _DEBUG
	NSLog(@"Device token: %@",self.devToken);
#endif
}

@end

