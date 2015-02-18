//
//  InicioRapidoViewController.h
//  Infomovil
//
//  Created by Sergio Sanchez on 11/18/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface InicioRapidoViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UITableView *tablaInicio;

@end
