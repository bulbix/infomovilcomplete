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
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "CommonUtils.h"
#import "NombrarViewController.h"
#import "NombraCompraDominio.h"
#import "MenuPasosViewController.h"
#import "WS_RedimirCodigo.h"

@interface CuentaViewController () {
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
   
	self.guardarVista = YES;
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.datosUsuario.voyAComprarTel = nil;
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
        [self.comprar1mes setBackgroundImage:[UIImage imageNamed:@"1mInac-en.png" ] forState:UIControlStateNormal];
        [self.comprar12meses setBackgroundImage:[UIImage imageNamed:@"12mAc-en.png" ] forState:UIControlStateNormal];
        _imgBeneficios.image = [UIImage imageNamed:@"beneficios-en.png"];
	}else{
		[self.botonCuenta setBackgroundImage:[UIImage imageNamed:@"micuentaon.png"] forState:UIControlStateNormal];
        [self.comprar1mes setBackgroundImage:[UIImage imageNamed:@"1mInac-es.png"] forState:UIControlStateNormal];
        [self.comprar12meses setBackgroundImage:[UIImage imageNamed:@"12mAc-es.png" ] forState:UIControlStateNormal];
        _imgBeneficios.image = [UIImage imageNamed:@"beneficios-es.png"];
	}
    
        
    
    
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        self.selector.frame = CGRectMake(20, 10, 335, 30);
         self.scrollContenido.frame = CGRectMake(0, 50, 375, 667);
        [self.scrollContenido setContentSize:CGSizeMake(1125, 667)];
        self.viewCompraPlanPro.frame = CGRectMake(0, 0, 375, 667);
        [self.vistaPlanPro setContentSize:CGSizeMake(375, 667)];
        self.vistaPlanPro.frame = CGRectMake(0, 0, 375, 667);
        self.vistaDominio.frame = CGRectMake(375, 0, 375, 667);
        self.imgBackgroundBotones.frame = CGRectMake(0, 68, 375, 150);
        self.comprar1mes.frame = CGRectMake(40, 74, 109, 109);
        self.comprar12meses.frame = CGRectMake(230, 74, 109, 109);
        [self.botonCuenta setFrame:CGRectMake(128, 12, 64, 54)];
        [self.precioUno setFrame:CGRectMake(0, 191,187 , 30)];
        [self.precioDoce setFrame:CGRectMake(187, 191,187 , 30)];
    }else if(IS_IPAD){
        self.selector.frame = CGRectMake(134, 80, 500, 35);
        self.scrollContenido.frame = CGRectMake(0, 120, 768, 1024);
        [self.scrollContenido setContentSize:CGSizeMake(2304, 2048)];
        self.viewCompraPlanPro.frame = CGRectMake(0, 0, 768, 900);
        self.vistaPlanPro.frame = CGRectMake(0, 0, 768, 1024);
        [self.vistaPlanPro setContentSize:CGSizeMake(768, 1024)];
        self.vistaDominio.frame = CGRectMake(768, 0, 768, 1024);
        self.tituloPlanPro.frame = CGRectMake(134, 15, 500, 35 );
        [self.tituloPlanPro setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
        self.subtituloPlanPro.frame = CGRectMake(134, 55, 500,29 );
         [self.subtituloPlanPro setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.imgBackgroundBotones.frame = CGRectMake(0, 110, 768, 270);
        self.comprar1mes.frame = CGRectMake(167, 147, 150, 150);
        self.comprar12meses.frame = CGRectMake(451, 147, 150, 150);
        
        [self.precioUno setFrame:CGRectMake(100, 330,284 , 40)];
        [self.precioDoce setFrame:CGRectMake(385, 330,284 , 40)];
        [self.precioUno setFont:[UIFont fontWithName:@"Avenir-Medium" size:22]];
        [self.precioDoce setFont:[UIFont fontWithName:@"Avenir-Medium" size:22]];
        self.beneficiosPlanPro.frame = CGRectMake(134, 395, 500, 30);
        [self.beneficiosPlanPro setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.rayaLabel.frame = CGRectMake(134, 420, 500, 1);
        self.imgBeneficios.frame = CGRectMake(134, 440 ,500 , 360);
        [self.botonCuenta setFrame:CGRectMake(176, 10, 88, 80)];
        [self.viewPlanProComprado setFrame:CGRectMake(0, 120, 768, 250)];;
    }else{
        [self.vistaPlanPro setContentSize:CGSizeMake(320, 655)];
        [self.scrollContenido setContentSize:CGSizeMake(960, 655)];
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
	[self.selector setTitle:NSLocalizedString(@"cuentaTituloSegment3", nil) forSegmentAtIndex:2];
	
	
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CompleteTransactionNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"FailedTransactionNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(guardarPreciosPlanPro:)
                                                 name:@"PreciosPlanPro"
                                               object:nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.precioDoce.text = [prefs stringForKey:@"precioDoceMesesPlanPro"];
    self.precioUno.text = [prefs stringForKey:@"precioUnMesPlanPro"];
}


-(void)guardarPreciosPlanPro:(id)sender{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.precioDoce.text = [prefs stringForKey:@"precioDoceMesesPlanPro"];
    self.precioUno.text = [prefs stringForKey:@"precioUnMesPlanPro"];
}

-(IBAction)regresar:(id)sender {
    MenuPasosViewController *cuenta = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
    [self.navigationController pushViewController:cuenta animated:YES];
    
}

-(void) viewWillAppear:(BOOL)animated {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
	
          if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
                [self.MensajePlanProComprado setFrame:CGRectMake(37, 60, 300, 150)];
            }else if(IS_IPAD){
                [self.MensajePlanProComprado setFrame:CGRectMake(184, 10, 400, 300)];
                [self.MensajePlanProComprado setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
                
            }

            self.MensajePlanProComprado.text = [NSString stringWithFormat:NSLocalizedString(@"cuentaConPlanPro", nil),self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
            self.msjPedacitoCodigo.text = NSLocalizedString(@"msjCompartePedacito", Nil);
            [self.btnPedacitoCodigo.titleLabel setText: NSLocalizedString(@"enviarPedacito", Nil)];
            self.viewCompraPlanPro.hidden = YES;
            self.viewPlanProComprado.hidden = NO;
            [self.vistaInferior setHidden:NO];
		
        }else{
            self.viewCompraPlanPro.hidden = NO;
            self.viewPlanProComprado.hidden = YES;
         
        }
	
        [self enviarEventoGAconCategoria:@"Ver" yEtiqueta:@"Plan Pro"];
    }
    self.beneficiosPlanPro.text = NSLocalizedString(@"BeneficiosCuentaPlanPro", Nil);
    self.subtituloPlanPro.text = NSLocalizedString(@"subtituloCuentaPlanPro", Nil);
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.precioDoce.text = [prefs stringForKey:@"precioDoceMesesPlanPro"];
    self.precioUno.text = [prefs stringForKey:@"precioUnMesPlanPro"];
 
    [self.labelPromocion setText:NSLocalizedString(@"labelPromocion", Nil)];
    [self.Enviar setTitle:NSLocalizedString(@"btnPromocion", Nil) forState:UIControlStateNormal];
    self.tituloCodigoRedimido.text = NSLocalizedString(@"felicidades", Nil) ;
    self.Enviar.layer.cornerRadius = 10;
    self.txtPromocion.layer.cornerRadius = 5;
    
    self.btnAceptar.layer.cornerRadius = 5;
    self.btnAceptar.titleLabel.text = NSLocalizedString(@"aceptarPop", Nil);
    self.viewFelicidadesRedimir.layer.cornerRadius = 5;
    
    if(IS_IPAD){
        self.viewContenidoRedimir.frame = CGRectMake(0, 0, 768, 1024);
        self.viewFelicidadesRedimir.frame = CGRectMake(234, 300, 300, 300);
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        self.viewContenidoRedimir.frame = CGRectMake(0, 0, 375, 768);
        self.viewFelicidadesRedimir.frame = CGRectMake(47, 200, 280, 280);
    }
    
}




// Este método es para cambiar el status en el server a INTENTO DE PAGO Y ME REGRESE UN FOLIO
-(void)compra{
    WS_CompraDominio *compra = [[WS_CompraDominio alloc] init];
    [compra setCompraDominioDelegate:self];
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.1_month"]){
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%li", (long)product.price.integerValue ];
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.12_months_new"]){
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%li", (long)product.price.integerValue ];
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

-(void)resultadoCompraDominio:(BOOL)estado{
    if(estado == YES && [self.datosUsuario.datosPago.statusPago isEqualToString: @"INTENTO PAGO"]){
        if(opcionButton == 1){
            [self compraProducto1mes];
        }else if(opcionButton == 2){
            [self compraProducto12meses];
        }
    }else if([self.datosUsuario.datosPago.statusPago isEqualToString: @"PAGADO"]){
        return;
    }else{
        noSeRepiteOprimirElBoton = YES;
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", Nil) message:NSLocalizedString(@"errorCompra", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
    }
}


- (IBAction)comprar1mesBtn:(id)sender {
if(noSeRepiteOprimirElBoton){
   if([CommonUtils hayConexion]){
       noSeRepiteOprimirElBoton = NO;
       opcionButton = 1;
    
    @try {
        if([_products count] <= 0){
                [self obtenerProductos];
        }else{
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                for(int i = 0 ; [_products count] > 0; i++){
                    SKProduct *product = _products[i];
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.1_month"]){
#if DEBUG
                        NSLog(@"Comprando item 0: %@", product.productIdentifier);
#endif
                        self.datosUsuario.datosPago.plan =@"PLAN PRO 1 MES";
                        self.datosUsuario.datosPago.comision = @"27";
                        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
                        self.datosUsuario.datosPago.tipoCompra = @"PP";
                        self.datosUsuario.datosPago.titulo = @"iOS";
                        self.datosUsuario.datosPago.codigoCobro = @" ";
                        self.datosUsuario.datosPago.pagoId = 0;
                        self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%li", (long)product.price.integerValue ];
                       
                        [self compra];
                        break;
                    }
                }
           
        }
    }
    @catch (NSException *exception) {
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
#if DEBUG
        NSLog(@"La NSException en comprar1mesBtn es: %@", exception.reason);
#endif
    }
        
    }else {
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    
    
}else{
#if DEBUG
    NSLog(@"SE REPITIO EL BOTON OPRIMIDO");
#endif
}
}





- (IBAction)comprar12mesesBtn:(id)sender {
if(noSeRepiteOprimirElBoton){
   if([CommonUtils hayConexion]){
       noSeRepiteOprimirElBoton = NO;
       opcionButton = 2;
    
       @try {
            if([_products count] <= 0){
                    [self obtenerProductos];
            }else{
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                    for(int i = 0 ; [_products count] > 0; i++){
                        SKProduct *product = _products[i];
                        if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.12_months_new"]){
                            self.datosUsuario.datosPago.plan =@"PLAN PRO 12 MESES";
                            self.datosUsuario.datosPago.comision = @"23";
                            self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
                            self.datosUsuario.datosPago.tipoCompra = @"PP";
                            self.datosUsuario.datosPago.titulo = @"iOS";
                            self.datosUsuario.datosPago.codigoCobro = @" ";
                            self.datosUsuario.datosPago.pagoId = 0;
                            self.datosUsuario.datosPago.montoBruto = [NSString stringWithFormat:@"%li", (long)product.price.integerValue ];
                            [self compra];
                            break;
                        }
                    }
            }
        }@catch (NSException *exception) {
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }

   }else {
       [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
       AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
       [alert show];
   }
}else{
#if DEBUG
    NSLog(@"SE REPITIO EL BOTON OPRIMIDO");
#endif
}
}

- (IBAction)redimirCodigo:(id)sender {
    
    if([self validaCodigo]){
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(redimirWS) withObject:Nil];
    }else{
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"letrasNumeros", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
  
}

-(void)resultadoRedimirCodigo:(NSString *)resultado{
    NSLog(@"El valor regresado es: %@", resultado);
    NSString * mensaje;
    if([resultado isEqualToString:@"Error"]){
        mensaje = NSLocalizedString(@"sentimosRedimirCodigo", @" ");
        [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"0"]){
        self.datosUsuario.datosPago.statusPago = @"PAGADO";
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        mensaje = NSLocalizedString(@"exitoCodRedimir", @" ");
        self.msjCodigoRedimido.text = mensaje;
        [self.view addSubview:self.viewContenidoRedimir];
    }else if([resultado isEqualToString:@"-1"]){
        mensaje = NSLocalizedString(@"paCodeError1", @" ");
        [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-2"]){
        mensaje = NSLocalizedString(@"paCodeError2", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-3"]){
        mensaje = NSLocalizedString(@"paCodeError3", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-4"]){
        mensaje = NSLocalizedString(@"paCodeError4", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-5"]){
        mensaje = NSLocalizedString(@"paCodeError5", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-6"]){
        mensaje = NSLocalizedString(@"paCodeError6", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-9"]){
        mensaje = NSLocalizedString(@"paCodeError9", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-10"]){
        mensaje = NSLocalizedString(@"paCodeError10", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-11"]){
        mensaje = NSLocalizedString(@"paCodeError11", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-12"]){
        mensaje = NSLocalizedString(@"paCodeError12", @" ");
         [self alertMensajeError:mensaje];
    }else if([resultado isEqualToString:@"-13"]){
        mensaje = NSLocalizedString(@"paCodeError13", @" ");
         [self alertMensajeError:mensaje];
    }
    
     [self performSelectorOnMainThread:@selector(ocultarActivityRedimir) withObject:Nil waitUntilDone:YES];
    
}

-(void)alertMensajeError:(NSString *)msj{
    AlertView *alert = [AlertView initWithDelegate:self message:msj andAlertViewType:AlertViewTypeInfo];
    [alert show];


}


-(void)redimirWS{
    WS_RedimirCodigo *redimir = [[WS_RedimirCodigo alloc] init];
    [redimir setRedimirCodigoDelegate:self];
    [redimir redimeElCodigo: self.txtPromocion.text ];
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
	[self.txtPromocion resignFirstResponder];
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
       [self.txtPromocion resignFirstResponder];
        if(self.datosUsuario.dominio == nil || [self.datosUsuario.dominio isEqualToString:@""] || (self.datosUsuario.dominio == (id)[NSNull null]) || [CommonUtils validarEmail:self.datosUsuario.dominio] || [self.datosUsuario.dominio isEqualToString:@"(null)"]){
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"msjDominioPublicar", Nil) andAlertViewType:AlertViewTypeQuestion];
            [alert show];
            
        }
        
            self.datosUsuario = [DatosUsuario sharedInstance];
            UIFont * customFont = [UIFont fontWithName:@"Avenir-Book" size:16];
            UILabel *dominio;
            if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
                dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 375, 100)];
           
            }else if(IS_IPAD){
                dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, 768, 100)];
            }else{
                dominio = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 320, 100)];
                
            }
        
        UILabel *fechas;
        fechas.font = customFont;
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            fechas = [[UILabel alloc]initWithFrame:CGRectMake(0, 120,375, 100)];
            [fechas setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
            [dominio setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
     
        }else if(IS_IPAD){
            fechas = [[UILabel alloc]initWithFrame:CGRectMake(184, 260,400, 200)];
            [fechas setFont: [UIFont fontWithName:@"Avenir-Book" size:24]];
            [dominio setFont: [UIFont fontWithName:@"Avenir-Book" size:24]];
        }else{
            fechas = [[UILabel alloc]initWithFrame:CGRectMake(0, 150,320, 100)];
            [fechas setFont: [UIFont fontWithName:@"Avenir-Book" size:16]];
            dominio.font = customFont;
        }
        
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                self.arregloDominios = self.datosUsuario.dominiosUsuario;
                dominio.text = @"";
                for(int i= 0; i< [self.arregloDominios count]; i++){
                    DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                    if([usuarioDom.domainType isEqualToString:@"tel"]){
                        if([usuarioDom.vigente isEqualToString:@"SI"] || [usuarioDom.vigente isEqualToString:@"si"]){
                            dominio.text = [NSString stringWithFormat:@"Your website\n\n www.%@.tel",self.datosUsuario.dominio] ;
                            if(usuarioDom.fechaIni && ![usuarioDom.fechaIni isEqualToString:@""] && ![usuarioDom.fechaIni isEqualToString:@"(null)"] && usuarioDom.fechaIni != nil){
                                fechas.text = [NSString stringWithFormat: @"Period of validity\n From %@ to %@", usuarioDom.fechaIni, usuarioDom.fechaFin ];
                            }else{
                                fechas.text = [NSString stringWithFormat: @"Period of validity\n From %@ to %@", self.datosUsuario.fechaDominioIni, self.datosUsuario.fechaDominioFin ];
                            }
                        }else if(usuarioDom.fechaIni == nil || [usuarioDom.fechaIni length] <= 0){
                            [self etiquetasBotonesYaComprado];
                        }else{
                            [self etiquetasBotonesDeCompra];
                            dominio.text = [NSString stringWithFormat:@"Your website\n\nwww.infomovil.com/%@",usuarioDom.domainName] ;
                        }
                        
                    }
                }
                if([dominio.text isEqualToString:@""]){
                    self.arregloDominios = self.datosUsuario.dominiosUsuario;
                    for(int i= 0; i< [self.arregloDominios count]; i++){
                        DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                        if([usuarioDom.domainType isEqualToString:@"recurso"]){
                            if(usuarioDom.domainName == nil || [usuarioDom.domainName length] <= 0 || [usuarioDom.domainName isEqualToString:@""]){usuarioDom.domainName = self.datosUsuario.dominio;}
                            dominio.text = [NSString stringWithFormat:@"Your website\n\nwww.infomovil.com/%@",usuarioDom.domainName] ;
                            self.arregloDominios = self.datosUsuario.dominiosUsuario;
                            int contador = 0;
                            for(int i= 0; i< [self.arregloDominios count]; i++){
                                DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                                if([usuarioDom.domainType isEqualToString:@"tel"]){
                                    if( usuarioDom.fechaIni == nil || [usuarioDom.fechaIni length] <= 0){
                                        contador++;
                                    }
                                }
                            }
                            if(contador == 0){
                                [self etiquetasBotonesDeCompra];
                            }
                            
                        }
                    }
                }

            }else{
                self.arregloDominios = self.datosUsuario.dominiosUsuario;
                dominio.text = @"";
                for(int i= 0; i< [self.arregloDominios count]; i++){
                    DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                    if([usuarioDom.domainType isEqualToString:@"tel"]){
                        if([usuarioDom.vigente isEqualToString:@"SI"] || [usuarioDom.vigente isEqualToString:@"si"]){
                            dominio.text = [NSString stringWithFormat:@"Tu sitio web\n\n www.%@.tel",self.datosUsuario.dominio] ;
                               if(usuarioDom.fechaIni && ![usuarioDom.fechaIni isEqualToString:@""] && ![usuarioDom.fechaIni isEqualToString:@"(null)"] && usuarioDom.fechaIni != nil){
                               fechas.text = [NSString stringWithFormat: @"Vigencia del dominio\n Del %@ al %@", usuarioDom.fechaIni, usuarioDom.fechaFin ];
                           }else{
                               fechas.text = [NSString stringWithFormat: @"Vigencia del dominio\n Del %@ al %@", self.datosUsuario.fechaDominioIni, self.datosUsuario.fechaDominioFin ];
                           }
                    }else if(usuarioDom.fechaIni == nil || [usuarioDom.fechaIni length] <= 0){
                        [self etiquetasBotonesYaComprado];
                    }else{
                        [self etiquetasBotonesDeCompra];
                        dominio.text = [NSString stringWithFormat:@"Tu sitio web\n\nwww.infomovil.com/%@",usuarioDom.domainName] ;
                    }
                    
                    }
                }
                if([dominio.text isEqualToString:@""]){
                    self.arregloDominios = self.datosUsuario.dominiosUsuario;
                    for(int i= 0; i< [self.arregloDominios count]; i++){
                        DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                        if([usuarioDom.domainType isEqualToString:@"recurso"]){
                            if(usuarioDom.domainName == nil || [usuarioDom.domainName length] <= 0 || [usuarioDom.domainName isEqualToString:@""]){usuarioDom.domainName = self.datosUsuario.dominio;}
                            dominio.text = [NSString stringWithFormat:@"Tu sitio web\n\nwww.infomovil.com/%@",usuarioDom.domainName] ;
                            self.arregloDominios = self.datosUsuario.dominiosUsuario;
                            int contador = 0;
                            for(int i= 0; i< [self.arregloDominios count]; i++){
                                DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
                                if([usuarioDom.domainType isEqualToString:@"tel"]){
                                    if( usuarioDom.fechaIni == nil || [usuarioDom.fechaIni length] <= 0){
                                        contador++;
                                    }
                                }
                            }
                            if(contador == 0){
                                [self etiquetasBotonesDeCompra];
                            }
    
                        }
                    }
                }
            }
        
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
            
            if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
                [self.scrollContenido scrollRectToVisible:CGRectMake(375, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
          
            }else if(IS_IPAD){
                [self.scrollContenido scrollRectToVisible:CGRectMake(768, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
            }else{
                [self.scrollContenido scrollRectToVisible:CGRectMake(320, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
            }
    }else if(self.selector.selectedSegmentIndex == 2){
       [self.txtPromocion becomeFirstResponder];
        
        if(IS_IPAD){
            self.labelPromocion.frame = CGRectMake(184, 140, 400, 60);
            self.txtPromocion.frame = CGRectMake(184, 240, 400, 40);
            self.Enviar.frame = CGRectMake(259, 340, 250, 40);
            self.labelPromocion.font = [UIFont fontWithName:@"Avenir-Book" size:24];
            self.txtPromocion.font = [UIFont fontWithName:@"Avenir-Book" size:24];
            self.Enviar.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:24];
            [self.viewEnviarCodigo setFrame:CGRectMake(1536, 0, 768,600)];
            [self.scrollContenido scrollRectToVisible:CGRectMake(1536, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
         }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
             self.labelPromocion.frame = CGRectMake(37, 80, 300, 40);
             self.txtPromocion.frame = CGRectMake(37, 130, 300, 35);
             self.Enviar.frame = CGRectMake(62, 200, 250, 35);
             [self.viewEnviarCodigo setFrame:CGRectMake(750, 0, 375,450)];
             [self.scrollContenido scrollRectToVisible:CGRectMake(750, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
         }else{
              [self.viewEnviarCodigo setFrame:CGRectMake(640, 0, 320,350)];
             [self.scrollContenido scrollRectToVisible:CGRectMake(640, 0, self.scrollContenido.frame.size.width, self.scrollContenido.frame.size.height) animated:YES];
         
         }
     
        [self.scrollContenido addSubview:self.viewEnviarCodigo];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text length] == 0) {
        return NO;
    }
    [textField resignFirstResponder];
    return YES;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



-(void) mostrarActivity {
    NSLog(@"CUANTAS VECES ENTRA AKI!!!!");
    self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}

-(void)ocultarActivityRedimir{
    [NSThread sleepForTimeInterval:1];
    [self.alerta hide];

}

-(void) ocultarActivity {
    noSeRepiteOprimirElBoton = YES;
    
   
       if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            [self.MensajePlanProComprado setFrame:CGRectMake(37, 60, 300, 150)];
        }else if(IS_IPAD){
            [self.MensajePlanProComprado setFrame:CGRectMake(184, 10, 400, 400)];
            [self.MensajePlanProComprado setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
            
        }
       self.MensajePlanProComprado.text = [NSString stringWithFormat:NSLocalizedString(@"cuentaConPlanPro", nil),self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
        
    [NSThread sleepForTimeInterval:1];
    [self.alerta hide];
    
}

- (IBAction)comprarDominioBtn:(id)sender {
    self.datosUsuario.voyAComprarTel = @"si";
    NombraCompraDominio *comparte = [[NombraCompraDominio alloc] initWithNibName:@"NombraCompraDominio" bundle:Nil];
    [self.navigationController pushViewController:comparte animated:YES];
    
}

-(void)accionAceptar2{
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"FailedTransactionNotification"]){
        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
        self.datosUsuario.descripcionDominio = @"";
        noSeRepiteOprimirElBoton = YES;
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
      
    }
    else if ([[notification name] isEqualToString:@"CompleteTransactionNotification"]){
       
        if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 1 MES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 1 Mes" withValue:@""];
            [[Appboy sharedInstance] logPurchase:@"PP1"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"65.00"]];
        }else if([self.datosUsuario.datosPago.plan isEqualToString:@"PLAN PRO 12 MESES"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Plan Pro 12 Meses" withValue:@""];
            [[Appboy sharedInstance] logPurchase:@"PP12"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"599.00"]];
        }
        
        self.MensajePlanProComprado.text = [NSString stringWithFormat:NSLocalizedString(@"cuentaConPlanPro", nil),self.datosUsuario.fechaInicial, self.datosUsuario.fechaFinal];
        self.viewCompraPlanPro.hidden = YES;
        self.viewPlanProComprado.hidden = NO;
        self.datosUsuario.datosPago.statusPago = @"PAGADO";
        self.datosUsuario.descripcionDominio = @"";
        [self compra];
        
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
      [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }
    
    
}

-(void)accionSi{
    if(self.datosUsuario.eligioTemplate){
        if( [self perfilEditado]) {
            NombrarViewController *comparte = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:Nil];
            [self.navigationController pushViewController:comparte animated:YES];
        }else{
            MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
            [self.navigationController pushViewController:comparte animated:YES];
            AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"editaPagina", Nil) andAlertViewType:AlertViewTypeInfo];
            [vistaNotificacion show];
        }
       
    }else{
        MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
        [self.navigationController pushViewController:comparte animated:YES];
 
        AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"eligeTemplate", Nil) andAlertViewType:AlertViewTypeInfo];
        [vistaNotificacion show];
    }

}

-(void)accionNo{
    self.selector.selectedSegmentIndex = 0;
    [self tipoCuenta:self];
    
}

-(void) errorConsultaWS {
    NSLog(@"DEBE QUITAR LA ALARMA");
    noSeRepiteOprimirElBoton = YES;
    [NSThread sleepForTimeInterval:1];
    [self.alerta hide];
}

-(void)etiquetasBotonesDeCompra{
    UILabel *etiquetaCompraDominio = [[UILabel alloc]init];
    UILabel *etiquetaCompraDominioSub = [[UILabel alloc]init];
    UIButton *btnCompraDominio = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    UIImageView* imgLineDominio = [[UIImageView alloc] init];

    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        imgLineDominio.frame = CGRectMake(47, 190, 280, 2);
        etiquetaCompraDominio.frame = CGRectMake(47, 250,280 ,70 );
        etiquetaCompraDominioSub.frame = CGRectMake(47, 360,280 ,40 );
        [btnCompraDominio setFrame:CGRectMake(87, 440, 200, 35)];
        etiquetaCompraDominio.font = [UIFont fontWithName:@"Avenir-Medium" size:17];
        etiquetaCompraDominioSub.font = [UIFont fontWithName:@"Avenir-Book" size:17];
        [btnCompraDominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
    }else if(IS_IPAD){
        imgLineDominio.frame = CGRectMake(184, 340, 400, 2);
        etiquetaCompraDominio.frame = CGRectMake(84, 400,600 ,120 );
        etiquetaCompraDominioSub.frame = CGRectMake(84, 530, 600, 40);
        [btnCompraDominio setFrame:CGRectMake(259, 630, 250, 40)];
        etiquetaCompraDominio.font = [UIFont fontWithName:@"Avenir-Medium" size:24];
        etiquetaCompraDominioSub.font = [UIFont fontWithName:@"Avenir-Book" size:24];
        [btnCompraDominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
    }else if(IS_IPHONE_4){
        imgLineDominio.frame = CGRectMake(20, 120, 280, 2);
        etiquetaCompraDominio.frame = CGRectMake(20, 140,280 ,80 );
        etiquetaCompraDominioSub.frame = CGRectMake(20, 220,280 ,40 );
        [btnCompraDominio setFrame:CGRectMake(60, 270, 200, 35)];
        etiquetaCompraDominio.font = [UIFont fontWithName:@"Avenir-Medium" size:17];
        etiquetaCompraDominioSub.font = [UIFont fontWithName:@"Avenir-Book" size:17];
        [btnCompraDominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
        
    }else{
        imgLineDominio.frame = CGRectMake(20, 145, 280, 2);
        etiquetaCompraDominio.frame = CGRectMake(20, 190,280 ,80 );
        etiquetaCompraDominioSub.frame = CGRectMake(20, 290,280 ,40 );
        [btnCompraDominio setFrame:CGRectMake(60, 350, 200, 35)];
        etiquetaCompraDominio.font = [UIFont fontWithName:@"Avenir-Medium" size:18];
        etiquetaCompraDominioSub.font = [UIFont fontWithName:@"Avenir-Book" size:18];
        [btnCompraDominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
    }
    [imgLineDominio setImage:[UIImage imageNamed:@"lineCompraDominio"]];
    [self.vistaDominio addSubview:imgLineDominio];
    
    [etiquetaCompraDominio setText:NSLocalizedString(@"leyendaCompraDominio", Nil)];
    etiquetaCompraDominio.numberOfLines = 6;
    etiquetaCompraDominio.adjustsFontSizeToFitWidth = YES;
    etiquetaCompraDominio.backgroundColor = [UIColor clearColor];
    etiquetaCompraDominio.textColor = [UIColor colorWithRed:47.0f/255.0f
                                                      green:163.0f/255.0f
                                                       blue:152.0f/255.0f
                                                      alpha:1.0f];
    etiquetaCompraDominio.textAlignment = NSTextAlignmentCenter;
    [self.vistaDominio addSubview:etiquetaCompraDominio];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [etiquetaCompraDominioSub setText:[prefs stringForKey:@"precioDominioTel"]];
    etiquetaCompraDominioSub.numberOfLines = 6;
    etiquetaCompraDominioSub.adjustsFontSizeToFitWidth = YES;
    etiquetaCompraDominioSub.backgroundColor = [UIColor clearColor];
    etiquetaCompraDominioSub.textColor = [UIColor colorWithRed:47.0f/255.0f
                                                      green:163.0f/255.0f
                                                       blue:152.0f/255.0f
                                                      alpha:1.0f];
    etiquetaCompraDominioSub.textAlignment = NSTextAlignmentCenter;
    [self.vistaDominio addSubview:etiquetaCompraDominioSub];
    
    
    [btnCompraDominio setTitle:NSLocalizedString(@"comprarDominioTel", Nil) forState:UIControlStateNormal];
    [btnCompraDominio addTarget:self action:@selector(comprarDominioBtn:)forControlEvents:UIControlEventTouchUpInside];
    btnCompraDominio.backgroundColor = [UIColor colorWithRed:47.0f/255.0f
                                                       green:163.0f/255.0f
                                                        blue:153.0f/255.0f
                                                       alpha:1.0f];
    [btnCompraDominio setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    btnCompraDominio.layer.cornerRadius = 10;
    [self.vistaDominio addSubview:btnCompraDominio];

}
-(void)etiquetasBotonesYaComprado{
    UILabel *etiquetaCompraDominio = [[UILabel alloc]init];
   // UILabel *etiquetaCompraDominioSub = [[UILabel alloc]init];
    UIButton *btnCompraDominio = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    UIImageView* imgLineDominio = [[UIImageView alloc] init];
    
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        imgLineDominio.frame = CGRectMake(37, 185, 300, 2);
        etiquetaCompraDominio.frame = CGRectMake(47, 250,280 ,40 );
      //  etiquetaCompraDominioSub.frame = CGRectMake(47, 250,280 ,40 );
        [btnCompraDominio setFrame:CGRectMake(87, 300, 200, 35)];
        etiquetaCompraDominio.font = [UIFont fontWithName:@"Avenir-Medium" size:18];
     //   etiquetaCompraDominioSub.font = [UIFont fontWithName:@"Avenir-Book" size:16];
        [btnCompraDominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
    }else if(IS_IPAD){
        imgLineDominio.frame = CGRectMake(184, 360, 400, 2);
        etiquetaCompraDominio.frame = CGRectMake(84, 450,600 ,80 );
      //  etiquetaCompraDominioSub.frame = CGRectMake(84, 500, 600, 40);
        [btnCompraDominio setFrame:CGRectMake(259, 600, 250, 40)];
        etiquetaCompraDominio.font = [UIFont fontWithName:@"Avenir-Medium" size:24];
      //  etiquetaCompraDominioSub.font = [UIFont fontWithName:@"Avenir-Book" size:20];
        [btnCompraDominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
    }else{
        imgLineDominio.frame = CGRectMake(20, 160, 280, 2);
        etiquetaCompraDominio.frame = CGRectMake(20, 220,280 ,40 );
       // etiquetaCompraDominioSub.frame = CGRectMake(20, 260,280 ,40 );
        [btnCompraDominio setFrame:CGRectMake(60, 270, 200, 35)];
        etiquetaCompraDominio.font = [UIFont fontWithName:@"Avenir-Medium" size:18];
      //  etiquetaCompraDominioSub.font = [UIFont fontWithName:@"Avenir-Book" size:16];
        [btnCompraDominio.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
    }
    [imgLineDominio setImage:[UIImage imageNamed:@"lineCompraDominio"]];
    [self.vistaDominio addSubview:imgLineDominio];
    
    [etiquetaCompraDominio setText:NSLocalizedString(@"dominioComprado", Nil)];
    etiquetaCompraDominio.numberOfLines = 3;
    etiquetaCompraDominio.adjustsFontSizeToFitWidth = YES;
    etiquetaCompraDominio.backgroundColor = [UIColor clearColor];
    etiquetaCompraDominio.textColor = [UIColor colorWithRed:47.0f/255.0f
                                                      green:163.0f/255.0f
                                                       blue:152.0f/255.0f
                                                      alpha:1.0f];
    etiquetaCompraDominio.textAlignment = NSTextAlignmentCenter;
    [self.vistaDominio addSubview:etiquetaCompraDominio];
    
    [btnCompraDominio setTitle:NSLocalizedString(@"registrarDominioComprado", Nil) forState:UIControlStateNormal];
    [btnCompraDominio addTarget:self action:@selector(comprarDominioBtn:)forControlEvents:UIControlEventTouchUpInside];
    btnCompraDominio.backgroundColor = [UIColor colorWithRed:47.0f/255.0f
                                                       green:163.0f/255.0f
                                                        blue:153.0f/255.0f
                                                       alpha:1.0f];
    [btnCompraDominio setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    btnCompraDominio.layer.cornerRadius = 10;
    [self.vistaDominio addSubview:btnCompraDominio];
    
}


-(BOOL)validaCodigo{
    NSString *myRegex = @"[A-Z0-9a-z]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    NSString *string = self.txtPromocion.text;
    BOOL valid = [myTest evaluateWithObject:string];
    if(valid){
        return YES;
    }else{
        return NO;
    }
    return NO;

}

-(BOOL) perfilEditado {
    BOOL fueEditado = NO;
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([self.datosUsuario.arregloEstatusEdicion count] > 0) {
        for (int i = 0; i < [self.datosUsuario.arregloEstatusEdicion count]; i++) {
            if ([[self.datosUsuario.arregloEstatusEdicion objectAtIndex:i]  isEqual: @YES]) {
                fueEditado = YES;
                break;
            }
        }
    }
    return fueEditado;
}




- (IBAction)aceptarAct:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self viewWillAppear:YES];
    [self.viewContenidoRedimir removeFromSuperview];
    
}
@end


