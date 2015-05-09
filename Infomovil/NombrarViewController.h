//
//  NombrarViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface NombrarViewController : InfomovilViewController <AlertViewDelegate, UITextFieldDelegate, WS_HandlerProtocol>
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

//MBC
@property (weak, nonatomic) IBOutlet UILabel *labelW;
@property (weak, nonatomic) IBOutlet UITextField *nombreDominio;
@property (weak, nonatomic) IBOutlet UILabel *labelTel;
@property (weak, nonatomic) IBOutlet UILabel *labelEstatusDominio;
@property (weak, nonatomic) IBOutlet UILabel *labelDominio;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIButton *boton;
@property (weak, nonatomic) IBOutlet UIView *popUpCenter;

@property (weak, nonatomic) IBOutlet UIButton *btnPublicar;

@property (nonatomic, strong) DatosUsuario *datos;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UILabel *estaDisponibleBtn;
@property (weak, nonatomic) IBOutlet UILabel *dominioBtn;

@property (weak, nonatomic) IBOutlet UIButton *cerrarPopUp;
- (IBAction)cerrarPopUpAction:(id)sender;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (IBAction)verificarDominio:(UIButton *)sender;
- (IBAction)publicarAction:(id)sender;
@end
