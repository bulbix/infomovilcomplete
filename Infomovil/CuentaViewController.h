//
//  CuentaViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"
#import <StoreKit/StoreKit.h>
#import "CuentaViewProtocol.h"
#import "TablaDominioViewController.h"





@interface CuentaViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol, CuentaViewProtocol, SKProductsRequestDelegate, UIScrollViewDelegate, UITextFieldDelegate>{//SKPaymentTransactionObserver>{
    NSArray *validProducts;
    TablaDominioViewController *tablaDominio;
   
    __weak IBOutlet UITableView *tablaSitios;
    
}

@property (nonatomic) BOOL regresarAnterior;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selector;
// IRC Etiquitas: titulo, subtitulo, beneficios de la pantalla cuenta //
@property (strong, nonatomic) IBOutlet UILabel *tituloPlanPro;
@property (weak, nonatomic) IBOutlet UILabel *subtituloPlanPro;
@property (weak, nonatomic) IBOutlet UILabel *beneficiosPlanPro;
@property (weak, nonatomic) IBOutlet UIImageView *imgBeneficios;
@property (weak, nonatomic) IBOutlet UILabel *MensajePlanProComprado;

@property (weak, nonatomic) IBOutlet UIView *viewPlanProComprado;


@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroundBotones;



@property (strong, nonatomic) NSArray *arregloProductos;
@property (strong, nonatomic) PagoModel *pago;

// Views que contienen el plan pro y el dominio //
@property (weak, nonatomic) IBOutlet UIScrollView *vistaPlanPro;
@property (weak, nonatomic) IBOutlet UIScrollView *vistaDominio;
@property (weak, nonatomic) IBOutlet UIView *viewCompraPlanPro;




@property (strong, nonatomic) IBOutlet UIScrollView *scrollContenido;
@property (weak, nonatomic) IBOutlet UILabel *labelMisSitios;


//IRC Botones de compra //
@property (weak, nonatomic) IBOutlet UIButton *ComprarDominio;
- (IBAction)comprarDominioBtn:(id)sender;




@property (weak, nonatomic) IBOutlet UIButton *comprar1mes;
@property (weak, nonatomic) IBOutlet UIButton *comprar6meses;
@property (weak, nonatomic) IBOutlet UIButton *comprar12meses;

- (IBAction)comprar1mesBtn:(id)sender;
- (IBAction)comprar6mesesBtn:(id)sender;
- (IBAction)comprar12mesesBtn:(id)sender;



- (IBAction)tipoCuenta:(id)sender;


@end
