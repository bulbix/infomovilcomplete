//
//  SesionIniciadaViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 4/14/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface SesionIniciadaViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol>



@property (weak, nonatomic) IBOutlet UIButton *btnReintentar;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;
@property (weak, nonatomic) IBOutlet UIButton *btnbtnOtraCuenta;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;












@end
