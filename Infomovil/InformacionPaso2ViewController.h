//
//  InformacionPaso2ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

typedef enum {
    InfoAdicionalOperacionAgregar,
    InfoAdicionalOperacionEditar
}InfoAdicionalOperacion;

@interface InformacionPaso2ViewController : InfomovilViewController <UITextViewDelegate, UITextFieldDelegate, AlertViewDelegate, WS_HandlerProtocol,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtTitulo;
@property (weak, nonatomic) IBOutlet UITextView *txtInfo;
//@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (nonatomic) InfoAdicionalOperacion operacionInformacion;
@property (nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *btnEliminar;
@property (weak, nonatomic) IBOutlet UILabel *labelAgregarTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelInformacionAdicional;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;


- (IBAction)eliminarAdicional:(UIButton *)sender;

@end
