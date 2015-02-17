//
//  NSDateUtiles.m
//  CategoriasBaz
//
//  Created by Ignaki Dominguez on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDateUtiles.h"


@implementation NSDate (NSDateUtiles)

/**
 *	Obtiene el componente de hora de la fecha actual
 *	@return numero de hora
 */
+ (int)getHora
{
	NSDate *date = [[NSDate alloc] init];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *compo = [calendar components:NSHourCalendarUnit fromDate:date];
	
	[date release];
    [calendar release];
	
	return compo.hour;
}

/**
 *	Obtiene el componente de hora de la fecha dada
 *	@param fecha: NSDate del cual se desae extraer la hora
 *	@return numero de hora
 */
+ (int)getHoraFromDate:(NSDate*)fecha
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *compo = [calendar components:NSHourCalendarUnit fromDate:fecha];
	
    [calendar release];
	
	return compo.hour;
}

#pragma mark -
#pragma mark Metodos de Comparacion
/**
 *	Metodo que compara la fechas para saber si es la misma fecha
 *	@param referencia: NSDate a la que se le hara la comparacion
 *	@param fecha: NSDate a comparar
 *	@return YES si es la misma fecha
 *			NO si es otro dia
 */
+ (BOOL)esMismaFecha:(NSDate *)referencia queFecha:(NSDate *)fecha
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *compDate = [calendar components:unitFlags fromDate:referencia toDate:fecha options:NSWrapCalendarComponents];
	
	[calendar release];
	return ([compDate day] == 0 && [compDate month] == 0 && [compDate year] == 0 );
}

/**
 *	Metodo que identifica si un NSDate tiene la fecha del dia de hoy
 *	@param fecha: NSDate a validar
 *	@return YES si contiene la fecha del dia
 *			NO si es una fecha distinta
 */
+ (BOOL)esHoyLaFecha:(NSDate *)fecha
{
	NSDate *fechaHoy = [[NSDate alloc] init];
	BOOL esHoy = [NSDate esMismaFecha:fechaHoy queFecha:fecha];
	[fechaHoy release];
	return esHoy;
}

@end
