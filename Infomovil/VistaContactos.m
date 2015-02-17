//
//  VistaContactos.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 21/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "VistaContactos.h"

@implementation VistaContactos

@synthesize labelDato, labelDescripcion, habilitado;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andTelephone:(NSString *)noTelefonico andDescription:(NSString *)descripcion {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.layer.cornerRadius = 5;
        
        labelDato = [[UILabel alloc] initWithFrame:CGRectMake(31, 5, 96, 21)];
        [labelDato setBackgroundColor:[UIColor whiteColor]];
        [labelDato setText:noTelefonico];
        [self addSubview:labelDato];
        
        labelDescripcion = [[UILabel alloc] initWithFrame:CGRectMake(31, 34, 139, 21)];
        [labelDescripcion setBackgroundColor:[UIColor whiteColor]];
        [labelDescripcion setText:descripcion];
        [self addSubview:labelDescripcion];
        
        habilitado = [[UISwitch alloc] initWithFrame:CGRectMake(216, 16, 51, 31)];
        [self addSubview:habilitado];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
