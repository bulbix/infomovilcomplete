//
//  MenuPasosViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface MenuPasosViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol>

@property (weak, nonatomic) IBOutlet UIButton *botonFondo;
@property (weak, nonatomic) IBOutlet UIButton *botonCrear;
@property (weak, nonatomic) IBOutlet UIButton *botonPublicar;
@property (strong, nonatomic) IBOutlet UILabel *dominio;
@property (strong, nonatomic) IBOutlet UIButton *botonEjemplo;

- (IBAction)elegirFondo:(UIButton *)sender;
- (IBAction)crearEditar:(UIButton *)sender;
- (IBAction)nombrar:(UIButton *)sender;
- (IBAction)publicar:(UIButton *)sender;
- (IBAction)verEjemplo:(UIButton *)sender;
- (void) pantallaAcomodaPublicar;

@end
