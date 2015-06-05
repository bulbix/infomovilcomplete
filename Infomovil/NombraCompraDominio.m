//
//  NombraCompraDominio.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/4/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "NombraCompraDominio.h"
#import "CuentaViewController.h"
@implementation NombraCompraDominio


-(void)viewDidLoad{

 [super viewDidLoad];
    
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
       
    }else if(IS_IPAD){
   
        
    }else{
      
    }
    
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

}


-(void) viewWillAppear:(BOOL)animated {
    self.datosUsuario = [DatosUsuario sharedInstance];
   
}

-(IBAction)regresar:(id)sender {
    CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
    [self.navigationController pushViewController:cuenta animated:YES];

}
/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)verificarDominio:(UIButton *)sender {
    
    [[self view] endEditing:YES];
    if ([self validarDominio]) {
        
        //self.nombreDelDominio.text = self.nombreDominio.text;
        
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            textoDominio = self.nombreDominio.text;
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



-(BOOL) validarDominio {
    BOOL dominioCorrecto;
    if (self.nombreDominio.text.length > 0) {
        if ([CommonUtils validarDominio:self.nombreDominio.text]) {
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



-(void) mostrarActivity {
    alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgNombrarSitio", Nil) andAlertViewType:AlertViewTypeActivity];
    [alertActivity show];
}

-(void) ocultarActivity {
    if (alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [alertActivity hide];
    }
    AlertView *alert;
    if (operacionWS == 1) {
        if (existeDominio) {
            self.datosUsuario = [DatosUsuario sharedInstance];
            self.modifico = YES;
            self.datosUsuario.dominio = self.nombreDominio.text;
            
            if([self.datosUsuario.tipoDeUsuario isEqualToString:@"normal"]){
                [self showAnimate];
            }else if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
                PublicarViewController *publicar = [[PublicarViewController alloc] initWithNibName:@"PublicarViewController" bundle:Nil];
                [self.navigationController pushViewController:publicar animated:YES];
            }else{
                [self showAnimate];
            }
        }
        else {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noDisponible", @" ") dominio:nil andAlertViewType:AlertViewTypeInfo];
            
            [alert show];
        }
    }else if(operacionWS == 12) {
        NSLog(@"ENTRO A OCULTAR ACTIVITY CON OPERACION 12 Y statusRespuesta %d",RespuestaStatusExistente2);
        self.datosUsuario = [DatosUsuario sharedInstance];
        AlertView *alert;
        if (statusRespuesta == RespuestaStatusExistente2) {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"txtErrorDomainNombrar", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else if (statusRespuesta == RespuestaStatusExito2) {
            
            
            
        }else if (statusRespuesta == RespuestaStatusPendiente2) {
            self.datosUsuario.nombroSitio = YES;
            creoDominio = YES;
            
            alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeProcesoPublicacion", Nil) andAlertViewType:AlertViewTypeInfo2];
            [alert show];
            
        }
        else {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"errorCrearDominio", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        
    }
    
}






-(void) checaDominio {
    operacionWS = 1;
    WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
    [dominioHandler setWSHandlerDelegate:self];
    [dominioHandler consultaDominio:textoDominio];
}

-(void) checaDominioPublicacion {
    operacionWS = 11;
    WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
    [dominioHandler setWSHandlerDelegate:self];
    [dominioHandler consultaDominio:textoDominio];
}

-(void) crearDominio { NSLog(@"Mando a llamar a CREAR DOMINIO");
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSString *dominioAux;
    if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
        dominioAux = @"tel";
    }else if([self.datosUsuario.tipoDeUsuario isEqualToString:@"normal"]){
        dominioAux = @"recurso";
        
    }
    
    
    NSLog(@"VALORES: %@ - %@ - %@ - %@ - %@ - %li", self.datosUsuario.email, self.datosUsuario.emailUsuario ,self.nombreDominio.text,self.datosUsuario.passwordUsuario, dominioAux, (long)self.datosUsuario.idDominio);
    operacionWS = 12;
    WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
    [dominioHandler setWSHandlerDelegate:self];
    [dominioHandler crearUsuario:self.datosUsuario.emailUsuario conNombre:self.nombreDominio.text password:self.datosUsuario.passwordUsuario status:@"1" nombre:@"xxx" direccion1:@"xxx" direccion2:@"xxx" pais:@"0" codigoPromocion:@"" tipoDominio:dominioAux idDominio:[NSString stringWithFormat:@"%li", (long)self.datosUsuario.idDominio]];
    
    
}

-(void) informacionDominio{
    operacionWS = 3;
    WS_HandlerPublicar *wsPublicar = [[WS_HandlerPublicar alloc] init];
    [wsPublicar setWsHandlerDelegate:self];
    [wsPublicar publicarDominio];
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    NSLog(@"EL RESULTADO REGRESADO Y QUE LLEGO A RESULTADOCONSULTADOMINIO ES: %@ y operacion: %li", resultado, (long)operacionWS);
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (operacionWS == 1) {
        if ([resultado isEqualToString:@"No existe"]) {
            existeDominio = YES;
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
        else {
            existeDominio = NO;
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
    }
    else if (operacionWS == 11){
        if ([resultado isEqualToString:@"No existe"]) {
            existeDominio = YES;
            [self performSelectorOnMainThread:@selector(crearDominio2) withObject:Nil waitUntilDone:YES];
        }
        else {
            existeDominio = NO;
            [self checaPublicacion];
            //[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
    }else if(operacionWS == 12){
        NSLog(@"LA OPERACION ES 12 PARA PUBLICAR y el resultado es: %@", resultado);
        if ([resultado isEqualToString:@"Exito"]) {
            if (alertActivity)
            {
                [NSThread sleepForTimeInterval:1];
                [alertActivity hide];
            }
            
            statusRespuesta = RespuestaStatusExito2;
            dominioUsuario = [[DominiosUsuario alloc] init];
            if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
                [dominioUsuario setDomainType:@"tel"];
            }else{
                [dominioUsuario setDomainType:@"recurso"];
            }
            [dominioUsuario setVigente:@"si"];
            NSLog(@"LOS VALORES A GUARDAR SON: %@ Y %@ ", dominioUsuario.domainType, dominioUsuario.vigente);
            self.arregloDominiosUsuario = [[NSMutableArray alloc] init];
            [self.arregloDominiosUsuario addObject:dominioUsuario];
            self.datosUsuario.dominiosUsuario = self.arregloDominiosUsuario;
            NSLog(@"LA CANTIDAD QUE AGREGO DE DOMINIOSUSUARIOS SON  %lu y el arreglo %lu", (unsigned long)[self.datosUsuario.dominiosUsuario count] , (unsigned long)[self.arregloDominiosUsuario count]);
            NSLog(@"ENTRO A RESPUESTA DE ESTATUS EXITO EN OCULTAR ACTIVITY");
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Publicar Dominio" withValue:@""];
            [[Appboy sharedInstance] logCustomEvent:@"Publicar Dominio"];
            if([self.datosUsuario.tipoDeUsuario isEqualToString:@"normal"]){
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"tipoDominio" andStringValue:@"recurso"];
            }else if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"tipoDominio" andStringValue:@"tel"];
            }else{
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"tipoDominio" andStringValue:@"recurso"];
            }
            [[Appboy sharedInstance].user setCustomAttributeWithKey:@"nombreDominio" andStringValue:self.datosUsuario.dominio];
            [self enviarEventoGAconCategoria:@"Publicar" yEtiqueta:@"Dominio"];
            self.datosUsuario.nombroSitio = YES;
            NSLog(@"self.datos usuario nombre de dominio %@", self.datosUsuario.dominio);
            creoDominio = YES;
            
            AlertView *alert  = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"felicidades", @" ") message:NSLocalizedString(@"nombradoExitoso", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            [self navigationController].navigationBarHidden = NO;
            MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
            [self.navigationController pushViewController:comparte animated:YES];
            
        }
        else if ([resultado isEqualToString:@"Error Publicar"]) {
            statusRespuesta = RespuestaStatusPendiente2;
            self.datosUsuario.dominio = nil;
        }
        else if ([resultado isEqualToString:@"Usuario Existe"] || [resultado isEqualToString:@"Existe"]) {
            NSLog(@"EL USUARIO YA EXISTE!!!");
            [self removeAnimate];
            statusRespuesta = RespuestaStatusExistente2;
            self.datosUsuario.dominio = nil;
        }
        else {
            statusRespuesta = RespuestaStatusError2;
            self.datosUsuario.dominio = nil;
        }
        
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }else if(operacionWS == 13 && [resultado isEqualToString:@"Exito"]){
        NSLog(@"ENTRO A RESPUESTA DE ESTATUS EXITO EN OCULTAR ACTIVITY");
        if (alertActivity)
        {
            [NSThread sleepForTimeInterval:1];
            [alertActivity hide];
        }
        [[AppsFlyerTracker sharedTracker] trackEvent:@"Publicar Dominio" withValue:@""];
        [[Appboy sharedInstance] logCustomEvent:@"Publicar Dominio"];
        if([self.datosUsuario.tipoDeUsuario isEqualToString:@"normal"]){
            [[Appboy sharedInstance].user setCustomAttributeWithKey:@"tipoDominio" andStringValue:@"recurso"];
        }else if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
            [[Appboy sharedInstance].user setCustomAttributeWithKey:@"tipoDominio" andStringValue:@"tel"];
        }else{
            [[Appboy sharedInstance].user setCustomAttributeWithKey:@"tipoDominio" andStringValue:@"recurso"];
        }
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"nombreDominio" andStringValue:self.datosUsuario.dominio];
        [self enviarEventoGAconCategoria:@"Publicar" yEtiqueta:@"Dominio"];
        self.datosUsuario.nombroSitio = YES;
        creoDominio = YES;
        
        AlertView * alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"felicidades", @" ") message:NSLocalizedString(@"nombradoExitoso", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
        [self navigationController].navigationBarHidden = NO;
        MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
        [self.navigationController pushViewController:comparte animated:YES];
        
    }else{
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }
}


-(void)crearDominio2{
    [self performSelectorInBackground:@selector(crearDominio) withObject:Nil];
}



-(void) errorToken {
    if (alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [alertActivity hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
    
}



-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorDominio) withObject:Nil waitUntilDone:YES];
}

-(void) errorDominio {
    if (alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [alertActivity hide];
    }
    [AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo];
}

-(BOOL) validarDominio {
    BOOL dominioCorrecto;
    if (self.nombreDominio.text.length > 0) {
        if ([CommonUtils validarDominio:self.nombreDominio.text]) {
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


*/






























@end
