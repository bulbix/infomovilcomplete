//
//  NSDataUtiles.h
//  rutaInalPruebas
//
//  Created by Ignaki Dominguez Martinez on 04/01/10.
//  Copyright 2010 BAZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSDataUtiles)

// GZIP
//- (NSData *) gzipDescomprime;
//- (NSData *) gzipComprime;

//Coder
- (id)initWithBase64EncodedData:(NSData *)data;
- (id)initWithBase64EncodedString:(NSString *)string;
+ (id)dataWithBase64EncodedData:(NSData *)data;
+ (id)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64Encoding;
+ (NSData *)desEncriptaDescomprimeDataB64:(NSData *)pCadena;
+ (NSData *)desEncriptaDescomprimeStringB64:(NSString*)pCadena;
+ (NSString*)comprimeEncriptaStringB64:(NSString*)pCadena;
+ (NSData *)decodificaHtmlData:(NSData *)data;
- (NSData *)decodificaHtmlData;

//
- (NSData *)dataByReplacingOccurrencesOfData:(NSData *)target withData:(NSData *)replacement;
- (NSData *)dataByChangingEncoding:(NSStringEncoding)codifOriginal toEncoding:(NSStringEncoding)codiNueva;
+ (NSData *)limpiaData:(NSData *)data;

@end
