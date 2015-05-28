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
				if(requiereEncriptar){
					((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = [StringUtils desEncriptar:((AppDelegate*)[[UIApplication sharedApplication]delegate]).statusDominio conToken: self.datosUsuario.token ];
				}
				
            self.datosUsuario.datosPago.pagoId = [[StringUtils desEncriptar:self.resultado conToken:self.datosUsuario.token] integerValue];
           
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
        self.currentElementString = @" ";
		descripcion = @"";
		status = 255;
    }
    
	else if ([elementName isEqualToString:@"descripcionItem"]) {
		descripcion = @"";
    }
	else if([elementName isEqualToString:@"status"]){
		status = 255;
	}
	else if([elementName isEqualToString:@"statusDominio"]){
		self.currentElementString = @" ";
	}
    else if ([elementName isEqualToString:@"respuesta"]) {
        self.currentElementString = @" ";
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
    }else if ([elementName isEqualToString:@"fTelNamesIni"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"fTelNamesFin"]){
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
        ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = self.currentElementString;
        
    }else if ([elementName isEqualToString:@"fechaFin"]){
        if(requiereEncriptar){
            self.datosUsuario.fechaFinal = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }else{
            self.datosUsuario.fechaFinal = self.currentElementString;
        }
    }
    else if ([elementName isEqualToString:@"fechaIni"]){
        if(requiereEncriptar){
            self.datosUsuario.fechaInicial = [StringUtils desEncriptar:self.currentElementString conToken:self.token];
        }else{
            self.datosUsuario.fechaInicial = self.currentElementString;
        }
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
