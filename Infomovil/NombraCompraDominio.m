//
//  NombraCompraDominio.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/4/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "NombraCompraDominio.h"
#import "CuentaViewController.h"
#import "WS_HandlerDominio.h"
#import "PublicarViewController.h"
#import <StoreKit/StoreKit.h>
#import "RageIAPHelper.h"
#import "WS_CompraDominio.h"


@implementation NombraCompraDominio

BOOL existeDominio;
NSString *respuestaPublicar;
-(void)viewDidLoad{
 [super viewDidLoad];
    
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        self.scrollNombrar.frame = CGRectMake(0, 0, 375, 667);
        self.etiquetaNombraSitio.frame = CGRectMake(30, 40, 315, 40);
        self.etiqutawww.frame = CGRectMake(20, 110, 50, 40);
        self.txtNombreSitio.frame = CGRectMake(71, 115, 235, 30);
        self.etiquetatel.frame = CGRectMake(305, 110, 40, 40);
        self.btnBuscar.frame = CGRectMake(87, 200, 200, 40);
    }else if(IS_IPAD){
        self.scrollNombrar.frame = CGRectMake(0, 0, 768, 1024);
        self.etiquetaNombraSitio.frame = CGRectMake(84, 80, 600, 80);
        self.etiqutawww.frame = CGRectMake(134, 180, 66, 40);
        self.txtNombreSitio.frame = CGRectMake(200, 180, 368, 40);
        self.etiquetatel.frame = CGRectMake(568, 180, 66, 40);
        self.btnBuscar.frame = CGRectMake(234, 280, 300, 40);
        [self.btnBuscar.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
        [self.etiquetatel setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
        [self.etiqutawww setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
        [self.etiquetaNombraSitio setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
    }else if(IS_IPHONE_4){
        self.scrollNombrar.frame = CGRectMake(0, 0, 320, 480);
        self.etiquetaNombraSitio.frame = CGRectMake(10, 20, 300, 40);
        self.etiqutawww.frame = CGRectMake(10, 80, 40, 40);
        self.txtNombreSitio.frame = CGRectMake(51, 80, 220, 30);
        self.etiquetatel.frame = CGRectMake(270, 80, 40, 40);
        self.btnBuscar.frame = CGRectMake(60, 150, 200, 40);
        
    }
    existeDominio = NO;
    self.operacionWS = 0;
    self.btnBuscar.layer.cornerRadius = 10.0f;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"comprarDominioTelHeader", @" ") nombreImagen:@"roja.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"comprarDominioTelHeader", @" ") nombreImagen:@"plecaroja.png"];
    }
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    self.navigationItem.rightBarButtonItem = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CompleteTransactionNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"FailedTransactionNotification"
                                               object:nil];
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    if ([[notification name] isEqualToString:@"FailedTransactionNotification"]){
        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
        self.datosUsuario.descripcionDominio = @"";
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
        
    }
    else if ([[notification name] isEqualToString:@"CompleteTransactionNotification"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Dominio" withValue:@""];
            [[Appboy sharedInstance] logPurchase:@"Tel"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"199.00"]];
        self.datosUsuario.datosPago.statusPago = @"PAGADO";
        self.datosUsuario.descripcionDominio = @"";
        [self compra];
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
        PublicarViewController *cuenta = [[PublicarViewController alloc] initWithNibName:@"PublicarViewController" bundle:Nil];
        [self.navigationController pushViewController:cuenta animated:YES];
    }
    
   
}



-(void) viewWillAppear:(BOOL)animated {
    self.datosUsuario = [DatosUsuario sharedInstance];
     self.etiquetaNombraSitio.text = NSLocalizedString(@"nombrarLabel2", @" ");
    [self.btnBuscar setTitle:NSLocalizedString(@"buscar", @" ") forState:UIControlStateNormal];
    [self.txtNombreSitio becomeFirstResponder];
    [self obtenerProductos];
}

-(IBAction)regresar:(id)sender {
    CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
    [self.navigationController pushViewController:cuenta animated:YES];

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self buscar:nil];
    return YES;
}

-(BOOL) validarDominio {
    BOOL dominioCorrecto;
    if (self.txtNombreSitio.text.length > 0) {
        if ([CommonUtils validarDominio:self.txtNombreSitio.text]) {
            dominioCorrecto = YES;
        }
        else {
            dominioCorrecto = NO;
        }
    }
    else {
        dominioCorrecto = NO;
    }
    return dominioCorrecto;
}

- (IBAction)buscar:(id)sender {
    
    [[self view] endEditing:YES];
    if ([self validarDominio]) {
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(checaDominio) withObject:Nil];
            
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"errorDominio", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}

-(void) mostrarActivity {
    self.alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgNombrarSitio", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertActivity show];
}

-(void) ocultarActivity {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    AlertView *alert;
    NSLog(@"EL VALOR DE OPERACIONWS ES: %d", self.operacionWS);
    if (self.operacionWS == 1) {
        if (existeDominio) {
              /*  PublicarViewController *publicar = [[PublicarViewController alloc] initWithNibName:@"PublicarViewController" bundle:Nil];
                [self.navigationController pushViewController:publicar animated:YES];
                */
            if([CommonUtils hayConexion]){
                @try {
                    if([_products count] <= 0){
                        [self obtenerProductos];
                    }else{
                        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                        for(int i = 0 ; [_products count] > 0; i++){
                            SKProduct *product = _products[i];
                            if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.dominiotel"]){
#if DEBUG
                                NSLog(@"Comprando item 0: %@", product.productIdentifier);
#endif
                                self.datosUsuario.datosPago.plan =@"DOMINIO TEL";
                                self.datosUsuario.datosPago.comision = @"27";
                                self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
                                self.datosUsuario.datosPago.tipoCompra = @"tel";
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
        }
        else {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noDisponible", @" ") dominio:nil andAlertViewType:AlertViewTypeInfo];
            
            [alert show];
        }
    }
}

// Este método es para cambiar el status en el server a INTENTO DE PAGO Y ME REGRESE UN FOLIO
-(void)compra{
    WS_CompraDominio *compra = [[WS_CompraDominio alloc] init];
    [compra setCompraDominioDelegate:self];
    //plan
    [compra compraDominio];
    
}

-(void)resultadoCompraDominio:(BOOL)estado{
    if(estado == YES && [self.datosUsuario.datosPago.statusPago isEqualToString: @"INTENTO PAGO"]){
       
            [self compraProductoTel];
        
    }else if([self.datosUsuario.datosPago.statusPago isEqualToString: @"PAGADO"]){
        return;
    }else{
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", Nil) message:NSLocalizedString(@"errorCompra", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
    }
}

- (void) compraProductoTel{
    
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
                    if([product.productIdentifier isEqualToString:@"com.infomovil.infomovil.dominiotel"]){
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



-(void) checaDominio {
    self.operacionWS = 1;
    WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
    [dominioHandler setWSHandlerDelegate:self];
    [dominioHandler consultaDominioCompra:self.txtNombreSitio.text];
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.operacionWS == 1) {
        if ([resultado isEqualToString:@"No existe"]) {
            existeDominio = YES;
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
        else {
            existeDominio = NO;
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
    
    }else{
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }
      
}

-(void) errorToken {
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorDominio) withObject:Nil waitUntilDone:YES];
}

-(void) errorDominio {
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    [AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo];
}




































@end
