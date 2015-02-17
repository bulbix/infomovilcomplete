//
//  VistaContactos.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 21/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VistaContactos : UIView

@property(nonatomic, strong) UILabel *labelDato;
@property(nonatomic, strong) UILabel *labelDescripcion;
@property(nonatomic, strong) UISwitch *habilitado;

-(id)initWithFrame:(CGRect)frame andTelephone:(NSString *)noTelefonico andDescription:(NSString *)descripcion;

@end
