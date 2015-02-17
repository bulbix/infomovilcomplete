//
//  NSDateFormatterUtiles.h
//  CategoriasBaz
//
//  Created by Ignaki Dominguez on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDateFormatter (NSDateFormatterUtiles)

+ (NSDate *)getDateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *)getStringFromTodayWithFormat:(NSString *)format;
+ (NSString *)obtenFechaComoCadena:(NSDate*)pfecha;
+ (NSString *)changeDateFormatOfString:(NSString *)strFecha from:(NSString *)frmtInicial to:(NSString *)frmtFinal;

@end
