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

-(void) consultaDominio:(NSString *) dominio {
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                               "<soapenv:Header/>"
                               "<soapenv:Body>"
                               "<ws:getExistDomain>"
                               "<domainName>%@</domainName>"
                               "<domainType>%@</domainType>"
                               "</ws:getExistDomain>"
                               "</soapenv:Body>"
                               "</soapenv:Envelope>", [StringUtils encriptar:dominio conToken:passwordEncriptar], [StringUtils encriptar:@"recurso" conToken:passwordEncriptar]];
    
    NSLog(@"el string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta de WS_HandlerDominio es %s", [dataResult bytes]);
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
                } else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wSHandlerDelegate sessionTimeout];
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
    DatosUsuario *datos = [DatosUsuario sharedInstance];
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
    DatosUsuario *datos = [DatosUsuario sharedInstance];
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
					 [StringUtils encriptar:@"0" conToken:datos.token != nil ? datos.token : passwordEncriptar],//phone
                     [StringUtils encriptar:pass conToken:datos.token != nil ? datos.token : passwordEncriptar],//password
                     [StringUtils encriptar:user conToken:datos.token != nil ? datos.token : passwordEncriptar],//domainName
                     [StringUtils encriptar:s conToken:datos.token != nil ? datos.token : passwordEncriptar],//status
					 [StringUtils encriptar:@"IOS" conToken:datos.token != nil ? datos.token : passwordEncriptar],//sistema
					 [StringUtils encriptar:@"0" conToken:datos.token != nil ? datos.token : passwordEncriptar],//tipoDispositivo
					 [StringUtils encriptar:@"0" conToken:datos.token != nil ? datos.token : passwordEncriptar],//notificacion
					 [StringUtils encriptar:@"5" conToken:datos.token != nil ? datos.token : passwordEncriptar],//tipoAction
					 [StringUtils encriptar:@"1" conToken:datos.token != nil ? datos.token : passwordEncriptar],//Pais
					 [StringUtils encriptar:@"0" conToken:datos.token != nil ? datos.token : passwordEncriptar],//Canal
					 [StringUtils encriptar:@"1" conToken:datos.token != nil ? datos.token : passwordEncriptar],//Sucursal
					 [StringUtils encriptar:@"0" conToken:datos.token != nil ? datos.token : passwordEncriptar],//Folio
					 [StringUtils encriptar:nom conToken:datos.token != nil ? datos.token : passwordEncriptar],//nombre
					 [StringUtils encriptar:dir1 conToken:datos.token != nil ? datos.token : passwordEncriptar],//dir1
					 [StringUtils encriptar:dir2 conToken:datos.token != nil ? datos.token : passwordEncriptar],//dir2
					 [StringUtils encriptar:nPais conToken:datos.token != nil ? datos.token : passwordEncriptar],//npais
                     [StringUtils encriptar:codProm conToken:datos.token != nil ? datos.token: passwordEncriptar],//codProm
                     [StringUtils encriptar:domainType conToken:datos.token != nil ? datos.token: passwordEncriptar],
                     [StringUtils encriptar:idDominio conToken:datos.token != nil ? datos.token: passwordEncriptar]];
		
		NSLog(@"token:: %@",datos.token != nil ? datos.token : passwordEncriptar);
		NSLog(@"token: %@",datos.token);
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es en CrearUsuario WS_HandelDominio %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        self.arregloItems = [[NSMutableArray alloc] init];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos.token = self.token;
                datos.codigoRedimir = codigoPromocional;
                NSString * stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                } else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wSHandlerDelegate sessionTimeout];
                else {
                    NSInteger respuestaInt = [stringResult integerValue];
                    if (respuestaInt > 0) {
                        datos.emailUsuario = email;
                        datos.passwordUsuario = pass;
                        datos.itemsDominio = [StringUtils ordenarItems:self.arregloItems];
                        datos.idDominio = [stringResult intValue];
                        datos.codigoError = codigoError.length > 0 ? codigoError.intValue : 0;
                        datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telIni
                                                                                                           conToken:datos.token]
                                                                                     from:@"yyyy-MM-dd"
                                                                                       to:@"dd-MM-yyy"];
                        datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telFin
                                                                                                         conToken:datos.token]
                                                                                   from:@"yyyy-MM-dd"
                                                                                     to:@"dd-MM-yyy"];

                        datos.fechaInicial = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaInicio conToken:datos.token]
                                                                                  from:@"yyyy-MM-dd"
                                                                                    to:@"dd-MM-yyy"];

                        datos.fechaFinal = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaFinal
                                                                                                      conToken:datos.token]
                                                                                from:@"yyyy-MM-dd"
                                                                                  to:@"dd-MM-yyy"];
                        datos.idDominio = respuestaInt;
                        datos.dominio = user;
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
                        NSLog(@"token::: %@",datos.token);
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        [prefs setObject:user forKey:@"dominioPublicado"];
                        [prefs synchronize];
                        [self.wSHandlerDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else if (respuestaInt == -3 || respuestaInt == -5) {
                        datos.emailUsuario = email;
                        datos.passwordUsuario = pass;
                        datos.idDominio = [stringResult intValue];
                        datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telIni
                                                                                                           conToken:datos.token]
                                                                                     from:@"yyyy-MM-dd"
                                                                                       to:@"dd-MM-yyy"];
                        datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telFin
                                                                                                         conToken:datos.token]
                                                                                   from:@"yyyy-MM-dd"
                                                                                     to:@"dd-MM-yyy"];
                        datos.idDominio = respuestaInt;
                        datos.dominio = user;
                        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = @"Pendiente";
                        NSLog(@"token::: %@",datos.token);
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

-(void) redimirCodigo:(NSString *)codProm {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    
    stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                 "<soapenv:Header/>"
                 "<soapenv:Body>"
                 "<ws:insertUserCam>"
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
                 "</UserDomainVO>"
                 "</ws:insertUserCam>"
                 "</soapenv:Body>"
                 "</soapenv:Envelope>", //[StringUtils encriptar:dominio conToken:passwordEncriptar],
                 [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar],
                 [StringUtils encriptar:@"0" conToken:datos.token != nil ? datos.token : passwordEncriptar],//phone
                 [StringUtils encriptar:datos.passwordUsuario conToken:datos.token != nil ? datos.token : passwordEncriptar],//password
                 [StringUtils encriptar:datos.dominio conToken:datos.token != nil ? datos.token : passwordEncriptar],//domainName
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//status
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//sistema
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//tipoDispositivo
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//notificacion
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//tipoAction
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//Pais
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//Canal
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//Sucursal
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//Folio
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//nombre
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//dir1
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//dir2
                 [StringUtils encriptar:@" " conToken:datos.token != nil ? datos.token : passwordEncriptar],//npais
                 [StringUtils encriptar:codProm conToken:datos.token != nil ? datos.token: passwordEncriptar]];//codProm
    
    NSLog(@"token:: %@",datos.token != nil ? datos.token : passwordEncriptar);
    NSLog(@"token: %@",datos.token);
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        self.arregloItems = [[NSMutableArray alloc] init];
        [parser setDelegate:self];
        if ([parser parse]) {
            datos.token = self.token;
            datos.codigoRedimir = codigoPromocional;
            NSString * stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
            if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                [self.wSHandlerDelegate errorToken];
            } else if ([stringResult isEqualToString:@"SessionTO"])
                [self.wSHandlerDelegate sessionTimeout];
            else {
                NSInteger respuestaInt = [stringResult integerValue];
                if (respuestaInt > 0) {
                    datos.codigoRedimir = codigoPromocional;
                    datos.itemsDominio = [StringUtils ordenarItems:self.arregloItems];
                    datos.idDominio = [stringResult intValue];
                    datos.codigoError = codigoError.length > 0 ? codigoError.intValue : 0;

                    datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telIni
                                                                                                       conToken:datos.token]
                                                                                 from:@"yyyy-MM-dd"
                                                                                   to:@"dd-MM-yyy"];

                    datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telFin
                                                                                                     conToken:datos.token]
                                                                               from:@"yyyy-MM-dd"
                                                                                 to:@"dd-MM-yyy"];

                    datos.fechaInicial = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaInicio conToken:datos.token]
                                                                              from:@"yyyy-MM-dd"
                                                                                to:@"dd-MM-yyy"];

                    datos.fechaFinal = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.fechaFinal
                                                                                                  conToken:datos.token]
                                                                            from:@"yyyy-MM-dd"
                                                                              to:@"dd-MM-yyy"];
                    NSLog(@"token::: %@",datos.token);
                    if ([statusDominio hasSuffix:@"PRO"]) {
                        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
                    [self.wSHandlerDelegate resultadoConsultaDominio:@"Exito"];
                }
                else if (respuestaInt == -3 || respuestaInt == -5) {
                    datos.idDominio = [stringResult intValue];
                    datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telIni
                                                                                                       conToken:datos.token]
                                                                                 from:@"yyyy-MM-dd"
                                                                                   to:@"dd-MM-yyy"];
                    datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telFin
                                                                                                     conToken:datos.token]
                                                                               from:@"yyyy-MM-dd"
                                                                                 to:@"dd-MM-yyy"];
                    datos.idDominio = respuestaInt;
                    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = @"Pendiente";
                    NSLog(@"token::: %@",datos.token);
                    [self.wSHandlerDelegate resultadoConsultaDominio:@"Error Publicar"];
                }
                else if (respuestaInt == -4) {
                    [self.wSHandlerDelegate resultadoConsultaDominio:@"Usuario Existe"];
                }
                else {
                    datos.codigoRedimir = codigoPromocional;
                    datos.codigoError = codigoError.length > 0 ? codigoError.intValue : 0;
                    [self.wSHandlerDelegate resultadoConsultaDominio:@"No Exito"];
                }
            }
        }
    }
}

-(void) consultaVisitasDominio {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
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
                               "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                               [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:getNumVisitas>"
                     "<Domain>%@</Domain>"
                     "</ws:getNumVisitas>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", datos.dominio];
    }
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                } else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wSHandlerDelegate sessionTimeout];
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
    DatosUsuario *datos = [DatosUsuario sharedInstance];
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
                               "</soapenv:Envelope>", [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                               [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:getFechaExpiracion>"
                     "<Domain>%@</Domain>"
                     "</ws:getFechaExpiracion>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", datos.dominio];
    }
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                } else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wSHandlerDelegate sessionTimeout];
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
    DatosUsuario *datos = [DatosUsuario sharedInstance];
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
					 "</soapenv:Envelope>", [StringUtils encriptar:datos.dominio conToken:datos.token], [StringUtils encriptar:datos.emailUsuario conToken:datos.token], [StringUtils encriptar:motivo conToken:datos.token],[StringUtils encriptar:datos.passwordUsuario conToken:datos.token],[StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
		
		NSLog(@"dominio:%@, usuario:%@, descripcion:%@, password:%@, token:%@",datos.dominio,datos.emailUsuario,motivo,datos.passwordUsuario,datos.token);
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
                     "</soapenv:Envelope>", datos.emailUsuario, motivo];
    }
    
    self.strSoapAction = @"wsInfomovildomain";
    NSLog(@"la peticion es %@", stringXML);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
                NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                } else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wSHandlerDelegate sessionTimeout];
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
   // NSLog(@"La respuesta es %s", [dataResult bytes]);
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
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:cerrarSession>"
                           "<email>%@</email>"
                           "<token>%@</token>"
                           "</ws:cerrarSession>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>", [StringUtils encriptar:usuario conToken:passwordEncriptar],
                           [StringUtils encriptar:datosUsuario.token conToken:passwordEncriptar]];
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {

            [StringUtils deleteResourcesWithExtension:@"jpg"];
            [StringUtils deleteFile];
            [datosUsuario eliminarDatos];
        }
    }
}

-(void) consultaEstatusDominio {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    NSString *stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                           "<soapenv:Header/>"
                           "<soapenv:Body>"
                           "<ws:statusDominio>"
                           "<domainId>%@</domainId>"
                           "<email>%@</email>"
                           "</ws:statusDominio>"
                           "</soapenv:Body>"
                           "</soapenv:Envelope>",
                           [StringUtils encriptar:[NSString stringWithFormat:@"%i", datosUsuario.idDominio] conToken:datosUsuario.token],
                           [StringUtils encriptar:datosUsuario.emailUsuario conToken:passwordEncriptar]];
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
                DatosUsuario *datos = [DatosUsuario sharedInstance];
                datos.token = self.token;
                NSString * stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.wSHandlerDelegate errorToken];
                } else if ([stringResult isEqualToString:@"SessionTO"])
                    [self.wSHandlerDelegate sessionTimeout];
                else {
                    datos.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telIni
                                                                                                       conToken:datos.token]
                                                                                 from:@"yyyy-MM-dd"
                                                                                   to:@"dd-MM-yyy"];
                    datos.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:[StringUtils desEncriptar:self.telFin
                                                                                                     conToken:datos.token]
                                                                               from:@"yyyy-MM-dd"
                                                                                 to:@"dd-MM-yyy"];
                    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = stringResult;
                    NSLog(@"token::: %@",datos.token);
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
    }
    else if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = self.currentElementString;
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
		NSLog(@"recibo token: %@",self.token);
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

