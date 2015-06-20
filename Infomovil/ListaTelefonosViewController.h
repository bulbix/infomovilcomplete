//
//  ListaTelefonosViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

typedef enum {
    ContactosOperacionEditar,
    ContactosOperacionAgregar,
    ContactosOperacionEliminar
}ContactosOperacion;

@interface ListaTelefonosViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate, AlertViewDelegate, WS_HandlerProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tablaContactos;
@property (weak, nonatomic) IBOutlet UIView *vistaInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelEditar;
@property (weak, nonatomic) IBOutlet UILabel *labelTelefono;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelAgregaDatos;
@property (weak, nonatomic) IBOutlet UILabel *labelBotonesGrandes;
@property (nonatomic, assign) NSInteger indiceSeleccionado;

- (IBAction)llamanosAct:(id)sender;
- (IBAction)ContactanosAct:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *btnInstrucciones;
- (IBAction)muestraInstrucciones:(id)sender;

@end
