//
//  SeleccionaPaisProtocol.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 24/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SeleccionaPaisProtocol <NSObject>

-(void) guardaPais:(NSString *)pais yCodigo:(NSString *)codigoPais;

@end
