//
//  ItemsDominio.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 08/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsDominio : NSObject <NSCoding>

@property (nonatomic, strong) NSString *descripcionItem;
@property (nonatomic, strong) NSString *descripcionIdioma;
@property (nonatomic) NSInteger estatus;

-(id) initWithDescripcion:(NSString *)descripcion andStatus:(NSInteger)status;

@end
