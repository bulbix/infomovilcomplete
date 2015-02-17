//
//  NSStringUtiles.h
//  MainMenu
//
//  Created by Ignaki Dominguez Martinez on 23/02/10.
//  Copyright 2010 BAZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define	kaacute @"\u221a\u00b0"
#define keacute @"\u221a\u00a9"
#define kiacute @"\u221a\u2260"
#define koacute @"\u221a\u2265"
#define kuacute @"\u221a\u222b"
#define kOacute @"\u221a\u00ec"
#define kEnieMayuscula @"\u221a\u00eb"
#define kEnieMinuscula @"\u221a\u00b1"
#define kIniciaInterrogacion @"\u221a?"
#define kTerminaInterrogacion @"\u00ac\u00f8"
#define kuuml @"\u221a\u00ba"

@interface NSString (NSStringUtiles)

+ (NSString *)limpiaData:(NSData *)data;
+ (NSString *)decodificaHtml:(NSString *)cadena;
+ (NSString *)codificaHtml:(NSString *)cadena;
+ (NSString *)seteaCadena:(NSString *)cadena;
+ (NSString *)seteaUrl:(NSString *)cadena;

+ (NSString *)trim:(NSString *)string;
- (NSString *)trim;

- (double)stringToDecimal;

+ (NSString *)stringToRc2b64:(NSString *)string;
+ (NSString *)rc2b64ToString:(NSString *)string;

- (NSString *)stringTob64WithEncoding:(NSStringEncoding)encode;
- (NSString *)b64ToStringWithEncoding:(NSStringEncoding)encode;

- (NSString *)left:(NSInteger)index;
- (NSString *)right:(NSInteger)index;

- (BOOL)isEmpty;
+ (BOOL)isEmptyString:(NSString *)string;



@end
