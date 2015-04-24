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

-(void) actualizarGaleria {
	ids = [[NSMutableArray alloc] init];
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
    if (requiereEncriptar) {
        stringXML = [[NSMutableString alloc] initWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:updateImage>"
                     "<domainId>%@</domainId>" , [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token]];
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
        }
        [stringXML appendFormat:@"<token>%@</token></ws:updateImage></soapenv:Body></soapenv:Envelope>", [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    
  //  NSLog(@"El string es %@", stringXML);
    self.strSoapAction = @"WSInfomovilDomain";
    NSData *dataResult = [self getXmlRespuesta:stringXML conURL:[NSString stringWithFormat:@"%@/%@/wsInfomovildomain", rutaWS, nombreServicio]];
    NSLog(@"La Respuesta en WS_HandlerGaleria del metodo actualizarGarleria es %s", [dataResult bytes]);
    if (dataResult != nil) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataResult];
        [parser setDelegate:self];
        if ([parser parse]) {
            if (requiereEncriptar) {
                datos = [DatosUsuario sharedInstance];
				if(datos.token == Nil){
					datos.token = self.token;
				}
                if (self.token == nil) {
                    [self.galeriaDelegate errorToken];
                } else {
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
                        [self.galeriaDelegate resultadoConsultaDominio:@"Exito"];
                    } else {
                        NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
                        if (stringResult == nil)
                            stringResult = [StringUtils desEncriptar:self.resultado conToken:self.token];
                        
                        
                            [self.galeriaDelegate resultadoConsultaDominio:stringResult];
                    }
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



-(void) eliminarImagen:(NSInteger)idImagen { NSLog(@"MANDO A LLAMAR ELIMINAR IMAGEN!!!!!");
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSString *stringXML;
    if (requiereEncriptar) {
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
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token],
                     [StringUtils encriptar:[NSString stringWithFormat:@"%i", idImagen] conToken:datos.token],
                     [StringUtils encriptar:datos.emailUsuario conToken:passwordEncriptar]];
    }
    else {
        stringXML = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:deleteImage>"
                     "<domainId>%i</domainId>"
                     "<imageId>%i</imageId>"
                     "</ws:deleteImage>"
                     "</soapenv:Body>"
                     "</soapenv:Envelope>", datos.idDominio, idImagen];
    }
    
    
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
                //datos.token = self.token;
               // NSString *stringResult = [StringUtils desEncriptar:self.resultado conToken:datos.token];
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
                        
                        [self.galeriaDelegate resultadoConsultaDominio:@"Exito"];
                    }
                    else {
                        [self.galeriaDelegate resultadoConsultaDominio:@"No Exito"];
                    }
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

-(void) insertarImagen:(GaleriaImagenes *) imagenInsertar {
    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *stringXML;
    NSString *tipoInsertar = @"LOGO";
    if (self.tipoGaleria == PhotoGaleryTypeImage) {
        tipoInsertar = @"IMAGEN";
        NSLog(@"INSERTO UNA IMAGEN DE LA GALERIA");
    }
    if (requiereEncriptar) {
//        NSString *strAux = [Base64 encode:[NSData dataWithContentsOfFile:imagenInsertar.rutaImagen]];
        stringXML = [NSMutableString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://ws.webservice.infomovil.org/\">"
                     "<soapenv:Header/>"
                     "<soapenv:Body>"
                     "<ws:insertImage>"
                     "<domainId>%@</domainId>",[StringUtils encriptar:[NSString stringWithFormat:@"%i", datos.idDominio] conToken:datos.token]];
        
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
                //datos.token = self.token;
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
