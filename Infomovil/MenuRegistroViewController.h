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

@property (strong, nonatomic) IBOutlet UIButton *boton;

@property (weak, nonatomic) IBOutlet UILabel *raya1;
@property (weak, nonatomic) IBOutlet UILabel *o;
@property (weak, nonatomic) IBOutlet UILabel *raya2;


- (IBAction)verificarNombre:(UIButton *)sender;
//- (IBAction)seleccionaCodigoPais:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *msjRegistrarConFacebook;
@property (weak, nonatomic) IBOutlet UIButton *llamarCrearCuenta;
- (IBAction)llamarCrearCuentaAct:(id)sender;

@end
