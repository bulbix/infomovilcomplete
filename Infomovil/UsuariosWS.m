//
//  UsuariosWS.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 19/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "UsuariosWS.h"
#import "AppDelegate.h"

@implementation UsuariosWS

-(void) crearUsuario {
    NSDictionary *diccionario;
    diccionario = [[NSDictionary alloc] initWithObjects:@[@"nombre", @"Otro"] forKeys:@[@"typ-nombre", @"typ-otro"]];
}

@end
