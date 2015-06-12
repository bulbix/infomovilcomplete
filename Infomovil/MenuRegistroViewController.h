//
//  MenuRegistroViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 12/02/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//


#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"
//#import "CRProductTour.h"

@interface MenuRegistroViewController : InfomovilViewController <UIScrollViewDelegate, UITextFieldDelegate, AlertViewDelegate, WS_HandlerProtocol> {
  
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *raya1;
@property (weak, nonatomic) IBOutlet UILabel *o;
@property (weak, nonatomic) IBOutlet UILabel *raya2;

// Nuevo Registro //
@property (weak, nonatomic) IBOutlet UIButton *btnRegistrar;
@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtContrasena;
@property (weak, nonatomic) IBOutlet UITextField *txtContrasenaConfirmar;
@property (weak, nonatomic) IBOutlet UILabel *msjRegistrarConFacebook;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogoInfo;




@property (weak, nonatomic) IBOutlet UILabel *leyenda1;
@property (weak, nonatomic) IBOutlet UIButton *leyenda2;
@property (weak, nonatomic) IBOutlet UILabel *leyenda3;
@property (weak, nonatomic) IBOutlet UIButton *leyenda4;
@property (weak, nonatomic) IBOutlet UILabel *leyenda5;


- (IBAction)mostrarTerminos:(id)sender;
- (IBAction)mostrarCondiciones:(id)sender;
- (IBAction)verificarNombre:(UIButton *)sender;

@end
