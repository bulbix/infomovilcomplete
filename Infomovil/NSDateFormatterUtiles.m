//
//  NSDateFormatterUtiles.m
//  CategoriasBaz
//
//  Created by Ignaki Dominguez on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatterUtiles.h"
#import "NSStringUtiles.h"

@implementation NSDateFormatter (NSDateFormatterUtiles)

+ (NSDate *)getDateFromString:(NSString *)string withFormat:(NSString *)format
{					 
	@try
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setLocale:[[NSLocale preferredLanguages] objectAtIndex:0]];
//        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
		[dateFormatter setDateFormat:format];
		
		NSDate *date = [dateFormatter dateFromString:string];
		
		if ( date )
		{
			[dateFormatter release];
			return date;
		} else {
			NSRange rango = [format rangeOfString:@"HH"];
			
			if( rango.location == NSNotFound )
				return nil;
			
			NSRange rangeAM = [string rangeOfString:@"am" options:NSCaseInsensitiveSearch];
			NSRange rangePM = [string rangeOfString:@"pm" options:NSCaseInsensitiveSearch];
			if ( rangeAM.location != NSNotFound )
				string = [string stringByReplacingCharactersInRange:rangeAM withString:@"a.m."];
			else if ( rangePM.location != NSNotFound )
				string = [string stringByReplacingCharactersInRange:rangePM withString:@"p.m."];
			
			
			rangeAM = [string rangeOfString:@" a.m." options:NSCaseInsensitiveSearch];
			rangePM = [string rangeOfString:@" p.m." options:NSCaseInsensitiveSearch];
			
			if ( rangePM.location == NSNotFound && rangeAM.location == NSNotFound )
			{
				NSString *strHora = [string substringWithRange:rango];
				
				if ( [strHora intValue] > 12 )
				{
					int hora = [strHora intValue] - 12;
					strHora = [NSString stringWithFormat:@"%02d",hora];
					string = [string stringByReplacingCharactersInRange:rango withString:strHora];
					string = [string stringByAppendingString:@" p.m."];
				} else if ( [strHora intValue] < 12 )
					string = [string stringByAppendingString:@" a.m."];
				else
					string = [string stringByAppendingString:@" p.m."];
				
			} else if ( rangePM.location != NSNotFound )
			{
				int hora = [[string substringWithRange:rango] intValue];
				NSString *strHora = [NSString stringWithFormat:@"%d",hora+12];
				string = [string stringByReplacingCharactersInRange:rangePM withString:@""];
				string = [string stringByReplacingCharactersInRange:rango withString:strHora];
			} else
				string = [string stringByReplacingCharactersInRange:rangeAM withString:@""];
			
			date = [dateFormatter dateFromString:string];
			[dateFormatter release];
			return date;
		}
		
	}@catch (NSException *e) {
		return nil;
	}
}

+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format
{
	NSDateFormatter *dateFormatter	= [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	@try
	{
		NSString *strFecha = [dateFormatter stringFromDate:date];
		
		if ([format rangeOfString:@"HH"].location != NSNotFound)
		{
			NSRange rango = [format rangeOfString:@"HH"];
			NSRange ranStr = NSMakeRange(0, [strFecha length]);
			
			if ( [strFecha rangeOfString:@"p.m." options:NSCaseInsensitiveSearch].location != NSNotFound )
			{
				NSInteger hora = [[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:date] hour];
				NSString *strHora = [NSString stringWithFormat:@"%d",hora];
				strFecha = [strFecha stringByReplacingCharactersInRange:rango withString:strHora];
				strFecha = [strFecha stringByReplacingOccurrencesOfString:@" p.m." withString:@"" options:NSCaseInsensitiveSearch range:ranStr];
			} else if([strFecha rangeOfString:@"a.m." options:NSCaseInsensitiveSearch].location != NSNotFound)
				strFecha = [strFecha stringByReplacingOccurrencesOfString:@" a.m." withString:@"" options:NSCaseInsensitiveSearch range:ranStr];
			
			[dateFormatter release];
			return strFecha;
		}
		
		else {
			[dateFormatter release];
			return strFecha;
		}	
		
	} @catch (NSException *e) 
	{
		return nil;
	}
}


+ (NSString *)getStringFromTodayWithFormat:(NSString *)format
{
	NSDate *fechaHoy	= [[NSDate alloc] init];
	NSString *strFecha	= [NSDateFormatter getStringFromDate:fechaHoy withFormat:format];
	[fechaHoy release];
	return strFecha;
}

+ (NSString *)obtenFechaComoCadena:(NSDate*)pfecha
{
	NSString *strFechaCadena = [[NSString alloc] initWithString:[NSDateFormatter getStringFromDate:pfecha withFormat:@"dd-MM-yyyy"]];
	return [strFechaCadena autorelease];
}

+ (NSString *)changeDateFormatOfString:(NSString *)strFecha from:(NSString *)frmtInicial to:(NSString *)frmtFinal
{
    if ( [NSString isEmptyString:strFecha] )
        return @"";
    
    NSString *newFecha = nil;
    if ( ([NSDateFormatter getDateFromString:strFecha withFormat:frmtFinal]) == nil )
    {
        NSDate *dateTemp = [NSDateFormatter getDateFromString:strFecha withFormat:frmtInicial];
        newFecha = [NSDateFormatter getStringFromDate:dateTemp withFormat:frmtFinal];
    } else
        newFecha = strFecha;
    
    return newFecha;
}


@end
