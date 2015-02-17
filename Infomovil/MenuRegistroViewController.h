//
//  MenuRegistroViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 12/02/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//


#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"
#import "SeleccionaPaisProtocol.h"
#import "CRProductTour.h"

@interface MenuRegistroViewController : InfomovilViewController <UIScrollViewDelegate, UITextFieldDelegate, AlertViewDelegate, WS_HandlerProtocol,SeleccionaPaisProtocol> {
    CRProductTour *productTourView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
//@property (weak, nonatomic) IBOutlet UITextField *txtNumero;
//@property (weak, nonatomic) IBOutlet UITextField *txtContrasena;

//@property (strong, nonatomic) IBOutlet UITextField *labelPais;
//@property (strong, nonatomic) IBOutlet UITextField *labelCodigoPais;
//@property (strong, nonatomic) IBOutlet UIButton *botnSeleccionaPais;
//@property (strong, nonatomic) IBOutlet UITextField *casillaMovil;
//@property (strong, nonatomic) IBOutlet UIView *vistaPais;
//@property (weak, nonatomic) IBOutlet UILabel *labelNumeroMovil;

//@property (strong, nonatomic) IBOutlet UILabel *label1;
//@property (strong, nonatomic) IBOutlet UILabel *label2;
//@property (strong, nonatomic) IBOutlet UILabel *label3;
//@property (strong, nonatomic) IBOutlet UILabel *label4;
//@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UIButton *boton;
//@property (strong, nonatomic) IBOutlet UILabel *label6;
//@property (strong, nonatomic) IBOutlet UITextField *txtContrasenaConfirmar;
//@property (weak, nonatomic) IBOutlet UILabel *labelCodigo;
//@property (weak, nonatomic) IBOutlet UITextField *txtCodigo;


- (IBAction)verificarNombre:(UIButton *)sender;
//- (IBAction)seleccionaCodigoPais:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *msjRegistrarConFacebook;








@property (weak, nonatomic) IBOutlet UIButton *llamarCrearCuenta;
- (IBAction)llamarCrearCuentaAct:(id)sender;

@end
