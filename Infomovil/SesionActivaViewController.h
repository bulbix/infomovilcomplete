//
//  SesionActivaViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 4/15/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"


@interface SesionActivaViewController : InfomovilViewController<AlertViewDelegate,WS_HandlerProtocol,UINavigationControllerDelegate, UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnReintentarConexion;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;
@property (weak, nonatomic) IBOutlet UIButton *btnSesionOtraCuenta;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@end
