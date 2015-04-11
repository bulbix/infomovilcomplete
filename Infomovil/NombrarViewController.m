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
#import "CompartirPublicacionViewController.h"
#import "MenuPasosViewController.h"
#import "WS_HandlerPublicar.h"

@interface NombrarViewController () {
//    BOOL modifico;
    BOOL existeDominio;
    NSInteger operacionWS;//1 consulta dominio 2 creacion usuario y dominio
    NSInteger idDominio;
	NSString *nameDominio;
    BOOL creoDominio;
	BOOL saliendo;
}

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //MBC
    if(IS_STANDARD_IPHONE_6){
        [self.scroll setFrame:CGRectMake(0, 0, 375, 667)];
        [self.label1 setFrame:CGRectMake(40, 47, 280, 97)];
        [self.label2 setFrame:CGRectMake(40, 97, 280, 101)];
        [self.labelW setFrame:CGRectMake(41, 178, 52, 24)];
        [self.nombreDominio setFrame:CGRectMake(93, 175, 200, 30)];
        [self.labelTel setFrame:CGRectMake(291, 178, 28, 24)];
        [self.labelDominio setFrame:CGRectMake(50, 223, 280, 24)];
        [self.boton setFrame:CGRectMake(93, 266, 200, 35)];
    }
    else if(IS_STANDARD_IPHONE_6_PLUS){
        [self.scroll setFrame:CGRectMake(0, 0, 414, 736)];
        [self.label1 setFrame:CGRectMake(60, 47, 280, 97)];
        [self.label2 setFrame:CGRectMake(60, 97, 280, 101)];
        [self.labelW setFrame:CGRectMake(61, 178, 52, 24)];
        [self.nombreDominio setFrame:CGRectMake(113, 175, 200, 30)];
        [self.labelTel setFrame:CGRectMake(311, 178, 28, 24)];
        [self.labelDominio setFrame:CGRectMake(70, 223, 280, 24)];
        [self.boton setFrame:CGRectMake(113, 266, 200, 35)];
    }else if(IS_IPAD){
        [self.scroll setFrame:CGRectMake(0, 0, 768, 1024)];
        //[self.label1 setFrame:CGRectMake(84, 500, 600, 50)];
        //[self.label1 setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.label2 setFrame:CGRectMake(84, 80, 600, 50)];
        [self.label2 setFont:[UIFont fontWithName:@"Avenir-medium" size:21]];
        [self.labelW setFrame:CGRectMake(0, 187, 209, 24)];
        [self.labelW setFont:[UIFont fontWithName:@"Avenir-Book" size:21]];
        [self.nombreDominio setFrame:CGRectMake(209, 180, 350, 40)];
        [self.nombreDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.labelTel setFrame:CGRectMake(559, 187, 209, 24)];
        [self.labelTel setFont:[UIFont fontWithName:@"Avenir-Book" size:21]];
        [self.labelDominio setFrame:CGRectMake(0, 270, 768, 24)];
        [self.labelDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.boton setFrame:CGRectMake(284, 350, 200, 40)];
        [self.boton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        
    
    }else{
        [self.label1 setFrame:CGRectMake(20, 47, 280, 47)];
        [self.label2 setFrame:CGRectMake(20, 97, 280, 61)];
        [self.labelW setFrame:CGRectMake(11, 178, 52, 24)];
        [self.nombreDominio setFrame:CGRectMake(63, 175, 200, 30)];
        [self.labelTel setFrame:CGRectMake(261, 178, 28, 24)];
        [self.labelDominio setFrame:CGRectMake(20, 223, 280, 24)];
        [self.boton setFrame:CGRectMake(63, 266, 200, 35)];
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"roja.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"plecaroja.png"];
    }

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
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
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
    //[self.nombreDominio setText:self.datosUsuario.dominio];
    if (self.datosUsuario.publicoSitio) {
        [self.nombreDominio setEnabled:NO];
    }
    else {
        [self.nombreDominio setEnabled:YES];
    }
	
	self.label1.text = NSLocalizedString(@"nombrarLabel1", nil);
	self.label2.text = NSLocalizedString(@"nombrarLabel2", nil);
	[self.boton setTitle:NSLocalizedString(@"nombrarBoton", nil) forState:UIControlStateNormal] ;
	
	saliendo = NO;
   
    self.nombreDominio.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"misitioURL", nil) attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    
#if DEBUG
    [self.labelDominio setText:[NSString stringWithFormat:@"www.info-movil.com/misitio"]];
#endif
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verificarDominio:(UIButton *)sender {
  
    [[self view] endEditing:YES];
    if ([self validarDominio]) {
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

-(IBAction)guardarInformacion:(id)sender {
    [self.view endEditing:YES];
    if (existeDominio) {
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
		((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
		((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = NO;
		[self.navigationController popToRootViewControllerAnimated:YES];
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
    if (creoDominio) {
       // NSArray *arrayControllers = [self.navigationController viewControllers];
        //[self.navigationController popToViewController:[arrayControllers objectAtIndex:arrayControllers.count-3] animated:YES];
    }
}

-(IBAction)regresar:(id)sender {
    self.datosUsuario.dominio = @"";
    [[self view] endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];

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
            PublicarViewController *publicar = [[PublicarViewController alloc] initWithNibName:@"PublicarViewController" bundle:Nil];
            [self.navigationController pushViewController:publicar animated:YES];
			
        }
        else {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noDisponible", @" ") dominio:nil andAlertViewType:AlertViewTypeInfo];
			
            [alert show];
        }
    }
    /*else {
        if (idDominio == 0) {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"errorCrearDominio", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        else {
            self.datosUsuario = [DatosUsuario sharedInstance];
            self.datosUsuario.idDominio = idDominio;
			self.datosUsuario.dominio = nameDominio;
            self.datosUsuario.nombroSitio = YES;
            creoDominio = YES;
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"felicidades", @" ") message:NSLocalizedString(@"nombradoExitoso", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
			
			[self.navigationController popViewControllerAnimated:YES];
			
			((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
			((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = YES;
			CompartirPublicacionViewController *compartir = [[CompartirPublicacionViewController alloc] initWithNibName:@"CompartirPublicacionViewController" bundle:nil];
			
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:compartir];
			
			[self.navigationController presentViewController:navController animated:YES completion:Nil];
        }
    }*/
    
}

-(void) checaDominio {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        operacionWS = 1;
        WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
        [dominioHandler setWSHandlerDelegate:self];
        [dominioHandler consultaDominio:textoDominio];
    }
    else {
        if (alertActivity)
        {
            [NSThread sleepForTimeInterval:1];
            [alertActivity hide];
        }
        self.alertActivity = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertActivity show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void) crearDominio {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        operacionWS = 2;
        self.datosUsuario = [DatosUsuario sharedInstance];
        WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
        [dominioHandler setWSHandlerDelegate:self];
        [dominioHandler crearUsuario:self.datosUsuario.emailUsuario conNombre:self.nombreDominio.text password:self.datosUsuario.passwordUsuario status:@"1" nombre:nil direccion1:nil direccion2:nil pais:nil codigoPromocion:@"" tipoDominio:dominioTipo idDominio:[NSString stringWithFormat:@"%i", self.datosUsuario.idDominio]];
    }
    else {
        if (alertActivity)
        {
            [NSThread sleepForTimeInterval:1];
            [alertActivity hide];
        }
        self.alertActivity = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertActivity show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

-(void) informacionDominio{
	operacionWS = 3;
	WS_HandlerPublicar *wsPublicar = [[WS_HandlerPublicar alloc] init];
	[wsPublicar setWsHandlerDelegate:self];
	[wsPublicar publicarDominio];
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
	self.datosUsuario = [DatosUsuario sharedInstance];
    if (operacionWS == 1) {
        if ([resultado isEqualToString:@"No existe"]) {
            existeDominio = YES;
			//self.datosUsuario.dominio = self.nombreDominio.text;
			[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
        else {
            existeDominio = NO;
			 [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
    }
    /*else if(operacionWS == 2){
        idDominio = [resultado integerValue];
		nameDominio = self.nombreDominio.text;
		//[self informacionDominio];
		[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }*/
	else{
		[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
	}
   
}
-(void) errorToken {
    if (alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [alertActivity hide];
    }
    self.alertActivity = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertActivity show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sessionTimeout
{
    if (alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [alertActivity hide];
    }
    self.alertActivity = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertActivity show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-30,self.view.frame.size.width,self.view.frame.size.height);
        self.view.frame = rect;
    }else if(IS_IPHONE_4){
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-120,self.view.frame.size.width,self.view.frame.size.height);
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
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+30,self.view.frame.size.width,self.view.frame.size.height);
        self.view.frame = rect;
    }else if(IS_IPHONE_4){
        rect = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+120,self.view.frame.size.width,self.view.frame.size.height);
        self.view.frame = rect;
    }
	
	
	[UIView commitAnimations];
}



@end
