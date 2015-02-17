//
//  ContactoPaso2ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 15/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "ListaTelefonosViewController.h"
#import "Contacto.h"
#import "WS_HandlerProtocol.h"

@interface ContactoPaso2ViewController : InfomovilViewController <UITextViewDelegate, UITextFieldDelegate, AlertViewDelegate, WS_HandlerProtocol>


//@property (nonatomic) BOOL modifico;
@property (nonatomic) BOOL seleccionoPais;

@property (weak, nonatomic) IBOutlet UILabel *labelTipoContacto;
@property (nonatomic, strong) NSDictionary *tipoContacto;
@property (weak, nonatomic) IBOutlet UITextView *txtDescripcion;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVista;
//@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtLada;
@property (weak, nonatomic) IBOutlet UILabel *labelNumeroTelefonico;
@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;
@property (weak, nonatomic) IBOutlet UILabel *labelDescripcion;
@property (weak, nonatomic) IBOutlet UIButton *btnEliminar;
@property (weak, nonatomic) IBOutlet UIView *vistaPais;
@property (weak, nonatomic) IBOutlet UILabel *labelPais;
@property (weak, nonatomic) IBOutlet UILabel *labelCodigo;
@property (weak, nonatomic) IBOutlet UIImageView *imagenTipoContacto;
@property (weak, nonatomic) IBOutlet UIButton *btnSeleccionarPais;
@property ContactosOperacion contactosOperacion;
@property (nonatomic, strong) Contacto *contactoSeleccionado;
@property (weak, nonatomic) IBOutlet UIImageView *imagenSiguiente;
@property (nonatomic) NSInteger indexContacto;
@property (weak, nonatomic) IBOutlet UILabel *labelInfoMexico;

@property NSInteger opcionSeleccionada;

@property (strong, nonatomic) IBOutlet UITextField *casillaMovil;

- (IBAction)eliminarContacto:(UIButton *)sender;
- (IBAction)seleccionarCodigoPais:(UIButton *)sender;


@end
