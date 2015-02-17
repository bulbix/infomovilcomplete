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
@property (weak, nonatomic) IBOutlet UITextField *nombreDominio;
@property (weak, nonatomic) IBOutlet UILabel *labelEstatusDominio;
@property (weak, nonatomic) IBOutlet UILabel *labelDominio;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIButton *boton;


- (IBAction)verificarDominio:(UIButton *)sender;
@end
