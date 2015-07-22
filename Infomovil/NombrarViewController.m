//
//  NombrarViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "NombrarViewController.h"
#import "WS_HandlerDominio.h"
#import "PublicarViewController.h"
#import "MenuPasosViewController.h"
#import "WS_HandlerPublicar.h"
#import "MainViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LMDefaultMenuItemCell.h"
#import "WS_getDominioGratuito.h"


@interface NombrarViewController () {
    BOOL existeDominio;
    NSInteger operacionWS;//1 consulta dominio 2 creacion usuario y dominio
	NSString *nameDominio;
    BOOL creoDominio;
	BOOL saliendo;
    BOOL RevisarSaliendo;
    RespuestaEstatus2 statusRespuesta;
    DominiosUsuario *dominioUsuario;
   
}
@property (nonatomic, strong) NSMutableArray *arregloDominiosUsuario;
@property (nonatomic, strong) AlertView *alertActivity;
@property (nonatomic, strong) NSString *textoDominio;
@property (nonatomic, strong) NSString *currentElementString;

@end

@implementation NombrarViewController


@synthesize alertActivity, textoDominio;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        RevisarSaliendo = NO;
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.scroll setFrame:CGRectMake(0, 0, 375, 667)];
        [self.label2 setFrame:CGRectMake(40, 70, 280, 101)];
        //[self.labelTel setFrame:CGRectMake(291, 178, 28, 24)];
        [self.labelDominio setFrame:CGRectMake(50, 223, 280, 24)];
        [self.boton setFrame:CGRectMake(93, 266, 200, 40)];
     }else if(IS_IPAD){
        [self.scroll setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.label2 setFrame:CGRectMake(84, 80, 600, 50)];
        [self.label2 setFont:[UIFont fontWithName:@"Avenir-medium" size:21]];
        [self.boton setFrame:CGRectMake(284, 350, 200, 40)];
        [self.boton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
    }else{
        [self.scroll setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.label2 setFrame:CGRectMake(20, 40, 280, 61)];
       // [self.labelTel setFrame:CGRectMake(261, 108, 28, 24)];
        [self.labelDominio setFrame:CGRectMake(20, 158, 280, 24)];
        [self.boton setFrame:CGRectMake(50, 200, 220, 40)];
    }
    
 
    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"roja.png"];
    

    self.navigationItem.rightBarButtonItem = Nil;
    creoDominio = NO;
    self.nombreDominio.layer.cornerRadius = 5.0f;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
	self.navigationItem.hidesBackButton = YES;
    UIImage *image = defRegresar;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self navigationController].navigationBarHidden = NO;
    if (self.datosUsuario.publicoSitio) {
        [self.nombreDominio setEnabled:NO];
    }
    else {
        [self.nombreDominio setEnabled:YES];
    }
    NSLog(@"EL TIPO DE USUARIO EN NOMBRAR ES: %@", self.datosUsuario.tipoDeUsuario);
    if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
        [self.labelTel setHidden:NO];
        [self.labelW setHidden:NO];
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            
            [self.nombreDominio setFrame:CGRectMake(60,160 , 265, 35)];
            [self.labelTel setFrame:CGRectMake(325, 160, 28, 35)];
            [self.labelW setFrame:CGRectMake(10, 160, 50, 35)];
          
        }else if(IS_IPAD){
             [self.nombreDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
             [self.labelTel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
             [self.labelW setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            [self.nombreDominio setFrame:CGRectMake(134,180 , 466, 40)];
            [self.labelTel setFrame:CGRectMake(600, 180, 30, 40)];
            [self.labelW setFrame:CGRectMake(84, 180, 50, 40)];
        }else{
            [self.nombreDominio setFrame:CGRectMake(50,130 , 235, 35)];
            [self.labelTel setFrame:CGRectMake(285, 130, 28, 35)];
            [self.labelW setFrame:CGRectMake(0, 130, 50, 35)];
        }
        
        
        
        
    }else if([self.datosUsuario.tipoDeUsuario isEqualToString:@"normal"]  ){
        [self.labelTel setHidden:YES];
        [self.labelW setHidden:YES];
        if(IS_IPAD){
            [self.nombreDominio setFrame:CGRectMake(84, 180, 600, 40)];
            [self.nombreDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            [self.viewContenidoDominios setFrame:CGRectMake(0, 0, 768, 1024)];
             [self.viewDominiosTable setFrame:CGRectMake(184, 250, 400, 400)];
            [self.SalirSelectDomain setFrame:CGRectMake(340, 20, 46, 30)];
            [self.tableDominios setFrame:CGRectMake(0, 60, 400, 250)];
            [self.btnAceptarDom setFrame:CGRectMake(100, 340, 200, 40)];
            
        }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
             [self.nombreDominio setFrame:CGRectMake(37, 175, 300, 35)];
            [self.viewContenidoDominios setFrame:CGRectMake(0, 0, 375, 667)];
            [self.viewDominiosTable setFrame:CGRectMake(37, 100, 300, 320)];
      }else{
            [self.nombreDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
            [self.nombreDominio setFrame:CGRectMake(20, 105, 280, 30)];
        }
        
    }
	
	
	self.label2.text = NSLocalizedString(@"nombrarLabel2", nil);
	[self.boton setTitle:NSLocalizedString(@"nombrarBoton", nil) forState:UIControlStateNormal] ;
	
	saliendo = NO;
   
    self.nombreDominio.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"misitioURL", nil) attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
        [self.labelDominio setText:NSLocalizedString(@"etiquetaDominioTel", nil)];
    }else if([self.datosUsuario.tipoDeUsuario isEqualToString:@"normal"]){
        [self.labelDominio setText:NSLocalizedString(@"etiquetaRecursoNormal", nil)];
    
    }
    
    [self.vistaInferior setHidden:YES];

    self.popUpCenter.layer.cornerRadius = 10;
    self.popUpCenter.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.btnPublicar.layer.cornerRadius = 10;
    self.MensajeDisponible.text = NSLocalizedString(@"estaDisponiblePublica", nil);
    [self.btnPublicar setTitle:NSLocalizedString(@"publicaTuSitioWebAccion", nil) forState:UIControlStateNormal];
    
    self.btnAceptarDom.layer.cornerRadius = 10;
    self.viewDominiosTable.layer.cornerRadius = 10;
    self.boton.layer.cornerRadius = 10;
    [self.btnAceptarDom setTitle:NSLocalizedString(@"aceptarPop", nil) forState:UIControlStateNormal];
  
    
}
-(void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];
    [self.nombreDominio becomeFirstResponder];
    [self performSelectorInBackground:@selector(descargarDominios) withObject:Nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verificarDominio:(UIButton *)sender {
    [[self view] endEditing:YES];
    if ([self validarDominio]) {
        self.nombreDelDominio.text = self.nombreDominio.text;
        
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivityBuscar) withObject:Nil waitUntilDone:YES];
            self.datosUsuario = [DatosUsuario sharedInstance];
            if( [self.datosUsuario.arregloDominiosGratuitos count] <= 0){
                [self performSelectorInBackground:@selector(descargarDominios) withObject:Nil];
            }
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

#pragma mark - AlertViewDelegate

-(void) accionNo {
	if(!saliendo){
		[self.navigationController popViewControllerAnimated:YES];
		saliendo = NO;
	}
	
}

-(void) accionSi {
	if(saliendo){
		self.datosUsuario = [DatosUsuario sharedInstance];
		[StringUtils deleteResourcesWithExtension:@"jpg"];
		[StringUtils deleteFile];
		[self.datosUsuario eliminarDatos];
        [self.datosUsuario eliminarSesion];
		((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
		
        MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
        [self.navigationController pushViewController:inicio animated:YES];
	}
    else if (existeDominio) {
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(crearDominio) withObject:Nil];
        }
        else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}

    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"comprobarDisponibilidad", @" ") andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}
-(void) accionAceptar {
   
}

-(IBAction)regresar:(id)sender {
    self.datosUsuario.dominio = @"";
    [[self view] endEditing:YES];
   
    MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
    [self.navigationController pushViewController:comparte animated:YES];

 }

#pragma mark - UITextFieldDelegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.modifico = YES;
    if ([string isEqualToString:@"<"] && [string isEqualToString:@">"]) {
        return NO;
    }
    else {
        if (existeDominio) {
            existeDominio = NO;
            [self.labelEstatusDominio setText:@" "];
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([[textField text] isEqualToString:@"MiSitio"]) {
        [self.nombreDominio setText:@" "];
    }
}

-(void) mostrarActivity {
    alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgNombrarSitio", Nil) andAlertViewType:AlertViewTypeActivity];
    [alertActivity show];
}
-(void) mostrarActivity2 {
    alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgPublicarSitio", Nil) andAlertViewType:AlertViewTypeActivity];
    [alertActivity show];
}
-(void) mostrarActivityBuscar{
    alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgBuscarDisponible", Nil) andAlertViewType:AlertViewTypeActivity];
    [alertActivity show];
}


-(void) ocultarActivity {
    NSLog(@"self.datosUsuario.tipoDeUsuario : %@", self.datosUsuario.tipoDeUsuario);
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
                //[self showAnimate];
                [self seleccionaDominioGratuito];
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

-(void) descargarDominios {
    getDominioGratuito *catalogo = [[getDominioGratuito alloc] init];
    [catalogo setDominioGratuitoDelegate:self];
    [catalogo getDominiosGratuitos];
}


-(void) checaDominioPublicacion {
    operacionWS = 11;
    WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
    [dominioHandler setWSHandlerDelegate:self];
    [dominioHandler consultaDominio:textoDominio];
}

-(void) crearDominio { NSLog(@"ENTRO AL METODO CREAR DOMINIO");
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
    [dominioHandler crearUsuario:self.datosUsuario.emailUsuario conNombre:self.nombreDominio.text password:self.datosUsuario.passwordUsuario status:@"1" nombre:@"xxx" direccion1:@"xxx" direccion2:@"xxx" pais:@"0" codigoPromocion:@"" tipoDominio:dominioAux idDominio:[NSString stringWithFormat:@"%li", (long)self.datosUsuario.idDominio]emailPubli:self.datosUsuario.emailUsuario];
    

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
            //self.datosUsuario.dominiosUsuario = self.arregloDominiosUsuario;
           
         
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
    NSLog(@"SE MANDO A LLAMAR A CREAR EL DOMINIO CON EL METODO CREARDOMINIO2 NOMBRARVIEWCONTROLLER");
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

#pragma mark - Métodos del teclado

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect rect;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    if(IS_IPHONE_5){
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-10,self.view.frame.size.width,self.view.frame.size.height);
        self.view.frame = rect;
    }else if(IS_IPHONE_4){
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        self.view.frame = rect;
    }
	
	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	CGRect rect;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    if(IS_IPHONE_5){
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+10,self.view.frame.size.width,self.view.frame.size.height);
        self.view.frame = rect;
    }else if(IS_IPHONE_4){
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        self.view.frame = rect;
    }
	[UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nombreDominio) {
        [textField resignFirstResponder];
    } 
    return YES;
}

-(void)seleccionaDominioGratuito{
    NSLog(@"ENTRO A SELECCIONA DOMINIO GRATUITO!!!!!!");
    [self navigationController].navigationBarHidden = YES;
    [self.view addSubview:self.viewContenidoDominios];
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView animateWithDuration:.40 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];


}


- (void)showAnimate
{
    
    [self navigationController].navigationBarHidden = YES;
    [self.popUpView setHidden:NO];
    [self.scroll setHidden:YES];
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.popUpView setFrame:CGRectMake(0, 0, 375, 667)];
        [self.popUpCenter setFrame:CGRectMake(47, 100, 280, 280)];
     }else if(IS_IPAD){
        [self.popUpView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.popUpCenter setFrame:CGRectMake(224, 200, 320, 320)];
        [self.etiquetaEstatica setFrame:CGRectMake(10, 62, 300, 24)];
        [self.nombreDelDominio setFrame:CGRectMake(10, 81, 300, 25)];
        [self.MensajeDisponible setFrame:CGRectMake(10, 98, 300, 85)];
        [self.btnPublicar setFrame:CGRectMake(30, 200, 260, 45)];
        [self.cerrarBtn setFrame:CGRectMake(240, 20, 46, 30)];
    }else{
        [self.popUpView setFrame:CGRectMake(0, 0, 320, 568)];
    }
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView animateWithDuration:.40 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [self navigationController].navigationBarHidden = NO;
    [self.popUpView setHidden:YES];
    [self.scroll setHidden:NO];
}



- (IBAction)cerrarPopUpAction:(id)sender {
    if(RevisarSaliendo == NO){
        [self removeAnimate];
    }else{
        [self checaPublicacion];
    
    }
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    NSLog(@"NO TENGO IDEA A QUE HORA ENTRA EN SHOWINVIEW!!!");
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
}


- (IBAction)publicarAction:(id)sender {
    RevisarSaliendo = YES;
    if( [CommonUtils hayConexion]){
        [self performSelectorOnMainThread:@selector(mostrarActivity2) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(checaDominioPublicacion) withObject:Nil];
    }else{
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}

-(void) checaPublicacion{
     if( [CommonUtils hayConexion]){
         operacionWS = 13;
         WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
         [dominioHandler setWSHandlerDelegate:self];
         [dominioHandler consultaEstatusDominio];
     }else{
         AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
         [alert show];
     }
}
////////////////////TABLEVIEW DE DOMINIOS //////////////////////////////////////////////////////


#pragma mark - TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   self.datosUsuario = [DatosUsuario sharedInstance];
    return [self.datosUsuario.arregloDominiosGratuitos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMDefaultMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultMenuItemCell"];
    if (!cell) {
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"LMDefaultMenuItemCell" owner:self options:nil];
        cell = [xibs firstObject];
    }
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSInteger cuantos = [self.datosUsuario.arregloDominiosGratuitos count];
    for(int i = 0; i < cuantos; i++){
        if(indexPath.row == i){
            cell.menuItemLabel.text = [[self.datosUsuario.arregloDominiosGratuitos objectAtIndex:i]descripcion];
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.dominioCompleto.text = [NSString stringWithFormat:@"%@/%@",[[self.datosUsuario.arregloDominiosGratuitos objectAtIndex:i]descripcion],self.nombreDominio.text ];
                self.datosUsuario.idSeleccionadoGratuito = [[self.datosUsuario.arregloDominiosGratuitos objectAtIndex:i]idCatalogo];
            }
        }
    
    }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSInteger cuantos = [self.datosUsuario.arregloDominiosGratuitos count];
    for(int i = 0; i < cuantos; i++){
        if(indexPath.row != i){
            NSIndexPath *myIP = [NSIndexPath indexPathForRow:i inSection:0];
            [tableView deselectRowAtIndexPath:myIP animated:YES];
            UITableViewCell *cells = [tableView cellForRowAtIndexPath:myIP];
             cells.accessoryType = UITableViewCellAccessoryNone;
        }else{
           
            self.dominioCompleto.text = [NSString stringWithFormat:@"%@/%@",[[self.datosUsuario.arregloDominiosGratuitos objectAtIndex:i]descripcion],self.nombreDominio.text ];
            self.datosUsuario.idSeleccionadoGratuito = [[self.datosUsuario.arregloDominiosGratuitos objectAtIndex:i]idCatalogo];
        }
        
    }
   
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label;  UIView *headerView;
    if(IS_IPAD){
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 110)];
        label = [[UILabel alloc] initWithFrame: CGRectMake(0,0, 400, 40)];
         self.dominioCompleto.frame = CGRectMake(0, 40, 400, 60);
        [self.dominioCompleto setFont:[UIFont fontWithName:@"Avenir-Medium" size:18]];
        label.font = [UIFont fontWithName:@"Avenir-Medium" size:18];
    }else{
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 110)];
        label = [[UILabel alloc] initWithFrame: CGRectMake(0,0, 300, 40)];
         self.dominioCompleto.frame = CGRectMake(0, 40, 300, 60);
        label.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    }
    headerView.backgroundColor = [UIColor clearColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = colorFuenteVerde;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    label.text = NSLocalizedString(@"tituloDominiosDisponibles", @" ");
    label.numberOfLines = 2;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.dominioCompleto];
    [headerView addSubview:label];
    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100.0f;
}
/*
- (IBAction)AceptarAct:(id)sender {
     [self navigationController].navigationBarHidden = NO;
    [self.viewContenidoDominios removeFromSuperview];
  
}
*/


- (IBAction)SalirSelectDomainAct:(id)sender {
    [self navigationController].navigationBarHidden = NO;
    [self.viewContenidoDominios removeFromSuperview];
   
    
}
@end
