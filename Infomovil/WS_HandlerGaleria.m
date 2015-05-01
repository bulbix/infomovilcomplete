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
@synthesize datosUsuario;

-(void) actualizarGaleria { NSLog(@"ENTRO EN ACTUALIZAR GALERA DE WS_HANDLERGALERIA");
	ids = [[NSMutableArray alloc] init];
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
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
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token]];
        NSLog(@"LOS VALORES ENVIADOS SON: %i y de arreglogariea son %i", datos.idDominio, [self.arregloGaleria count]);
        for (int i = 0; i < [self.arregloGaleria count]; i++) {
            GaleriaImagenes *galeria = [self.arregloGaleria objectAtIndex:i];
            NSData *dataImage = [NSData dataWithContentsOfFile:galeria.rutaImagen];
            [stringXML appendFormat:@"<arg1>"
             "<typeImage>%@</typeImage>"
             "<descripcionImagen>%@</descripcionImagen>"
             "<idImagen>%@</idImagen>"
             "<imagenClobGaleria>%@</imagenClobGaleria>"
             "</arg1>",
             [StringUtils encriptar:@"IMAGEN" conToken:datos.token],
             [StringUtils encriptar:galeria.pieFoto conToken:datos.token],
             [StringUtils encriptar:[NSString stringWithFormat:@"%i", galeria.idImagen] conToken:datos.token],
             [Base64 encode:dataImage]];
            NSLog(@"LOS VALORES ENVIADOS SON: %@", galeria.pieFoto);
        }
        [stringXML appendFormat:@"<token>%@</token></ws:updateImage></soapenv:Body></soapenv:Envelope>", [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La Respuesta en WS_HandlerGaleria del metodo actualizarGaleria es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
				
                    int aux=0;
                    int idAux=0;
                    for(int x = 0;x < ids.count;x++)
                    {
                        GaleriaImagenes *imagen = [self.arregloGaleria objectAtIndex:x];
                        
                        imagen.idImagen = [[StringUtils desEncriptar:[ids objectAtIndex:x] conToken:datos.token] integerValue];
                        aux++;
                        idAux = imagen.idImagen;
                    }
                    if(aux==1){
                        [self.galeriaDelegate resultadoConsultaDominio:[NSString stringWithFormat:@"%i",idAux]];
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
    NSLog(@"ENTRO EN ACTUALIZAR GALERA DE WS_HANDLERGALERIA");
    ids = [[NSMutableArray alloc] init];
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
    NSString *idImagenInt = [datos.arregloIdImagenGaleria objectAtIndex:indexImage];
     NSLog(@"LOS VALORES ENVIADOS SON: %@ y LA DESCRIPCIONIMAGE %@", idImagenInt, descImage);
    
    
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
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token]];
        NSLog(@"LOS VALORES ENVIADOS SON: %i y de arreglogariea son %i", datos.idDominio, [self.arregloGaleria count]);
        
            [stringXML appendFormat:@"<arg1>"
             "<typeImage>%@</typeImage>"
             "<descripcionImagen>%@</descripcionImagen>"
             "<idImagen>%@</idImagen>"
             "<imagenClobGaleria></imagenClobGaleria>"
             "</arg1>",
             [StringUtils encriptar:@"IMAGEN" conToken:datos.token],
             [StringUtils encriptar:descImage conToken:datos.token],
             [StringUtils encriptar:idImagenInt conToken:datos.token]];
        }
        [stringXML appendFormat:@"<token>%@</token></ws:updateImage></soapenv:Body></soapenv:Envelope>", [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    
    
    
    NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La Respuesta en WS_HandlerGaleria del metodo actualizarGaleria es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
                int aux=0;
                int idAux=0;
                for(int x = 0;x < ids.count;x++)
                {
                    GaleriaImagenes *imagen = [self.arregloGaleria objectAtIndex:x];
                    
                    imagen.idImagen = [[StringUtils desEncriptar:[ids objectAtIndex:x] conToken:datos.token] integerValue];
                    aux++;
                    idAux = imagen.idImagen;
                }
                if(aux==1){
                    [self.galeriaDelegate resultadoConsultaDominio:[NSString stringWithFormat:@"%i",idAux]];
                } else if(self.resultado == nil){
                    [datos setArregloGaleriaImagenes:self.arregloGaleria];
                    NSLog(@"ENTRO A actualizarGaleriaDescripcion Y REGRESO EXITO");
                    [datos.arregloDescripcionImagenGaleria replaceObjectAtIndex:indexImage withObject:descImage];
                    [self.galeriaDelegate resultadoConsultaDominio:@"Exito"];
                } else {
                    NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                    [self.galeriaDelegate resultadoConsultaDominio:stringResult];
                }
                
            }
            else {NSLog(@"REGRESSO resultadoConsultaDominio DEL METODO ACTUALIZAR GALERIA ACTUALIZARGALERIADESCRIPCION");
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
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i",datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar: [NSString stringWithFormat:@"%i",idImagen] conToken:datos.token],
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
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token]];
        
        [stringXML appendFormat:@"<arg1>"
         "<typeImage>%@</typeImage>"
         "<descripcionImagen>%@</descripcionImagen>"
         "<idImagen>%@</idImagen>"
         "<imagenClobGaleria>%@</imagenClobGaleria>"
         "</arg1><token>%@</token>",
         [StringUtils encriptar:tipoInsertar conToken:datos.token],
         [StringUtils encriptar:imagenInsertar.pieFoto conToken:datos.token],
         [StringUtils encriptar:[NSString stringWithFormat:@"%i", imagenInsertar.idImagen] conToken:datos.token],
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
                datos = [DatosUsuario sharedInstance];
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
                            [self.datosUsuario.arregloUrlImagenesGaleria addObject:self.urlResultado];
                            [self.datosUsuario.arregloTipoImagenGaleria addObject:@"IMAGEN"];
                            [self.datosUsuario.arregloDescripcionImagenGaleria addObject:imagenInsertar.pieFoto];
                            NSLog(@"");
                            if(![self.resultado isEqualToString:@"Exito"] && ![self.resultado isEqualToString:@"No Exito"] && ![self.resultado isEqualToString:@"Error de token"]){
                                 NSLog(@"EL ID DE IMAGEN ES: %@", self.resultado);
                                [self.datosUsuario.arregloIdImagenGaleria addObject:self.resultado];
                            }
                            NSLog(@"LOS VALORES GUARDADOS SON PRIMERO RESULTADO: %@", self.resultado);
                            NSLog(@"LOS VALORES GUARDADOS SON arregloUrlImagenesGaleria RESULTADO: %@", self.resultado);
                            NSLog(@"LOS VALORES GUARDADOS SON arregloTipoImagenGaleria RESULTADO: %@", self.urlResultado);
                           
                        }
                        else {
                            NSLog(@"ENTRO A LA OPCION LOGO");
                            [self.datosUsuario.arregloUrlImagenes addObject:self.urlResultado];
                            [self.datosUsuario.arregloTipoImagen addObject:@"LOGO"];
                            [self.datosUsuario.arregloDescripcionImagen addObject:@""];
                            if(![self.resultado isEqualToString:@"Exito"] && ![self.resultado isEqualToString:@"No Exito"] && ![self.resultado isEqualToString:@"Error de token"]){
                                NSLog(@"EL ID DE IMAGEN ES: %@", self.resultado);
                                [self.datosUsuario.arregloIdImagen addObject:self.resultado];
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
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    self.datosUsuario = [DatosUsuario sharedInstance];
    
    if ([elementName isEqualToString:@"resultado"]) {
        self.resultado = [StringUtils desEncriptar:self.currentElementString conToken:self.datosUsuario.token];
        NSLog(@"EL resultado DE LA IMAGEN : %@", self.resultado);
        
        
    }else if([elementName isEqualToString:@"urlImagen"]){
        self.urlResultado = [StringUtils desEncriptar:self.currentElementString conToken:self.datosUsuario.token];
        NSLog(@"EL resultado de la urlResultado es: %@", self.urlResultado);
    }
}



@end
