//
//  NombraCompraDominio.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/4/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"


@interface NombraCompraDominio : InfomovilViewController<AlertViewDelegate, UITextFieldDelegate, WS_HandlerProtocol>
{
    BOOL existeDominio;
    SKProduct *productoElegido;
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}
@property (weak, nonatomic) IBOutlet UILabel *etiquetaNombraSitio;
@property (weak, nonatomic) IBOutlet UILabel *etiqutawww;
@property (weak, nonatomic) IBOutlet UITextField *txtNombreSitio;
@property (weak, nonatomic) IBOutlet UILabel *etiquetatel;
@property (weak, nonatomic) IBOutlet UIButton *btnBuscar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollNombrar;
@property (nonatomic, strong) AlertView *alertActivity;
@property (nonatomic, assign) int operacionWS;

@property (nonatomic, strong) NSMutableArray *arregloDominios;

// POPUP //
@property (weak, nonatomic) IBOutlet UIView *viewPopUp;
@property (weak, nonatomic) IBOutlet UIView *viewCenterPopUp;
@property (weak, nonatomic) IBOutlet UILabel *dominioPopUp;
@property (weak, nonatomic) IBOutlet UILabel *msjPopUp;
@property (weak, nonatomic) IBOutlet UIButton *comprarPopUp;
@property (weak, nonatomic) IBOutlet UIButton *cerrarPopUp;
- (IBAction)comprarPopUpAct:(id)sender;
- (IBAction)cerrarPupUpAct:(id)sender;




- (IBAction)buscar:(id)sender;












@end
