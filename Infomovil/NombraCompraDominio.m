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
                                                 name:@"CompleteTransactionNotificationDominio"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"FailedTransactionNotificationDominio"
                                               object:nil];
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"FailedTransactionNotificationDominio"]){
        self.datosUsuario.datosPago.statusPago = @"INTENTO PAGO";
        self.datosUsuario.descripcionDominio = @"";
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
            [NSThread sleepForTimeInterval:1];
            [self.alertActivity hide];
    }
    else if ([[notification name] isEqualToString:@"CompleteTransactionNotificationDominio"]){
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Dominio Tel" withValue:@""];
            [[Appboy sharedInstance] logPurchase:@"TEL"
                                      inCurrency:@"MXN"
                                         atPrice:[[NSDecimalNumber alloc] initWithString:@"199.00"]];
        self.datosUsuario.datosPago.statusPago = @"PAGADO";
        self.datosUsuario.descripcionDominio = @"";
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Pago";
        [self removeAnimate];
        // IRC Validar la compra!!
        [self compra];
    }else if (self.alertActivity){
            [NSThread sleepForTimeInterval:1];
            [self.alertActivity hide];
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

- (IBAction)comprarPopUpAct:(id)sender {
    NSLog(@"SOLO DEBE OPRIMIRSE UNA VEZ!!!!");
    if ([CommonUtils hayConexion]) {
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(compraProductoTel) withObject:Nil];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    
}

- (IBAction)cerrarPupUpAct:(id)sender {
     [self removeAnimate];
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
    
    NSLog(@"EL VALOR DE OPERACIONWS ES: %d", self.operacionWS);
    if (self.operacionWS == 1) {
        if (existeDominio) {
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
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noDisponible", @" ") dominio:nil andAlertViewType:AlertViewTypeInfo];
            
            [alert show];
        }
    }
   
}

// Este método es para cambiar el status en el server a INTENTO DE PAGO Y ME REGRESE UN FOLIO
-(void)compra{
    WS_CompraDominio *compra = [[WS_CompraDominio alloc] init];
    [compra setCompraDominioDelegate:self];
    //plan
    [compra compraDominioTel];
    
}

-(void)resultadoCompraDominio:(BOOL)estado{
    self.datosUsuario = [DatosUsuario sharedInstance];
    if(estado == YES && [self.datosUsuario.datosPago.statusPago isEqualToString: @"INTENTO PAGO"]){
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
            [self showAnimate];
        }else{
            self.datosUsuario.dominioTel = self.txtNombreSitio.text;
            [NSThread sleepForTimeInterval:1];
            [self.alertActivity hide];
            [self removeAnimate];
            PublicarViewController *cuenta = [[PublicarViewController alloc] initWithNibName:@"PublicarViewController" bundle:Nil];
            [self.navigationController pushViewController:cuenta animated:YES];
        
        }
        
    }else if([self.datosUsuario.datosPago.statusPago isEqualToString: @"PAGADO"]){
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
        [self removeAnimate];
        self.datosUsuario.dominioTel = self.txtNombreSitio.text;
        PublicarViewController *cuenta = [[PublicarViewController alloc] initWithNibName:@"PublicarViewController" bundle:Nil];
        [self.navigationController pushViewController:cuenta animated:YES];
    }else{
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", Nil) message:NSLocalizedString(@"errorCompra", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
    }
}

- (void) compraProductoTel{
    self.datosUsuario = [DatosUsuario sharedInstance];
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



- (void)showAnimate
{
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    [self navigationController].navigationBarHidden = YES;
    [self.vistaInferior setHidden:YES];
    self.viewCenterPopUp.layer.cornerRadius = 10;
    self.comprarPopUp.layer.cornerRadius = 10;
    self.viewCenterPopUp.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.dominioPopUp.text = [NSString stringWithFormat:@"www.%@.tel",self.txtNombreSitio.text];
    self.msjPopUp.text = NSLocalizedString(@"estaDisponiblePublica", Nil);
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.viewPopUp setFrame:CGRectMake(0, 0, 375, 667)];
        [self.viewCenterPopUp setFrame:CGRectMake(47, 100, 280, 280)];
    }else if(IS_IPAD){
        [self.viewPopUp setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.viewCenterPopUp setFrame:CGRectMake(224, 200, 320, 320)];
        [self.dominioPopUp setFrame:CGRectMake(10, 62, 300, 24)];
        [self.msjPopUp setFrame:CGRectMake(10, 98, 300, 85)];
        [self.comprarPopUp setFrame:CGRectMake(30, 200, 260, 45)];
        [self.cerrarPopUp setFrame:CGRectMake(240, 20, 46, 30)];
    }else{
        [self.viewPopUp setFrame:CGRectMake(0, 0, 320, 568)];
    }
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView animateWithDuration:.40 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        [self.view addSubview:self.viewPopUp];
    }];
}

- (void)removeAnimate
{
    [self navigationController].navigationBarHidden = NO;
    [self.vistaInferior setHidden:NO];
    [UIView animateWithDuration:.40 animations:^{
        self.viewCenterPopUp.transform = CGAffineTransformMakeScale(1, 1);
        [self.viewPopUp removeFromSuperview];
    }];
}
































@end
