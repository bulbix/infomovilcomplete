//
//  InformacionAdicionalViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface InformacionAdicionalViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate, AlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *arregloInformacion;
@property (strong, nonatomic) IBOutlet UIView *vistaInformacion;
@property (weak, nonatomic) IBOutlet UITableView *tablaInformacion;
@property (weak, nonatomic) IBOutlet UILabel *imgBull1;
@property (weak, nonatomic) IBOutlet UILabel *imgBull2;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *labelTexto1;

@end
