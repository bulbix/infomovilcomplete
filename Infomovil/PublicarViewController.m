//
//  PublicarViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "PublicarViewController.h"
#import "WS_HandlerPublicar.h"
#import "WS_HandlerDominio.h"
#import "CompartirPublicacionViewController.h"
#import "AppsFlyerTracker.h"
#import "CommonUtils.h"
#import "SelectorPaisViewController.h"
#import "UIViewDefs.h"
#import "MenuPasosViewController.h"

@interface PublicarViewController () {
    BOOL publicoDominio;
    WSOperacion operacionWS;
    NSInteger idDominio;
	NSString *nameDominio;
	BOOL creoDominio;
    RespuestaEstatus statusRespuesta;
    NSString *mensajeError;
	
	BOOL selectOculto;
    id txtSeleccionado;
    NSInteger valorSeleccionado;
	
	NSMutableArray *array;
	NSMutableArray *codeArray;
	NSMutableArray *filteredArray;
	NSMutableArray *filteredCodeArray;
	
	NSArray *codigoPais;
    NSLocale *local;
	
	NSInteger operacionWS2;
	BOOL existeDominio;

}

@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) NSMutableArray *arregloPais;
@property (nonatomic, strong) NSDictionary *prefijos;

@end

@implementation PublicarViewController

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

	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"publicar", @" ") nombreImagen:@"roja.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"publicar", @" ") nombreImagen:@"plecaroja.png"];
	}
     
    operacionWS = WSOperacionNombrar;
    publicoDominio = NO;
	creoDominio = NO;
	codigoPais = [NSLocale ISOCountryCodes];
    local = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]];
    _arregloPais = [[NSMutableArray alloc] initWithCapacity:[codigoPais count]];
    
    self.prefijos = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                pathForResource:@"CallingCodes"
                                                                ofType:@"plist"]];
	
//	[self fillDataSourceArray];
	array = [[NSMutableArray alloc] init];
	filteredArray = [[NSMutableArray alloc] init];
	
	for(int i=0; i<[_arregloPais count] ; i++){
		[array addObject:[[_arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
		[filteredArray addObject:[[_arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
	}
	
	[self.scroll setContentSize:CGSizeMake(320, 200)];
	
	self.nPais = @"1";
	
	self.labelNombre.text = NSLocalizedString(@"publicarNombre", nil);
	self.labelDir1.text = NSLocalizedString(@"publicarDir1", nil);
	self.labelDir2.text = NSLocalizedString(@"publicarDir2", nil);
	self.labelPais.text = NSLocalizedString(@"publicarPais", nil);
    NSArray *fields = @[self.txtNombre, self.txtDir1, self.txtDir2];
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    [self.keyboardControls setDelegate:self];
	
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
	
	self.label1.text = [NSString stringWithFormat:NSLocalizedString(@"disponible", nil),[self.datosUsuario dominio]];
	self.label2.text = NSLocalizedString(@"confirmalo", nil);
	[self.boton setTitle:NSLocalizedString(@"PublicarBoton", nil) forState:UIControlStateNormal];
	
	self.vistaCombo.layer.cornerRadius = 5.0f;
	
	self.txtNombre.layer.cornerRadius = 5.0f;
	self.txtDir1.layer.cornerRadius = 5.0f;
	self.txtDir2.layer.cornerRadius = 5.0f;
	
	
	selectOculto = YES;
	existeDominio = NO;
	operacionWS2 = 0;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)guardarInformacion:(id)sender {
	[self confirmarDominio:nil];
}

-(void) consultaDominio {
    self.datosUsuario = [DatosUsuario sharedInstance];
        WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
        [dominioHandler setWSHandlerDelegate:self];
   
}

-(void) mostrarActivity {
    self.alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgPublicando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertView show];
}


-(void) crearDominio {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        operacionWS2 = 2;
        
        self.datosUsuario = [DatosUsuario sharedInstance];
        WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
        [dominioHandler setWSHandlerDelegate:self];
        
        NSLog(@"Los valores que envio desde crearDominio en PublicarViewController: crearUsuario: %@ /n nombreDominio: %@ /n password: %@ /n nombre: %@ /n direccion %@ /n direccion %@ /n pais %@ /n codigo %@ /n idDominio: %i " ,self.datosUsuario.emailUsuario,dominioTipo, self.datosUsuario.passwordUsuario, self.txtNombre.text, self.txtDir1.text,self.txtDir2.text, self.nPais, self.datosUsuario.codigoRedimir, self.datosUsuario.idDominio);
        
        [dominioHandler crearUsuario:self.datosUsuario.emailUsuario conNombre:self.datosUsuario.dominio password:self.datosUsuario.passwordUsuario status:@"1" nombre:self.txtNombre.text direccion1:self.txtDir1.text direccion2:self.txtDir2.text pais:self.nPais codigoPromocion:self.datosUsuario.codigoRedimir==nil?@" ":self.datosUsuario.codigoRedimir tipoDominio:dominioTipo idDominio:[NSString stringWithFormat:@"%i", self.datosUsuario.idDominio]];

        
        
        
    }
    else {
        if (self.alertView)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertView hide];
        }
        self.alertView = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertView show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


-(void) ocultarActivity {
    [NSThread sleepForTimeInterval:1];
    [self.alertView hide];
	if(!existeDominio){
		AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noDisponible", @" ") dominio:nil andAlertViewType:AlertViewTypeInfo];
		[alert show];
        [self.navigationController popViewControllerAnimated:YES];
	}
    else if(operacionWS2 == 2) {
        if (self.alertView)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertView hide];
        }
        self.datosUsuario = [DatosUsuario sharedInstance];
        AlertView *alert;
		if (statusRespuesta == RespuestaStatusExistente) {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"txtErrorDomainNombrar", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
			
			[self.navigationController popViewControllerAnimated:YES];
        }
        else if (statusRespuesta == RespuestaStatusExito) {
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Publicar Dominio" withValue:@""];
            // IRC APPBOY //
            [[Appboy sharedInstance] logCustomEvent:@"Publicar Dominio"];
            [self enviarEventoGAconCategoria:@"Publicar" yEtiqueta:@"Dominio"];
           
            self.datosUsuario.nombroSitio = YES;
            creoDominio = YES;
            
            
            
          
            
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"felicidades", @" ") message:NSLocalizedString(@"nombradoExitoso", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
    
            NSInteger lessVC;
            if (self.datosUsuario.vistaOrigen == 12) {
                NSLog(@"IRC Me envio a la pantalla -4 en publicarViewController");
                lessVC = 4;
            }
            else {
                NSLog(@"IRC Me envio a la pantalla -3 publicarViewController");
                lessVC = 3;
            }
			[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-lessVC] animated:YES];
			

			((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = YES;
			CompartirPublicacionViewController *compartir = [[CompartirPublicacionViewController alloc] initWithNibName:@"CompartirPublicacionViewController" bundle:nil];
			

                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:compartir];
               [self.navigationController presentViewController:navController animated:YES completion:Nil];

			
			
		}
        else if (statusRespuesta == RespuestaStatusPendiente) {
            self.datosUsuario.nombroSitio = YES;
            creoDominio = YES;
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion = YES;
            alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeProcesoPublicacion", Nil) andAlertViewType:AlertViewTypeInfo2];
            [alert show];
            
        }
        else {
            alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"errorCrearDominio", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }

    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
	NSLog(@"El resultado de checaDominio en PublicarViewController es: %@", resultado);
    self.datosUsuario = [DatosUsuario sharedInstance];
	if(operacionWS == 1){
        if ([resultado isEqualToString:@"No existe"]) {
            NSLog(@"Entro a el dominio No existe IRC publicarViewController");
            existeDominio = YES;
			[self performSelectorInBackground:@selector(crearDominio2) withObject:Nil];
        }
        else {
            existeDominio = NO;
			[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
	}
	else if(operacionWS2 == 2){
		
        if ([resultado isEqualToString:@"Exito"]) {
            statusRespuesta = RespuestaStatusExito;
        }
        else if ([resultado isEqualToString:@"Error Publicar"]) {
            statusRespuesta = RespuestaStatusPendiente;
        }
        else if ([resultado isEqualToString:@"Usuario Existe"]) {
            statusRespuesta = RespuestaStatusExistente;
        }
        else {
            statusRespuesta = RespuestaStatusError;
        }
    
		[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
	}
}
-(void) errorToken {
    if (self.alertView)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertView hide];
    }
    self.alertView = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertView show];
    [StringUtils terminarSession];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) sessionTimeout
{
    if (self.alertView)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertView hide];
    }
    self.alertView = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertView show];
    [StringUtils terminarSession];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorPublicar) withObject:Nil waitUntilDone:YES];
}

-(void) errorPublicar {
    if (self.alertView)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertView hide];
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
   // [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}


-(void) textFieldDidBeginEditing:(UITextField *)textField {
    txtSeleccionado = textField;
    [self muestraContadorTexto:[textField.text length] conLimite:255 paraVista:textField];
    [self.keyboardControls setActiveField:textField];
    [self apareceTeclado];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [self ocultaContadorTexto];
    [self desapareceTeclado];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string isEqualToString:@"\n"] )
        return NO;
    
    return [self shouldChangeText:string withLimit:255 forFinalLenght:[textField.text length] - range.length + [string length]];
}


-(void) apareceTeclado {
    CGSize tamanioTeclado = TAMANIO_TECLADO;// CGSizeMake(320, 235);
    UIEdgeInsets edgeInsets;
    edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+15, 0);

    
    [self.scroll setContentInset:edgeInsets];
    [self.scroll setScrollIndicatorInsets:edgeInsets];
    
	[[self scroll] scrollRectToVisible:((UITextField *)txtSeleccionado).frame animated:YES];


	
	UITextField * aux = ((UITextField *)txtSeleccionado);
	if(aux.frame.origin.y == 96){
		[[self scroll] scrollRectToVisible:CGRectMake(self.scroll.frame.origin.x, self.scroll.frame.origin.y-2*aux.frame.origin.y, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
	}else{
		[[self scroll] scrollRectToVisible:CGRectMake(self.scroll.frame.origin.x, self.scroll.frame.origin.y-1/aux.frame.origin.y, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
	}

    
}

-(void) desapareceTeclado {
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scroll] setContentInset:edgeInsets];
    [[self scroll] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
	[[self scroll] scrollRectToVisible:CGRectMake(0,0, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
	 
}

- (IBAction)mostrarOpcion:(UIButton *)sender {
	SelectorPaisViewController *selector = [[SelectorPaisViewController alloc] initWithNibName:@"SelectorPaisViewController" bundle:Nil];
    selector.publicarController = self;
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		selector.nombreTituloVista = @"roja.png";
	}else{
		selector.nombreTituloVista = @"plecaroja.png";
	}
    //selector.nombreTituloVista = @"barraverde.png";
    [self.navigationController pushViewController:selector animated:YES];
}

- (IBAction)confirmarDominio:(id)sender {
	BOOL resultado = [self validarCampos];
	
	[[self view] endEditing:YES];
    if(resultado && [CommonUtils hayConexion]){
		[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
		[self performSelectorInBackground:@selector(checaDominio) withObject:Nil];
    
	}else{
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
	}
}

-(void) checaDominio {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        DatosUsuario * datos = [DatosUsuario sharedInstance];
        operacionWS = 1;
        WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
        [dominioHandler setWSHandlerDelegate:self];
        NSLog(@"El dominio que se checara si esta disponible en PublicarViewController es: %@", datos.dominio);
        [dominioHandler consultaDominio:datos.dominio];
    }
    else {
        if (self.alertView)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertView hide];
        }
        self.alertView = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertView show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void)crearDominio2{
	operacionWS = 2;
	[self performSelectorInBackground:@selector(crearDominio) withObject:Nil];
}

-(BOOL)validarCampos{
	if([[NSString trim:self.txtNombre.text] isEqualToString:@""]){
        mensajeError = NSLocalizedString(@"txtLlenarNombre", Nil);
		return NO;
	}
    else if ([[NSString trim:self.txtDir1.text] isEqualToString:@""] || [[NSString trim:self.txtDir2.text] isEqualToString:@""]) {
        mensajeError = NSLocalizedString(@"txtLlenarDireccion", Nil);
        return NO;
    }
    else{
		return YES;
	}
	
}


-(void) accionAceptar {
    if (statusRespuesta == RespuestaStatusPendiente) {
        MenuPasosViewController *pasoView = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
        [self.navigationController pushViewController:pasoView animated:YES];
    }
}

#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}

@end

