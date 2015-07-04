//
//  EliminarCuentaViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 25/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface EliminarCuentaViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, WS_HandlerProtocol, AlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *vistaCombo;
@property (weak, nonatomic) IBOutlet UITableView *tablaOption;
@property (weak, nonatomic) IBOutlet UILabel *labelOpcionSeleccionada;
@property (weak, nonatomic) IBOutlet UITextView *textEspecifica;
@property (weak, nonatomic) IBOutlet UILabel *labelEspecifica;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollEliminarCuenta;
@property (weak, nonatomic) IBOutlet UILabel *label;




@property (weak, nonatomic) IBOutlet UIImageView *imgSelecciona;
@property (weak, nonatomic) IBOutlet UIButton *btnEligeOpcion;


@property (weak, nonatomic) IBOutlet UILabel *label2;
// Si se logueo con facebook y quiere eliminar su cuenta //
@property (weak, nonatomic) IBOutlet UIButton *olvidasteContrasena;
- (IBAction)olvidasteContraseñaAct:(id)sender;

- (IBAction)mostrarOption:(UIButton *)sender;
@end
