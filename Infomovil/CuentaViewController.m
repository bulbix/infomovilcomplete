//
//  CuentaViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "CuentaViewController.h"
#import "WS_HandlerDominio.h"
#import "AlertView.h"
#import "WS_CompraDominio.h"
#import "WS_HandlerDominio.h"
#import "AppDelegate.h"
#import "AppsFlyerTracker.h"
#import "CompartirPublicacionViewController.h"
#import "CNPPopupController.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "CommonUtils.h"
#import "NombrarViewController.h"


@interface CuentaViewController () <CNPPopupControllerDelegate> {
    NSInteger noVisitas;
    NSInteger tipoVista;
	NSMutableArray * pro;
	NSMutableArray * domain;
	NSMutableArray * arreglo;
	
	BOOL tipo; //NO = version pro
	//YES = version domain
	
	BOOL medio;
	BOOL uno;
    BOOL intentoCompra;
   
	NSInteger compraSeleccionada;
	BOOL edo;
    SKProduct *productoElegido;
    BOOL noSeRepiteOprimirElBoton;
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}


@property (nonatomic, strong) NSMutableArray *arregloDominios;
@property (nonatomic, strong) AlertView *alerta;
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation CuentaViewController
// IRC : Para saber que opción de compra selecciono //
int opcionButton = 0 ;
// 1-> 1mes 2-> 6meses 3->12meses

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.regresarAnterior = NO;
        tipoVista = 0;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self obtenerProductos];
    noSeRepiteOprimirElBoton = YES;
    opcionButton = 0;
   // IRC SE OCULTA LA TABLA PARA MOSTRAR EL DOMINIO Y LA DURACIÓN DEL MISMO //
    // IRC CUANDOS SE QUIERA HACER DOMINIOS SE DEBE DESCOMENTAR LA TABLA //
    /*
    if (tablaDominio == nil) {
        tablaDominio = [[TablaDominioViewController alloc] init];
    }
    [tablaSitios setDelegate:tablaDominio];
    [tablaSitios setDataSource:tablaDominio];
    tablaDominio.view = tablaDominio.tableView;
    tablaSitios.layer.cornerRadius = 5.0f;
     
    self.labelMisSitios.text = NSLocalizedString(@"txtMisSitios", Nil);
    */
	self.guardarVista = YES;
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.datosUsuario.datosPago == nil) {
        self.datosUsuario.datosPago = [[PagoModel alloc] init];
    }
 
	
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
	
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"cuenta", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"cuenta", @" ") nombreImagen:@"NBlila.png"];
	}
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonCuenta setBackgroundImage:[UIImage imageNamed:@"acountEn.png"] forState:UIControlStateNormal];
        [self.comprar1mes setBackgroundImage:[UIImage imageNamed:@"3mInac-en.png" ] forState:UIControlStateNormal];
        [self.comprar6meses setBackgroundImage:[UIImage imageNamed:@"6mInac-en.png" ] forState:UIControlStateNormal];
        [self.comprar12meses setBackgroundImage:[UIImage imageNamed:@"12mAc-en.png" ] forState:UIControlStateNormal];
        _imgBeneficios.image = [UIImage imageNamed:@"beneficios-en.png"];
	}else{
		[self.botonCuenta setBackgroundImage:[UIImage imageNamed:@"micuentaon.png"] forState:UIControlStateNormal];
        [self.comprar1mes setBackgroundImage:[UIImage imageNamed:@"3mInac-es.png"] forState:UIControlStateNormal];
        [self.comprar6meses setBackgroundImage:[UIImage imageNamed:@"6mInac-es.png" ] forState:UIControlStateNormal];
        [self.comprar12meses setBackgroundImage:[UIImage imageNamed:@"12mAc-es.png" ] forState:UIControlStateNormal];
        _imgBeneficios.image = [UIImage imageNamed:@"beneficios-es.png"];
	}
    
        
    
    
    if(IS_STANDARD_IPHONE_6){
        self.selector.frame = CGRectMake(20, 10, 335, 30);
         self.scrollContenido.frame = CGRectMake(0, 50, 375, 667);
        [self.scrollContenido setContentSize:CGSizeMake(750, 667)];
        self.viewCompraPlanPro.frame = CGRectMake(0, 0, 375, 667);
        [self.vistaPlanPro setContentSize:CGSizeMake(375, 667)];
        self.vistaPlanPro.frame = CGRectMake(0, 0, 375, 667);
        self.vistaDominio.frame = CGRectMake(375, 0, 375, 667);
        self.imgBackgroundBotones.frame = CGRectMake(0, 68, 375, 143);
        self.comprar1mes.frame = CGRectMake(30, 87, 109, 109);
        self.comprar6meses.frame = CGRectMake(135, 87, 109, 109);
        self.comprar12meses.frame = CGRectMake(240, 87, 109, 109);
        
        
        
    }else if(IS_STANDARD_IPHONE_6_PLUS){
        self.selector.frame = CGRectMake(30, 10, 354, 30);
        self.scrollContenido.frame = CGRectMake(0, 50, 414, 736);
        [self.scrollContenido setContentSize:CGSizeMake(828, 1472)];
        self.viewCompraPlanPro.frame = CGRectMake(0, 0, 414, 736);
        self.vistaPlanPro.frame = CGRectMake(0, 0, 414, 736);
        [self.vistaPlanPro setContentSize:CGSizeMake(414, 736)];
        self.vistaDominio.frame = CGRectMake(414, 0, 414, 736);
        self.imgBackgroundBotones.frame = CGRectMake(0, 68, 414, 143);
        self.comprar1mes.frame = CGRectMake(45, 87, 109, 109);
        self.comprar6meses.frame = CGRectMake(150, 87, 109, 109);
        self.comprar12meses.frame = CGRectMake(255, 87, 109, 109);
        self.tituloPlanPro.frame = CGRectMake(45, 15, 324, 20 );
        self.subtituloPlanPro.frame = CGRectMake(45, 35, 324,20 );
        self.beneficiosPlanPro.frame = CGRectMake(45, 220, 324, 20);
        self.rayaLabel.frame = CGRectMake(45, 240, 324, 1);
        self.imgBeneficios.frame = CGRectMake(45, 265 ,324 , 161);
        
    }else if(IS_IPAD){
        self.selector.frame = CGRectMake(134, 80, 500, 35);
        self.scrollContenido.frame = CGRectMake(0, 120, 768, 1024);
        [self.scrollContenido setContentSize:CGSizeMake(1536, 2048)];
        self.viewCompraPlanPro.frame = CGRectMake(0, 0, 768, 900);
        self.vistaPlanPro.frame = CGRectMake(0, 0, 768, 1024);
        [self.vistaPlanPro setContentSize:CGSizeMake(768, 1024)];
        self.vistaDominio.frame = CGRectMake(768, 0, 768, 1024);
        [self.scrollContenido setContentSize:CGSizeMake(1536, 2048)];
        self.tituloPlanPro.frame = CGRectMake(134, 60, 500, 35 );
        [self.tituloPlanPro setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
        self.subtituloPlanPro.frame = CGRectMake(134, 100, 500,29 );
         [self.subtituloPlanPro setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.imgBackgroundBotones.frame = CGRectMake(0, 145, 768, 200);
        self.comprar1mes.frame = CGRectMake(134, 175, 150, 150);
        self.comprar6meses.frame = CGRectMake(310, 175, 150, 150);
        self.comprar12meses.frame = CGRectMake(485, 175, 150, 150);
        
        self.beneficiosPlanPro.frame = CGRectMake(134, 360, 500, 30);
        [self.beneficiosPlanPro setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.rayaLabel.frame = CGRectMake(134, 385, 500, 1);
        self.imgBeneficios.frame = CGRectMake(134, 410 ,500 , 270);
        [self.botonCuenta setFrame:CGRectMake(176, 10, 88, 80)];
        [self.viewPlanProComprado setFrame:CGRectMake(0, 120, 768, 250)];;
    }else{
        [self.vistaPlanPro setContentSize:CGSizeMake(320, 568)];
        [self.scrollContenido setContentSize:CGSizeMake(640, 568)];
        [self.botonCuenta setFrame:CGRectMake(128, 14, 64, 54)];
    }
  
	pro = [NSMutableArray arrayWithObjects:
		   NSLocalizedString(@"numeroImagenes", @" "),
           NSLocalizedString(@"datosBasicos", @" "),
		   NSLocalizedString(@"numeroContactos", @" "),
		   NSLocalizedString(@"ads", @" "),
		   nil];
	arreglo = pro;
	tipo = NO;
	// IRC PARA PLAN PRO
    //self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", nil);//@"Características de Cuenta Pro";
    self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", @" ");
    self.navigationItem.rightBarButtonItem = Nil;
	
	medio = NO;
	uno = NO;
	
	
	

#ifdef _DEBUG
	NSLog(@"En CuentaViewController statusDominio del appdelegate 2 es: %@",((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio);
#endif
	if([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] ){
        [self.vistaInferior setHidden:NO];
	}else{
        [self.vistaInferior setHidden:YES];
		
	}
	
	[self.selector setTitle:NSLocalizedString(@"cuentaTituloSegment1", nil) forSegmentAtIndex:0];
	[self.selector setTitle:NSLocalizedString(@"cuentaTituloSegment2", nil) forSegmentAtIndex:1];
	
	
	
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CompleteTransactionNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"FailedTransactionNotification"
                                               object:nil];
    
}





-(void) viewWillAppear:(BOOL)animated {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    if(self.selector.selectedSegmentIndex == 1){
        if(datosUsuario.dominio == nil || [datosUsuario.dominio isEqualToString:@""] || (datosUsuario.dominio == (id)[NSNull null]) || [CommonUtils validarEmail:datosUsuario.dominio] || [datosUsuario.dominio isEqualToString:@"(null)"]){
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"msjDominioPublicar", Nil) andAlertViewType:AlertViewTypeQuestion];
            [alert show];
        
        }
    }
    
    noSeRepiteOprimirElBoton = YES;
    if (tipoVista != 1) {
	
#ifdef _DEBUG
	NSLog(@"En CuentaViewController statusDominio del appdelegate 1 es: %@",((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio);
#endif
        
        if([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
	
            //MBC
            if(IS_STANDARD_IPHONE_6_PLUS){
                [self.MensajePlanProComprado setFrame:CGRectMake(70, 60, 414, 150)];
            }else if(IS_STANDARD_IPHONE_6){
                [self.MensajePlanProComprado setFrame:CGRectMake(70, 60, 220, 150)];
            }else if(IS_IPAD){
                [self.MensajePlanProComprado setFrame:CGRectMake(184, 10, 400, 300)];
                [self.MensajePlanProComprado setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
                
            }
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                self.MensajePlanProComprado.text = [NSString stringWithFormat:@"This site already has a Plan Pro\n\nStart date: %@ \nEnd date: %@",self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
            }else{
                self.MensajePlanProComprado.text = [NSString stringWithFormat:@"Este sitio ya cuenta con PLAN PRO disfruta sus beneficios.\n\nFecha de inicio: %@\nFecha de término: %@",self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
            }
            self.viewCompraPlanPro.hidden = YES;
            self.viewPlanProComprado.hidden = NO;
            [self.vistaInferior setHidden:NO];
		
        }else{
            self.viewCompraPlanPro.hidden = NO;
            self.viewPlanProComprado.hidden = YES;
         
        }
	
        [self enviarEventoGAconCategoria:@"Ver" yEtiqueta:@"Plan Pro"];
    }
}


// Este método es para cambiar el status en el server a INTENTO DE PAGO Y ME REGRESE UN FOLIO
-(void)compra{
    WS_CompraDominio *compra = [[WS_CompraDominio alloc] init];
    [compra setCompraDominioDelegate:self];
    //plan
    [compra compraDominio];
    
}


- (void) compraProducto1mes{
    
    @try {
        if([_products count] <= 0){
            if([CommonUtils hayConexion]){
                [self obtenerProductos];
            }else {
                [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }else{
            if([CommonUtils hayConexion]){
                for(int i = 0 ; [_products count] > 0; i++){
                    SKProduct *product = _products[i];
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.3_months"]){
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%i", product.price.integerValue ];
                        [[RageIAPHelper sharedInstance] buyProduct:product];
                        break;
                    }
                }
            }else{
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
            }
        }
    }
    @catch (NSException *exception) {
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
       
    }
    
}

- (void) compraProducto6meses{
   
    @try {
        if([_products count] <= 0){
            if([CommonUtils hayConexion]){
                [self obtenerProductos];
            }else {
                [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }else{
            if([CommonUtils hayConexion]){
                for(int i = 0 ; [_products count] > 0; i++){
                    SKProduct *product = _products[i];
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.6_months"]){
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%i", product.price.integerValue ];
                        [[RageIAPHelper sharedInstance] buyProduct:product];
                        break;
                    }
                }
            }else{
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
            }
        }
    }
    @catch (NSException *exception) {
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
       
    }
    
}

- (void) compraProducto12meses{
 
    @try {
        if([_products count] <= 0){
            if([CommonUtils hayConexion]){
                [self obtenerProductos];
            }else {
                [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }else{
            if([CommonUtils hayConexion]){
                for(int i = 0 ; [_products count] > 0; i++){
                    SKProduct *product = _products[i];
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.12_months"]){
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%i", product.price.integerValue ];
                        [[RageIAPHelper sharedInstance] buyProduct:product];
                        break;
                    }
                }
            }else{
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
            }
        }
    }
    @catch (NSException *exception) {
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
      
    }
    
}

-(void)resultadoCompraDominio:(BOOL)estado{ NSLog(@"EL ESTATUS ES: %@", self.datosUsuario.datosPago.statusPago);
    if(estado == YES && [self.datosUsuario.datosPago.statusPago isEqualToString: @"INTENTO PAGO"]){
        if(opcionButton == 1){
            [self compraProducto1mes];
        }else if(opcionButton == 2){
          [self compraProducto6meses];
        }else if(opcionButton == 3){
            [self compraProducto12meses];
        }
    }else{
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", Nil) message:NSLocalizedString(@"errorCompra", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
    }
}


- (IBAction)comprar1mesBtn:(id)sender {
if(noSeRepiteOprimirElBoton){
    noSeRepiteOprimirElBoton = NO;
    opcionButton = 1;
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    
    @try {
        if([_products count] <= 0){
            if([CommonUtils hayConexion]){
                [self obtenerProductos];
             }else {
                 [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }else{
            
            if([CommonUtils hayConexion]){
                for(int i = 0 ; [_products count] > 0; i++){
                    SKProduct *product = _products[i];
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.3_months"]){
#if DEBUG
                        NSLog(@"Comprando item 0: %@", product.productIdentifier);
#endif
                        self.datosUsuario.datosPago.plan =@"PLAN PRO 3 MESES";
                        self.datosUsuario.datosPago.comision = @"27";
                        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
                        self.datosUsuario.datosPago.tipoCompra = @"PP";
                        self.datosUsuario.datosPago.titulo = @"iOS";
                        self.datosUsuario.datosPago.codigoCobro = @" ";
                        self.datosUsuario.datosPago.pagoId = 0;
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%i", product.price.integerValue ];
                       
                        [self compra];
                        break;
                    }
                }
            }else {
                [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }
    }
    @catch (NSException *exception) {
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
#if DEBUG
        NSLog(@"La NSException en comprar1mesBtn es: %@", exception.reason);
#endif
    }
}
}



- (IBAction)comprar6mesesBtn:(id)sender {
    if(noSeRepiteOprimirElBoton){
    noSeRepiteOprimirElBoton = NO;
    opcionButton = 2;
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    @try {
            if([_products count] <= 0){
                    if([CommonUtils hayConexion]){
                        [self obtenerProductos];
                    }else {
                        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                        [alert show];
                    }
            }else{
                
                if([CommonUtils hayConexion]){
                    for(int i = 0 ; [_products count] > 0; i++){
                        SKProduct *product = _products[i];
                        if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.6_months"]){
#if DEBUG
                            NSLog(@"Comprando item 0: %@", product.productIdentifier);
#endif
                            self.datosUsuario.datosPago.plan =@"PLAN PRO 6 MESES";
                            self.datosUsuario.datosPago.comision = @"17";
                            self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
                            self.datosUsuario.datosPago.tipoCompra = @"PP";
                            self.datosUsuario.datosPago.titulo = @"iOS";
                            self.datosUsuario.datosPago.codigoCobro = @" ";
                            self.datosUsuario.datosPago.pagoId = 0;
                            self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%i", product.price.integerValue ];
                            
                            [self compra];
                            break;
                        }
                    }
                }else {
                    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                    AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                    [alert show];
                }
            }
        }
        @catch (NSException *exception) {
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
           
        }
    }else{
        NSLog(@"SE REPITIO EL BOTON OPRIMIDO");
    }
}

- (IBAction)comprar12mesesBtn:(id)sender {
if(noSeRepiteOprimirElBoton){
    noSeRepiteOprimirElBoton = NO;
    opcionButton = 3;
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    @try {
        if([_products count] <= 0){
            if([CommonUtils hayConexion]){
                [self obtenerProductos];
            }else {
                [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }else{
            if([CommonUtils hayConexion]){
                for(int i = 0 ; [_products count] > 0; i++){
                    SKProduct *product = _products[i];
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.12_months"]){
                        self.datosUsuario.datosPago.plan =@"PLAN PRO 12 MESES";
                        self.datosUsuario.datosPago.comision = @"23";
                        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
                        self.datosUsuario.datosPago.tipoCompra = @"PP";
                        self.datosUsuario.datosPago.titulo = @"iOS";
                        self.datosUsuario.datosPago.codigoCobro = @" ";
                        self.datosUsuario.datosPago.pagoId = 0;
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%i", product.price.integerValue ];
                        [self compra];
                        break;
                    }
                }
            }else {
                [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }
    }
    @catch (NSException *exception) {
      
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }
}
}

// IRC OBTIENE LOS IDENTIFICADORES DE LOS PRODUCTOS EN APPSTORE  //
- (void)obtenerProductos {
    _products = nil;
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
        }
    }];
}

- (IBAction)tipoCuenta:(id)sender {
	/////////////////////////////////// COMPRAR PLAN PRO //////////////////////////////////
	self.datosUsuario = [DatosUsuario sharedInstance];
    if(self.selector.selectedSegmentIndex == 0){
	
        if(  ![((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] ){
			arreglo = pro;
			tipo = NO;
            self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", @" ");
            
			self.vistaPlanPro.hidden = NO;
		
		}else{
			arreglo = pro;
			tipo = NO;
            self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", @" ");
			
		
		}
        [self.scrollContenido scrollRectToVisible:CGRectMake(0, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
/////////////////////////////////// DOMINIOS  /////////////////////////////////
	}else if(self.selector.selectedSegmentIndex == 1){
        DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
        if(datosUsuario.dominio == nil || [datosUsuario.dominio isEqualToString:@""] || (datosUsuario.dominio == (id)[NSNull null]) || [CommonUtils validarEmail:datosUsuario.dominio] || [datosUsuario.dominio isEqualToString:@"(null)"]){
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"msjDominioPublicar", Nil) andAlertViewType:AlertViewTypeQuestion];
            [alert show];
            
        }
        
            self.datosUsuario = [DatosUsuario sharedInstance];
            UIFont * customFont = [UIFont fontWithName:@"Avenir-Medium" size:16];
            UILabel *dominio;
            if(IS_STANDARD_IPHONE_6){
                dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 375, 100)];
            }else if(IS_STANDARD_IPHONE_6_PLUS){
                dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 414, 100)];
            }else if(IS_IPAD){
                dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 768, 100)];
            }else{
                dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 320, 100)];
            }
        
        UILabel *fechas;
        fechas.font = customFont;
        if(IS_STANDARD_IPHONE_6){
            fechas = [[UILabel alloc]initWithFrame:CGRectMake(0, 120,375, 100)];
            [fechas setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
            [dominio setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        }else if(IS_STANDARD_IPHONE_6_PLUS){
            fechas = [[UILabel alloc]initWithFrame:CGRectMake(0, 180,414, 100)];
            [fechas setFont: [UIFont fontWithName:@"Avenir-Book" size:20]];
            [dominio setFont: [UIFont fontWithName:@"Avenir-Book" size:20]];
        }else if(IS_IPAD){
            fechas = [[UILabel alloc]initWithFrame:CGRectMake(184, 180,400, 200)];
            [fechas setFont: [UIFont fontWithName:@"Avenir-Book" size:20]];
            [dominio setFont: [UIFont fontWithName:@"Avenir-Book" size:24]];
        }else{
            fechas = [[UILabel alloc]initWithFrame:CGRectMake(0, 120,320, 100)];
        }
        
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                self.arregloDominios = self.datosUsuario.dominiosUsuario;
                dominio.text = @"";
                for(int i= 0; i< [self.arregloDominios count]; i++){
                    DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                    if([usuarioDom.domainType isEqualToString:@"tel"]){
                        NSLog(@"EL DOMINIO FUE TEL ");
                        if([usuarioDom.vigente isEqualToString:@"SI"] || [usuarioDom.vigente isEqualToString:@"si"]){
                            dominio.text = [NSString stringWithFormat:@"My website\n\n www.%@.tel",self.datosUsuario.dominio] ;
                            if(self.datosUsuario.fechaDominioIni && ![self.datosUsuario.fechaDominioIni isEqualToString:@""] && ![self.datosUsuario.fechaDominioIni isEqualToString:@"(null)"] && self.datosUsuario.fechaDominioIni != nil){
                                fechas.text = [NSString stringWithFormat: @"Fecha de inicio: %@\n Fecha de término: %@", self.datosUsuario.fechaDominioIni, self.datosUsuario.fechaDominioFin ];
                            }else{
                                fechas.text = [NSString stringWithFormat: @"Fecha de inicio: %@\n Fecha de término: %@", usuarioDom.fechaIni, usuarioDom.fechaFin ];
                            
                            }
                            
                        }else{
                            dominio.text = [NSString stringWithFormat:@"My website\n\nhttp://infomovil.com%@",self.datosUsuario.dominio] ;
                        }
                    }
                }
                if([dominio.text isEqualToString:@""]){
                    for(int i= 0; i< [self.arregloDominios count]; i++){
                        DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                        if([usuarioDom.domainType isEqualToString:@"recurso"]){
                            NSLog(@"EL DOMINIO FUE RECURSO ");
                            dominio.text = [NSString stringWithFormat:@"My website\n\nhttp://infomovil.com/%@",self.datosUsuario.dominio] ;
                        }
                    }
                }

            }else{
                self.arregloDominios = self.datosUsuario.dominiosUsuario;
                dominio.text = @"";
                for(int i= 0; i< [self.arregloDominios count]; i++){
                    DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                    if([usuarioDom.domainType isEqualToString:@"tel"]){
                        NSLog(@"EL DOMINIO FUE TEL ");
                        if([usuarioDom.vigente isEqualToString:@"SI"] || [usuarioDom.vigente isEqualToString:@"si"]){
                            dominio.text = [NSString stringWithFormat:@"Mi sitio web\n\n www.%@.tel",self.datosUsuario.dominio] ;
                           if(self.datosUsuario.fechaDominioIni && ![self.datosUsuario.fechaDominioIni isEqualToString:@""] && ![self.datosUsuario.fechaDominioIni isEqualToString:@"(null)"] && self.datosUsuario.fechaDominioIni != nil){
                            
                               fechas.text = [NSString stringWithFormat: @"Fecha de inicio: %@\n Fecha de término: %@", self.datosUsuario.fechaDominioIni, self.datosUsuario.fechaDominioFin ];
                           }else{
                               fechas.text = [NSString stringWithFormat: @"Fecha de inicio: %@\n Fecha de término: %@", usuarioDom.fechaIni, usuarioDom.fechaFin ];
                           }
                        }else{
                            dominio.text = [NSString stringWithFormat:@"Mi sitio web\n\nhttp://infomovil.com/%@",self.datosUsuario.dominio] ;
                        }
                    }
                }
                if([dominio.text isEqualToString:@""]){
                    for(int i= 0; i< [self.arregloDominios count]; i++){
                        DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                        if([usuarioDom.domainType isEqualToString:@"recurso"]){
                            NSLog(@"EL DOMINIO FUE RECURSO ");
                            dominio.text = [NSString stringWithFormat:@"Mi sitio web\n\nhttp://infomovil.com/%@",self.datosUsuario.dominio] ;
                            
                        }
                    }
                }
            }
        
            dominio.font = customFont;
            dominio.numberOfLines = 5;
            dominio.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            dominio.adjustsFontSizeToFitWidth = YES;
            dominio.clipsToBounds = YES;
            dominio.backgroundColor = [UIColor clearColor];
            dominio.textColor = [UIColor colorWithRed:47.0f/255.0f
                                                  green:163.0f/255.0f
                                                   blue:153.0f/255.0f
                                                  alpha:1.0f];

            dominio.textAlignment = NSTextAlignmentCenter;
        
        [self.vistaDominio addSubview:dominio];
        
            fechas.numberOfLines = 5;
            fechas.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
            fechas.adjustsFontSizeToFitWidth = YES;
            fechas.clipsToBounds = YES;
            fechas.backgroundColor = [UIColor clearColor];
            fechas.textColor = [UIColor colorWithRed:47.0f/255.0f
                                                  green:163.0f/255.0f
                                                   blue:153.0f/255.0f
                                                  alpha:1.0f];
            ;
            fechas.textAlignment = NSTextAlignmentCenter;
            [self.vistaDominio addSubview:fechas];
            
            if(IS_STANDARD_IPHONE_6){
                [self.scrollContenido scrollRectToVisible:CGRectMake(375, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
            }else if(IS_STANDARD_IPHONE_6_PLUS){
                [self.scrollContenido scrollRectToVisible:CGRectMake(414, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
            }else if(IS_IPAD){
                [self.scrollContenido scrollRectToVisible:CGRectMake(768, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
            }else{
                [self.scrollContenido scrollRectToVisible:CGRectMake(320, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
            }
    }
	
            
            
            
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



-(void) mostrarActivity {
   
    self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}
-(void) ocultarActivity {
    noSeRepiteOprimirElBoton = YES;
    
    if (self.alerta)
    {
        //MBC
        if(IS_STANDARD_IPHONE_6_PLUS){
            [self.MensajePlanProComprado setFrame:CGRectMake(70, 60, 414, 150)];
        }else if(IS_STANDARD_IPHONE_6){
            [self.MensajePlanProComprado setFrame:CGRectMake(70, 60, 220, 150)];
        }else if(IS_IPAD){
            [self.MensajePlanProComprado setFrame:CGRectMake(184, 120, 400, 400)];
            [self.MensajePlanProComprado setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
            
        }
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            self.MensajePlanProComprado.text = [NSString stringWithFormat:@"This site already has a Plan Pro\n\nStart date: %@ \nEnd date: %@",self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
        }else{
            self.MensajePlanProComprado.text = [NSString stringWithFormat:@"Este sitio ya cuenta con PLAN PRO disfruta sus beneficios.\n\nFecha de inicio: %@\nFecha de término: %@",self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
        }
        
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
}


- (IBAction)comprarDominioBtn:(id)sender {
}

-(void)accionAceptar2{
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"FailedTransactionNotification"]){
        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
        self.datosUsuario.descripcionDominio = @"";
      
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
      
    }
    else if ([[notification name] isEqualToString:@"CompleteTransactionNotification"]){
       
        if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 3 MESES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 3 Meses" withValue:@""];
            [[Appboy sharedInstance] logPurchase:@"PP3"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"199.00"]];
        }else if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 6 MESES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 6 Meses" withValue:@""];
            [[Appboy sharedInstance] logPurchase:@"PP6"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"349.00"]];
        }else if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 12 MESES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 12 Meses" withValue:@""];
            [[Appboy sharedInstance] logPurchase:@"PP12"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"599.00"]];
        }
        
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            self.MensajePlanProComprado.text = [NSString stringWithFormat:@"This site already has a Plan Pro\n\nStart date: %@ \nEnd date: %@",self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
        }else{
            self.MensajePlanProComprado.text = [NSString stringWithFormat:@"Este sitio ya cuenta con un Plan Pro\n\nFecha de inicio: %@\nFecha de término: %@",self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
        }
        self.viewCompraPlanPro.hidden = YES;
        self.viewPlanProComprado.hidden = NO;
        self.datosUsuario.datosPago.statusPago = @"PAGADO";
        self.datosUsuario.descripcionDominio = @"";
        
        [self compra];
        
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
      
    }
    
    
     [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void)accionSi{
    NombrarViewController *comparte = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:Nil];
    [self.navigationController pushViewController:comparte animated:YES];

}

-(void)accionNo{
    self.selector.selectedSegmentIndex = 0;
    [self tipoCuenta:self];
    
}

-(void) errorConsultaWS {
    
    NSLog(@"ENTRO A ERRORCONSULTAWS");
    //[self performSelectorOnMainThread:@selector(errorLogin) withObject:Nil waitUntilDone:YES];
    noSeRepiteOprimirElBoton = YES;
    [NSThread sleepForTimeInterval:1];
    [self.alerta hide];
    
}


@end


