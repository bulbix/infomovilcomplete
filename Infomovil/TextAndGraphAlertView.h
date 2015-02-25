//
//  TextAndGraphAlertView.h
//  Infomovil
//
//  Created by German Azahel Velazquez Garcia on 8/25/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "AlertView.h"

@interface TextAndGraphAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;
@property (weak, nonatomic) IBOutlet UILabel *lblTexto1;
@property (weak, nonatomic) IBOutlet UILabel *lblTexto2;
@property (weak, nonatomic) IBOutlet UILabel *lblTexto3;
@property (weak, nonatomic) IBOutlet UIButton *presionarAceptarBtn;


+(id)initInstruccionesContacto;
- (void)show;
- (void)hide;

@end
