//
//  CommonUtils.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 20/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(BOOL) hayConexion {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

+(BOOL)validarDominio:(NSString *)nombreDominio{
    //por default no es valido el nombre
    BOOL valido = NO;
    
    //verificar longitud del nombre de dominio
    if ([nombreDominio length] >= 2 && [nombreDominio length] <= 63) {
        const char *guion = [nombreDominio UTF8String];
        //confirmar que los ultimos caracteres sean distintos de "-"
        if (guion[0] != '-' && guion[[nombreDominio length]-1] != '-') {
            //NSLog(@"primer %c final %c",guion[0],guion[[nombreDominio length]-1]);
            //verificar que no termine .tel, .com, .mx, etc
            //NSString *dominioRegex = @".*(\\.[tT][eE][lL])$";
            NSString *dominioRegex = @"^[_a-z0-9-]+([a-z0-9])$";
            NSPredicate *dominioTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dominioRegex];
            valido = [dominioTest evaluateWithObject:nombreDominio];
            
            //            if (valido)
            //                valido = NO;
            //            else
            //                valido = YES;
        }
        else
            valido = NO;
        
    }
    else
        valido = NO;
    
    return valido;
}

/******
 Validar contrasenia de usuario, para ser valida debe cumplir con las siguientes caracteristicas
 -  Debe tener 6 o más caracteres (letras y números)
 -  No debe ser igual al nombre que designaste como usuario. Debe contener números y letras (alfanumérico)
 -  No debe ser igual al nombre de Infomovil
 ******/

+(BOOL)validarContrasena:(NSString *)usuario contrasena:(NSString *)contrasena{
    //por default no es valido
    BOOL valido = NO;
	BOOL valido2 = NO;
	//int size;
	//const char *c;
    
    //validar longitud de la contrasenia
    if ([contrasena length] >= 8 && [contrasena length] <= 15) {
        //validar que no sea igual al nombre de usuario
        if (![contrasena isEqualToString:usuario]) {
            //expresion regular para evitar que la contrasenia tenga la palabra "infomovil", "INFOMOVIL", "INfoMovIL", etc
            NSString *infomovil = @".*[iI][nN][fF][oO][mM][oO][vV][iI][lL].*";
            NSPredicate *expRegContrasena = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",infomovil];
            valido = [expRegContrasena evaluateWithObject:contrasena];
			
			NSString *infomovil2 = @".*[iI][nN][fF][oO].*";
            NSPredicate *expRegContrasena2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",infomovil2];
            valido2 = [expRegContrasena2 evaluateWithObject:contrasena];
			
			int index = 0;
			while (YES) {
				if([usuario characterAtIndex:index] == '@' ){
					break;
				}
				index++;
			}
			
			NSString * nombre = [usuario substringToIndex:index];
			
            
            if (!valido && !valido2 && ![nombre isEqualToString:contrasena]) {
                //NSString *contraseniaRegex = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}";
                //NSString *contraseniaRegex = @"^(?=.*\\d)(?=.*([a-z]|[A-Z])).{8,15}";
				NSString *contraseniaRegex = @"^(?=.{8,15}$)(?=[^A-Za-z]*[A-Za-z])(?=[^0-9]*[0-9])(?:([\\w\\d])\1?(?!\1))+$";
//				NSString *contraseniaRegex = @"^(?=.{8,15}$)(?=[^A-Za-z]*[A-Za-z])(?=[^0-9]*[0-9])";
                NSPredicate *contraseniaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", contraseniaRegex];
                
                valido = [contraseniaTest evaluateWithObject:contrasena];
				
				/*c = [contrasena UTF8String];
				
				char aux1;
				char aux2;
				char aux3;
				size = 0;
				for(int i = 0;i<strlen(c)-2;i++){
					aux1 = c[i];
					aux2 = c[i+1];
					aux3 = c[i+2];
					
					if(aux2 == aux1){
						if(aux3 != aux2){
							size++;
						}
					}else{
						size++;
					}
				}*/
				
            }
            else
                valido = NO;
        }
        else{
            valido = NO;
        }
    }
	//if(valido && (size+2) == strlen(c))
		return valido;
	//else{
	//	return NO;
	//}
}

/******
 ******/
+(BOOL)validarEmail:(NSString *)email{
    //por default no es valido
    BOOL valido = NO;
    
    NSString *emailRegex = @"^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,3})$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    valido = [emailTest evaluateWithObject:email];
	
	
	
    
    return valido;
}

+ (BOOL)validaNumeroDeTel:(NSString *)strTel {
	NSString *strRegexTel;
	NSPredicate *predRegexDeValidacion;
	
    strRegexTel = @"[0-9]{2,100}";
	
	predRegexDeValidacion = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegexTel];
	
	if ([predRegexDeValidacion evaluateWithObject:strTel] == YES)
		return YES;
	
	
	return NO;
}

+(NSString *)validaFacebookUrl:(NSString *)strFacebook{
	
	//Eliminamos el https:// de la url dada por el usuario(sólo en caso de que la url posea esta suncadena)
	NSString *strFacebookValida = [[strFacebook stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"HTTPS://" withString:@""];
	
	//Expresion regular para validar la url de facebook
	NSString *facebookRegex = @"(((www|WWW))\\.)?(facebook|FACEBOOK)\\.(com|COM)\\/[a-zA-Z0-9\\*\\?\\+\\[\\(\\)\\{\\}\\^\\$\\|\\.\\/\\ ]{1,}";
	NSPredicate * facebookTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",facebookRegex];
	
	if([facebookTest evaluateWithObject:strFacebookValida] == YES)
		return strFacebookValida;
	
	return NSLocalizedString(@"urlInvalida", @" ");
}

+(NSString *)validaTwitterUrl:(NSString *)strTwitter{
	
	//Eliminamos el https:// de la url dada por el usuario(sólo en caso de que la url posea esta suncadena)
	NSString *strTwitterValida = [[[[strTwitter stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"HTTPS://" withString:@""] stringByReplacingOccurrencesOfString:@"www." withString:@""] stringByReplacingOccurrencesOfString:@"WWW." withString:@""];
	
	//Expresion regular para validar la url de twitter
	NSString *twitterRegex = @"(twitter|TWITTER)\\.(com|COM)\\/[a-zA-Z0-9\\*\\?\\+\\[\\(\\)\\{\\}\\^\\$\\|\\.\\/\\ ]{1,}";
	NSPredicate * twitterTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",twitterRegex];
	
	if([twitterTest evaluateWithObject:strTwitterValida] == YES)
		return strTwitterValida;
	
	return NSLocalizedString(@"urlInvalida", @" ");
}

+(NSString *)validaGooglePlus:(NSString *)strGooglePlus{
	
	//Eliminamos el https:// de la url dada por el usuario(sólo en caso de que la url posea esta suncadena)
	NSString *strGoogleValida = [[[[strGooglePlus stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"HTTPS://" withString:@""] stringByReplacingOccurrencesOfString:@"www." withString:@""] stringByReplacingOccurrencesOfString:@"WWW." withString:@""];
	
//	NSLog(@"googlePlus: %@",strGoogleValida);
	
	//Expresion regular para validar la url de google+
	NSString *googleRegex = @"(plus|PLUS)\\.(google|GOOGLE)\\.(com|COM)\\/[a-zA-Z0-9\\*\\?\\+\\[\\(\\)\\{\\}\\^\\$\\|\\.\\/\\ ]{1,}";
	NSPredicate * googleTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",googleRegex];
	
	if([googleTest evaluateWithObject:strGoogleValida] == YES)
		return strGoogleValida;
	
	return NSLocalizedString(@"urlInvalida", @" ");
}

+(NSString *)validaSkype:(NSString *)strSkype{
	//Eliminamos el https:// de la url dada por el usuario(sólo en caso de que la url posea esta suncadena)
	NSString *strSkypeValida = [[[[[[[[strSkype stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"HTTPS://" withString:@""] stringByReplacingOccurrencesOfString:@"www." withString:@""] stringByReplacingOccurrencesOfString:@"WWW." withString:@""]stringByReplacingOccurrencesOfString:@".com" withString:@""] stringByReplacingOccurrencesOfString:@".COM" withString:@""] stringByReplacingOccurrencesOfString:@"SKYPE/" withString:@""] stringByReplacingOccurrencesOfString:@"skype/" withString:@""];
	
	//Expresion regular para validar la url de skype
	NSString *skypeRegex = @"[a-zA-Z0-9\\*\\?\\+\\[\\(\\)\\{\\}\\^\\$\\|\\.\\/\\ ]{1,}";
	NSPredicate * skypeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",skypeRegex];
	
	if([skypeTest evaluateWithObject:strSkypeValida] == YES)
		return strSkypeValida;
	
	return NSLocalizedString(@"cuentaInvalida", @" ");
}

+(NSString *)validaLinkedIn:(NSString *)strLinkedIn{
	//Eliminamos el https:// de la url dada por el usuario(sólo en caso de que la url posea esta suncadena)
    //	NSString *strLinkedInValida = [[strLinkedIn stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"HTTPS://" withString:@""];
	
	//Expresion regular para validar la url de linked in
    //	NSString *linkedInRegex = @"((WWW|www)\\.){0,1}(([a-zA-Z]){1,3}\\.){0,1}(linkedin|LINKEDIN)\\.(com|COM)\\/(IN|in|PUB|pub|COMPANY|company|title|TITLE)\\/[a-zA-Z0-9\\*\\?\\+\\[\\(\\)\\{\\}\\^\\$\\|\\.\\/\\ ]{1,}";
    //	NSPredicate * linkedInTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",linkedInRegex];
    //
    //	if([linkedInTest evaluateWithObject:strLinkedInValida] == YES)
    //		return strLinkedInValida;
    
	if ( [strLinkedIn rangeOfString:@"linkedin.com" options:NSCaseInsensitiveSearch].location != NSNotFound )
        return strLinkedIn;
	
	return NSLocalizedString(@"urlInvalida", @" ");
}

+(NSString *)validaSecureWebside:(NSString *)strSecureWebside{
	//Eliminamos el https:// de la url dada por el usuario(sólo en caso de que la url posea esta suncadena)
	NSString *strSecureWebsideValida = [[strSecureWebside stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"HTTPS://" withString:@""];
	
	//Expresion regular para validar la url de secure Web
	NSString *secureWebsideRegex = @"((www|WWW)\\.){0,1}[a-zA-Z0-9\\*\\?\\+\\[\\(\\)\\{\\}\\^\\$\\|\\.\\/\\ ]{1,}(\\.([a-zA-Z]){1,3})";
	NSPredicate * secureWebsideTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secureWebsideRegex];
	
	if([secureWebsideTest evaluateWithObject:strSecureWebsideValida] == YES)
		return strSecureWebsideValida;
	
	return NSLocalizedString(@"urlInvalida", @" ");
}

+(BOOL) validaNombreEmpresa:(NSString *)nombre{
	NSString *nombreEmpresaRegex = @"[a-z|A-Z|0-9| \\,\\*\\?\\+\\[\\(\\)\\{\\}\\^\\$\\|\\.\\/\\]{1,255}";
	NSPredicate * nombreEmpresaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nombreEmpresaRegex];
	
	if([nombreEmpresaTest evaluateWithObject:nombre] == YES)
		return YES;

	return NO;
}
+(BOOL) validaServicios:(NSString *)servicios{
	NSString * serviciosRegex = @"[a-z|A-Z|0-9| \\+\\.\\,]{1,255}";
	NSPredicate * serviciosTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",serviciosRegex];
	
	if([serviciosTest evaluateWithObject:servicios] == YES)
		return YES;
	
	return NO;
}
+(BOOL) validaNumeroMovil:(NSString *)numero{
	NSString * numeroRegex = @"[0-9]{1,32}";
	NSPredicate * numeroTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numeroRegex];
	
	if([numeroTest evaluateWithObject:numero] == YES)
		return YES;
	
	return NO;
}
+(BOOL) validaMail:(NSString *)mail{
	BOOL valido = NO;
    
    NSString *emailRegex = @"^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,3})$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    valido = [emailTest evaluateWithObject:mail];
    
    return valido;
}
+(BOOL) validaCalleNumero:(NSString *)calleNum{
	NSString *calleNumRegex = @"[a-z|A-Z|0-9| \\+\\.\\,]{1,255}";
	NSPredicate * calleNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",calleNumRegex];
	
	if([calleNumTest evaluateWithObject:calleNum] == YES)
		return YES;
	
	return NO;
}
+(BOOL) validaPoblacion:(NSString *)poblacion{
	NSString *poblacionRegex = @"[a-z|A-Z|0-9| \\+\\.\\,]{1,255}";
	NSPredicate * poblacionTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",poblacionRegex];
	
	if([poblacionTest evaluateWithObject:poblacion] == YES)
		return YES;
	
	return NO;
}
+(BOOL) validaCiudad:(NSString *)ciudad{
	NSString *ciudadRegex = @"[a-z|A-Z|0-9| \\+\\.\\,]{1,100}";
	NSPredicate * ciudadTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ciudadRegex];
	
	if([ciudadTest evaluateWithObject:ciudad] == YES)
		return YES;
	
	return NO;
}
+(BOOL) validaEstado:(NSString *)estado{
	NSString *estadoRegex = @"[a-z|A-Z|0-9| \\+\\.\\,]{1,255}";
	NSPredicate * estadoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",estadoRegex];
	
	if([estadoTest evaluateWithObject:estado] == YES)
		return YES;
	
	return NO;
}
+(BOOL) validaCP:(NSString *)cp{
	NSString *cpRegex = @"[a-z|A-Z|0-9|]{1,32}";
	NSPredicate * cpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cpRegex];
	
	if([cpTest evaluateWithObject:cp] == YES)
		return YES;
	
	return NO;
}
+(BOOL) validaPais:(NSString *)pais{
	NSString *paisRegex = @"[a-z|A-Z|0-9| \\+\\.\\,]{1,255}";
	NSPredicate * paisTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",paisRegex];
	
	if([paisTest evaluateWithObject:pais] == YES)
		return YES;
	
	return NO;
}

+(BOOL) validaNoCaracteres: (NSString *) texto {
    NSString *cadenaExp = @"([a-z|A-Z|0-9|]|ñ|Ñ|&|\\s){1,255}";
    NSPredicate *cadenaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cadenaExp];
    if ([cadenaTest evaluateWithObject:texto] == YES) {
        return YES;
    }
    return NO;
}

+(BOOL) validaCodigoRedimir:(NSString *)texto {
    NSString *cadenaExp = @"([a-z|A-Z|0-9|]|\\s){1,}";
    NSPredicate *cadenaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cadenaExp];
    if ([cadenaTest evaluateWithObject:texto] == YES) {
        return YES;
    }
    return NO;
}

+(BOOL)validarYoutubeURL: (NSString *)url {
    NSString *expRegular = @"(https?://)?(www\\.)?(yotu\\.be/|youtube\\.com/)?((.+/)?(watch(\\?v=|.+&v=))?(v=)?)([\\w_-]{11})(&.+)?";
    NSPredicate *cadenaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expRegular];
    if ([cadenaTest evaluateWithObject:url] == YES) {
        return YES;
    }
    return NO;
}

+(BOOL) perfilEditado {
    BOOL fueEditado = NO;
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    if ([datosUsuario.arregloEstatusEdicion count] > 0) {
        for (int i = 0; i < [datosUsuario.arregloEstatusEdicion count]; i++) {
            if ([[datosUsuario.arregloEstatusEdicion objectAtIndex:i]  isEqual: @YES]) {
                fueEditado = YES;
                break;
            }
        }
    }
    return fueEditado;
}

@end
