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
    
    
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        [self.vistaPlanPro setContentSize:CGSizeMake(320, 568)];
        [self.scrollContenido setContentSize:CGSizeMake(640, 568)];
    
    [self.botonCuenta setFrame:CGRectMake(128, 14, 64, 54)];
	
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
	
	
	BOOL sesion = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion;

#ifdef _DEBUG
	NSLog(@"En CuentaViewController statusDominio del appdelegate 2 es: %@",((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio);
#endif
	if(sesion &&  [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] ){
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
    self.datosUsuario = [DatosUsuario sharedInstance];
    noSeRepiteOprimirElBoton = YES;
    if (tipoVista != 1) {
	BOOL sesion = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion;
#ifdef _DEBUG
	NSLog(@"En CuentaViewController statusDominio del appdelegate 1 es: %@",((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio);
#endif
        
        if(sesion &&  [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
	
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
            [self.vistaInferior setHidden:YES];
        }
	
        self.datosUsuario = [DatosUsuario sharedInstance];
        if(self.datosUsuario.nombroSitio || ![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Tramite"]){
            if ([self.datosUsuario.fechaInicialTel isEqualToString:@""] && [self.datosUsuario.fechaFinalTel isEqualToString:@""]) {
                NSDate *dateInit = [NSDate date];
                NSDateComponents *setMonths			= [[NSDateComponents alloc] init];
                NSCalendar		*calendar			= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			
                [setMonths setMonth:12];
                NSDate *dateFinal = [calendar dateByAddingComponents:setMonths toDate:dateInit options:0];
			
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                [dateFormat setDateFormat:@"dd-MM-yyyy"];
                NSString *inicio = [dateFormat stringFromDate:dateInit];
                NSString *fin = [dateFormat stringFromDate:dateFinal];
		
                self.datosUsuario.fechaInicial = inicio;
                self.datosUsuario.fechaFinal = fin;
			
			
            }else{
            }
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.prices_3_months"]){
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
        NSLog(@"La NSException en comprarProducto1mes es: %@", exception.reason);
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.prices_6_months"]){
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
        NSLog(@"La NSException en comprarProducto6meses es: %@", exception.reason);
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.prices_12_months"]){
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
        NSLog(@"La NSException en comprarProducto12meses es: %@", exception.reason);
    }
    
}

-(void)resultadoCompraDominio:(BOOL)estado{
    if(estado && ![self.datosUsuario.datosPago.statusPago isEqualToString: @"PAGADO"]){
        if(opcionButton == 1){
            [self compraProducto1mes];
        }else if(opcionButton == 2){
          [self compraProducto6meses];
        }else if(opcionButton == 3){
            [self compraProducto12meses];
        }
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.prices_3_months"]){
                        NSLog(@"Comprando item 0: %@", product.productIdentifier);
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
        NSLog(@"La NSException en comprar1mesBtn es: %@", exception.reason);
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
                        if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.prices_6_months"]){
                            NSLog(@"Comprando item 0: %@", product.productIdentifier);
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
            NSLog(@"La NSException en comprar6mesesBtn es: %@", exception.reason);
        }
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.prices_12_months"]){
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
        NSLog(@"La NSException en comprar12mesesBtn es: %@", exception.reason);
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
		BOOL sesion = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion;
        if(sesion &&  ![((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] ){
			arreglo = pro;
			tipo = NO;
            // IRC para plan Pro
			//self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", @" ");
            // IRC Temporal
            self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", @" ");
            
			self.vistaPlanPro.hidden = NO;
		
		}else{
			arreglo = pro;
			tipo = NO;
            // IRC para plan Pro
			//self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", @" ");
            self.tituloPlanPro.text = NSLocalizedString(@"mensajeCuenta", @" ");
			//BOOL sesion = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion;
		
		}
        [self.scrollContenido scrollRectToVisible:CGRectMake(0, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];

	}else if(self.selector.selectedSegmentIndex == 1){
        /////////////////////////////////  COMPRAR DOMINIO   //////////////////////////////
		/*self.tituloPlanPro.text = @"";
        if ([((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pendiente"]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        }
         */
        
        BOOL sesion = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion;
        if(sesion ){
            
                // IRC ESTAS LINEAS SE COMENTAN PARA OCULTAR LA TABLA DE DOMINIOS //
            /*
             if (tablaDominio == nil) {
                tablaDominio = [[TablaDominioViewController alloc] init];
             }
             [tablaSitios setDelegate:tablaDominio];
             [tablaSitios setDataSource:tablaDominio];
             tablaDominio.view = tablaDominio.tableView;
             [self.scrollContenido scrollRectToVisible:CGRectMake(320, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
             */
            
            // ESTAS LINEAS SE CREARON MIENTRAS NO EXISTE SUBDOMINIOS

            // IRC DOMINIO
            self.datosUsuario = [DatosUsuario sharedInstance];
            UIFont * customFont = [UIFont fontWithName:@"Avenir-Medium" size:16];
            
            UILabel *dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 320, 100)];
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                dominio.text = [NSString stringWithFormat:@"My website\n\n http://%@.tel",self.datosUsuario.dominio] ;
            
#if DEBUG
                dominio.text = [NSString stringWithFormat:@"My website\n\nhttp://info-movil.com/%@",self.datosUsuario.dominio] ;
#endif
            }else{
                dominio.text = [NSString stringWithFormat:@"Mi sitio web\n\n http://%@.tel",self.datosUsuario.dominio] ;
#if DEBUG
                dominio.text = [NSString stringWithFormat:@"Mi sitio web\n\nhttp://info-movil.com/%@",self.datosUsuario.dominio] ;
#endif
            }
            
            dominio.font = customFont;
            dominio.numberOfLines = 5;
            dominio.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            dominio.adjustsFontSizeToFitWidth = YES;
           // dominio.minimumScaleFactor = 10.0f/12.0f;
            dominio.clipsToBounds = YES;
            dominio.backgroundColor = [UIColor clearColor];
            dominio.textColor = [UIColor colorWithRed:47.0f/255.0f
                                                  green:163.0f/255.0f
                                                   blue:153.0f/255.0f
                                                  alpha:1.0f];

            dominio.textAlignment = NSTextAlignmentCenter;
            [self.vistaDominio addSubview:dominio];
            
            // IRC FECHA INICIO Y FIN
            UILabel *fechas = [[UILabel alloc]initWithFrame:CGRectMake(0, 120,320, 100)];
            fechas.text = [NSString stringWithFormat: @"Fecha de inicio: %@\n Fecha de término: %@", self.datosUsuario.fechaInicialTel, self.datosUsuario.fechaFinalTel ];
            fechas.font = customFont;
            fechas.numberOfLines = 5;
            fechas.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
            fechas.adjustsFontSizeToFitWidth = YES;
           // fechas.minimumScaleFactor = 10.0f/12.0f;
            fechas.clipsToBounds = YES;
            fechas.backgroundColor = [UIColor clearColor];
            fechas.textColor = [UIColor colorWithRed:47.0f/255.0f
                                                  green:163.0f/255.0f
                                                   blue:153.0f/255.0f
                                                  alpha:1.0f];
            ;
            fechas.textAlignment = NSTextAlignmentCenter;
            [self.vistaDominio addSubview:fechas];
            
            
            [self.scrollContenido scrollRectToVisible:CGRectMake(320, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
            
      }
      
    }
	
            
            
            
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



-(void) mostrarActivity {
    NSLog(@"Mostrar actividad de espera!");
    self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}
-(void) ocultarActivity {
    noSeRepiteOprimirElBoton = YES;
    NSLog(@"Ocultar actividad de espera!");
    if (self.alerta)
    {
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
    NSLog(@"*************************************************a ver si se activa en algun momento!!1");
    NSLog(@"****************************************************************************************");
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"FailedTransactionNotification"]){
        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
        self.datosUsuario.descripcionDominio = @"";
        NSLog (@" IRC --------------------------- Fallo la transaccion!");
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
        NSLog(@"CONFIRMANDO QUE EL STATUSDOMINIO CAMBIO :  %@", ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio);
    }
    else if ([[notification name] isEqualToString:@"CompleteTransactionNotification"]){
       
        if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 3 MESES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 3 Meses" withValue:@""];
           // [[Appboy sharedInstance] logCustomEvent:@"Plan Pro 3 Meses"];
            [[Appboy sharedInstance] logPurchase:@"PP3"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"199.00"]];
        }else if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 6 MESES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 6 Meses" withValue:@""];
           // [[Appboy sharedInstance] logCustomEvent:@"Plan Pro 6 Meses"];
            [[Appboy sharedInstance] logPurchase:@"PP6"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"349.00"]];
        }else if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 12 MESES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 12 Meses" withValue:@""];
           // [[Appboy sharedInstance] logCustomEvent:@"Plan Pro 12 Meses"];
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
        NSLog (@" IRC --------------------------- Se completo la transaccion !");
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
        NSLog(@"CONFIRMANDO QUE EL STATUSDOMINIO CAMBIO :  %@", ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio);
    }
    
    
     [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}




@end


