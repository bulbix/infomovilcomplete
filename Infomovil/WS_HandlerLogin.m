//
//  WS_HandlerLogin.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerLogin.h"
#import "NSStringUtiles.h"
#import "Base64.h"
#import "JFRandom.h"
#import "KeywordDataModel.h"
#import "NSDateFormatterUtiles.h"
#import "ListaHorarios.h"
#import "ItemsDominio.h"
#import "AppDelegate.h"
#import "DominiosUsuario.h"



@interface WS_HandlerLogin () {
    BOOL esLogo;
    BOOL guardarLogo;
    NSInteger indexInsertar;
    BOOL hayPerfil;
    ItemsDominio *itemDominio;
    DominiosUsuario *dominioUsuario;
    BOOL esRecurso;
}

@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;
@property (nonatomic, strong) KeywordDataModel *keywordData;
@property (nonatomic, strong) NSMutableArray *arregloDireccion;
@property (nonatomic, strong) NSMutableArray *arregloPerfil;
@property (nonatomic, strong) NSMutableArray *arregloAdicional;
@property (nonatomic, strong) NSDictionary *diccionarioInformacion;
@property (nonatomic, strong) NSString *idDominioAux;
@property (nonatomic, strong) NSString *colorAux;
@property (nonatomic, strong) NSString *descipcionAux;
@property (nonatomic, strong) NSString *nombreEmpresaAux;
@property (nonatomic, strong) NSMutableArray *arregloItems;
@property (nonatomic, strong) NSMutableArray *arregloTiposDominio;
@property (nonatomic, strong) NSMutableArray *arregloDominiosUsuario;

@end

@implementation WS_HandlerLogin

-(void) obtieneLogin:(NSString *)usuario conPassword:(NSString *)password {
    if (self.redSocial == nil) {
        self.redSocial = @"";
        
        NSUserDefaults *prefsLogin = [NSUserDefaults standardUserDefaults];
        if( [prefsLogin integerForKey:@"intRecordar"] == 1){ NSLog(@"Realice el login con 1 !!");
            [prefsLogin setObject:usuario forKey:@"strRecordarUser"];
            [prefsLogin setObject:password forKey:@"strRecordarPass"];
            [prefsLogin synchronize];
        }
        
        
        
    }
    NSString *stringXML;
  
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:getDomain>"
                     "<email>%@</email>"
                     "<password>%@</password>"
                     "<redSocial>%@</redSocial>"
                     "<tipoDispositivo>%@</tipoDispositivo>"
                     "<sistema>%@</sistema>"
                     "<suscrito>%@</suscrito>"
                     "<tipoPlan>%@</tipoPlan>"
                     "<medioPago>%@</medioPago>"
                     "</ws:getDomain>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:usuario conToken:passwordEncriptar],
                     [StringUtils encriptar:password conToken:passwordEncriptar],
                     [StringUtils encriptar:self.redSocial conToken:passwordEncriptar],
                     [StringUtils encriptar:@"0" conToken:passwordEncriptar],
                     [StringUtils encriptar:@"IOS" conToken:passwordEncriptar],
                     [StringUtils encriptar:@"false" conToken:passwordEncriptar],
                     [StringUtils encriptar:@"" conToken:passwordEncriptar],
                     [StringUtils encriptar:@"APP STORE" conToken:passwordEncriptar]];
    
                        NSLog(@"El usuario es: %@  pass: %@  redsocial: %@", usuario, password, self.redSocial);
    stringXML = [NSString decodificaHtml:stringXML];
#ifdef DEBUG
    NSLog(@"El string es %@", stringXML);
#endif
    
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
  //  NSLog(@"IRC : La respuesta es del login es: %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.arregloContactos = [[NSMutableArray alloc] init];
        self.arregloImagenes = [[NSMutableArray alloc] init];
        self.arregloDireccion = [[NSMutableArray alloc] init];
        hayPerfil = NO;
        self.arregloPerfil = [[NSMutableArray alloc] initWithArray:@[[[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init]]];
        self.arregloAdicional = [[NSMutableArray alloc] init];
        self.diccionarioInformacion = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CatalogoInformacion" ofType:@"plist"]];
        NSArray *arregloAux = @[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO];
        self.datosUsuario.arregloEstatusEdicion = [[NSMutableArray alloc] init];
        [self.datosUsuario.arregloEstatusEdicion addObjectsFromArray:arregloAux];
        self.arregloItems = [[NSMutableArray alloc] init];
        self.arregloTiposDominio = [[NSMutableArray alloc] init];
        self.arregloDominiosUsuario = [[NSMutableArray alloc] init];
        guardarLogo = NO;
        self.currentElementString = [[NSMutableString alloc] init];
        if([parser parse]) {

                self.datosUsuario = [DatosUsuario sharedInstance];
                self.datosUsuario.token = self.token;
                [StringUtils deleteResourcesWithExtension:@"js"];
                [StringUtils deleteResourcesWithExtension:@"css"];
				
				NSString *auxIdDom = [StringUtils desEncriptar:self.idDominioAux conToken:self.datosUsuario.token];
                self.datosUsuario.idDominio = [auxIdDom integerValue];
                self.idDominio = [auxIdDom integerValue];
                
                if (self.colorAux.length > 0 && self.colorAux != Nil) {
                    auxIdDom = [StringUtils desEncriptar:self.colorAux conToken:self.datosUsuario.token];
                    if (auxIdDom.length > 6) {
                        self.datosUsuario.colorSeleccionado = [StringUtils colorFromHexString:auxIdDom];
                        self.datosUsuario.eligioColor = YES;
                    }
                }
                if (self.descipcionAux.length > 0 && self.descipcionAux != Nil) {
                    self.descipcionAux = [StringUtils desEncriptar:self.descipcionAux conToken:self.datosUsuario.token];
                    if ((self.descipcionAux.length > 0 && ![self.descipcionAux isEqualToString:@"Título"]) && ![self.descipcionAux isEqualToString:@"(null)"]) {
                        self.datosUsuario.descripcion = self.descipcionAux;
                        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:3 withObject:@YES];
                    }
                }
                if (self.datosUsuario.dominio.length > 0 && self.datosUsuario.dominio != Nil) {
                    self.datosUsuario.dominio = [StringUtils desEncriptar:self.datosUsuario.dominio conToken:self.datosUsuario.token];
                }
                if (self.nombreEmpresaAux.length > 0 && self.nombreEmpresaAux != Nil) {
                    self.nombreEmpresaAux = [StringUtils desEncriptar:self.nombreEmpresaAux conToken:self.datosUsuario.token];
                    if (![self.nombreEmpresaAux isEqualToString:@"Título"] && ![self.nombreEmpresaAux isEqualToString:@"(null)"]) {
                        self.datosUsuario.nombreEmpresa = self.nombreEmpresaAux;
                        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:0 withObject:@YES];
                    }
                }
                if (self.datosUsuario.urlVideo.length > 0 && self.datosUsuario.urlVideo != Nil) {
                    self.datosUsuario.urlVideo = [StringUtils desEncriptar:self.datosUsuario.urlVideo conToken:self.datosUsuario.token];
                    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:6 withObject:@YES];
                }
                
                
                [self acomodaContactos];
                self.datosUsuario.arregloContacto = self.arregloContactos;
                for (NSInteger i = 0; i < [self.arregloImagenes count]; i++) {
                    GaleriaImagenes *galImagenes = [self.arregloImagenes objectAtIndex:i];
                    if (galImagenes.pieFoto != Nil && galImagenes.pieFoto.length > 0) {
                        galImagenes.pieFoto = [StringUtils desEncriptar:galImagenes.pieFoto conToken:self.datosUsuario.token];
                    }
                    if (galImagenes.imagenIdAux != Nil && galImagenes.imagenIdAux.length > 0) {
                        NSString *auxString = [StringUtils desEncriptar:galImagenes.imagenIdAux conToken:self.datosUsuario.token];
                        [galImagenes setIdImagen:[auxString integerValue]];
                    }
                    [self.arregloImagenes replaceObjectAtIndex:i withObject:galImagenes];
                }
                self.datosUsuario.arregloGaleriaImagenes = self.arregloImagenes;
                if ([self.arregloDireccion count] > 0 && [[StringUtils desEncriptar:[[self.arregloDireccion objectAtIndex:0] idAuxKeyword] conToken:self.datosUsuario.token] integerValue]!= 0) {
                    BOOL hayDatos = NO;
                    for (NSInteger i = 0; i < [self.arregloDireccion count]; i++) {
                        KeywordDataModel *keyAux = [self.arregloDireccion objectAtIndex:i];
                        if (keyAux.idAuxKeyword != Nil && keyAux.idAuxKeyword.length > 0) {
                            NSString *idAux = [StringUtils desEncriptar:keyAux.idAuxKeyword conToken:self.datosUsuario.token];
                            [keyAux setIdKeyword:[idAux integerValue]];
                        }
                        if (keyAux.keywordField != Nil && keyAux.keywordField.length > 0) {
                            keyAux.keywordField = [StringUtils desEncriptar:keyAux.keywordField conToken:self.datosUsuario.token];
                        }
						if (keyAux.KeywordPos != Nil && keyAux.KeywordPos.length > 0) {
                            keyAux.KeywordPos = [StringUtils desEncriptar:keyAux.KeywordPos conToken:self.datosUsuario.token];
                        }
                        if(keyAux.keywordValue != Nil && keyAux.keywordValue.length > 0) {
                            keyAux.keywordValue = [StringUtils desEncriptar:keyAux.keywordValue conToken:self.datosUsuario.token];
                            if (keyAux.keywordValue != nil && [[keyAux.keywordValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
                                hayDatos = YES;
                            }
                        }
                        [self.arregloDireccion replaceObjectAtIndex:i withObject:keyAux];
                    }
                    self.datosUsuario.direccion = self.arregloDireccion;
                    if (hayDatos) {
                        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:10 withObject:@YES];
                    }
                    
                }
                if ([self.arregloPerfil count] > 0 && hayPerfil) {
                    for (NSInteger i = 0; i < [self.arregloPerfil count]; i++) {
                        KeywordDataModel *keyAux = [self.arregloPerfil objectAtIndex:i];
                        if (keyAux.idAuxKeyword != Nil && keyAux.idAuxKeyword.length > 0) {
                            NSString *idAux = [StringUtils desEncriptar:keyAux.idAuxKeyword conToken:self.datosUsuario.token];
                            [keyAux setIdKeyword:[idAux integerValue]];
                        }
                        if (keyAux.keywordField != Nil && keyAux.keywordField.length > 0) {
                            keyAux.keywordField = [StringUtils desEncriptar:keyAux.keywordField conToken:self.datosUsuario.token];
                        }
						if (keyAux.KeywordPos != Nil && keyAux.KeywordPos.length > 0) {
                            keyAux.KeywordPos = [StringUtils desEncriptar:keyAux.KeywordPos conToken:self.datosUsuario.token];
                        }
                        if(keyAux.keywordValue != Nil && keyAux.keywordValue.length > 0) {
                            keyAux.keywordValue = [StringUtils desEncriptar:keyAux.keywordValue conToken:self.datosUsuario.token];
                        }
						if([keyAux.keywordValue isEqualToString:@"|Lun|00:00 - 00:00|Mar|00:00 - 00:00|Mie|00:00 - 00:00|Jue|00:00 - 00:00|Vie|00:00 - 00:00|Sab|00:00 - 00:00|Dom|00:00 - 00:00|"]){

							[self.arregloPerfil replaceObjectAtIndex:i withObject:keyAux];
						}else{
							[self.arregloPerfil replaceObjectAtIndex:i withObject:keyAux];
						}
                    }
                    //checar la llamada a acomodar horario ************************************
					int x = 0;
					for(KeywordDataModel * aux in self.arregloPerfil){
						if(aux.idKeyword == 0){
							x++;
						}
					}
					
					if(x == 7){
						self.datosUsuario.arregloDatosPerfil = self.arregloPerfil;
						[self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@NO];
					}else{
						self.datosUsuario.arregloDatosPerfil = self.arregloPerfil;
						[self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@YES];
		
                        [self validaEditados];
					}
                }
                if (self.promocionElegida != Nil) {
                    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:7 withObject:@YES];
                    [self verificarPromocion];
                }
                if ([self.arregloAdicional count] > 0) {
                    for (NSInteger i = 0; i < [self.arregloAdicional count]; i++) {
                        KeywordDataModel *keyAux = [self.arregloAdicional objectAtIndex:i];
                        if (keyAux.idAuxKeyword != Nil && keyAux.idAuxKeyword.length > 0) {
                            NSString *idAux = [StringUtils desEncriptar:keyAux.idAuxKeyword conToken:self.datosUsuario.token];
                            [keyAux setIdKeyword:[idAux integerValue]];
                        }
                        if (keyAux.keywordField != Nil && keyAux.keywordField.length > 0) {
                            keyAux.keywordField = [StringUtils desEncriptar:keyAux.keywordField conToken:self.datosUsuario.token];
                        }
						if (keyAux.KeywordPos != Nil && keyAux.KeywordPos.length > 0) {
                            keyAux.KeywordPos = [StringUtils desEncriptar:keyAux.KeywordPos conToken:self.datosUsuario.token];
                        }
                        if(keyAux.keywordValue != Nil && keyAux.keywordValue.length > 0) {
                            keyAux.keywordValue = [StringUtils desEncriptar:keyAux.keywordValue conToken:self.datosUsuario.token];
                        }
                        [self.arregloAdicional replaceObjectAtIndex:i withObject:keyAux];
                    }
                    self.datosUsuario.arregloInformacionAdicional = self.arregloAdicional;
                    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:11 withObject:@YES];
                }
            
            if ([self.arregloItems count] > 0) {
                self.datosUsuario.itemsDominio = self.arregloItems;
                self.datosUsuario.itemsDominio = [StringUtils ordenarItems:self.arregloItems];
                for(int x = 0; x< [self.datosUsuario.itemsTipoDominio count]; x++){
                    NSLog(@"GETDOMAIN WS_HANDLERLOGIN items que me da el server en el getDomain es: %@", self.datosUsuario.itemsTipoDominio);
                }
            }
            if ([self.arregloTiposDominio count] > 0) {
                self.datosUsuario.itemsTipoDominio = self.arregloTiposDominio;
            }
            if ([self.arregloDominiosUsuario count] > 0) {
                self.datosUsuario.dominiosUsuario = self.arregloDominiosUsuario;
            }
            else {
                dominioUsuario = [[DominiosUsuario alloc] init];
            }
            
            ((AppDelegate *) [[UIApplication sharedApplication] delegate]).fechaLogin = [NSDate date];
            [self.loginDelegate resultadoLogin:self.idDominio];
            
        }
        else {
            [self.loginDelegate errorConsultaWS];
        }
    }
    else {
        [self.loginDelegate errorConsultaWS];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.loginDelegate errorConsultaWS];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.currentElementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"idDomain"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"listRecordNaptrVo"]) {
        self.contactoActual = [[Contacto alloc] init];
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:4 withObject:@YES];
    }
    else if ([elementName isEqualToString:@"listOffertRecordVO"]) {
        self.promocionElegida = [[OffertRecord alloc] init];
    }
    else if ([elementName isEqualToString:@"claveContacto"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"listImagenVO"]) {
        self.galeria = [[GaleriaImagenes alloc] init];
    }
    else if ([elementName isEqualToString:@"listKeywordVO"]) {
        self.currentElementString = [[NSMutableString alloc] init];
        self.keywordData = [[KeywordDataModel alloc] init];
    }
    else if ([elementName isEqualToString:@"idKeyword"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"keywordField"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
	else if ([elementName isEqualToString:@"keywordPos"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"keywordValue"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"keywordPos"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"visible"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"latitudeLoc"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"longitudeLoc"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"descOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"discountOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"endDateOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"idOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"imageClobOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"redeemOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"termsOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"titleOffer"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"colour"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"listInfoUsuarioVO"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"canal"]) {
        self.currentElementString = [[NSMutableString alloc] init];
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
	else if ([elementName isEqualToString:@"statusDominio"]){
		self.currentElementString = [[NSMutableString alloc] init];
	}
	else if ([elementName isEqualToString:@"fechaIni"]){
		self.currentElementString = [[NSMutableString alloc] init];
	}
	else if ([elementName isEqualToString:@"fechaFin"]){
		self.currentElementString = [[NSMutableString alloc] init];
	}
	else if ([elementName isEqualToString:@"fTelNamesIni"]){
		self.currentElementString = [[NSMutableString alloc] init];
	}
	else if ([elementName isEqualToString:@"fTelNamesFin"]){
		self.currentElementString = [[NSMutableString alloc] init];
	}
    else if ([elementName isEqualToString:@"descripcionDominio"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"codeCamp"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"listExtDominioVO"]) {
        itemDominio = [[ItemsDominio alloc] init];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"extDesc"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"extStatus"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"listUsuarioDominiosVO"]) {
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
    else if ([elementName isEqualToString:@"idCtrlDomain"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"idDomain"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"statusCtrlDominio"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"statusVisible"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"idDomain"]) {
        if (dominioUsuario != nil) {
            NSString *strAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
            [dominioUsuario setIdDomain:[strAux integerValue]];
        }
        else {
            self.idDominioAux = self.currentElementString;
            self.currentElementString = [[NSMutableString alloc] init];
        }
        
    }
	else if ([elementName isEqualToString:@"statusDominio"]){
        NSString *valor = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        NSLog(@"EL VALOR QUE ME ENVIO COMO ESTATUSDOMINIO ES: %@", valor);
        if ([valor isEqualToString:@"Mes PRO"] || [valor isEqualToString:@"Anual PRO"]) {
            ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
        }
        else {
			((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = valor;
        }
		
	}
    else if ([elementName isEqualToString:@"listRecordNaptrVo"]) {
        [self.arregloContactos addObject:self.contactoActual];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"claveContacto"]) {
        [self.contactoActual setIdContacto:[self.currentElementString integerValue]];
        [self.contactoActual setValorContacto:self.currentElementString];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"regExp"]) {
        NSArray *arrAux = [self.currentElementString componentsSeparatedByString:@":"];
        if ([arrAux count] > 1) {
            [self.contactoActual setNoContacto:[arrAux objectAtIndex:1]];
        }
        else {
            [self.contactoActual setNoContacto:self.currentElementString];
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"replacementNaptr"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"servicesNaptr"]) {
        [self.contactoActual setServicio:self.currentElementString];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"subCategory"]) {
        [self.contactoActual setSubCategoria:self.currentElementString];
    }
    else if ([elementName isEqualToString:@"longLabelNaptr"]) {
        [self.contactoActual setDescripcion:self.currentElementString];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"visible"]) {
        if ([self.currentElementString isEqualToString:@"1"]) {
            [self.contactoActual setHabilitado:YES];
        }
        else {
            [self.contactoActual setHabilitado:NO];
        }
        [self.contactoActual setValorVisible:self.currentElementString];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"colour"]) {
        if (self.currentElementString.length > 6) {
            if (requiereEncriptar) {
                self.colorAux = self.currentElementString;
            }
            else {
                self.datosUsuario.colorSeleccionado = [StringUtils colorFromHexString:self.currentElementString];
            }
            self.datosUsuario.eligioColor = YES;
        }
        else {
            self.datosUsuario.colorSeleccionado = [UIColor whiteColor];
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"cssTemplate"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"displayString"]) {
        self.descipcionAux = self.currentElementString;
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"domainName"]) {
        self.datosUsuario.dominio = self.currentElementString;
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"textRecord"]) {
        self.nombreEmpresaAux = self.currentElementString;
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"video"]) {
        NSLog(@"El video es %@ *****************", self.currentElementString);
        if (self.currentElementString.length > 1) {
            self.datosUsuario.urlVideo = self.currentElementString;
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:6 withObject:@YES];
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"descOffer"]) {
        if (self.currentElementString.length > 0) {
            if (requiereEncriptar) {
                NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];

                [self.promocionElegida setDescOffer:auxOffer];
            }
            
        }
        
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"endDateOffer"]) {

        if (self.currentElementString.length > 0) {
            if (requiereEncriptar) {
                NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];

                [self.promocionElegida setEndDateAux:[NSDateFormatter getDateFromString:auxOffer withFormat:@"dd/MM/yyyy"]];
            }
        }
        
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"idOffer"]) {
        if (self.currentElementString.length > 0) {
            if (requiereEncriptar) {
                NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];

                [self.promocionElegida setIdOffer:[auxOffer integerValue]];
            }
            
        }
        
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"imageClobOffer"]) {
        if (self.currentElementString != nil && [[self.currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
            NSData *dataImagen = [Base64 decode:[self.currentElementString stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            
            NSString *filePath = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:@"imagenPromocion.jpg"];
            [dataImagen writeToFile:filePath atomically:YES];
            //        [self.diccionarioPromocion setObject:filePath forKey:@"rutaImagen"];
            [self.promocionElegida setPathImageOffer:filePath];
        }
        
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"termsOffer"]) {
        if (self.currentElementString.length > 0) {
            if (requiereEncriptar) {
                NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];

                [self.promocionElegida setTermsOffer:auxOffer];
            }
            
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"redeemOffer"]) {
        if (self.currentElementString > 0) {
            if (requiereEncriptar) {

                [self.promocionElegida setRedeemOffer:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
            }
        }
    }
    else if ([elementName isEqualToString:@"titleOffer"]) {
        if (self.currentElementString.length > 0) {
            if (requiereEncriptar) {
                NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];

                [self.promocionElegida setTitleOffer:auxOffer];
            }
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"listOffertRecordVO"]) {

        self.datosUsuario.promocionActual = self.promocionElegida;
    }
    else if ([elementName isEqualToString:@"listImagenVO"]) {
        if (esLogo) {
            if (guardarLogo) {
                self.datosUsuario.imagenLogo = self.galeria;
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:1 withObject:@YES];
            }
        }
        else {
            [self.arregloImagenes addObject:self.galeria];
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:8 withObject:@YES];
        }
    }
    else if ([elementName isEqualToString:@"typeImage"]) {
        if (requiereEncriptar) {
            NSString *typeImageAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
            if ([typeImageAux isEqualToString:@"LOGO"]) {
                esLogo = YES;
            }
            else {
                esLogo = NO;
            }
        }
        else {
            if ([self.currentElementString isEqualToString:@"LOGO"]) {
                esLogo = YES;
            }
            else {
                esLogo = NO;
            }
        }
        
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"descripcionImagen"]) {
        [self.galeria setPieFoto:self.currentElementString];
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"imagenClobGaleria"]) {
        NSData *dataImagen = [Base64 decode:[self.currentElementString stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        if (esLogo) {
            if (self.currentElementString.length > 0) {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:1 withObject:@YES];
                NSString *filePath = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:@"imagenLogo.jpg"];
                [dataImagen writeToFile:filePath atomically:YES];
                [self.galeria setRutaImagen:filePath];
                guardarLogo = YES;
            }
        }
        else {
            NSString *nombreImagen = [StringUtils randomStringWithLength:15];
            NSString *filePath = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", nombreImagen]];
            [dataImagen writeToFile:filePath atomically:YES];
            [self.galeria setRutaImagen:filePath];
        }
        self.currentElementString = [[NSMutableString alloc] init];
        
    }
    else if ([elementName isEqualToString:@"idImagen"]) {
        if (requiereEncriptar) {
            [self.galeria setIdImagen:[[StringUtils desEncriptar:self.currentElementString conToken:self.token] integerValue]];
            [self.galeria setImagenIdAux:self.currentElementString];
        }
        else {
            [self.galeria setIdImagen:[self.currentElementString integerValue]];
            [self.galeria setImagenIdAux:self.currentElementString];
        }
        
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"listLatitud"]) {
        
        if (self.latitude != 0.0 || self.longitude != 0.0) {
            NSLog(@"La latitud es %f y la longitud es %f", self.latitude, self.longitude);
            CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
            self.datosUsuario.localizacion = location;
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:5 withObject:@YES];
        }
        
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"latitudeLoc"]) {
        NSString *latAux = self.currentElementString;
        if (latAux.length > 0) {
            if (requiereEncriptar) {
                latAux = [StringUtils desEncriptar:latAux conToken:self.token];
                self.latitude = [latAux floatValue];
            }
            else {
                self.latitude = [latAux floatValue];
            }
            
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"longitudeLoc"]) {
        NSString *lonAux = self.currentElementString;
        if (lonAux.length > 0) {
            if (requiereEncriptar) {
                lonAux = [StringUtils desEncriptar:lonAux conToken:self.token];
                self.longitude = [lonAux doubleValue];
            }
            else {
                self.longitude = [lonAux doubleValue];
            }
            
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }//keywordData
    else if ([elementName isEqualToString:@"listKeywordVO"]) {
        //NSLog(@"La llave es %@", self.keywordData.keywordField);
        NSInteger inter;
        if (requiereEncriptar) {
            inter = [self buscarEnArreglo:self.diccionarioInformacion conLlave:[StringUtils desEncriptar:self.keywordData.keywordField conToken:self.token]];
        }
        else {
            inter = [self buscarEnArreglo:self.diccionarioInformacion conLlave:self.keywordData.keywordField];
        }
        
        if (inter == 1) {
            [self.arregloDireccion addObject:self.keywordData];
        }
        else if (inter == 2) {

            hayPerfil = YES;
            [self.arregloPerfil replaceObjectAtIndex:indexInsertar withObject:self.keywordData];
        }
        else {
            NSLog(@"Esta mal la comprobacion");
            [self.arregloAdicional addObject:self.keywordData];
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"idKeyword"]) {
        self.keywordData.idAuxKeyword = self.currentElementString;
        self.keywordData.idKeyword = [self.currentElementString integerValue];
    }
    else if ([elementName isEqualToString:@"keywordField"]) {
        self.keywordData.keywordField = self.currentElementString;
    }
	else if ([elementName isEqualToString:@"keywordPos"]) {
        self.keywordData.KeywordPos = self.currentElementString;
    }
    else if ([elementName isEqualToString:@"keywordValue"]) {
        self.keywordData.keywordValue = self.currentElementString;
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
		NSLog(@"recibo token login: %@",self.token);
    }
    else if ([elementName isEqualToString:@"calleNum"]) {
        if (requiereEncriptar) {
            self.datosUsuario.calleNumero = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.calleNumero = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"ciudad"]) {
        if (requiereEncriptar) {
            self.datosUsuario.ciudad = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.ciudad = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"correo"]) {
        if (requiereEncriptar) {
            self.datosUsuario.email = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.email = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"cp"]) {
        if (requiereEncriptar) {
            self.datosUsuario.cp = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.cp = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"estado"]) {
        if (requiereEncriptar) {
            self.datosUsuario.estado = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.estado = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"nombre"]) {
        if (requiereEncriptar) {
            self.datosUsuario.servicioCliente = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.servicioCliente = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"pais"]) {
        if (requiereEncriptar) {
            self.datosUsuario.pais = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.pais = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"poblacion"]) {
        if (requiereEncriptar) {
            self.datosUsuario.poblacion = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.poblacion = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"tel"]) {
        if (requiereEncriptar) {
            self.datosUsuario.numeroMovil = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }
        else {
            self.datosUsuario.numeroMovil = self.currentElementString;
        }
        self.currentElementString = [[NSMutableString alloc] init];
    }
	else if ([elementName isEqualToString:@"nameEmpresa"]) {
		if (requiereEncriptar) {
			self.datosUsuario.nombreOrganizacion = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
		}
		else {
			self.datosUsuario.nombreOrganizacion = self.currentElementString;
		}
		self.currentElementString = [[NSMutableString alloc] init];
	}
	else if ([elementName isEqualToString:@"canal"]) {
		self.currentElementString = [[NSMutableString alloc] init];
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
    else if ([elementName isEqualToString:@"keywordPos"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"preference"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
	else if ([elementName isEqualToString:@"fechaIni"]){
		if(requiereEncriptar){
			self.datosUsuario.fechaInicial = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
		}else{
			self.datosUsuario.fechaInicial = self.currentElementString;
		}
	}
	else if ([elementName isEqualToString:@"fechaFin"]){
		if(requiereEncriptar){
			self.datosUsuario.fechaFinal = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
		}else{
			self.datosUsuario.fechaFinal = self.currentElementString;
		}
	}
	else if ([elementName isEqualToString:@"fTelNamesIni"]){
        NSString *strAux;
		if(requiereEncriptar){
			strAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
		}else{
			strAux = self.currentElementString;
		}
        self.datosUsuario.fechaInicialTel = [NSDateFormatter changeDateFormatOfString:strAux
                                                                                 from:@"yyyy-MM-dd"
                                                                                   to:@"dd-MM-yyy"];
	}
	else if ([elementName isEqualToString:@"fTelNamesFin"]){
        NSString *strAux;
		if(requiereEncriptar){
			strAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
		}else{
			strAux = self.currentElementString;
		}
        self.datosUsuario.fechaFinalTel = [NSDateFormatter changeDateFormatOfString:strAux
                                                                               from:@"yyyy-MM-dd"
                                                                                 to:@"dd-MM-yyy"];
	}
    else if ([elementName isEqualToString:@"descripcionDominio"]) {
        self.datosUsuario.descripcionDominio =  [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        NSLog(@"LA DESCRIPCION DOMINIO ES: %@",self.datosUsuario.descripcionDominio );
    }
    else if ([elementName isEqualToString:@"codeCamp"]) {
        self.datosUsuario.codigoRedimir = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
    }
    else if ([elementName isEqualToString:@"listExtDominioVO"]) {
        [self.arregloTiposDominio addObject:itemDominio];
    }
    else if ([elementName isEqualToString:@"extDesc"]) {
        itemDominio.descripcionItem = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
    }
    else if ([elementName isEqualToString:@"extStatus"]) {
        itemDominio.estatus = [[StringUtils desEncriptar:self.currentElementString conToken:self.token] integerValue];
    }
    else if ([elementName isEqualToString:@"listUsuarioDominiosVO"]) {
        if (esRecurso) {
            [self.arregloDominiosUsuario insertObject:dominioUsuario atIndex:0];
        }
        else {
            [self.arregloDominiosUsuario addObject:dominioUsuario];
        }
    }
    else if ([elementName isEqualToString:@"domainCtrlName"]) {
        [dominioUsuario setDomainName:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
        NSLog(@"EL DOMINIO QUE ME ENVIA EL SERVER ES: %@ EN WS_HANDLERLOGIN", dominioUsuario.domainName);
    }
    else if ([elementName isEqualToString:@"domainType"]) {
        NSString *typeAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        NSLog(@"El tipo de Dominio es : %@", typeAux);
        if ([typeAux isEqualToString:@"recurso"]) {
            esRecurso = YES;
        }
        else {
            esRecurso = NO;
        }
        [dominioUsuario setDomainType:typeAux];
    }
    else if ([elementName isEqualToString:@"fechaCtrlFin"]) {
        [dominioUsuario setFechaFin:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }
    else if ([elementName isEqualToString:@"fechaCtrlIni"]) {
        [dominioUsuario setFechaFin:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }
    else if ([elementName isEqualToString:@"idCtrlDomain"]) {
        NSString *strAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setIdCtrlDomain:[strAux integerValue]];
    }

    else if ([elementName isEqualToString:@"statusCtrlDominio"]) {
        [dominioUsuario setStatusDominio:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
    }
    else if ([elementName isEqualToString:@"statusVisible"]) {
        NSString *strAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setStatusVisible:[strAux integerValue]];
    }
    
}

-(void) acomodaContactos {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (requiereEncriptar) {
        for (NSInteger i = 0; i < [self.arregloContactos count]; i++) {
            Contacto *contAct = [self.arregloContactos objectAtIndex:i];
            if (contAct.noContacto != Nil && contAct.noContacto.length > 0) {
                contAct.noContacto = [StringUtils desEncriptar:contAct.noContacto conToken:self.datosUsuario.token];
            }
            if (contAct.descripcion != Nil && contAct.descripcion.length > 0) {
                contAct.descripcion = [StringUtils desEncriptar:contAct.descripcion conToken:self.datosUsuario.token];
            }
            if (contAct.valorVisible != Nil && contAct.valorVisible.length > 0) {
                NSString *auxVal = [StringUtils desEncriptar:contAct.valorVisible conToken:self.datosUsuario.token];
                if ([auxVal isEqualToString:@"1"]) {
                    [contAct setHabilitado:YES];
                }
                else {
                    [contAct setHabilitado:NO];
                }
            }
            if (contAct.valorContacto != Nil && contAct.valorContacto.length > 0) {
                NSString *stringAux = [StringUtils desEncriptar:contAct.valorContacto conToken:self.datosUsuario.token];
                [contAct setIdContacto:[stringAux integerValue]];
            }
            if (contAct.servicio != Nil && contAct.servicio.length > 0) {
                contAct.servicio = [StringUtils desEncriptar:contAct.servicio conToken:self.datosUsuario.token];
            }
            if (contAct.subCategoria != Nil && contAct.subCategoria.length > 0) {
                contAct.subCategoria = [StringUtils desEncriptar:contAct.subCategoria conToken:self.datosUsuario.token];
            }
            [self.arregloContactos replaceObjectAtIndex:i withObject:contAct];
        }
    }
    
    NSDictionary *diccCodes = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CallingCodes" ofType:@"plist"]];
    NSArray *arreglotipoTelefonos = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]];
    for (NSInteger i = 0; i < [self.arregloContactos count]; i++) {
        self.contactoActual = [self.arregloContactos objectAtIndex:i];
        for (NSInteger j = 0; j < [arreglotipoTelefonos count]; j++) {
             NSDictionary *dictAux = [arreglotipoTelefonos objectAtIndex:j];
            if ([self.contactoActual.servicio isEqualToString:[dictAux objectForKey:@"servicio"]]) {
                if ([[dictAux objectForKey:@"servicio"] isEqualToString:@"E2U+web:http"]) {
                    if ([self.contactoActual.subCategoria isEqualToString:[dictAux objectForKey:@"subcategoria"]]) {
                        [self.contactoActual setIndice:j];
                    }
                }
                else {
                    [self.contactoActual setIndice:j];
                }
            }
        }
        if ([self.contactoActual.servicio hasPrefix:@"E2U+voice"] || [self.contactoActual.servicio hasPrefix:@"E2U+sms"] || [self.contactoActual.servicio hasPrefix:@"E2U+fax"]) {
            if ([self.contactoActual.noContacto hasPrefix:@"tel:"]) {
                self.contactoActual.noContacto = [self.contactoActual.noContacto substringFromIndex:4];
            }
            NSMutableArray *ccTestArray = [NSMutableArray arrayWithCapacity:3];
            NSUInteger maxLength = [self.contactoActual.noContacto length];
            if (maxLength > 3) {
                [ccTestArray addObject:[self.contactoActual.noContacto substringWithRange:NSMakeRange(0, 4)]];
            }
            if (maxLength > 2) {
                [ccTestArray addObject:[self.contactoActual.noContacto substringWithRange:NSMakeRange(0, 3)]];
            }
            if (maxLength > 1) {
                [ccTestArray addObject:[self.contactoActual.noContacto substringWithRange:NSMakeRange(0, 2)]];
            }
            for (NSString *isoCC in diccCodes) {
                NSString *shortestCC = [ccTestArray lastObject];
                NSString *ccValue = [diccCodes objectForKey:isoCC];
                if ([ccValue hasPrefix:shortestCC]) {
                    for (NSString *matchCC in ccTestArray) {
                        if ([ccValue isEqualToString:matchCC]) {
                            [self.contactoActual setIdPais:matchCC];
                            [self.contactoActual setPais:[local displayNameForKey:NSLocaleCountryCode value:isoCC]];
                            [self.contactoActual setNoContacto:[self.contactoActual.noContacto substringFromIndex:matchCC.length]];
                            goto ccMatched;
                        }
                    }
                }
            }
        }
        ccMatched:;
        if ([self.contactoActual.noContacto hasPrefix:@"//"]) {
            self.contactoActual.noContacto = [self.contactoActual.noContacto substringWithRange:NSMakeRange(2, self.contactoActual.noContacto.length-2)];
        }
		if ([self.contactoActual.noContacto hasPrefix:@"http://"]) {
            self.contactoActual.noContacto = [self.contactoActual.noContacto substringWithRange:NSMakeRange(7, self.contactoActual.noContacto.length-7)];
        }
		if ([self.contactoActual.noContacto hasPrefix:@"mailto:"]) {
            self.contactoActual.noContacto = [self.contactoActual.noContacto substringWithRange:NSMakeRange(7, self.contactoActual.noContacto.length-7)];
        }
		if ([self.contactoActual.noContacto hasPrefix:@"skype:"]) {
            self.contactoActual.noContacto = [self.contactoActual.noContacto substringWithRange:NSMakeRange(6, self.contactoActual.noContacto.length-6)];
        }
    }
}

-(NSInteger) buscarEnArreglo:(NSDictionary *)diccionarioLlaves conLlave:(NSString *)llave {
    NSArray *arregloLlaves = [diccionarioLlaves objectForKey:@"direccion"];
    for (NSString *llaveAux in arregloLlaves) {
        if ([llaveAux isEqualToString:llave]) {
            return 1;
        }
    }
    arregloLlaves = [diccionarioLlaves objectForKey:@"perfil"];
    NSInteger i = 0;
    for (NSString *llaveAux in arregloLlaves) {
        if ([llaveAux isEqualToString:llave]) {
            indexInsertar = i;
            return 2;
        }
        i++;
    }
    return 3;
}
-(NSInteger) posicionKeywordData {
    return 0;
}

-(void) validaEditados {
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@NO];
    NSArray *arrayEstatus = @[@NO, @NO, @NO, @NO, @NO, @NO, @NO];
    self.datosUsuario.arregloEstatusPerfil = [[NSMutableArray alloc] init];
    [self.datosUsuario.arregloEstatusPerfil addObjectsFromArray:arrayEstatus];
    int i = 0, k = 0;
    for (KeywordDataModel *keyAux in self.datosUsuario.arregloDatosPerfil) {
        if (i == 2) {
            if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0) {
                NSArray *arrayHorarioAux = [keyAux.keywordValue componentsSeparatedByString:@"|"];
                for (int j = 0; j < [arrayHorarioAux count]; j++) {
                    if (j % 2 == 0 && j > 0) {
                        NSArray *arrayDiaAux = [[arrayHorarioAux objectAtIndex:j] componentsSeparatedByString:@" - "];
                        if (![[arrayDiaAux objectAtIndex:0] isEqualToString:@"00:00"] || ![[arrayDiaAux objectAtIndex:1] isEqualToString:@"00:00"]) {
                            k++;
                        }
                    }
                }
                if (k > 0) {
                    [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@YES];
                    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@YES];
                }
                else {
                    [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@NO];
                }
            }
            
        }
        else if (i == 6) {
            if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0) {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:2 withObject:@YES];
            }
            else {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:2 withObject:@NO];
            }
        }
        else {
            if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0) {
                [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@YES];
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@YES];
            }
            else {
                [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@NO];
            }
            
        }
        i++;
    }
}

-(void) verificarPromocion {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.datosUsuario.promocionActual.redeemOffer != nil && [[self.datosUsuario.promocionActual.redeemOffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        NSArray *arregloRedencionEsp = @[NSLocalizedStringFromTable(@"noEspecificado", @"Spanish",@" "), NSLocalizedStringFromTable(@"llamanos", @"Spanish", @""), NSLocalizedStringFromTable(@"enviaEmail", @"Spanish", @""), NSLocalizedStringFromTable(@"visitanos", @"Spanish", @"")];
        
        NSArray *arregloRedencion = @[NSLocalizedString(@"noEspecificado",@" "), NSLocalizedString(@"llamanos", @""), NSLocalizedString(@"enviaEmail", @""), NSLocalizedString(@"visitanos", @"")];
        for (int i = 0; i < [arregloRedencionEsp count]; i++) {
            if ([self.datosUsuario.promocionActual.redeemOffer isEqualToString:[arregloRedencionEsp objectAtIndex:i]]) {
                self.datosUsuario.promocionActual.redeemAux = [arregloRedencion objectAtIndex:i];
            }
        }
    }
}

@end