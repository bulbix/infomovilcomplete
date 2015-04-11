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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *diccionario;
    if (appDelegate.existeSesion) {
        diccionario = [[NSDictionary alloc] initWithObjects:@[@"nombre", @"Otro"] forKeys:@[@"typ-nombre", @"typ-otro"]];
      //  NSString *strSoap = [self creaSoapData:diccionario ordenado:NO strAtribute:Nil];
       
    }
    else {
        DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
        NSArray *arregloDatos = @[datosUsuario.emailUsuario, @"primary-user", @"default-primary", datosUsuario.passwordUsuario, datosUsuario.emailUsuario];
        NSArray *arregloLlaves = @[@"typ:userName", @"typ:type", @"typ:permissions", @"typ:password", @"typ:emailAddress"];
        diccionario = [[NSDictionary alloc] initWithObjects:arregloDatos forKeys:arregloLlaves];
        
    }
}

@end
