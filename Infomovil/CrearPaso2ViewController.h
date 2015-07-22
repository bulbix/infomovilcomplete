//
//  CrearPaso2ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "AlertView.h"
#import "PECropViewController.h"
#import "WS_HandlerProtocol.h"

@interface CrearPaso2ViewController : InfomovilViewController <UINavigationControllerDelegate, UITextFieldDelegate, AlertViewDelegate, UITextViewDelegate, WS_HandlerProtocol,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollEmpresa;
@property (strong, nonatomic) IBOutlet UIView *vistaEmpresa;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *tituloPaso;
@property (weak, nonatomic) IBOutlet UILabel *labelInstruccion;
@property (weak, nonatomic) IBOutlet UITextField *textEmpresa;
@property (weak, nonatomic) IBOutlet UITextView *txtDescripcion;
@property (strong, nonatomic) IBOutlet UIView *vista;
@property (weak, nonatomic) IBOutlet UIButton *botonEliminar;

- (IBAction)borrar:(UIButton *)sender;

@end
