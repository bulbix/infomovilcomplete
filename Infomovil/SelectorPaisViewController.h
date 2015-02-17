//
//  SelectorPaisViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 10/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "ContactoPaso2ViewController.h"
#import "PublicarViewController.h"
#import "SeleccionaPaisProtocol.h"

@interface SelectorPaisViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablaPais;
@property (nonatomic, strong) ContactoPaso2ViewController *contactoController;
@property (nonatomic, strong) PublicarViewController *publicarController;
@property (nonatomic, strong) id<SeleccionaPaisProtocol> seleccionaDelegate;
@property (nonatomic, strong) NSString *nombreTituloVista;


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
