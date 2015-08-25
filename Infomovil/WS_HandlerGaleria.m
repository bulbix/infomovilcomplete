//
//  WS_HandlerGaleria.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_HandlerGaleria.h"
#import "GaleriaImagenes.h"
#import "Base64.h"

@interface WS_HandlerGaleria(){
	NSMutableArray *arregloImagenes;
	NSMutableArray * ids;
   
}

@end

@implementation WS_HandlerGaleria


-(void) actualizarGaleria:(NSArray *)arrUrlImages idImages:(NSArray *)arrIdImages descImages:(NSArray *)arrDescImages{
    NSLog(@"ENTRO EN ACTUALIZAR GALERA DE WS_HANDLERGALERIA actualizarGaleria");
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
    
        stringXML = [[NSMutableString alloc] initWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateImage>"
                     "<sistema>%@</sistema>"
                     "<versionSistema>%@</versionSistema>"
                     "<domainId>%@</domainId>" ,
                     [StringUtils encriptar:@"IOS" conToken:datos.token],
                     [StringUtils encriptar:versionDefault conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token]];
    
        for (int i = 0; i < [arrUrlImages count]; i++) {
            [stringXML appendFormat:@"<arg1>"
             "<typeImage>%@</typeImage>"
             "<descripcionImagen>%@</descripcionImagen>"
             "<idImagen>%@</idImagen>"
             "<imagenClobGaleria></imagenClobGaleria>"
             "</arg1>",
             [StringUtils encriptar:@"IMAGEN" conToken:datos.token],
             [StringUtils encriptar:[arrIdImages objectAtIndex:i] conToken:datos.token],
             [StringUtils encriptar:[arrDescImages objectAtIndex:i] conToken:datos.token]];
             
        }
        [stringXML appendFormat:@"<token>%@</token></ws:updateImage></soapenv:Body></soapenv:Envelope>", [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    
    
    
   // NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
   // NSLog(@"La Respuesta en WS_HandlerGaleria del metodo actualizarGaleria es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
            
				
                    NSUInteger aux=0;
                    NSUInteger idAux=0;
                    for(int x = 0;x < ids.count;x++)
                    {
                        GaleriaImagenes *imagen = [self.arregloGaleria objectAtIndex:x];
                        
                        imagen.idImagen = [[StringUtils desEncriptar:[ids objectAtIndex:x] conToken:datos.token] integerValue];
                        aux++;
                        idAux = imagen.idImagen;
                    }
                    if(aux==1){
                        [self.galeriaDelegate resultadoConsultaDominio:[NSString stringWithFormat:@"%lu",(unsigned long)idAux]];
                    } else if(self.resultado == nil){
                        [datos setArregloGaleriaImagenes:self.arregloGaleria];
                        NSLog(@"REGRESSO resultadoConsultaDominio DEL METODO ACTUALIZAR GALERIA");
                        [self.galeriaDelegate resultadoConsultaDominio:@"Exito"];
                    } else {
                        NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                        [self.galeriaDelegate resultadoConsultaDominio:stringResult];
                    }
                
            }
            else {
                [self.galeriaDelegate resultadoConsultaDominio:self.resultado];
            }
        }
        else {
            [self.galeriaDelegate errorConsultaWS];
        }
    }
    else {
        [self.galeriaDelegate errorConsultaWS];
    }
}

-(void) actualizarGaleriaDescripcion:(NSInteger)indexImage descripcion:(NSString *)descImage{
    NSLog(@"ENTRO EN ACTUALIZAR GALERA DE WS_HANDLERGALERIA DESCRIPCION actualizarGaleriaDescripcion");
    ids = [[NSMutableArray alloc] init];
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
    NSString *idImagenInt = [datos.arregloIdImagenGaleria objectAtIndex:indexImage];
    NSLog(@"LOS VALORES ENVIADOS SON: %@ y LA DESCRIPCION IMAGE %@", idImagenInt, descImage);
    
    
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateImage>"
                     "<sistema>%@</sistema>"
                     "<versionSistema>%@</versionSistema>"
                     "<domainId>%@</domainId>" ,
                     [StringUtils encriptar:@"IOS" conToken:datos.token],
                     [StringUtils encriptar:versionDefault conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token]];
        NSLog(@"LOS VALORES ENVIADOS SON: %li y de arreglogariea son %lu y el url Image es: %@", (long)datos.idDominio, (unsigned long)[self.arregloGaleria count], [datos.arregloUrlImagenesGaleria objectAtIndex:indexImage]);
        
            [stringXML appendFormat:@"<arg1>"
             "<typeImage>%@</typeImage>"
             "<descripcionImagen>%@</descripcionImagen>"
             "<idImagen>%@</idImagen>"
             "<imagenClobGaleria>%@</imagenClobGaleria>"
             "</arg1>",
             [StringUtils encriptar:@"IMAGEN" conToken:datos.token],
             [StringUtils encriptar:descImage conToken:datos.token],
             [StringUtils encriptar:idImagenInt conToken:datos.token],
             [StringUtils encriptar:[datos.arregloUrlImagenesGaleria objectAtIndex:indexImage] conToken:datos.token]];
        }
        [stringXML appendFormat:@"<token>%@</token></ws:updateImage></soapenv:Body></soapenv:Envelope>", [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    
    self.arregloUrlGaleriaAux = [[NSMutableArray alloc] init];
    self.arregloTypeImageGaleriaAux = [[NSMutableArray alloc] init];
    self.arregloDescripcionImageGaleriaAux = [[NSMutableArray alloc] init];
    self.arregloIdImagenGaleriaAux = [[NSMutableArray alloc] init];
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    //NSLog(@"La Respuesta en WS_HandlerGaleria del metodo actualizarGaleria es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (self.resultadoLista == nil || [[self.resultadoLista stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [self.resultadoLista isEqualToString:@"Error de token"]) {
                NSLog(@"ENTRO A ERROR DE TOKEN");
                [self.galeriaDelegate errorToken];
            }else{
                datos.arregloUrlImagenesGaleria = nil;
                datos.arregloTipoImagenGaleria = nil;
                datos.arregloIdImagenGaleria = nil;
                datos.arregloDescripcionImagenGaleria = nil;
                
                datos.arregloUrlImagenesGaleria = [[NSMutableArray alloc] initWithArray:self.arregloUrlGaleriaAux copyItems:YES];
                datos.arregloTipoImagenGaleria = [[NSMutableArray alloc] initWithArray:self.arregloTypeImageGaleriaAux copyItems:YES];
                datos.arregloIdImagenGaleria = [[NSMutableArray alloc] initWithArray:self.arregloIdImagenGaleriaAux copyItems:YES];
                datos.arregloDescripcionImagenGaleria = [[NSMutableArray alloc] initWithArray:self.arregloDescripcionImageGaleriaAux copyItems:YES];
                [self.galeriaDelegate resultadoConsultaDominio:@"Exito"];
            }
            
            
        }
        else {
            [self.galeriaDelegate errorConsultaWS];
        }
    }
    else {
        [self.galeriaDelegate errorConsultaWS];
    }
}

-(void) eliminarImagen:(NSInteger)idImagen { NSLog(@"MANDO A LLAMAR ELIMINAR IMAGEN!!!!!");
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteImage>"
                     "<domainId>%@</domainId>"
                     "<imageId>%@</imageId>"
                     "<token>%@</token>"
                     "</ws:deleteImage>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>",
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li",(long)datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar: [NSString stringWithFormat:@"%li",(long)idImagen] conToken:datos.token],
                     [StringUtils encriptar: datos.emailUsuario conToken:passwordEncriptar]];
    
   // NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La Respuesta del metodo eliminarImagen es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                
                if (self.resultado == nil || [[self.resultado stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [self.resultado isEqualToString:@"Error de token"]) {
                    NSLog(@"ENTRO A ERROR DE TOKEN");
                    [self.galeriaDelegate errorToken];
                }
                else {
                  
                    if ([self.resultado isEqualToString:@"Exito"]) {
                   
                        switch (self.tipoGaleria) {
                            case PhotoGaleryTypeLogo:
                                datos.imagenLogo = [[GaleriaImagenes alloc] init];
                                [datos.arregloUrlImagenes removeObjectAtIndex:self.indiceSeleccionado];
                                [datos.arregloIdImagen removeObjectAtIndex:self.indiceSeleccionado];
                                [datos.arregloDescripcionImagen removeObjectAtIndex:self.indiceSeleccionado];
                                [datos.arregloTipoImagen removeObjectAtIndex:self.indiceSeleccionado];
                                NSLog(@"Vamos a imprimir todo: %@  -   %@   -    %@     -     %@  y el indie es: %li",datos.arregloUrlImagenes, datos.arregloIdImagen, datos.arregloDescripcionImagen, datos.arregloTipoImagen , (long)self.indiceSeleccionado);
                                
                                break;
                            case PhotoGaleryTypeImage:
                                NSLog(@"SI SE PUDO ELIMINAR LA FOTO DE GALERIA");
                                [datos.arregloUrlImagenesGaleria removeObjectAtIndex:self.indiceSeleccionado];
                                [datos.arregloIdImagenGaleria removeObjectAtIndex:self.indiceSeleccionado];
                                [datos.arregloDescripcionImagenGaleria removeObjectAtIndex:self.indiceSeleccionado];
                                [datos.arregloTipoImagenGaleria removeObjectAtIndex:self.indiceSeleccionado];
                                
                            default:
                                break;
                        }
                        NSLog(@"REGRESO EXITO EN EL METODO ELIMINAR IMAGEN");
                        [self.galeriaDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else {
                        [self.galeriaDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
            }
            else {NSLog(@"REGRESSO resultadoConsultaDominio DEL METODO ELIMINAR  IMAGEN");
                [self.galeriaDelegate resultadoConsultaDominio:self.resultado];
            }
        }
        else {
            [self.galeriaDelegate errorConsultaWS];
        }
    }
    else {
        [self.galeriaDelegate errorConsultaWS];
    }
}

-(void) insertarImagen:(GaleriaImagenes *) imagenInsertar {
    NSLog(@"ENTRO A INSERTARIMAGEN WS_HANDLERGALERIA");
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
    NSString *tipoInsertar = @"LOGO";
    if (self.tipoGaleria == PhotoGaleryTypeImage) {
        tipoInsertar = @"IMAGEN";
        NSLog(@"INSERTO UNA IMAGEN DE LA GALERIA");
    }
    if (requiereEncriptar) {
        stringXML = [NSMutableString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertImage>"
                     "<sistema>%@</sistema>"
                     "<versionSistema>%@</versionSistema>"
                     "<domainId>%@</domainId>",[StringUtils encriptar:@"IOS" conToken:datos.token],
                     [StringUtils encriptar:versionDefault conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)datos.idDominio] conToken:datos.token]];
        
        [stringXML appendFormat:@"<arg1>"
         "<typeImage>%@</typeImage>"
         "<descripcionImagen>%@</descripcionImagen>"
         "<idImagen>%@</idImagen>"
         "<imagenClobGaleria>%@</imagenClobGaleria>"
         "</arg1><token>%@</token>",
         [StringUtils encriptar:tipoInsertar conToken:datos.token],
         [StringUtils encriptar:imagenInsertar.pieFoto conToken:datos.token],
         [StringUtils encriptar:[NSString stringWithFormat:@"%li", (long)imagenInsertar.idImagen] conToken:datos.token],
         [Base64 encode:[NSData dataWithContentsOfFile:imagenInsertar.rutaImagen]],
         [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
        NSLog(@"EL PIE QUE SE INSERTA SERA: %@", imagenInsertar.pieFoto);
        [stringXML appendString:@"</ws:insertImage>"
         "</soapenv:Body>"
         "</soapenv:Envelope>" ];
    }
   // NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    if (dataResult != nil) {
        NSLog(@"La Respuesta en WS_HandlerGaleria del metodo insertarImagen es %s", [dataResult bytes]);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                NSString *stringResult = self.resultado;
                    if (stringResult == nil || [[stringResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0|| [stringResult isEqualToString:@"Error de token"]) {
                    [self.galeriaDelegate errorToken];
                    NSLog(@"FUE ERROR DE TOKEN");
                }
                else {
                    NSInteger idAux = [stringResult integerValue];
                    if (idAux > 0) {
                        if (self.tipoGaleria == PhotoGaleryTypeImage) {
                            NSLog(@"ENTRO A LA OPCION DE GALERIA DE LOS USUARIOS");
                            [datos.arregloUrlImagenesGaleria addObject:self.urlResultado];
                            [datos.arregloTipoImagenGaleria addObject:@"IMAGEN"];
                            [datos.arregloDescripcionImagenGaleria addObject:imagenInsertar.pieFoto];
                            NSLog(@"");
                            if(![self.resultado isEqualToString:@"Exito"] && ![self.resultado isEqualToString:@"No Exito"] && ![self.resultado isEqualToString:@"Error de token"]){
                                 NSLog(@"EL ID DE IMAGEN ES: %@", self.resultado);
                                [datos.arregloIdImagenGaleria addObject:self.resultado];
                            }
                            NSLog(@"LOS VALORES GUARDADOS SON PRIMERO RESULTADO: %@", self.resultado);
                            NSLog(@"LOS VALORES GUARDADOS SON arregloUrlImagenesGaleria RESULTADO: %@", self.resultado);
                            NSLog(@"LOS VALORES GUARDADOS SON arregloTipoImagenGaleria RESULTADO: %@", self.urlResultado);
                           
                        }
                        else {
                            NSLog(@"ENTRO A LA OPCION LOGO");
                            [datos.arregloUrlImagenes addObject:self.urlResultado];
                            [datos.arregloTipoImagen addObject:@"LOGO"];
                            [datos.arregloDescripcionImagen addObject:@""];
                            if(![self.resultado isEqualToString:@"Exito"] && ![self.resultado isEqualToString:@"No Exito"] && ![self.resultado isEqualToString:@"Error de token"]){
                                NSLog(@"EL ID DE IMAGEN ES: %@", self.resultado);
                                [datos.arregloIdImagen addObject:self.resultado];
                            }
                            
                          
                            NSLog(@"LOS VALORES GUARDADOS SON arregloUrlImagenesGaleria RESULTADO: %@", self.resultado);
                            NSLog(@"LOS VALORES GUARDADOS SON arregloTipoImagenGaleria RESULTADO: %@", self.urlResultado);
                        }
                        NSLog(@"REGRESSO resultadoConsultaDominio DEL METODO INSERTAR IMAGEN");
                        [self.galeriaDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else {
                        [self.galeriaDelegate resultadoConsultaDominio:@"No Exito"];
                    }
                }
                }
                
        }
        else {
            [self.galeriaDelegate errorConsultaWS];
        }
    }
    else {
        [self.galeriaDelegate errorConsultaWS];
    }
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //[self.galeriaDelegate errorConsultaWS];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementString = string;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"resultado"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"token"]) {
        self.currentElementString = [[NSMutableString alloc] init];
    }
	else if([elementName isEqualToString:@"idImagen"]){
		self.currentElementString = [[NSMutableString alloc] init];
	}
    else if([elementName isEqualToString:@"urlImagen"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    
    
    else if([elementName isEqualToString:@"url"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"typeImage"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"descripcionImagen"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"idImagen"]){
        self.currentElementString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
     DatosUsuario *datos = [DatosUsuario sharedInstance];
    
    if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
        NSLog(@"EL RESULTADO ES: %@", self.resultado);
        
    }
    else if([elementName isEqualToString:@"urlImagen"]){
        self.urlResultado = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
        NSLog(@"EL resultado de la urlResultado es: %@", self.urlResultado);
    }
    else if([elementName isEqualToString:@"listImagenVO"]){
        self.resultadoLista = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
        NSLog(@"LA LISTA QUE ME ENVIO ES: %@", self.resultadoLista);
    }
    else if([elementName isEqualToString:@"url"]){
        self.resultado = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
        [self.arregloUrlGaleriaAux addObject:self.resultado];
        NSLog(@"EL resultado de la urlResultado  en URL es: %@", self.resultado);
    }
    else if([elementName isEqualToString:@"typeImage"]){
        self.resultado = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
        [self.arregloTypeImageGaleriaAux addObject:self.resultado];
        NSLog(@"EL resultado de la urlResultado  en typeImage es: %@", self.resultado);
    }
    else if([elementName isEqualToString:@"descripcionImagen"]){
        self.resultado = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
        [self.arregloDescripcionImageGaleriaAux addObject:self.resultado];
        NSLog(@"EL resultado de la urlResultado  en descripcionImagen es: %@", self.resultado);
    }
    else if([elementName isEqualToString:@"idImagen"]){
        self.resultado = [StringUtils desEncriptar:self.currentElementString conToken:datos.token];
        [self.arregloIdImagenGaleriaAux addObject:self.resultado];
        NSLog(@"EL resultado de la urlResultado  en idImagen es: %@", self.resultado);
    }
    
}


@end
