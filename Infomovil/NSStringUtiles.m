//
//  NSStringUtiles.m
//  MainMenu
//
//  Created by Ignaki Dominguez Martinez on 23/02/10.
//  Copyright 2010 BAZ. All rights reserved.
//

#import "NSStringUtiles.h"
#import "NSDataUtiles.h"
#import "rc2.h"

#define EncodingActual NSASCIIStringEncoding
//#define EncodingActual NSISOLatin1StringEncoding
//#define EncodingActual NSISOLatin2StringEncoding
//#define EncodingActual NSWindowsCP1252StringEncoding
//#define EncodingActual NSWindowsCP1254StringEncoding
//#define EncodingActual NSWindowsCP1250StringEncoding
//#define EncodingActual NSISO2022JPStringEncoding
//#define EncodingActual NSMacOSRomanStringEncoding /*quita acento*/

@implementation NSString (NSStringUtiles)

/**
 *	Sobreescribe caracteres especiales contenidos en el NSData para que mantengan la codificacion UTF-8
 *	@param data: informacion que se desea limpiar
 *	@return representacion del data corregido en NSString, nil en caso de que el data sea nulo
 *	@since 2010-01-22
 */
+ (NSString *)limpiaData:(NSData *)data
{
	if( data != nil )
	{
		NSMutableString *mstrLimpia = [[[NSMutableString alloc] initWithCString:[data bytes] length:[data length]] autorelease];
		
		[mstrLimpia replaceOccurrencesOfString:kaacute withString:@"á" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:keacute withString:@"é" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kiacute withString:@"í" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:koacute withString:@"ó" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kuacute withString:@"ú" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kOacute withString:@"Ó" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kEnieMayuscula withString:@"Ñ" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kEnieMinuscula withString:@"ñ" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kuuml withString:@"ü" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kIniciaInterrogacion withString:@"?" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kTerminaInterrogacion withString:@"¿" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		//		NSString *salida = [[[NSString alloc] initWithUTF8String:[limpia UTF8String]] autorelease];
		//		return salida;
		return mstrLimpia;
	}else
		return nil;
}

/**
 *	Sobreescribe por caracteres especiales tags del xml en una cadena para que mantengan la longitud deseada
 *	@param cadena: informacion que se desea limpiar
 *	@return representacion del data corregido en NSString, nil en caso de que el data sea nulo
 *	@since 2010-01-26
 */
+ (NSString *)decodificaHtml:(NSString *)cadena
{
	if ( cadena != nil )
	{
		NSMutableString *mstrLimpia = [[[NSMutableString alloc] initWithString:cadena] autorelease];
		[mstrLimpia replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&#xD;"  withString:@"\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&#xA;"  withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		return mstrLimpia;
	}else
		return nil;
}

/**
 *	Sobreescribe por caracteres especiales tags del xml en una cadena para que mantengan la longitud deseada
 *	@param cadena: informacion que se desea limpiar
 *	@return representacion del data corregido en NSString, nil en caso de que el data sea nulo
 *	@since 2010-01-26
 */
+ (NSString *)codificaHtml:(NSString *)cadena
{
	if ( cadena != nil )
	{
		NSMutableString *mstrLimpia = [[[NSMutableString alloc] initWithString:cadena] autorelease];
		[mstrLimpia replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
//		[mstrLimpia replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
//		[mstrLimpia replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
//		[mstrLimpia replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
        
//        [mstrLimpia replaceOccurrencesOfString:@"&"  withString:@"&#38;"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
//		[mstrLimpia replaceOccurrencesOfString:@"<"  withString:@"&#60;"   options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
//		[mstrLimpia replaceOccurrencesOfString:@">"  withString:@"&#62;"   options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
//		[mstrLimpia replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		return mstrLimpia;
	}else
		return nil;
}

/**
 *	Sobreescribe por caracteres especiales tags del xml en una cadena para que mantengan la codificacion UTF-8
 *	@param cadena: informacion que se setear limpiar
 *	@return representacion del data corregido en NSString, nil en caso de que el data sea nulo
 *	@since 2010-01-26
 */
+ (NSString *)seteaCadena:(NSString *)cadena
{
	if ( cadena != nil )
	{
		NSMutableString *mstrLimpia = [[[NSMutableString alloc] initWithString:cadena] autorelease];
		[mstrLimpia replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&#xD;"  withString:@"\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"&#xA;"  withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:@"\u00c3\u00ad" withString:@"í" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"\u00c3\u00a9" withString:@"é" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];

		[mstrLimpia replaceOccurrencesOfString:kaacute withString:@"á" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:keacute withString:@"é" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kiacute withString:@"í" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:koacute withString:@"ó" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kuacute withString:@"ú" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kOacute withString:@"Ó" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kEnieMayuscula withString:@"Ñ" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kEnieMinuscula withString:@"ñ" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kuuml withString:@"ü" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		[mstrLimpia replaceOccurrencesOfString:kIniciaInterrogacion withString:@"?" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:kTerminaInterrogacion withString:@"¿" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		
		
		return mstrLimpia;
	}else
		return nil;
}


/**
 *	Sobreescribe por caracteres especiales de una URL en una cadena para que puedan ser codificados correctamente por el WS
 *	@param cadena: URL a modificar
 *	@return URL corregida, nil en caso de que el data sea nulo
 *	@since 2010-09-01
 */
+ (NSString *)seteaUrl:(NSString *)cadena
{
	if ( cadena != nil )
	{
		NSMutableString *newUrl = [[[NSMutableString alloc] initWithString:cadena] autorelease];
		[newUrl replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newUrl length])];
		[newUrl replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newUrl length])];
		[newUrl replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newUrl length])];
		[newUrl replaceOccurrencesOfString:@"°" withString:@"%C2%B0" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newUrl length])];
		[newUrl replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newUrl length])];
        [newUrl replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newUrl length])];
#ifdef _DEBUG
		NSLog(@"SETEA: %@",newUrl);
#endif
		return newUrl;
	}else
		return nil;
}






/**
 *	Borra los espacios a la derecha e izquierda de una cadena dada
 *	@param string: cadena con la cual se creara la nueva cadena sin espacios a los extremos
 *	@return regresa la cadena sin espacios, o nil en caso de que la entrada sea nula
 */
+ (NSString *)trim:(NSString *)string
{
	if ( string != nil )
	{
		NSString *strRegresa = [[NSString alloc] initWithString:
								[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		return [strRegresa autorelease];
	}else
		return nil;
}

/**
 *	Borra los espacios a la derecha e izquierda de una cadena dada
 *	@return regresa la cadena sin espacios, o nil en caso de que la entrada sea nula
 */
- (NSString *)trim
{
	if ( self )
	{
		NSString *strRegresa = [[NSString alloc] initWithString:
								[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		return [strRegresa autorelease];
	}else
		return nil;
}

/**
 * Convierte una cadena, sin punto decimal a un numero con dos decimales (division entre 100)
 *	@return regresa el valor del numero convertido
 */
- (double)stringToDecimal
{
	double dValor = [[self substringToIndex:[self length]-2] doubleValue] + ( [[self substringFromIndex:[self length]-2]doubleValue]/100 );
	return dValor;
}

/**
 *	Encripta una cadena dada con el metodo RC2 y la codifica a base 64
 *	@param string: cadena a convertir
 *	@return cadena tratada en base 64
 *	@since 2010-08-13
 */
+ (NSString *)stringToRc2b64:(NSString *)string
{
	unsigned char _key[] = {"ABCDEFGHIJKLMNOP"};
	unsigned char iv1[] = {"ABCDEFGH"};
	int lon = [string lengthOfBytesUsingEncoding:EncodingActual];
	unsigned char *output = NULL;
	unsigned char *input = NULL;
	int lonTemp;
	
	RC2_KEY key;
	RC2_set_key(&key, strlen((char*)_key), _key, 128);
	
	lonTemp = (lon+8)/8 * 8 + 1;
	if ( (input = (unsigned char*) malloc( lonTemp )) && (output = (unsigned char*) malloc( lonTemp )) )
	{
		memset(input, 0, lonTemp);
		memcpy(input, (unsigned char*)[string cStringUsingEncoding:EncodingActual], lon);
		lonTemp--;
		memset(input+lon, lonTemp-lon, lonTemp-lon);
		
		RC2_cbc_encrypt((const unsigned char*)input, output, lonTemp, &key, iv1, RC2_ENCRYPT);
		
		//NSData *data = [NSData dataWithBytesNoCopy:output length:lonTemp];
		NSData *data = [NSData dataWithBytes:output length:lonTemp];
		
		free(input);
		free(output);
		
		return [data base64Encoding];
	} else {
		if ( input )
			free(input);
		if ( output)
			free(output);
		return nil;
	}
}

/**
 *	Decodifica una cadena dada en base 64 y la desencripta con el metodo RC2
 *	@param string: cadena a convertir
 *	@return cadena tratada (resultado de la operacion)
 *	@since 2010-08-13
 */
+ (NSString *)rc2b64ToString:(NSString *)string
{
	unsigned char _key[] = {"ABCDEFGHIJKLMNOP"};
	unsigned char iv1[] = {"ABCDEFGH"};
	int lon;
	unsigned char *output = NULL;
	const void *inp2;
	NSData *data64;
	
	RC2_KEY key;
	RC2_set_key(&key, strlen((char*)_key), _key, 128);
	
	data64 = [NSData dataWithBase64EncodedString:string];
	inp2 = [data64 bytes];
	lon = [data64 length];
	if ( (output = (unsigned char*)malloc( lon+1 )) )
	{
		memset(output, 0x0, lon+1);
		RC2_cbc_encrypt((const unsigned char*)inp2, output, lon, &key, iv1, RC2_DECRYPT);
		lon--;
		while ( lon >= 0 )
		{
			if ( output[lon] < ' ' )
				lon--;
			else
				break;
		}
		memset((void*)output+lon+1, '\0', [data64 length]-lon-1);
		NSString *strConv = [[[NSString alloc] initWithCString:(char*)output encoding:EncodingActual] autorelease];
		
		strConv = [strConv stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
		strConv = [strConv stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
		strConv = [strConv stringByReplacingOccurrencesOfString:@"í" withString:@"i"];
		strConv = [strConv stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
		strConv = [strConv stringByReplacingOccurrencesOfString:@"ú" withString:@"u"];
		strConv = [strConv stringByReplacingOccurrencesOfString:@"ñ" withString:@"n"];
		
		free(output);
		
		//NSLog(@"Prueba desencripta %@ -> %@",string,strConv);
		return strConv;
	}
	return nil;
}

/**
 *  Convierte la informacion de una cadena a Base 64 con una codificacion especifica
 *  @param encode: tipo de encoding del NSString que lo invoca
 *  @return cadena codificada
 */
- (NSString *)stringTob64WithEncoding:(NSStringEncoding)encode
{
	int lon = [self lengthOfBytesUsingEncoding:encode];
	char *buffer = malloc(lon+1 );
	memset(buffer,0,lon+1);
	memcpy(buffer, (unsigned char*)[self cStringUsingEncoding:encode], lon);
	NSData *data = [[[NSData alloc] initWithBytes:buffer length:lon] autorelease];
	free(buffer);
	
	return [data base64Encoding];
}

- (NSString *)b64ToStringWithEncoding:(NSStringEncoding)encode
{
	NSData *data64 = [NSData dataWithBase64EncodedString:self];
	NSString *strResp = [[NSString alloc] initWithData:data64 encoding:encode];
	return [strResp autorelease];
}

/**
 *	Extra los "index" caracteres solicitados de izquierda a derecha como una subcadena de la actual
 *	@param index: cantidad maxima de caracteres solicitados
 *	@return una cadena con una cantidad de caracteres menor o iguales a los solicitados de izquierda a derecha
 *	@since 2010-10-21
 */
- (NSString *)left:(NSInteger)index
{
	if ( [self length] > index )
		return [self substringToIndex:index];
	else
		return [NSString stringWithString:self];
}

/**
 *	Extra los "index" caracteres solicitados de derecha a izquierda como una subcadena de la actual
 *	@param index: cantidad de caracteres solicitados
 *	@return una cadena con una cantidad de caracteres menor o iguales a los solicitados de derecha a izquierda
 *	@since 2010-10-21
 */
- (NSString *)right:(NSInteger)index
{
	if ( [self length] > index )
		return [self substringFromIndex:[self length]-index];
	else
		return [NSString stringWithString:self];
}

- (BOOL)isEmpty
{
	return [[self trim] isEqualToString:@""];
}

+ (BOOL)isEmptyString:(NSString *)string
{
	if ( string )
		return [string isEmpty];
	else
		return YES;
}



@end
