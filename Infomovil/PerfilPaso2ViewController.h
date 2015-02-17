//
//  PerfilPaso2ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface PerfilPaso2ViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, AlertViewDelegate, UITextViewDelegate, WS_HandlerProtocol>

@property NSInteger index;
@property (nonatomic, strong) NSString *tituloPerfil;
@property (weak, nonatomic) IBOutlet UIScrollView *vistaPerfil;
@property (weak, nonatomic) IBOutlet UITextView *txtDescripcion;
//@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelComentario;
@property (weak, nonatomic) IBOutlet UIScrollView *vistaHorarios;
@property (weak, nonatomic) IBOutlet UITableView *tablaHorarios;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerHorarios;
@property (weak, nonatomic) IBOutlet UIView *vistaPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnEliminar;
@property (weak, nonatomic) IBOutlet UILabel *labelTituloHorarios;
@property (weak, nonatomic) IBOutlet UILabel *labelInformacion;

@property (strong, nonatomic) IBOutlet UIButton *btnEliminar2;

- (IBAction)seleccionarHorario:(UIBarButtonItem *)sender;
- (IBAction)eliminarPerfil:(UIButton *)sender;

- (IBAction)eliminarHorario:(UIButton *)sender;

@end
