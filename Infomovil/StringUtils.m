//
//  StringUtils.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "StringUtils.h"
#import "STEncryptorDES.h"
#import "NSData+Base64.h"
#import "ItemsDominio.h"
#import "AppDelegate.h"


#define EncodingActual NSASCIIStringEncoding

@implementation StringUtils

+(NSString *) pathForDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    return documentsPath;
}

+ (NSString *) hexFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0), (int)((CGColorGetComponents(color.CGColor))[1]*255.0), (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (BOOL) deleteFile {
    BOOL exito = NO;
    NSString *filePath = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:@"datos.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = Nil;
    [fileManager removeItemAtPath:filePath error:&error];
    if (error == Nil) {
        exito = YES;
    }
#if DEBUG
    else {
        NSLog(@"El error es %@", [error localizedDescription]);
    }
#endif
    return exito;
}

+ (NSString *)encriptar:(NSString *)texto conToken:(NSString *)token {
 
#ifdef _DEBUG
	NSLog(@"Texto: %@, token: %@",texto,token);
#endif
    NSData *valueData = [texto dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSData *keyData = [token dataUsingEncoding:NSUTF8StringEncoding];
	Byte iv [] = {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08};
	NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
	NSData *encryptedData = [STEncryptorDES encryptData:valueData key:keyData iv:ivData];
#ifdef _DEBUG
	NSLog(@"encrypted : %@", [encryptedData base64EncodedString]);
#endif
    return [encryptedData base64EncodedString];
}

+ (NSString *)desEncriptar:(NSString *)texto conToken:(NSString *)token {
    if (token == nil || [[token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Error token" object:Nil];
        return nil;
    }
    NSData *valueData = [NSData dataFromBase64String:texto];
#ifdef _DEBUG
	NSLog(@"Texto: %@, token: %@",texto,token);
#endif
	NSData *keyData = [token dataUsingEncoding:NSUTF8StringEncoding];
	Byte iv [] = {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08};
	NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
	NSData *decryptedData = [STEncryptorDES decryptData:valueData key:keyData iv:ivData];
#ifdef _DEBUG
	NSLog(@"decrypted : %@", [[NSString alloc] initWithData:decryptedData encoding:NSASCIIStringEncoding]);
#endif
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+ (NSString *) eliminarAcentos: (NSString *)texto {
    NSMutableString *stringAux = [[NSMutableString alloc] initWithString:texto];
    [stringAux replaceOccurrencesOfString:@"á" withString:@"a" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringAux length])];
    [stringAux replaceOccurrencesOfString:@"é" withString:@"e" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringAux length])];
    [stringAux replaceOccurrencesOfString:@"í" withString:@"i" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringAux length])];
    [stringAux replaceOccurrencesOfString:@"ó" withString:@"o" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringAux length])];
    [stringAux replaceOccurrencesOfString:@"ú" withString:@"u" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringAux length])];
    
    return stringAux;
}

+(void) deleteResourcesWithExtension:(NSString *)ext {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:ext]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

+ (NSMutableArray *)ordenarItems:(NSMutableArray *)items {
    NSArray *arregloTitulos = @[NSLocalizedStringFromTable(@"nombreEmpresa", @"Spanish",@" "), NSLocalizedStringFromTable(@"logo",@"Spanish", @" "),
        NSLocalizedStringFromTable(@"descripcionCorta", @"Spanish",@" "),
        NSLocalizedStringFromTable(@"contacto", @"Spanish",@" "),
        NSLocalizedStringFromTable(@"mapa",@"Spanish", @" "),
        NSLocalizedStringFromTable(@"video", @"Spanish",@" "),
        NSLocalizedStringFromTable(@"promociones", @"Spanish",@" "),
        NSLocalizedStringFromTable(@"galeriaImagenes",@"Spanish", @" "),
        NSLocalizedStringFromTable(@"perfil",@"Spanish", @" "),
        NSLocalizedStringFromTable(@"direccion", @"Spanish",@" "),
        NSLocalizedStringFromTable(@"informacionAdicional", @"Spanish",@" ")];
    
    NSArray *arregloIdioma = @[NSLocalizedString(@"nombreEmpresa", @" "),
        NSLocalizedString(@"logo", @" "),
        NSLocalizedString(@"descripcionCorta", @" "),
        NSLocalizedString(@"contacto", @" "),
        NSLocalizedString(@"mapa", @" "),
        NSLocalizedString(@"video", @" "),
        NSLocalizedString(@"promociones", @" "),
        NSLocalizedString(@"galeriaImagenes", @" "),
        NSLocalizedString(@"perfil", @" "),
        NSLocalizedString(@"direccion", @" "),
        NSLocalizedString(@"informacionAdicional", @" ")];
     NSMutableArray *arregloItemsAux = [[NSMutableArray alloc] init];
    if (items != nil) {
    NSMutableArray *arregloItems = items;
        
    for (int i = 0; i < [arregloTitulos count]; i++) {
        NSString *stringAux = [StringUtils eliminarAcentos:[arregloTitulos objectAtIndex:i]];
        for (int j = 0; j < [arregloItems count]; j++) {
            ItemsDominio *itemDominioAux = [arregloItems objectAtIndex:j];
       
            if (([[stringAux uppercaseString] isEqualToString:[itemDominioAux descripcionItem]]) || ([stringAux isEqualToString:[itemDominioAux descripcionItem]])) {
                [itemDominioAux setDescripcionItem:[arregloTitulos objectAtIndex:i]];
                [itemDominioAux setDescripcionIdioma:[arregloIdioma objectAtIndex:i]];
                [arregloItemsAux addObject:itemDominioAux];
            }
        }
    }
        [arregloItemsAux insertObject:[[ItemsDominio alloc] initWithDescripcion:NSLocalizedString(@"perfinNegocioProfesion", Nil) andStatus:1] atIndex:2];
    }
    
    return arregloItemsAux;
}

+ (void) terminarSession {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    [StringUtils deleteResourcesWithExtension:@"jpg"];
    [StringUtils deleteFile];
    [datosUsuario eliminarDatos];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = NO;
}

+ (NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length]) % [letters length]]];
    }
    
    return randomString;
}

@end
