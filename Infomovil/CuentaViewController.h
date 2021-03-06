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






@interface CuentaViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol, UIScrollViewDelegate, UITextFieldDelegate>{
    NSArray *validProducts;
  
}


@property (weak, nonatomic) IBOutlet UITableView *tablaSitios;
@property (nonatomic) BOOL regresarAnterior;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selector;
// IRC Etiquitas: titulo, subtitulo, beneficios de la pantalla cuenta //
@property (weak, nonatomic) IBOutlet UILabel *tituloPlanPro;
@property (weak, nonatomic) IBOutlet UILabel *subtituloPlanPro;
@property (weak, nonatomic) IBOutlet UILabel *beneficiosPlanPro;
@property (weak, nonatomic) IBOutlet UIImageView *imgBeneficios;
@property (weak, nonatomic) IBOutlet UILabel *MensajePlanProComprado;

@property (strong, nonatomic) IBOutlet UIView *viewPlanProComprado;
@property (weak, nonatomic) IBOutlet UIButton *conocerMasBeneficios;

@property (weak, nonatomic) IBOutlet UILabel *precioUno;
@property (weak, nonatomic) IBOutlet UILabel *precioDoce;

@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroundBotones;

// Mensaje de Pedacito de código //
@property (weak, nonatomic) IBOutlet UILabel *msjPedacitoCodigo;
@property (weak, nonatomic) IBOutlet UIButton *btnPedacitoCodigo;
- (IBAction)pedacitoCodigoAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnConoceMas;
- (IBAction)conoceMasAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *lineMoviliza;

@property (weak, nonatomic) IBOutlet UILabel *conoceMasCodigo;

//////////////////////////////////////////////////////

@property (strong, nonatomic) NSArray *arregloProductos;
@property (strong, nonatomic) PagoModel *pago;

// Views que contienen el plan pro y el dominio //
@property (weak, nonatomic) IBOutlet UIScrollView *vistaPlanPro;
@property (weak, nonatomic) IBOutlet UIScrollView *vistaDominio;
@property (strong, nonatomic) IBOutlet UIView *viewCompraPlanPro;

@property (weak, nonatomic) IBOutlet UILabel *rayaLabel;
// view mensaje exitoso redimido //
@property (weak, nonatomic) IBOutlet UILabel *msjCodigoRedimido;
@property (weak, nonatomic) IBOutlet UILabel *tituloCodigoRedimido;
@property (weak, nonatomic) IBOutlet UIButton *btnAceptar;
@property (strong, nonatomic) IBOutlet UIView *viewFelicidadesRedimir;
@property (strong, nonatomic) IBOutlet UIView *viewContenidoRedimir;
- (IBAction)aceptarAct:(id)sender;


///////////////////////
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContenido;
@property (weak, nonatomic) IBOutlet UILabel *labelMisSitios;


//IRC Botones de compra //
@property (weak, nonatomic) IBOutlet UIButton *ComprarDominio;
- (IBAction)comprarDominioBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewEnviarCodigo;
@property (weak, nonatomic) IBOutlet UILabel *labelPromocion;
@property (weak, nonatomic) IBOutlet UITextField *txtPromocion;
@property (weak, nonatomic) IBOutlet UIButton *Enviar;



@property (weak, nonatomic) IBOutlet UIButton *comprar1mes;

@property (weak, nonatomic) IBOutlet UIButton *comprar12meses;

- (IBAction)comprar1mesBtn:(id)sender;

- (IBAction)comprar12mesesBtn:(id)sender;


- (IBAction)redimirCodigo:(id)sender;

- (IBAction)tipoCuenta:(id)sender;


@end
