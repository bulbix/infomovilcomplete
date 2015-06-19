//
//  EnviarPedacitoCodigoViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/18/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"


@interface EnviarPedacitoCodigoViewController : InfomovilViewController<AlertViewDelegate, BSKeyboardControlsDelegate>


@property (weak, nonatomic) IBOutlet UILabel *tituloMoviliza;
@property (weak, nonatomic) IBOutlet UILabel *textoMoviliza;
@property (weak, nonatomic) IBOutlet UIButton *btnMovilizaImg;
@property (weak, nonatomic) IBOutlet UIButton *btnMovilizaText;

//@property (nonatomic, strong) DatosUsuario *datosUsuario;


- (IBAction)movilizaImgAct:(id)sender;

- (IBAction)movilizaTextAct:(id)sender;














@end
