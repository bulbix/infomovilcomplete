//
//  WS:ItemsDominio.m
//  Infomovil
//
//  Created by Ivan Peña on 08/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_ItemsDominio.h"
#import "ItemsDominio.h"

@interface WS_ItemsDominio (){
	DatosUsuario *datos;
	NSMutableArray * items;
	NSString * descripcion;
	NSInteger status;
	
	BOOL bandera;
}

@end

@implementation WS_ItemsDominio

-(void) actualizarItemsDominio {
	NSLog(@"Actualizar");
	bandera = YES;
	items = [[NSMutableArray alloc] init];
    datos = [DatosUsuario sharedInstance];
	NSString *stringXML;
	if (requiereEncriptar) {
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
					 "<soapenv:Header/>"
					 "<soapenv:Body>"
					 "<ws:getItemsGratisDomain/>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>"];
	}else{
		stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
					 "<soapenv:Header/>"
					 "<soapenv:Body>"
					 "<ws:getItemsGratisDomain/>"
					 "</soapenv:Body>"
					 "</soapenv:Envelope>"];
	}
    self.strSoapAction = @"WSInfomovilDomain";
	NSLog(@"La peticion es %@", stringXML);
    NSLog(@"la url es %@",[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]);
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La respuesta es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
			
			if(requiereEncriptar){
                datos.itemsDominio = [StringUtils ordenarItems:datos.itemsDominio];
				[self.itemsDominioDelegate itemsActualizados:bandera];
			}else{
                datos.itemsDominio = [StringUtils ordenarItems:datos.itemsDominio];
				[self.itemsDominioDelegate itemsActualizados:bandera];
			}
        }
        else {
            [self.itemsDominioDelegate errorConsultaWS];
        }
    }
    else {
        [self.itemsDominioDelegate errorConsultaWS];
    }
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.itemsDominioDelegate errorConsultaWS];
	bandera = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"StatusDomainVO"]) {
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
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"StatusDomainVO"]) {
        ItemsDominio * item = [[ItemsDominio alloc] init];
		[item setDescripcionItem:descripcion];
		[item setEstatus:status];
		
		[items addObject:item];
    }
    else if ([elementName isEqualToString:@"descripcionItem"]) {
		descripcion = self.currentElementString;
    }
	else if([elementName isEqualToString:@"status"]){
		status = [self.currentElementString integerValue];	}
	else if([elementName isEqualToString:@"ns2:getItemsGratisDomainResponse"]){
		datos = [DatosUsuario sharedInstance];
		datos.itemsDominio = items;
		
		for(ItemsDominio * item in datos.itemsDominio)
			NSLog(@"items: %@ , descripcion: %@ , status: %i", item, item.descripcionItem, item.estatus);
	}
}

//-(void) ordenarItems {
//	
//	NSLog(@"NombreEmpresa: %@",NSLocalizedStringFromTable(@"nombreEmpresa", @"Spanish", nil));
//    NSArray *arregloTitulos = @[NSLocalizedStringFromTable(@"nombreEmpresa", @"Spanish",@" "), NSLocalizedStringFromTable(@"logo",@"Spanish", @" "), NSLocalizedStringFromTable(@"descripcionCorta", @"Spanish",@" "), NSLocalizedStringFromTable(@"contacto", @"Spanish",@" "), NSLocalizedStringFromTable(@"mapa",@"Spanish", @" "), NSLocalizedStringFromTable(@"video", @"Spanish",@" "), NSLocalizedStringFromTable(@"promociones", @"Spanish",@" "), NSLocalizedStringFromTable(@"galeriaImagenes",@"Spanish", @" "), NSLocalizedStringFromTable(@"perfil",@"Spanish", @" "), NSLocalizedStringFromTable(@"direccion", @"Spanish",@" "),  NSLocalizedStringFromTable(@"informacionAdicional", @"Spanish",@" ")];
//    
//    NSArray *arregloIdioma = @[NSLocalizedString(@"nombreEmpresa", @" "), NSLocalizedString(@"logo", @" "), NSLocalizedString(@"descripcionCorta", @" "), NSLocalizedString(@"contacto", @" "), NSLocalizedString(@"mapa", @" "), NSLocalizedString(@"video", @" "), NSLocalizedString(@"promociones", @" "), NSLocalizedString(@"galeriaImagenes", @" "), NSLocalizedString(@"perfil", @" "), NSLocalizedString(@"direccion", @" "),  NSLocalizedString(@"informacionAdicional", @" ")];
//    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
//    NSMutableArray *arregloItems = datosUsuario.itemsDominio;
//    NSMutableArray *arregloItemsAux = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [arregloTitulos count]; i++) {
//        NSString *stringAux = [StringUtils eliminarAcentos:[arregloTitulos objectAtIndex:i]];
//        for (int j = 0; j < [arregloItems count]; j++) {
//            ItemsDominio *itemDominio = [arregloItems objectAtIndex:j];
//            if ([[stringAux uppercaseString] isEqualToString:[itemDominio descripcionItem]]) {
//                [itemDominio setDescripcionItem:[arregloTitulos objectAtIndex:i]];
//                [itemDominio setDescripcionIdioma:[arregloIdioma objectAtIndex:i]];
//                [arregloItemsAux addObject:itemDominio];
//            }
//        }
//    }
//    datosUsuario.itemsDominio = arregloItemsAux;
//    NSLog(@"Termino");
//    
//}

@end
