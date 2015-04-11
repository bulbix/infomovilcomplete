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
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
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
#if DEBUG
		for(ItemsDominio * item in datos.itemsDominio)
			NSLog(@"items: %@ , descripcion: %@ , status: %i", item, item.descripcionItem, item.estatus);
    }
#endif
}



@end
