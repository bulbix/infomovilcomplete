//
//  PagoModel.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 10/09/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "PagoModel.h"

@implementation PagoModel

-(id) init {
    self = [super init];
    if (self) {
        _plan = @"";
        _medioPago = @"APP STORE";
        _titulo = @"";
        _montoBruto = @"";
        _comision = @"";
        _montoReal = @"";
        _pagoId = 0;
        _statusPago = @"";
        _codigoCobro = @"";
        _referencia = @"";
        _tipoCompra = @"";
    }
    return self;
}

@end
