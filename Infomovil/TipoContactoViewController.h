//
//  TipoContactoViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 02/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface TipoContactoViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablaContacto;
@end
