//
//  WS_CompraDominio.m
//  Infomovil
//
//  Created by Ivan Peña on 25/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_CompraDominio.h"
#import "NSStringUtiles.h"
#import "Base64.h"
#import "ItemsDominio.h"
#import "AppDelegate.h"
#import "NSDateFormatterUtiles.h"

@interface WS_CompraDominio (){
	
	NSMutableArray * items;
	NSString * descripcion;
	NSInteger status;
    DominiosUsuario *dominioUsuario;
    BOOL esRecurso;
	BOOL bandera;
}

@end

@implementation WS_CompraDominio

-(void) compraDominio{
	items = [[NSMutableArray alloc] init];
    self.datosUsuario = [DatosUsuario sharedInstance];
    PagoModel *pago = [self.datosUsuario datosPago];
    
    if([self.datosUsuario.dominio isEqualToString:@"(null)"] || self.datosUsuario.dominio == nil || [self.datosUsuario.dominio isEqualToString:@""] || !self.datosUsuario.dominio || [self.datosUsuario.dominio isKindOfClass:[NSNull class]] ){
        self.datosUsuario.dominio = self.datosUsuario.emailUsuario;
    }
    
	NSString *stringXML;
	
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
					 "<soapenv:Header/>"
					 "<soapenv:Body>"
                     "<ws:compraDominio>"
                     "<usuario>%@</usuario>"
                     "<dominio>%@</dominio>"
                     "<plan>%@</plan>"
                     "<medioPago>%@</medioPago>"
                     "<titulo>%@</titulo>"
                     "<comision>%@</comision>"
                     "<PagoId>%@</PagoId>"
                     "<statusPago>%@</statusPago>"
                     "<codigoCobro>%@</codigoCobro>"
                     "<tipoCompra>%@</tipoCompra>"
                     "<montoB>%@</montoB>"
                     "</ws:compraDominio>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:self.datosUsuario.emailUsuario conToken:passwordEncriptar],
                     [StringUtils encriptar:self.datosUsuario.dominio conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.plan conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.medioPago conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.titulo conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.comision conToken:self.datosUsuario.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%lu", (unsigned long)pago.pagoId] conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.statusPago conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.codigoCobro conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.tipoCompra conToken:self.datosUsuario.token],
                     [StringUtils encriptar:pago.montoBruto conToken:self.datosUsuario.token]];
    self.strSoapAction = @"WSInfomovilDomain";
    NSLog(@"LOS VALORES QUE LES ENVIO SON1: %@ - %@ - %@ - %@ - %lu - %@ - %@ - %@ - %@", pago.plan, pago.medioPago,pago.titulo,pago.comision,(unsigned long)pago.pagoId,pago.statusPago,pago.codigoCobro,pago.tipoCompra,pago.montoBruto);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"WS_CompraDominio La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil && [dataResult length] > 0) {
        NSLog(@"CONSIDERO QUE DATA RESULT ES MAYOR A CERO O TRAE ALGUN DATO");
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if(self.token != nil && [self.token length] > 0 && ![self.token isEqualToString:@" "]){
                self.datosUsuario.token = self.token;
            }
			/*	if(requiereEncriptar){
					((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = [StringUtils desEncriptar:((AppDelegate*)[[UIApplication sharedApplication]delegate]).statusDominio conToken: self.datosUsuario.token ];
				}
			*/
            self.datosUsuario.datosPago.pagoId = [[StringUtils desEncriptar:self.resultado conToken:self.datosUsuario.token] integerValue];
            NSLog(@"EL PAGO ID ES: %lu", (unsigned long)self.datosUsuario.datosPago.pagoId);
            if(self.datosUsuario.datosPago.pagoId > 0){
				[self.compraDominioDelegate resultadoCompraDominio:YES];
            }else{
                [self.compraDominioDelegate resultadoCompraDominio:NO];
            }
        }
        else {
            [self.compraDominioDelegate errorConsultaWS];
        }
    }
    else {
         NSLog(@"REGRESO ERROR CONSULTAWS");
        [self.compraDominioDelegate errorConsultaWS];
    }
    
}

-(void) compraDominioTel{
    items = [[NSMutableArray alloc] init];
    self.datosUsuario = [DatosUsuario sharedInstance];
    PagoModel *pago = [self.datosUsuario datosPago];
    
    if([self.datosUsuario.dominioTel isEqualToString:@"(null)"] || self.datosUsuario.dominioTel == nil || [self.datosUsuario.dominioTel isEqualToString:@""] || !self.datosUsuario.dominioTel || [self.datosUsuario.dominioTel isKindOfClass:[NSNull class]] ){
        self.datosUsuario.dominioTel = self.datosUsuario.emailUsuario;
    }
    
    NSString *stringXML;
    
    stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                 "<soapenv:Header/>"
                 "<soapenv:Body>"
                 "<ws:compraDominio>"
                 "<usuario>%@</usuario>"
                 "<dominio>%@</dominio>"
                 "<plan>%@</plan>"
                 "<medioPago>%@</medioPago>"
                 "<titulo>%@</titulo>"
                 "<comision>%@</comision>"
                 "<PagoId>%@</PagoId>"
                 "<statusPago>%@</statusPago>"
                 "<codigoCobro>%@</codigoCobro>"
                 "<tipoCompra>%@</tipoCompra>"
                 "<montoB>%@</montoB>"
                 "</ws:compraDominio>"
                 "</soapenv:Body>"
                 "</soapenv:Envelope>",
                 [StringUtils encriptar:self.datosUsuario.emailUsuario conToken:passwordEncriptar],
                 [StringUtils encriptar:self.datosUsuario.dominioTel conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.plan conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.medioPago conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.titulo conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.comision conToken:self.datosUsuario.token],
                 [StringUtils encriptar:[NSString stringWithFormat:@"%lu", (unsigned long)pago.pagoId] conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.statusPago conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.codigoCobro conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.tipoCompra conToken:self.datosUsuario.token],
                 [StringUtils encriptar:pago.montoBruto conToken:self.datosUsuario.token]];
    self.strSoapAction = @"WSInfomovilDomain";
    NSLog(@"LOS VALORES QUE LES ENVIO SON2: %@ - %@ - %@ - %@ - %lu - %@ - %@ - %@ - %@", pago.plan, pago.medioPago,pago.titulo,pago.comision,(unsigned long)pago.pagoId,pago.statusPago,pago.codigoCobro,pago.tipoCompra,pago.montoBruto);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"WS_CompraDominio La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil && [dataResult length] > 0) {
        NSLog(@"CONSIDERO QUE DATA RESULT ES MAYOR A CERO O TRAE ALGUN DATO");
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        self.arregloDominiosUsuario = [[NSMutableArray alloc] init];
        if ([parser parse]) {
            if(self.token != nil && [self.token length] > 0 && ![self.token isEqualToString:@" "]){
                self.datosUsuario.token = self.token;
            }
         /*   if(requiereEncriptar){
                ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = [StringUtils desEncriptar:((AppDelegate*)[[UIApplication sharedApplication]delegate]).statusDominio conToken: self.datosUsuario.token ];
            }
           */
            if ([self.arregloDominiosUsuario count] > 0) {
                self.datosUsuario.dominiosUsuario = self.arregloDominiosUsuario;
            }else {
                dominioUsuario = [[DominiosUsuario alloc] init];
            }
            
            self.datosUsuario.datosPago.pagoId = [[StringUtils desEncriptar:self.resultado conToken:self.datosUsuario.token] integerValue];
            NSLog(@"EL PAGO ID ES: %lu", (unsigned long)self.datosUsuario.datosPago.pagoId);
            if(self.datosUsuario.datosPago.pagoId > 0){
                [self.compraDominioDelegate resultadoCompraDominio:YES];
            }else{
                [self.compraDominioDelegate resultadoCompraDominio:NO];
            }
        }
        else {
            [self.compraDominioDelegate errorConsultaWS];
        }
    }
    else {
        NSLog(@"REGRESO ERROR CONSULTAWS");
        [self.compraDominioDelegate errorConsultaWS];
    }
    
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.compraDominioDelegate errorConsultaWS];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"listStatusDomainVO"]) {
       self.currentElementString = [[NSMutableString alloc] init];
		descripcion = @"";
		status = 255;
    }
    
	else if ([elementName isEqualToString:@"descripcionItem"]) {
		self.currentElementString = [[NSMutableString alloc] init];
        descripcion = @"";
    }
	else if([elementName isEqualToString:@"status"]){
		status = 255;
	}
	else if([elementName isEqualToString:@"statusDominio"]){
		self.currentElementString = [[NSMutableString alloc] init];
	}
    else if ([elementName isEqualToString:@"respuesta"]) {
       self.currentElementString = [[NSMutableString alloc] init];
    }
	else if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"referencia"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"fechaIni"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"fechaFin"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"fechaCtrlIni"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"fechaCtrlFin"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"domainCtrlName"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"domainType"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"listUsuarioDominiosVO"]) {
        dominioUsuario = [[DominiosUsuario alloc] init];
    }else if ([elementName isEqualToString:@"vigente"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"token"]){
        self.token = [StringUtils desEncriptar:self.currentElementString conToken:passwordEncriptar];
    }
    
    else if([elementName isEqualToString:@"resultado"]){
        self.resultado = self.currentElementString;
 
    }else if([elementName isEqualToString:@"statusDominio"]){
            NSString *valor = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
            if ([valor isEqualToString:@"Mes PRO"] || [valor isEqualToString:@"Anual PRO"] || [valor isEqualToString:@"Tramite PRO"] ) {
                ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
            }
            else {
                ((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio = valor;
            }
            NSLog(@"EL ESTATUS DOMINIO ES: %@", valor);
        
        
    }else if ([elementName isEqualToString:@"fechaFin"]){
        if(requiereEncriptar){
            self.datosUsuario.fechaFinal = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }else{
            self.datosUsuario.fechaFinal = self.currentElementString;
        }
       
    }else if ([elementName isEqualToString:@"fechaIni"]){
        if(requiereEncriptar){
            self.datosUsuario.fechaInicial = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }else{
            self.datosUsuario.fechaInicial = self.currentElementString;
        }
   
    }else if ([elementName isEqualToString:@"fechaCtrlIni"]){
        NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setFechaIni:auxOffer];
        NSLog(@"LA FECHA DEL TEL INICIAL ES: %@", auxOffer);
    
    }else if([elementName isEqualToString:@"fechaCtrlFin"]){
        NSString *auxOffer = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setFechaFin:auxOffer];
          NSLog(@"LA FECHA DEL TEL FINAL ES: %@", auxOffer);
    }else if ([elementName isEqualToString:@"domainCtrlName"]){
       [dominioUsuario setDomainName:[StringUtils desEncriptar:self.currentElementString conToken:self.token]];
        NSLog(@"ELL NOMBRE QUE TRAJO EN WS_COMPRADOMINIO ES: %@", [StringUtils desEncriptar:self.currentElementString conToken:self.token]);
    }else if ([elementName isEqualToString:@"domainType"]){
        NSString *typeAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        if ([typeAux isEqualToString:@"recurso"]) {
            esRecurso = YES;
        }
        else {
            esRecurso = NO;
        }
        NSLog(@"EL TIPO DE DOMINIO ES: %@", typeAux);
        [dominioUsuario setDomainType:typeAux];
    }else if ([elementName isEqualToString:@"listUsuarioDominiosVO"]) {
        if (esRecurso) {
            [self.arregloDominiosUsuario insertObject:dominioUsuario atIndex:0];
        }
        else {
            [self.arregloDominiosUsuario addObject:dominioUsuario];
        }
    }else if ([elementName isEqualToString:@"vigente"]) {
        NSString *typeAux = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        [dominioUsuario setVigente:typeAux];
        NSLog(@"EL DOMINIO ES VIGENTE? : %@", typeAux);
    }
}

-(void) ordenarItemsCompraDom{
    NSArray *arregloTitulos = @[NSLocalizedStringFromTable(@"nombreEmpresa", @"Spanish",@" "), NSLocalizedStringFromTable(@"logo",@"Spanish", @" "), NSLocalizedStringFromTable(@"descripcionCorta", @"Spanish",@" "), NSLocalizedStringFromTable(@"contacto", @"Spanish",@" "), NSLocalizedStringFromTable(@"mapa",@"Spanish", @" "),
        NSLocalizedStringFromTable(@"video", @"Spanish",@" "),
        NSLocalizedStringFromTable(@"promociones", @"Spanish",@" "), NSLocalizedStringFromTable(@"galeriaImagenes",@"Spanish", @" "), NSLocalizedStringFromTable(@"perfil",@"Spanish", @" "), NSLocalizedStringFromTable(@"direccion", @"Spanish",@" "),  NSLocalizedStringFromTable(@"informacionAdicional", @"Spanish",@" ")];
    DatosUsuario *datosUsuario = self.datosUsuario;//[DatosUsuario sharedInstance];
    
    NSArray *arregloIdioma = @[NSLocalizedString(@"nombreEmpresa", @" "),
        NSLocalizedString(@"logo", @" "),
        NSLocalizedString(@"descripcionCorta", @" "),
        NSLocalizedString(@"contacto", @" "),
        NSLocalizedString(@"mapa", @" "),
        NSLocalizedString(@"video", @" "),
        NSLocalizedString(@"promociones", @" "),
        NSLocalizedString(@"galeriaImagenes", @" "),
        NSLocalizedString(@"perfil", @" "),
        NSLocalizedString(@"direccion", @" "),
        NSLocalizedString(@"informacionAdicional", @" ")];
    NSMutableArray *arregloItems = datosUsuario.itemsDominio;
    NSMutableArray *arregloItemsAux = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arregloTitulos count]; i++) {
        NSString *stringAux = [StringUtils eliminarAcentos:[arregloTitulos objectAtIndex:i]];
        for (int j = 0; j < [arregloItems count]; j++) {
            ItemsDominio *itemDominio = [arregloItems objectAtIndex:j];
            if (([[stringAux uppercaseString] isEqualToString:[itemDominio descripcionItem]]) || ([stringAux isEqualToString:[itemDominio descripcionItem]])) {
                [itemDominio setDescripcionItem:[arregloTitulos objectAtIndex:i]];
                [itemDominio setDescripcionIdioma:[arregloIdioma objectAtIndex:i]];
                [arregloItemsAux addObject:itemDominio];
            }
        }
    }
    datosUsuario.itemsDominio = arregloItemsAux;
}

@end
