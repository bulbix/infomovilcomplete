//
//  MainViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface MainViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol, UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) AlertView *alerta;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollLogin;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *boton;

@property (weak, nonatomic) IBOutlet UILabel *raya1;
@property (weak, nonatomic) IBOutlet UILabel *o;
@property (weak, nonatomic) IBOutlet UILabel *raya2;

@property (weak, nonatomic) IBOutlet UIButton *btnOlvidePass;
// LOGIN nuevo//

@property (weak, nonatomic) IBOutlet UIButton *btnRegistrate;

@property (weak, nonatomic) IBOutlet UIButton *recordarbtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;

- (IBAction)iniciarSesion:(id)sender;
- (IBAction)cambiarPassword:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordarLogin1;



@property (weak, nonatomic) IBOutlet UILabel *leyenda1;
@property (weak, nonatomic) IBOutlet UIButton *leyenda2;
@property (weak, nonatomic) IBOutlet UILabel *leyenda3;
@property (weak, nonatomic) IBOutlet UIButton *leyenda4;
@property (weak, nonatomic) IBOutlet UILabel *leyenda5;





@end
