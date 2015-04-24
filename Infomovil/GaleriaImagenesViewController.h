//
//  GaleriaImagenesViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"
typedef enum {
    GaleriaImagenesAgregar,
    GaleriaImagenesEditar
}GaleriaImagenesOperacion;


@interface GaleriaImagenesViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate, AlertViewDelegate, WS_HandlerProtocol>

@property (weak, nonatomic) IBOutlet UIView *vistaInfo;
@property (nonatomic) NSInteger indiceItem;
@property (weak, nonatomic) IBOutlet UITableView *tablaGaleria;
@property (weak, nonatomic) IBOutlet UILabel *labelNumeroImagenes;
@property (weak, nonatomic) IBOutlet UILabel *labelImagenesMensaje;
@property (weak, nonatomic) IBOutlet UILabel *labelImagenesMensaje2;
@property (strong, nonatomic) IBOutlet UILabel *vineta1;
@property (strong, nonatomic) IBOutlet UILabel *vineta2;
@property (strong, nonatomic) IBOutlet UILabel *vineta3;

@property (nonatomic, strong) NSString *urlImagen;

@end
