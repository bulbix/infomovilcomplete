//
//  NSDataUtiles.m
//  rutaInalPruebas
//
//  Created by Ignaki Dominguez Martinez on 04/01/10.
//  Copyright 2010 BAZ. All rights reserved.
//	Compilacion de metodos para trabajar con base 64 y compresion en un objeto NSData
//

#import "NSDataUtiles.h"
#import "NSStringUtiles.h"
#import "NSMutableDataUtiles.h"
#include <zlib.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (NSDataUtiles)

#pragma mark -
#pragma mark Gzip Methods
//- (NSData *)gzipDescomprime
//{
//	if ([self length] == 0) return self;
//	
//	unsigned full_length = [self length];
//	unsigned half_length = [self length] / 2;
//	
//	NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
//	BOOL done = NO;
//	int status;
//	
//	z_stream strm;
//	strm.next_in = (Bytef *)[self bytes];
//	strm.avail_in = [self length];
//	strm.total_out = 0;
//	strm.zalloc = Z_NULL;
//	strm.zfree = Z_NULL;
//	
//	if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
//	while (!done)
//	{
//		// Make sure we have enough room and reset the lengths.
//		if (strm.total_out >= [decompressed length])
//			[decompressed increaseLengthBy: half_length];
//		strm.next_out = [decompressed mutableBytes] + strm.total_out;
//		strm.avail_out = [decompressed length] - strm.total_out;
//		
//		// Inflate another chunk.
//		status = inflate (&strm, Z_SYNC_FLUSH);
//		if (status == Z_STREAM_END) done = YES;
//		else if (status != Z_OK) break;
//	}
//	if (inflateEnd (&strm) != Z_OK) return nil;
//	
//	// Set real length.
//	if (done)
//	{
//		[decompressed setLength: strm.total_out];
//		return decompressed;
//	}
//	else return nil;
//}

//- (NSData *)gzipComprime
//{
//	if ([self length] == 0) return self;
//	
//	z_stream strm;
//	
//	strm.zalloc = Z_NULL;
//	strm.zfree = Z_NULL;
//	strm.opaque = Z_NULL;
//	strm.total_out = 0;
//	strm.next_in=(Bytef *)[self bytes];
//	strm.avail_in = [self length];
//	
//	// Compresssion Levels:
//	//   Z_NO_COMPRESSION
//	//   Z_BEST_SPEED
//	//   Z_BEST_COMPRESSION
//	//   Z_DEFAULT_COMPRESSION
//	
//	if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
//	
//	NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
//	
//	do {
//		
//		if (strm.total_out >= [compressed length])
//			[compressed increaseLengthBy: 16384];
//		
//		strm.next_out = [compressed mutableBytes] + strm.total_out;
//		strm.avail_out = [compressed length] - strm.total_out;
//		
//		deflate(&strm, Z_FINISH);  
//		
//	} while (strm.avail_out == 0);
//	
//	deflateEnd(&strm);
//	
//	[compressed setLength: strm.total_out];
//	return compressed;
//}

#pragma mark -
#pragma mark Base64 Coder
- (id)initWithBase64EncodedData:(NSData *)data
{
	NSData *dataTemp = [NSData dataWithBase64EncodedData:data];
	self = [self initWithData:dataTemp];
	return self;
}

- (id)initWithBase64EncodedString:(NSString *)string
{
	NSData *data = [NSData dataWithBase64EncodedString:string];
	self = [self initWithData:data];
	return self;
}

+ (id)dataWithBase64EncodedData:(NSData *)data
{
	char *temp = malloc([data length]+1);
	memset(temp,0,[data length]+1);
	memccpy(temp, [data bytes], 0, [data length]);
	NSString *str = [NSString stringWithCString:temp encoding:NSUTF8StringEncoding];
	free(temp);
	return [NSData dataWithBase64EncodedString:str];
}

+ (id)dataWithBase64EncodedString:(NSString *)string
{
	if (string == nil)
		return nil;
		//[NSException raise:NSInvalidArgumentException format:@"%@",nil];
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
	{
		free(decodingTable);
		decodingTable = NULL;
		return nil;
	}
	char *bytes = malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
	{
		free(decodingTable);
		decodingTable = NULL;
		return nil;
	}
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				free(decodingTable);
				decodingTable = NULL;
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			free(decodingTable);
			decodingTable = NULL;
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	free(decodingTable);
	decodingTable = NULL;
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encoding
{
	if ( [self length] == 0 )
		return @"";
	// Buffer de salida
    char *characters = malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while ( i < [self length] )
	{
		// segmento de trabajo de cada iteracion (24 bits)
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while ( bufferLength < 3 && i < [self length] )
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Codificacion de bytes dentro de un buffer de 4 caracteres, incluyendo los sufijos de caracteres "=" cuando sean necesarios
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

+ (NSData *)desEncriptaDescomprimeDataB64:(NSData *)pCadena
{
	char *temp = malloc([pCadena length]+1);
	memset(temp, 0, [pCadena length]+1);
	memccpy(temp, [pCadena bytes], 0, [pCadena length]);
	NSString *strTemp = [NSString stringWithCString:temp encoding:NSUTF8StringEncoding];
	free(temp);
	return [NSData desEncriptaDescomprimeStringB64:strTemp];
}

+ (NSData *)desEncriptaDescomprimeStringB64:(NSString*)pCadena
{
	NSData *data = [NSData dataWithBase64EncodedString:pCadena];
	if ( data ) {
//		data = [data gzipDescomprime];
    }
	
	return data;
}

+ (NSString*)comprimeEncriptaStringB64:(NSString*)pCadena
{
	NSData *data		= nil;
	NSString *strReturn = nil;
	
	data		= [pCadena dataUsingEncoding:NSUTF8StringEncoding];
//	data		= [data gzipComprime];
	strReturn	= [data base64Encoding];
	
	return strReturn;
}

+ (NSData *)decodificaHtmlData:(NSData *)data
{
	NSData *dataDecode = [data decodificaHtmlData];
	return dataDecode;
}

- (NSData *)decodificaHtmlData
{
	NSMutableData *dataDecode		= [[NSMutableData alloc] initWithData:self];
	NSDictionary *dictDataChange	= [[NSDictionary alloc] initWithObjectsAndKeys:
											[@"&amp;" dataUsingEncoding:NSUTF8StringEncoding],@"&",
											[@"&lt;" dataUsingEncoding:NSUTF8StringEncoding],@"<",
											[@"&gt;" dataUsingEncoding:NSUTF8StringEncoding],@">",
											[@"&quot;" dataUsingEncoding:NSUTF8StringEncoding],@"\"",
											[@"&#xD;" dataUsingEncoding:NSUTF8StringEncoding],@"\r",
											[@"&#xA;" dataUsingEncoding:NSUTF8StringEncoding],@"\n",
											nil];
	
	NSArray *arrayLlaves = [dictDataChange allKeys];
	for ( NSString *llave in arrayLlaves )
		[dataDecode replaceOccurrencesOfData:[dictDataChange objectForKey:llave]
									withData:[llave dataUsingEncoding:NSUTF8StringEncoding]];
    [dictDataChange release];
	return [dataDecode autorelease];
}

#pragma mark -
- (NSData *)dataByReplacingOccurrencesOfData:(NSData *)target withData:(NSData *)replacement
{
	NSMutableData *data = [[NSMutableData alloc] initWithData:self];
	[data replaceOccurrencesOfData:target withData:replacement];
	
	return [data autorelease];
}

- (NSData *)dataByChangingEncoding:(NSStringEncoding)codifOriginal toEncoding:(NSStringEncoding)codiNueva
{
	char *temp = malloc([self length]+1);
	memset(temp,0,[self length]+1);
	memccpy(temp, [self bytes], 0, [self length]);
	NSString *strTemp = [NSString stringWithCString:temp encoding:codifOriginal];
	free(temp);
#ifdef _DEBUG
	NSLog(strTemp,nil);
#endif
	return [strTemp dataUsingEncoding:codiNueva];
}

/*+ (NSData *)limpiaData:(NSData *)data
{
	NSMutableData *dataDecode		= [[NSMutableData alloc] initWithData:data];
	NSDictionary *dictDataChange	= [[NSDictionary alloc] initWithObjectsAndKeys:
											[kaacute dataUsingEncoding:NSUTF8StringEncoding],@"á",
											[keacute dataUsingEncoding:NSUTF8StringEncoding],@"é",
											[kiacute dataUsingEncoding:NSUTF8StringEncoding],@"í",
											[koacute dataUsingEncoding:NSUTF8StringEncoding],@"ó",
											[kuacute dataUsingEncoding:NSUTF8StringEncoding],@"ú",
											[kOacute dataUsingEncoding:NSUTF8StringEncoding],@"Ó",
											[kEnieMayuscula dataUsingEncoding:NSUTF8StringEncoding],@"Ñ",
											[kEnieMinuscula dataUsingEncoding:NSUTF8StringEncoding],@"ñ",
											[kuuml dataUsingEncoding:NSUTF8StringEncoding],@"ü",
											[kIniciaInterrogacion dataUsingEncoding:NSUTF8StringEncoding],@"?",
											[kTerminaInterrogacion dataUsingEncoding:NSUTF8StringEncoding],@"¿",
											nil];
	
	NSArray *arrayLlaves = [dictDataChange allKeys];
	for ( NSString *llave in arrayLlaves )
		[dataDecode replaceOccurrencesOfData:[dictDataChange objectForKey:llave]
									withData:[llave dataUsingEncoding:NSUTF8StringEncoding]];
	
    [dictDataChange release];
	return [dataDecode autorelease];
}
*/
@end
