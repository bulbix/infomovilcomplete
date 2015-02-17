//
//  CrearPaso1ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "AlertView.h"

@interface CrearPaso1ViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate,AlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *arregloCampos;
@property (weak, nonatomic) IBOutlet UITableView *tablaEditar;

@end
