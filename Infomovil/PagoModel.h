//
//  PagoModel.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 10/09/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PagoModel : NSObject

@property (nonatomic, strong) NSString *plan;
@property (nonatomic, strong) NSString *medioPago;
@property (nonatomic, strong) NSString *titulo;
@property (nonatomic, strong) NSString *montoBruto;
@property (nonatomic, strong) NSString *comision;
@property (nonatomic, strong) NSString *montoReal;
@property (nonatomic) NSUInteger pagoId;
@property (nonatomic, strong) NSString *statusPago;
@property (nonatomic, strong) NSString *codigoCobro;
@property (nonatomic, strong) NSString *referencia;
@property (nonatomic, strong) NSString *tipoCompra;


@end
