//
//  NSMutableDataUtiles.h
//  MainMenu
//
//  Created by Ignaki Dominguez Martinez on 13/04/11.
//  Copyright 2011 BAZ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableData (NSMutableDataUtiles)

- (void)replaceOccurrencesOfData:(NSData *)target withData:(NSData *)replacement;
- (void)changeEncoding:(NSStringEncoding)codifOriginal toEncoding:(NSStringEncoding)codiNueva;
- (void)decodificaHtmlMutableData;

@end
