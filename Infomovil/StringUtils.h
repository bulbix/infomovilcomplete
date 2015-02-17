//
//  StringUtils.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (NSString *) pathForDocumentsDirectory;
+ (NSString *) hexFromUIColor:(UIColor *)color;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (BOOL) deleteFile;

+ (NSString *)encriptar:(NSString *)texto conToken:(NSString *)token;
+ (NSString *)desEncriptar:(NSString *)texto conToken:(NSString *)token;

+ (NSString *) eliminarAcentos: (NSString *)texto;

+ (void) deleteResourcesWithExtension:(NSString *)ext;

+ (NSMutableArray *)ordenarItems:(NSMutableArray *)arregloItems;

+ (void) terminarSession;

+ (NSString *) randomStringWithLength:(int) len;

@end
