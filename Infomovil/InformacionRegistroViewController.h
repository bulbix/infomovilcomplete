//
//  InformacionRegistroViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 24/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "SeleccionaPaisProtocol.h"
#import "WS_HandlerProtocol.h"

@interface InformacionRegistroViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate,AlertViewDelegate, UITextFieldDelegate,SeleccionaPaisProtocol,WS_HandlerProtocol>

//@property (nonatomic) BOOL modifico;
@property (nonatomic) BOOL seleccionoPais;

@property (weak, nonatomic) IBOutlet UITableView *tabla;

@property (weak, nonatomic) IBOutlet UIButton *botonEmpresa;
@property (weak, nonatomic) IBOutlet UIButton *botonIndividual;

- (IBAction)esEmpresa:(id)sender;
- (IBAction)esIndividual:(id)sender;

@end
