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

@property (weak, nonatomic) IBOutlet UIButton *recordarbtn;

- (IBAction)iniciarSesion:(id)sender;
- (IBAction)cambiarPassword:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordarLogin1;
- (IBAction)recordarLoginAct1:(id)sender;
- (IBAction)recordarLoginAct2:(id)sender;

@end
