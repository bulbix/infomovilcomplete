//
//  FormularioRegistroViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "FormularioRegistroViewController.h"
#import "NombrarViewController.h"
#import "WS_HandlerUsuario.h"
#import "SelectorPaisViewController.h"
#import "WS_HandlerDominio.h"
#import "MenuPasosViewController.h"
#import "AppsFlyerTracker.h"
#import "WS_HandlerLogin.h"
#import "AppboyKit.h"
#import "InicioViewController.h"

@interface FormularioRegistroViewController (){
    UITextField *textoSeleccionado;
    BOOL exito, loginFacebook, loginExitoso;
    BOOL existeUsuario;
    BOOL seleccionoPais;
	
	NSInteger operacionWS;
	NSInteger idDominio, respuestaError;
	
	NSString * Pais;
	NSString * codPais;
	
	NSString * nombre;
	NSString * password;
    NSString * codPromocion;
}

@property (nonatomic, strong) AlertView *alerta;

@end

@implementation FormularioRegistroViewController

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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"FormularioViewController"
           value:@"Home Screen"];

    self.navigationItem.rightBarButtonItem = Nil;
    
    if(IS_STANDARD_IPHONE_6){
         [self.scrollView setContentSize:CGSizeMake(375, 667)];
    }else if (IS_STANDARD_IPHONE_6_PLUS){
         [self.scrollView setContentSize:CGSizeMake(540, 960)];
    }else if(IS_IPAD){
        [self.scrollView setContentSize:CGSizeMake(768, 1024)];
    }else{
        [self.scrollView setContentSize:CGSizeMake(320, 380)];
    }
    
   
    
    self.txtNombre.layer.cornerRadius = 10.0f;
    
    self.txtNumero.layer.cornerRadius = 10.0f;
	
	self.vistaPais.layer.cornerRadius = 10.0f;
    
    self.txtContrasena.layer.cornerRadius = 10.0f;
	self.txtContrasenaConfirmar.layer.cornerRadius = 10.0f;
    self.txtCodigo.layer.cornerRadius = 10.0f;
    exito = NO;
    
    NSArray *fields = @[self.txtNombre, self.txtContrasena, self.txtContrasenaConfirmar];//, self.txtCodigo];//
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    [self.keyboardControls setDelegate:self];
	
	self.casillaMovil.hidden = YES;
	
	self.labelPais.textColor = colorFuenteAzul;
	self.labelCodigoPais.textColor = colorFuenteAzul;
	self.casillaMovil.textColor = colorFuenteAzul;
	
	self.datosUsuario = [DatosUsuario sharedInstance];
    [self.txtNumero setText:self.datosUsuario.numeroUsuario];
    seleccionoPais = NO;
    
    productTourView = [[CRProductTour alloc] initWithFrame:self.view.frame];
	CRBubble *bubbleButton1;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		 bubbleButton1 = [[CRBubble alloc] initWithAttachedView:_txtContrasena title:@" Password" description:@"Must be 8 or more characters\n(letters and numbers)\nCan not contain the word infomovil" arrowPosition:CRArrowPositionBottom andColor:[UIColor whiteColor]];
	}else{
		 bubbleButton1 = [[CRBubble alloc] initWithAttachedView:_txtContrasena title:@"Contraseña" description:@"Debe tener de 8 a 15 caracteres\n(letras y números)\nNo puede contener la palabra infomovil\nNo puede ser igual al correo" arrowPosition:CRArrowPositionBottom andColor:[UIColor whiteColor]];
	}
   
   
	
    
    NSMutableArray *bubbleArray = [[NSMutableArray alloc] initWithObjects:bubbleButton1, /*bubbleButton2,*/ nil];

    [productTourView setBubbles:bubbleArray];

    [self.view addSubview:productTourView];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    if (self.datosUsuario.publicoSitio) {
        [self.txtNombre setEnabled:NO];
        [self.txtNumero setEnabled:NO];
        [self.txtContrasena setEnabled:NO];
    }

   
    
    self.txtContrasena.placeholder = NSLocalizedString(@"contrasenaRegistrar", nil);
    self.txtContrasenaConfirmar.placeholder = NSLocalizedString(@"confirmarContrasena", nil);
    
	self.label1.text = NSLocalizedString(@"requiereDueno", nil);
	self.label2.text = NSLocalizedString(@"registrarMensaje", nil);
	self.label4.text = NSLocalizedString(@"pais", nil);
	self.label5.text = NSLocalizedString(@"numeroTelefonico", nil);
	[self.boton setTitle:NSLocalizedString(@"formularioBoton", nil) forState:UIControlStateNormal] ;
    self.labelCodigo.text = NSLocalizedString(@"codigoRedimir", nil);

    UIButton *botonRegresar = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPAD){
        [botonRegresar setBackgroundImage:[UIImage imageNamed:@"btn_back_iPad"] forState:UIControlStateNormal];
        [botonRegresar setFrame:CGRectMake(25, 30, 65, 65)];
    }else{
        [botonRegresar setBackgroundImage:[UIImage imageNamed:@"backNuevo.png"] forState:UIControlStateNormal];
        [botonRegresar setFrame:CGRectMake(10, 25, 36, 36)];
    }
    
    [botonRegresar addTarget:self action:@selector(regresarMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:botonRegresar];
    
    [self.vistaInferior setHidden:YES];
    
    
    if(IS_STANDARD_IPHONE_6){
        self.label2.frame = CGRectMake(20, 70, 335, 57);
        self.txtNombre.frame = CGRectMake(20,138, 335, 50);
        self.txtContrasena.frame = CGRectMake(20, 197, 335, 45);
        self.txtContrasenaConfirmar.frame = CGRectMake(20, 255, 335, 45);
        self.boton.frame =  CGRectMake(20, 329, 335, 55);
        [self.scrollView setContentSize:CGSizeMake(375, 667)];
        
    }else if (IS_STANDARD_IPHONE_6_PLUS){
      
        self.label2.frame = CGRectMake(50, 100, 335, 57);
        self.txtNombre.frame = CGRectMake(50, 200, 335, 45);
        self.txtContrasena.frame = CGRectMake(50, 260, 335, 45);
        self.txtContrasenaConfirmar.frame = CGRectMake(50, 320, 335, 45);
        self.boton.frame =  CGRectMake(50, 400, 335, 55);
        [self.scrollView setContentSize:CGSizeMake(414, 736)];
        
    }else if(IS_IPAD){
        self.label2.frame = CGRectMake(184, 300, 400, 57);
        self.txtNombre.frame = CGRectMake(196,430, 375, 50);
        [self.txtNombre setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f
                                                           green:255.0f/255.0f
                                                            blue:255.0f/255.0f
                                                           alpha:0.45f]];
        self.txtNombre.layer.borderWidth = 1.0f;
        self.txtNombre.layer.cornerRadius = 15.0f;
        self.txtNombre.layer.borderColor = [UIColor whiteColor].CGColor;
        UIColor *color = [UIColor whiteColor];
        self.txtNombre.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  info@infomovil.com" attributes:@{NSForegroundColorAttributeName: color}];
        [self.txtNombre setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        
        self.txtContrasena.frame = CGRectMake(196,500, 375, 52);
        [self.txtContrasena setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f
                                                           green:255.0f/255.0f
                                                            blue:255.0f/255.0f
                                                           alpha:0.45f]];
        self.txtContrasena.layer.borderWidth = 1.0f;
        self.txtContrasena.layer.cornerRadius = 15.0f;
        self.txtContrasena.layer.borderColor = [UIColor whiteColor].CGColor;
        self.txtContrasena.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"contrasenaRegistrar", nil) attributes:@{NSForegroundColorAttributeName: color}];
        [self.txtContrasena setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
       
        self.txtContrasenaConfirmar.frame = CGRectMake(196,570, 375, 52);
        [self.txtContrasenaConfirmar setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f
                                                               green:255.0f/255.0f
                                                                blue:255.0f/255.0f
                                                               alpha:0.45f]];
        self.txtContrasenaConfirmar.layer.borderWidth = 1.0f;
        self.txtContrasenaConfirmar.layer.cornerRadius = 15.0f;
        self.txtContrasenaConfirmar.layer.borderColor = [UIColor whiteColor].CGColor;
        self.txtContrasenaConfirmar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"confirmarContrasena", nil) attributes:@{NSForegroundColorAttributeName: color}];
        [self.txtContrasenaConfirmar setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        
        self.boton.frame =  CGRectMake(196, 650, 375, 55);
        [self.boton.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        UIImage *lineImg = [UIImage imageNamed:@"line@1x.png"];
        UIImageView * myImageView = [[UIImageView alloc] initWithImage:lineImg];
        CGRect myFrame = CGRectMake(146, 380, 475, 2);
        [myImageView setFrame:myFrame];
        [self.view addSubview:myImageView];
        [self mostrarLogo];
        [self.labelInfo setHidden:YES];
        [self.labelCodigo setHidden:YES];
    }else{
        [self.scrollView setContentSize:CGSizeMake(320, 380)];
    }
    
}

-(IBAction)regresarMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textoSeleccionado = textField;
    NSInteger textoLength = [textField.text length];
    [self.labelInfo setText:[NSString stringWithFormat:@"%i/%i", textoLength, 255]];
    [UIView animateWithDuration:0.4f animations:^{
        [self.labelInfo setFrame:CGRectMake(284, textField.frame.origin.y + textField.frame.size.height, 33, 21)];
    }];
    if ([textField isEqual:self.txtContrasena] || [textField isEqual:self.txtCodigo]) {
        [self toogleHelpAction:Nil];
    }

    [self.keyboardControls setActiveField:textField];
    [self apareceElTeclado];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4f animations:^{
        [self.labelInfo setFrame:CGRectMake(284, 600, 33, 21)];
    }];
    if ([textField isEqual:self.txtContrasena] || [textField isEqual:self.txtCodigo]) {
        [self toogleHelpAction:Nil];
    }
	
	if (self.txtNombre.text.length > 0){
		if ([CommonUtils validarEmail:self.txtNombre.text]) {
			self.datosUsuario = [DatosUsuario sharedInstance];
			self.datosUsuario.emailUsuario = [self.txtNombre text];
		}
	}
	
	
    [self desapareceElTeclado];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.modifico = YES;
    NSInteger maxLength = 255;
    NSInteger textoLength = [textField.text length];
    if (textoLength < maxLength) {
        if ([string isEqualToString:@"<"] && [string isEqualToString:@">"]) {
            return NO;
        }
        else {
            if ([string isEqualToString:@""]) {
                [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength-1, (long)maxLength]];
            }
            else {
                [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength+1, (long)maxLength]];
            }
            return YES;
        }
    }
    else {
        if ([string isEqualToString:@""]) {
            [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength-1, (long)maxLength]];
            return YES;
        }
        return NO;
    }
}

-(IBAction)guardarInformacion:(id)sender {
    [[self view] endEditing:YES];
    
    if ([self validaCampos]) {
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.datosUsuario.emailUsuario = [self.txtNombre text];
		if([codPais isEqualToString:@"+52"]){
			self.datosUsuario.numeroUsuario =  [[@"+52" stringByAppendingString:@"1"] stringByAppendingString:[self.txtNumero text]];
		}else{
			self.datosUsuario.numeroUsuario =  [codPais stringByAppendingString:[self.txtNumero text]];
		}
        self.datosUsuario.passwordUsuario = [self.txtContrasena text];
        //Descomentar esto es para que realize las peticiones al servidor
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(checaNombre) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        
    }
}

-(void) accionAceptar {
    if (exito) {
        NombrarViewController *nombrar = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:Nil];
        [self.navigationController pushViewController:nombrar animated:YES];
    }
    
}

-(void) accionSi {
    if (self.modifico) {
        if ((self.txtNombre.text.length) > 0 && (self.txtNumero.text.length > 0) && (self.txtContrasena.text.length > 0)) {
            exito = YES;
            self.datosUsuario = [DatosUsuario sharedInstance];
            self.datosUsuario.emailUsuario = [self.txtNombre text];
            if([codPais isEqualToString:@"+52"]){
				self.datosUsuario.numeroUsuario =  [[@"+52" stringByAppendingString:@"1"] stringByAppendingString:[self.txtNumero text]];
			}else{
				self.datosUsuario.numeroUsuario =  [codPais stringByAppendingString:[self.txtNumero text]];
			}
            self.datosUsuario.passwordUsuario = [self.txtContrasena text];
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"felicidades", @" ") message:NSLocalizedString(@"nombrarSitio", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"llenarCampos", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
}

-(void) accionNo {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) apareceElTeclado:(NSNotification*)aNotification {
    NSDictionary *infoNotificacion = [aNotification userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+15, 0);
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [[self scrollView] scrollRectToVisible:textoSeleccionado.frame animated:YES];
    
}
-(void) desapareceElTeclado:(NSNotification *)aNotificacion {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

-(void) apareceElTeclado{
    CGSize tamanioTeclado = CGSizeMake(320, 260);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+15, 0);
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [[self scrollView] scrollRectToVisible:textoSeleccionado.frame animated:YES];
}
-(void) desapareceElTeclado{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollView] setContentInset:edgeInsets];
    [[self scrollView] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
   
}

-(void) mostrarActivity {
    self.alerta = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"cargando", @" ") message:Nil dominio:Nil andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}

-(void) checaNombre {
    
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        operacionWS = 1;
        WS_HandlerUsuario *handlerUsuario = [[WS_HandlerUsuario alloc] init];
        [handlerUsuario setWsHandlerDelegate:self];
        [handlerUsuario consultaUsuario:nombre];

}

-(void) crearDominio {
   
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        operacionWS = 2;
        WS_HandlerDominio *dominioHandler = [[WS_HandlerDominio alloc] init];
        [dominioHandler setWSHandlerDelegate:self];
        codPromocion = codPromocion == nil?@"":codPromocion;
        codPromocion = [NSString trim:codPromocion];

        [dominioHandler crearUsuario:nombre conNombre:@"" password:password status:@"9" nombre:nil direccion1:nil direccion2:nil pais:nil codigoPromocion:codPromocion tipoDominio:dominioTipo idDominio:@""];
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.datosUsuario.tipoDeUsuario = @"normal";
    
}

-(void) ocultarActivity {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    if (existeUsuario) {

		
		if (idDominio == 0) {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", Nil) message:NSLocalizedString(@"errorCrearDominio", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }else{
            
            [[AppsFlyerTracker sharedTracker] setCustomerUserID:self.txtNombre.text];
            [[AppsFlyerTracker sharedTracker] trackEvent:@"Registro Usuario" withValue:@""];
            // IRC APPBOY //
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *launch =  [defaults objectForKey:@"launchingWithOptions"];
            [Appboy startWithApiKey:llaveAppboy
                      inApplication:[UIApplication sharedApplication]
                  withLaunchOptions:launch];
            [[Appboy sharedInstance] changeUser:self.txtNombre.text];
            
            
            [self enviarEventoGAconCategoria:@"Registrar" yEtiqueta:@"Usuario"];
            // IRC Dominio
             ((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio = @"Tramite";
			
			MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
			[self.navigationController pushViewController:menuPasos animated:YES];
		}
		
		
    }
    else {
        exito = NO;
        AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"errorEmail", Nil) message:NSLocalizedString(@"emailAsociado", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
		
		
    }
    
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
  
	if(operacionWS == 1){
		if ([resultado isEqualToString:@"No existe"]) {
			existeUsuario = YES;
			[self crearDominio];
		}
		else {
			existeUsuario = NO;
			[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
		}
	}else{
		DatosUsuario *datos = [DatosUsuario sharedInstance];
		idDominio = datos.idDominio;
		[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];

	}
}

-(void) resultadoLogin:(NSInteger) idDominioLogin {
  
    if (idDominioLogin > 0) {
        loginExitoso = YES;
        idDominio = idDominioLogin;
        existeUsuario = YES;
        self.datosUsuario.redSocial = @"Facebook";
        
        self.datosUsuario = [DatosUsuario sharedInstance];
        // Se guarda la sesion //
        NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
        [prefSesion setObject:self.datosUsuario.auxStrSesionUser forKey:@"strSesionUser"];
        [prefSesion setObject:self.datosUsuario.auxStrSesionPass forKey:@"strSesionPass"];
        [prefSesion setInteger:(long)self.datosUsuario.auxSesionFacebook forKey:@"intSesionFacebook"];
        [prefSesion setInteger:1 forKey:@"intSesionActiva"];
        [prefSesion synchronize];
    }
    else {
        respuestaError = idDominioLogin;
        loginExitoso = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorToken {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    InicioViewController *inicio = [[InicioViewController alloc] initWithNibName:@"InicioViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}



-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorConsultaUsuario) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaUsuario {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
   // [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}

-(BOOL) validaCampos {
    if ((self.txtNombre.text.length) > 0 && (self.txtContrasena.text.length > 0) ){
        if (![CommonUtils validarEmail:self.txtNombre.text]) {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"emailIncorrecto", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            return NO;
        }
     
        if (![CommonUtils validarContrasena:self.txtNombre.text contrasena:self.txtContrasena.text]) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorPassword", Nil) andAlertViewType:AlertViewTypeInfo];
            [alert show];
            return NO;
        }
		if(![self.txtContrasena.text isEqualToString:self.txtContrasenaConfirmar.text]){
			AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"formularioPassword", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            return NO;
		}

    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"error", @" ") message:NSLocalizedString(@"llenarCampos", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}

- (IBAction)verificarNombre:(UIButton *)sender {
    if ([self validaCampos]) {
        nombre = self.txtNombre.text;
		password = self.txtContrasena.text;
        codPromocion = self.txtCodigo.text;
        if ([codPromocion length] > 0 && ![CommonUtils validaCodigoRedimir:codPromocion]) {
            [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"txtErrorCodigo", nil) andAlertViewType:AlertViewTypeInfo] show];
        }
		
		else {
        
        //Descomentar esto es para que realize las peticiones al servidor
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(checaNombre) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField.tag < 3){
		NSInteger nextTag = textField.tag + 1;
		// Try to find next responder
		UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
		if (nextResponder) {
			// Found next responder, so set it.
			[nextResponder becomeFirstResponder];
		}
	}
    else if (textField.tag == 3 && [self validaCampos]) {
		
		nombre = self.txtNombre.text;
		password = self.txtContrasena.text;
        
        //Descomentar esto es para que realize las peticiones al servidor
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(checaNombre) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)seleccionaCodigoPais:(id)sender {
	SelectorPaisViewController * sel = [[SelectorPaisViewController alloc] initWithNibName:@"SelectorPaisViewController" bundle:Nil];
	sel.seleccionaDelegate = self;
    sel.nombreTituloVista = @"barraroja.png";
	[self.navigationController pushViewController:sel animated:YES];
	
}

#pragma mark - Selector País Delegate

-(void) guardaPais:(NSString *)pais yCodigo:(NSString *)codigoPais {

	if([codigoPais isEqualToString:@"+52"]){
		[self.txtNumero setFrame:CGRectMake(70, self.labelNumeroMovil.frame.origin.y+29, 230, 30)];

		self.casillaMovil.hidden = NO;
		self.casillaMovil.layer.cornerRadius = 10.0f;
	}else{
		[self.txtNumero setFrame:CGRectMake(20, self.labelNumeroMovil.frame.origin.y+29, 280, 30)];
		
		self.casillaMovil.hidden = YES;
	}
    seleccionoPais = YES;
	
	self.labelPais.text = pais;
	self.labelCodigoPais.text = codigoPais;
	pais = pais;
	codPais = codigoPais;
}

- (IBAction)toogleHelpAction:(id)sender {
    [productTourView setVisible:![productTourView isVisible]];
}





@end

