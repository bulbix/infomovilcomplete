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
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIButton *boton;

@property (strong, nonatomic) IBOutlet UILabel *labelNombre;
@property (strong, nonatomic) IBOutlet UILabel *labelDir1;
@property (strong, nonatomic) IBOutlet UILabel *labelDir2;
@property (strong, nonatomic) IBOutlet UILabel *labelPais;
@property (strong, nonatomic) IBOutlet UILabel *labelPaisSeleccionado;

@property (strong, nonatomic) IBOutlet UITextField *txtNombre;
@property (strong, nonatomic) IBOutlet UITextField *txtDir1;
@property (strong, nonatomic) IBOutlet UITextField *txtDir2;

@property (weak, nonatomic) IBOutlet UIImageView *imgBull;

@property (strong, nonatomic) IBOutlet UIView *vistaCombo;
@property (strong, nonatomic) IBOutlet UIButton *botonCombo;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic) NSString *nPais;

@property (nonatomic, strong) DatosUsuario *datos;


- (IBAction)mostrarOpcion:(UIButton *)sender;

- (IBAction)confirmarDominio:(id)sender;
@end
