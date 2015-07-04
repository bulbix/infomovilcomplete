//
//  EditarPaso2ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 08/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface EditarPaso2ViewController : InfomovilViewController <UIScrollViewDelegate, UITextFieldDelegate, AlertViewDelegate, WS_HandlerProtocol>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollDireccion;
@property (weak, nonatomic) IBOutlet UITextField *txtCalle;
@property (weak, nonatomic) IBOutlet UITextField *txtColonia;
@property (weak, nonatomic) IBOutlet UITextField *txtPoblacion;
@property (weak, nonatomic) IBOutlet UITextField *txtCiudad;
@property (weak, nonatomic) IBOutlet UITextField *txtEstado;
@property (weak, nonatomic) IBOutlet UITextField *txtPais;
@property (weak, nonatomic) IBOutlet UITextField *txtCodigoPostal;
@property (nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *labelDireccion1;
@property (weak, nonatomic) IBOutlet UILabel *labelDireccion2;
@property (weak, nonatomic) IBOutlet UILabel *labelDireccion3;
@property (weak, nonatomic) IBOutlet UILabel *labelCiudad;
@property (weak, nonatomic) IBOutlet UILabel *labelEstado;
@property (weak, nonatomic) IBOutlet UILabel *labelPais;
@property (weak, nonatomic) IBOutlet UILabel *labelCodigoPostal;
@property (weak, nonatomic) IBOutlet UIButton *btnBorra;

@property (nonatomic, strong) NSMutableArray *diccionarioDireccion;
- (IBAction)borrarDireccion:(id)sender;

@end
