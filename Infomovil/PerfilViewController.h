//
//  PerfilViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface PerfilViewController : InfomovilViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tablaPerfil;

@end
