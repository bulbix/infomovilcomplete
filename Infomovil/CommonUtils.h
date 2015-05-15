//
//  CommonUtils.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 20/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CommonUtils : NSObject

+(BOOL) hayConexion;
+(BOOL) validarDominio:(NSString *)nombreDominio;
+(BOOL) validarContrasena:(NSString *)usuario contrasena:(NSString *)contrasena;
+(BOOL) validarEmail:(NSString *)email;
+(BOOL)validarIdFacebook:(NSString *)idFacebook;
+ (BOOL)validaNumeroDeTel:(NSString *)strTel;
+(NSString *)validaFacebookUrl:(NSString *)strFacebook;
+(NSString *)validaTwitterUrl:(NSString *)strTwitter;
+(NSString *)validaGooglePlus:(NSString *)strGooglePlus;
+(NSString *)validaSkype:(NSString *)strSkype;
+(NSString *)validaLinkedIn:(NSString *)strLinkedIn;
+(NSString *)validaSecureWebside:(NSString *)strSecureWebside;

+(BOOL) validaNombreEmpresa:(NSString *)nombre;
+(BOOL) validaServicios:(NSString *)servicios;
+(BOOL) validaNumeroMovil:(NSString *)numero;
+(BOOL) validaMail:(NSString *)mail;
+(BOOL) validaCalleNumero:(NSString *)calleNum;
+(BOOL) validaPoblacion:(NSString *)poblacion;
+(BOOL) validaCiudad:(NSString *)ciudad;
+(BOOL) validaEstado:(NSString *)estado;
+(BOOL) validaCP:(NSString *)cp;
+(BOOL) validaPais:(NSString *)pais;
+(BOOL) validaNoCaracteres: (NSString *)texto;

+(BOOL)validarYoutubeURL: (NSString *)url;

+(BOOL) perfilEditado;

+(BOOL) validaCodigoRedimir:(NSString *)texto;

@end
