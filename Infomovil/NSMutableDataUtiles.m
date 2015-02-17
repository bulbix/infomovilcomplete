//
//  NSMutableDataUtiles.m
//  MainMenu
//
//  Created by Ignaki Dominguez Martinez on 13/04/11.
//  Copyright 2011 BAZ. All rights reserved.
//

#import "NSMutableDataUtiles.h"
#import "NSDataUtiles.h"


@implementation NSMutableData (NSMutableDataUtiles)

- (void)replaceOccurrencesOfData:(NSData *)target withData:(NSData *)replacement;
{
	// withRange cambiando al longitud calculando la diferencia de longitudes de las datas involucradas
	NSRange rangoModif;
	do
	{
		rangoModif = [self rangeOfData:target
									 options:NSDataSearchBackwards
									   range:NSMakeRange(0, [self length])];
		if ( rangoModif.location == NSNotFound )
			break;
		
		[self replaceBytesInRange:rangoModif withBytes:[replacement bytes] length:[replacement length]];
	} while ( TRUE );
}

- (void)changeEncoding:(NSStringEncoding)codifOriginal toEncoding:(NSStringEncoding)codiNueva
{
	char *temp = malloc([self length]+1);
	memset(temp,0,[self length]+1);
	memccpy(temp, [self bytes], 0, [self length]);
	NSString *strTemp = [NSString stringWithCString:temp encoding:codifOriginal];
	free(temp);
	[self setData:[strTemp dataUsingEncoding:codiNueva]];
}

- (void)decodificaHtmlMutableData
{
	[self setData:[self decodificaHtmlData]];
}

@end
