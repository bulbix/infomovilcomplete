//
//  NSDateUtiles.h
//  CategoriasBaz
//
//  Created by Ignaki Dominguez on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface  NSDate (NSDateUtiles) 

+ (int)getHora;
+ (int)getHoraFromDate:(NSDate*)fecha;
// Comparacion
+ (BOOL)esMismaFecha:(NSDate *)referencia queFecha:(NSDate *)fecha;
+ (BOOL)esHoyLaFecha:(NSDate *)fecha;

@end
