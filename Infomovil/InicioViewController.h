//
//  InicioViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 22/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface InicioViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol>

@property (nonatomic, strong) AlertView *alerta;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *botonPruebalos;
@property (strong, nonatomic) IBOutlet UIButton *botonSesions;
@property (strong, nonatomic) IBOutlet UILabel *leyenda1;
@property (strong, nonatomic) IBOutlet UIButton *leyenda2;
@property (strong, nonatomic) IBOutlet UILabel *leyenda3;
@property (strong, nonatomic) IBOutlet UIButton *leyenda4;
@property (strong, nonatomic) IBOutlet UILabel *leyenda5;
@property (strong, nonatomic) IBOutlet UILabel *version;

@property (nonatomic, strong) DatosUsuario *datosUsuario;


- (IBAction)probarInfomovil:(UIButton *)sender;
- (IBAction)loguearInfomovil:(UIButton *)sender;
- (IBAction)mostrarTerminos:(id)sender;
- (IBAction)mostrarCondiciones:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *conoceMas;
@property (weak, nonatomic) IBOutlet UIButton *conoceMasPlay;
- (IBAction)conoceMasAct:(id)sender;
- (IBAction)conoceMasPlayAct:(id)sender;

@end

