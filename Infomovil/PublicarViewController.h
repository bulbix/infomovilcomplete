//
//  PublicarViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

typedef enum {
    WSOperacionNombrar,
    WSOperacionPublicar
}WSOperacion;

typedef enum {
    RespuestaStatusExito,
    RespuestaStatusPendiente,
    RespuestaStatusExistente,
    RespuestaStatusError
}RespuestaEstatus;

@interface PublicarViewController : InfomovilViewController <WS_HandlerProtocol, AlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *boton;

@property (weak, nonatomic) IBOutlet UILabel *labelNombre;
@property (weak, nonatomic) IBOutlet UILabel *labelDir1;
@property (weak, nonatomic) IBOutlet UILabel *labelDir2;
@property (weak, nonatomic) IBOutlet UILabel *labelPais;
@property (weak, nonatomic) IBOutlet UILabel *labelPaisSeleccionado;

@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtDir1;
@property (weak, nonatomic) IBOutlet UITextField *txtDir2;

@property (weak, nonatomic) IBOutlet UIImageView *imgBull;

@property (strong, nonatomic) IBOutlet UIView *vistaCombo;
@property (weak, nonatomic) IBOutlet UIButton *botonCombo;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic,strong) NSString *nPais;

@property (nonatomic, strong) DatosUsuario *datos;

@property (nonatomic, strong) NSMutableArray *arregloDominios;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;

- (IBAction)mostrarOpcion:(UIButton *)sender;

- (IBAction)confirmarDominio:(id)sender;
@end
  