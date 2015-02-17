//
//  VisitasModel.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 11/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitasModel : NSObject

@property (nonatomic, strong) NSString *descripcion;
@property (nonatomic, strong) NSString *fecha;
@property (nonatomic) NSInteger visitas;
@property (nonatomic) NSInteger dia;

@end
