//
//  ListaHorarios.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 11/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListaHorarios : NSObject <NSCoding>

@property (nonatomic, strong) NSString *dia;
@property (nonatomic, strong) NSString *inicio;
@property (nonatomic, strong) NSString *cierre;
@property (nonatomic) BOOL editado;

@end
