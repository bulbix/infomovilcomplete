//
//  EditarPaso2ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 08/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "EditarPaso2ViewController.h"
#import "KeywordDataModel.h"
#import "WS_ActualizarDireccion.h"

@interface EditarPaso2ViewController () {
    UITextField *textoEditado;
//    BOOL self.modifico;
    BOOL exito;
    BOOL estaEditando;
    BOOL borrar;
	
	NSMutableArray * respaldo;
	NSMutableArray *arregloDireccionAux;
}

@property (nonatomic, strong) AlertView *alertaDireccion;

@end

@implementation EditarPaso2ViewController

@synthesize diccionarioDireccion, index;

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
    // Do any additional setup after loading the view from its nib.
//    [self.tituloVista setText:NSLocalizedString(@"direccion", @" ")];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecaverde.png"]];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecacreasitio.png"]];
    
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"direccion", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"direccion", @" ") nombreImagen:@"NBverde.png"];
	}
    
    [self.labelDireccion1 setText:NSLocalizedString(@"direccion1", nil)];
    [self.txtCalle setPlaceholder:NSLocalizedString(@"direccion1", nil)];
    
    [self.labelDireccion2 setText:NSLocalizedString(@"direccion2", nil)];
    [self.txtColonia setPlaceholder:NSLocalizedString(@"direccion2", nil)];
    
    [self.labelDireccion3 setText:NSLocalizedString(@"direccion3", nil)];
    [self.txtPoblacion setPlaceholder:NSLocalizedString(@"direccion3", nil)];
    
    [self.labelCiudad setText:NSLocalizedString(@"ciudad", nil)];
    [self.txtCiudad setPlaceholder:NSLocalizedString(@"ciudad", nil)];
    
    [self.labelEstado setText:NSLocalizedString(@"estado", nil)];
    [self.txtEstado setPlaceholder:NSLocalizedString(@"estado", nil)];
    
    [self.labelPais setText:NSLocalizedString(@"pais", nil)];
    [self.txtPais setPlaceholder:NSLocalizedString(@"pais", nil)];
    
    [self.labelCodigoPostal setText:NSLocalizedString(@"cp", nil)];
    [self.txtCodigoPostal setPlaceholder:NSLocalizedString(@"cp", nil)];
    
    
    self.modifico = NO;
    
	[self setBotonRegresar];
    [self llenaCamposTexto];
    
    NSArray *fields = @[self.txtCalle, self.txtColonia, self.txtPoblacion, self.txtCiudad, self.txtEstado, self.txtPais, self.txtCodigoPostal];
    
    self.txtCalle.layer.cornerRadius		= 5.0f;
    self.txtColonia.layer.cornerRadius		= 5.0f;
    self.txtPoblacion.layer.cornerRadius	= 5.0f;
    self.txtCiudad.layer.cornerRadius		= 5.0f;
    self.txtEstado.layer.cornerRadius		= 5.0f;
    self.txtPais.layer.cornerRadius			= 5.0f;
    self.txtCodigoPostal.layer.cornerRadius = 5.0f;
    
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    [self.keyboardControls setDelegate:self];
    
    
    if ( estaEditando )
        [self.scrollDireccion setContentSize:CGSizeMake(305, _btnBorra.frame.size.height+_btnBorra.frame.origin.y)];
    else
        [self.scrollDireccion setContentSize:CGSizeMake(305, self.txtCodigoPostal.frame.size.height+self.txtCodigoPostal.frame.origin.y)];
}

-(void)viewWillAppear:(BOOL)animated{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"direccion", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"direccion", @" ") nombreImagen:@"NBverde.png"];
	}
	[super viewWillAppear:YES];
}

-(void) llenaCamposTexto {
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSMutableArray *arrayAux = [self.datosUsuario direccion];
	respaldo = [self.datosUsuario direccion];
    self.txtCalle.text		= [[[arrayAux objectAtIndex:0] keywordValue] isEqualToString:@" "]?@"":[[arrayAux objectAtIndex:0] keywordValue];
    self.txtColonia.text	= [[[arrayAux objectAtIndex:1] keywordValue] isEqualToString:@" "]?@"":[[arrayAux objectAtIndex:1] keywordValue];
    self.txtPoblacion.text	= [[[arrayAux objectAtIndex:2] keywordValue] isEqualToString:@" "]?@"":[[arrayAux objectAtIndex:2] keywordValue];
    self.txtCiudad.text		= [[[arrayAux objectAtIndex:3] keywordValue] isEqualToString:@" "]?@"":[[arrayAux objectAtIndex:3] keywordValue];
    self.txtEstado.text		= [[[arrayAux objectAtIndex:4] keywordValue] isEqualToString:@" "]?@"":[[arrayAux objectAtIndex:4] keywordValue];
    self.txtPais.text		= [[[arrayAux objectAtIndex:5] keywordValue] isEqualToString:@" "]?@"":[[arrayAux objectAtIndex:5] keywordValue];
    if ([arrayAux count] == 7) {
        self.txtCodigoPostal.text = [[[arrayAux objectAtIndex:6] keywordValue] isEqualToString:@" "]?@"":[[arrayAux objectAtIndex:6] keywordValue];
    }
    
    if (self.txtCalle.text.length > 0 || self.txtColonia.text.length > 0 || self.txtPoblacion.text.length > 0 || self.txtCiudad.text.length > 0 || self.txtEstado.text.length > 0 || self.txtPais.text.length > 0 || self.txtCodigoPostal.text.length > 0) {
        estaEditando = YES;
    }
    else {
        estaEditando = NO;
    }
    
    if ( !estaEditando )
        _btnBorra.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField {
    textoEditado = textField;
    NSInteger limite;
    if ([textoEditado isEqual:self.txtCodigoPostal]) {
        limite = 10;
    }
    else {
        limite = 255;
    }
    [self.keyboardControls setActiveField:textField];
    [self muestraContadorTexto:[textField.text length] conLimite:limite paraVista:textField];
    [self apareceTeclado:_scrollDireccion withView:textoEditado];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self ocultaContadorTexto];
	[self desapareceElTeclado:_scrollDireccion];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
	NSInteger maxLength;
    if ([textoEditado isEqual:self.txtCodigoPostal]) {
        maxLength = 10;
    }
    else {
        maxLength = 255;
    }
    NSInteger textoLength = [textField.text length] - range.length + [string length];
	
    if ( [string isEqualToString:@"<"] || [string isEqualToString:@">"] || [string isEqualToString:@"\n"] || textoLength > maxLength )
		return NO;
	
	if ( textoLength <= maxLength )
	{
		[self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength, (long)maxLength]];
		self.modifico = YES;
		return YES;
    }
	
	return NO;
}

//-(void) apareceElTeclado:(NSNotification*)aNotification {
//    NSDictionary *infoNotificacion = [aNotification userInfo];
//    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
////    tamanioTeclado = CGSizeMake(tamanioTeclado.width, tamanioTeclado.height+40);
//    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
//    [[self scrollDireccion] setContentInset:edgeInsets];
//    [[self scrollDireccion] setScrollIndicatorInsets:edgeInsets];
//    [[self scrollDireccion] scrollRectToVisible:textoEditado.frame animated:YES];
//    
//}
//-(void) desapareceElTeclado:(NSNotification *)aNotificacion {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
//    [[self scrollDireccion] setContentInset:edgeInsets];
//    [[self scrollDireccion] setScrollIndicatorInsets:edgeInsets];
//    [UIView commitAnimations];
//}

//-(void) apareceElTeclado {
//    CGSize tamanioTeclado = CGSizeMake(320, 260);
//    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
//    [[self scrollDireccion] setContentInset:edgeInsets];
//    [[self scrollDireccion] setScrollIndicatorInsets:edgeInsets];
//    [[self scrollDireccion] scrollRectToVisible:textoEditado.frame animated:YES];
//}
//-(void) desapareceElTeclado {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
//    [[self scrollDireccion] setContentInset:edgeInsets];
//    [[self scrollDireccion] setScrollIndicatorInsets:edgeInsets];
//    [UIView commitAnimations];
//}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    AlertView *alertView;
    if (self.modifico) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(IBAction)guardarInformacion:(id)sender {
    [[self view] endEditing:YES];
	
//	if (self.txtCalle.text.length > 0 || self.txtColonia.text.length > 0 || self.txtPoblacion.text.length > 0 || self.txtCiudad.text.length > 0 || self.txtEstado.text.length > 0 || self.txtPais.text.length > 0 || self.txtCodigoPostal.text.length > 0) {
    if (self.modifico || borrar )
    {
	
        NSArray *arrayValues = @[(_txtCalle.text.length > 0 && !borrar ) ? _txtCalle.text: @"",
                                 (_txtColonia.text.length > 0 && !borrar ) ? _txtColonia.text: @"",
                                 (_txtPoblacion.text.length > 0 && !borrar ) ? _txtPoblacion.text: @"",
                                 (_txtCiudad.text.length > 0 && !borrar ) ? _txtCiudad.text: @"",
                                 (_txtEstado.text.length > 0 && !borrar ) ? _txtEstado.text: @"",
                                 (_txtPais.text.length > 0 && !borrar ) ? _txtPais.text: @"",
                                 (_txtCodigoPostal.text.length > 0 && !borrar ) ? _txtCodigoPostal.text: @""];
        NSArray *arrayKeys = @[@"a1", @"a2", @"a3", @"tc", @"sp", @"c", @"pc"];
        
        //DatosUsuario * datos = [DatosUsuario sharedInstance];
        arregloDireccionAux = [[NSMutableArray alloc] initWithArray:[self.datosUsuario direccion] copyItems:YES];
        int i = 0;
        for(KeywordDataModel * data in self.datosUsuario.direccion){
            [[arregloDireccionAux objectAtIndex:i] setIdKeyword:[data idKeyword]];
            i++;
        }

        diccionarioDireccion = [[NSMutableArray alloc] init];
        
        if (estaEditando || ([arregloDireccionAux count] > 0 && [[arregloDireccionAux objectAtIndex:i-1] idKeyword] != 0)) {
            //self.datosUsuario = [DatosUsuario sharedInstance];
            diccionarioDireccion = arregloDireccionAux;
            for (int i=0; i < [arrayValues count]; i++) {
                [[diccionarioDireccion objectAtIndex:i] setKeywordValue:[arrayValues objectAtIndex:i]];
            }
            estaEditando = YES;
        }
        else {
            for (int i = 0; i < [arrayKeys count]; i++) {
                KeywordDataModel *keyword = [[KeywordDataModel alloc] init];
                [keyword setKeywordValue:[arrayValues objectAtIndex:i]];
                [keyword setKeywordField:[arrayKeys objectAtIndex:i]];
                [diccionarioDireccion addObject:keyword];
            }
        }
        
        NSMutableArray *arregloDireccion = [arregloDireccionAux copy];
        //self.datosUsuario = [DatosUsuario sharedInstance];
        arregloDireccionAux = diccionarioDireccion;
//        self.modifico = NO;
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
            for (int i = 0; i < [arregloDireccion count]; i++) {
                [[arregloDireccionAux objectAtIndex:i] setIdKeyword:[[arregloDireccion objectAtIndex:i] idKeyword]];
            }
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarDireccion) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:self
                                                        titulo:NSLocalizedString(@"sentimos", @" ")
                                                       message:NSLocalizedString(@"noConexion", @" ")
                                                       dominio:Nil
                                              andAlertViewType:AlertViewTypeInfo];
                [alert show];
                [self revertirGuardado];
            }
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
	}else{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void) accionSi {
//    if ( borrar )
//        [self limpiaDatos];
    [self guardarInformacion:nil];
}

-(void) accionNo {
    if (  borrar )
        borrar = NO;
    else
        [self.navigationController popViewControllerAnimated:YES];
}
-(void) accionAceptar {
    if (  borrar )
        borrar = NO;
    
    if (exito) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}

-(void) mostrarActivity {
    self.alertaDireccion = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarDireccion", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaDireccion show];
}

-(void) ocultarActivity {
    if ( self.alertaDireccion )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaDireccion hide];
    }
    borrar = NO;
    if (exito) {
        AlertView *alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertView show];
    }
    else {
        AlertView *alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertView show];
		[self revertirGuardado];
    }
}

-(void) actualizarDireccion {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_ActualizarDireccion *actualizarDireccion = [[WS_ActualizarDireccion alloc] init];
        [actualizarDireccion setDireccionDelegate:self];
        [actualizarDireccion setArregloDireccion:arregloDireccionAux];
        if (estaEditando) {
            [actualizarDireccion actualizarDireccion];
        }
        else {
            [actualizarDireccion insertarDireccion];
        }
    }
    else {
        if ( self.alertaDireccion )
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertaDireccion hide];
        }
        self.alertaDireccion = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertaDireccion show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)actualizaEstatus
{
    NSMutableArray *arrayAux = self.datosUsuario.arregloEstatusEdicion;
    if ( (!borrar) && (self.txtCalle.text.length > 0 || self.txtColonia.text.length > 0 || self.txtPoblacion.text.length > 0 || self.txtCiudad.text.length > 0 || self.txtEstado.text.length > 0 || self.txtPais.text.length > 0 || self.txtCodigoPostal.text.length > 0)) {
        [arrayAux replaceObjectAtIndex:index withObject:@YES];
      //  [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito Direccion" withValue:@""];
        [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Direccion"];
    }
    else {
     //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro Direccion" withValue:@""];
        [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Direccion"];
        [arrayAux replaceObjectAtIndex:index withObject:@NO];
    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado
{
    if ([resultado isEqualToString:@"Exito"]) {
        exito = YES;
        [self actualizaEstatus];
    }
    else {
        exito = NO;
    }
    [self performSelectorInBackground:@selector(ocultarActivity) withObject:Nil];
}

-(void) resultadoInsertarDireccion:(NSString *) diccionarioID {
    if ([diccionarioID isEqualToString:@"Exito"]) {
        
        exito = YES;
        [self actualizaEstatus];
    }
    else {
        exito = NO;
    }
    [self performSelectorInBackground:@selector(ocultarActivity) withObject:Nil];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar {
    if ( self.alertaDireccion )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaDireccion hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
	[self revertirGuardado];
}

-(void)revertirGuardado{
	 self.datosUsuario = [DatosUsuario sharedInstance];
	if(estaEditando){
		self.datosUsuario.direccion = respaldo;
	}else{
		self.datosUsuario.direccion = respaldo;
	}
//	NSLog(@"Direccion: %@",self.datosUsuario.direccion);
}


- (IBAction)borrarDireccion:(id)sender
{
    borrar = YES;
//    self.modifico = YES;
    [[AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeEliminarPerfil", nil) andAlertViewType:AlertViewTypeQuestion] show];
}

-(void)limpiaDatos
{
    [self.txtCalle setText: @""];
    [self.txtColonia setText: @""];
    [self.txtPoblacion setText: @""];
    [self.txtCiudad setText: @""];
    [self.txtEstado setText: @""];
    [self.txtPais setText: @""];
    [self.txtCodigoPostal setText: @""];
}

-(void) errorToken {
    if ( self.alertaDireccion )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaDireccion hide];
    }
    self.alertaDireccion = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertaDireccion show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sessionTimeout
{
    if ( self.alertaDireccion )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaDireccion hide];
    }
    self.alertaDireccion = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertaDireccion show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
