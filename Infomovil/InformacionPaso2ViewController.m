//
//  InformacionPaso2ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InformacionPaso2ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "InformacionAdicional.h"
#import "KeywordDataModel.h"
#import "WS_ActualizarDireccion.h"

@interface InformacionPaso2ViewController () {
//    BOOL self.modifico;
    BOOL exito;
    NSInteger idKeyword;
    BOOL estaBorrando;
    BOOL estaEditando;
	
	BOOL btextField;
	BOOL btextArea;
	
	BOOL editando;
	
	NSMutableArray * respaldo;
    NSMutableArray *arregloInformacionAux;
	
	UITextField *textoEditado;
}

@property (nonatomic, strong) KeywordDataModel *informacion;
@property (nonatomic, strong) AlertView *alertInformacion;

@end

@implementation InformacionPaso2ViewController
@synthesize informacion;

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
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirInformacion", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirInformacion", @" ") nombreImagen:@"NBverde.png"];
	}
    self.txtInfo.layer.cornerRadius = 5;
    arregloInformacionAux = [[NSMutableArray alloc] init];
    
    self.txtTitulo.layer.cornerRadius = 5;
    self.modifico = NO;
    [self.labelAgregarTitulo setText:NSLocalizedString(@"agregaTitulo", Nil)];
    [self.labelInformacionAdicional setText:NSLocalizedString(@"informacionAdicional", Nil)];
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
	
	btextArea = NO;
	btextField = NO;
	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
	respaldo = [[NSMutableArray alloc] initWithArray:self.datosUsuario.arregloInformacionAdicional copyItems:YES];
    if (self.operacionInformacion == InfoAdicionalOperacionEditar) {
        KeywordDataModel *model = [self.datosUsuario.arregloInformacionAdicional objectAtIndex:self.index];
        [self.txtTitulo setText:model.keywordField];
        [self.txtInfo setText:model.keywordValue];
        [self.btnEliminar setEnabled:YES];
		editando = YES;
    }
	
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirInformacion", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirInformacion", @" ") nombreImagen:@"NBverde.png"];
	}
    

    if(IS_STANDARD_IPHONE_6_PLUS){
        [self.labelAgregarTitulo setFrame:CGRectMake(50, 20, 314, 21)];
        [self.labelInformacionAdicional setFrame:CGRectMake(50, 95, 314, 21)];
        self.txtTitulo.frame = CGRectMake(50, 49, 314, 30 );
        self.txtInfo.frame = CGRectMake(50, 124, 314, 128);
        [self.btnEliminar setFrame:CGRectMake(334, 281, 29, 35)];
        [self.scroll setFrame:CGRectMake(0, 0, 414, 736)];
    }else if(IS_STANDARD_IPHONE_6){
        self.txtTitulo.frame = CGRectMake(20, 49, 335, 30 );
        self.txtInfo.frame = CGRectMake(20, 124, 335, 128);
    }else if(IS_IPAD){
        [self.labelAgregarTitulo setFrame:CGRectMake(84, 20, 600, 21)];
        [self.labelInformacionAdicional setFrame:CGRectMake(84, 95, 600, 21)];
        self.txtTitulo.frame = CGRectMake(84, 49, 600, 30 );
        self.txtInfo.frame = CGRectMake(84, 124, 600, 128);
        [self.btnEliminar setFrame:CGRectMake(650, 281, 29, 35)];
        [self.scroll setFrame:CGRectMake(0, 0, 768, 1024)];
    }else{
    
    }
}

#pragma mark
#pragma mark UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self muestraContadorTexto:[textView.text length] conLimite:400 paraVista:textView];
	[self apareceElTeclado];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	if ([textView.text isEqualToString:@"Puedes utilizar este espacio para añadir cualquier información adicional"]) {
        btextArea = NO;
    }else{
		btextArea = YES;
	}

    [self ocultaContadorTexto];
	[self desapareceElTeclado];
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    return [self shouldChangeText:text withLimit:400 forFinalLenght:[textView.text length] - range.length + [text length]];
}

#pragma mark
#pragma mark UITextFieldDelegate

//-(void) textFieldDidBeginEditing:(UITextField *)textField {
//	
//	textoEditado = textField;
//    [self.keyboardControls setActiveField:textField];
//	
//    NSInteger textoLength = [textField.text length];
//    [self.labelInfo setText:[NSString stringWithFormat:@"%i/%i", textoLength, 255]];
//    //[UIView animateWithDuration:0.4f animations:^{
//	//[self.labelInfo setFrame:CGRectMake(284, 200, 33, 21)];
//    //}];
//
//}
//
//-(void) textFieldDidEndEditing:(UITextField *)textField {
//	NSInteger textoLength = [textField.text length];
//	if(textoLength != 0){
//		btextField = YES;
//	}
//    //[UIView animateWithDuration:0.4f animations:^{
//    //    [self.labelInfo setFrame:CGRectMake(284, 600, 33, 21)];
//    //}];
//
//}

-(void) apareceElTeclado {
	
	if(IS_IPHONE_4){
		self.scroll.frame = CGRectMake(0, -80, 320, 328);
    }
    
    CGSize tamanioTeclado = CGSizeMake(320, 260);
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [[self scroll] setContentInset:edgeInsets];
    [[self scroll] setScrollIndicatorInsets:edgeInsets];
    [[self scroll] scrollRectToVisible:textoEditado.frame animated:YES];
    
}
-(void) desapareceElTeclado {
	
	if(IS_IPHONE_4){
		self.scroll.frame = CGRectMake(0, 0, 320, 328);
	}
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scroll] setContentInset:edgeInsets];
    [[self scroll] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}


//-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    self.modifico = YES;
//    NSInteger maxLength = 255;
//    NSInteger textoLength = [textField.text length];
//    if (textoLength < maxLength) {
//        if ([string isEqualToString:@"<"] || [string isEqualToString:@">"]) {
//            return NO;
//        }
//        else {
//            if ([string isEqualToString:@""]) {
//                [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength-1, (long)maxLength]];
//            }
//            else {
//                [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength+1, (long)maxLength]];
//            }
//            return YES;
//        }
//    }
//    else {
//        if ([string isEqualToString:@""]) {
//            [self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength-1, (long)maxLength]];
//            return YES;
//        }
//        return NO;
//    }
//}

-(IBAction)guardarInformacion:(id)sender {
    [self guardaDatos];
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    AlertView *alertView;
    if (self.modifico && [CommonUtils hayConexion]) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) accionSi {    if (estaBorrando) {
        self.datosUsuario = [DatosUsuario sharedInstance];
        arregloInformacionAux = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloInformacionAdicional count]];
        for (KeywordDataModel *keyData in self.datosUsuario.arregloInformacionAdicional) {
            KeywordDataModel *keyAux = [[KeywordDataModel alloc] init];
            [keyAux setKeywordField:[keyData keywordField]];
            [keyAux setKeywordValue:[keyData keywordValue]];
            [keyAux setKeywordPos:[keyData KeywordPos]];
            [keyAux setIdKeyword:[keyData idKeyword]];
            [arregloInformacionAux addObject:keyAux];
        }
        idKeyword = [[arregloInformacionAux objectAtIndex:self.index] idKeyword];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
            estaBorrando = YES;
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarInformacion) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }
    }
    else {
        [self guardaDatos];
    }
    
}

-(void) accionNo {
    if (!estaBorrando) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) accionAceptar {
    if (exito) {
        self.datosUsuario = [DatosUsuario sharedInstance];
        if ([self.datosUsuario.arregloInformacionAdicional count] == 0) {
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:11 withObject:@NO];
        }
        else {
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:11 withObject:@YES];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) mostrarActivity {
    self.alertInformacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarInfoAd", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertInformacion show];
}

-(void) ocultarActivity {
    if (self.alertInformacion)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertInformacion hide];
    }
    AlertView *alertView;
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.operacionInformacion == InfoAdicionalOperacionAgregar) {
        if (exito) {
            KeywordDataModel *dataModel = [self.datosUsuario.arregloInformacionAdicional lastObject];
            [dataModel setIdKeyword:idKeyword];
         //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito Informacion adicional" withValue:@""];
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Informacion adicional"];
        }
        else {
       //     [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro Informacion adicional" withValue:@""];
            [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Informacion adicional"];
            [self.datosUsuario.arregloInformacionAdicional removeLastObject];
        }
    }
    if (exito) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertView show];
    }
    else {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertView show];
		[self revertirGuardado];
    }
}

-(void) actualizarInformacion {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_ActualizarDireccion *actualizarDireccion = [[WS_ActualizarDireccion alloc] init];
        [actualizarDireccion setArregloPerfil:arregloInformacionAux];
        [actualizarDireccion setIndexSeleccionado:self.index];
        [actualizarDireccion setTipoInfo:2]; //Info adicional
        [actualizarDireccion setDireccionDelegate:self];
        if (self.operacionInformacion == InfoAdicionalOperacionAgregar) {
            [actualizarDireccion insertarInformacion];
        }
        else {
            if (estaBorrando) {
                [actualizarDireccion eliminarKeywordConId:idKeyword];
            }
            else {
                [actualizarDireccion actualizarInformacion];
            }
        }
    }
    else {
        if (self.alertInformacion)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertInformacion hide];
        }
        self.alertInformacion = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertInformacion show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if (self.operacionInformacion == InfoAdicionalOperacionAgregar) {
        if ([resultado integerValue] > 0) {
            idKeyword = [resultado integerValue];
            exito = YES;
        }
        else {
            exito = NO;
        }
    }
    else {
        if ([resultado isEqualToString:@"Exito"]) {
            exito = YES;
        }
        else {
            exito = NO;
        }
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertInformacion)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertInformacion hide];
    }
    self.alertInformacion = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertInformacion show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) sessionTimeout
{
    if (self.alertInformacion)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertInformacion hide];
    }
    self.alertInformacion = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertInformacion show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar {
    if (self.alertInformacion)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertInformacion hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
	[self revertirGuardado];
}

- (IBAction)eliminarAdicional:(UIButton *)sender {
    estaBorrando = YES;
    self.alertInformacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeEliminarPerfil", nil) andAlertViewType:AlertViewTypeQuestion];
    [self.alertInformacion show];
    
}

-(void)revertirGuardado{
	self.datosUsuario.arregloInformacionAdicional = respaldo;
	self.modifico = NO;
}

-(void) guardaDatos {
    [self.view endEditing:YES];
    self.datosUsuario = [DatosUsuario sharedInstance];
	
	if([self.txtTitulo.text isEqualToString:@""] && ![self.txtInfo.text isEqualToString:@""]){
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			AlertView *alert = [AlertView initWithDelegate:nil message:@"Enter any title" andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
        else{
			AlertView *alert = [AlertView initWithDelegate:nil message:@"Ingresa algún título" andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
    }

	else if(![self.txtTitulo.text isEqualToString:@""] && [self.txtInfo.text isEqualToString:@""]){
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			AlertView *alert = [AlertView initWithDelegate:nil message:@"Enter any information" andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}else{
			AlertView *alert = [AlertView initWithDelegate:nil message:@"Ingresa alguna información" andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
    }
	else if(editando && self.modifico && (btextField || btextArea)){
        arregloInformacionAux = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloInformacionAdicional count]];
        for (KeywordDataModel *keyData in self.datosUsuario.arregloInformacionAdicional) {
            KeywordDataModel *keyAux = [[KeywordDataModel alloc] init];
            [keyAux setKeywordField:[keyData keywordField]];
            [keyAux setKeywordValue:[keyData keywordValue]];
            [keyAux setKeywordPos:[keyData KeywordPos]];
            [keyAux setIdKeyword:[keyData idKeyword]];
            [arregloInformacionAux addObject:keyAux];
        }
		((KeywordDataModel *)[arregloInformacionAux objectAtIndex:self.index]).keywordField = [self.txtTitulo text];
		((KeywordDataModel *)[arregloInformacionAux objectAtIndex:self.index]).keywordValue = [self.txtInfo text];
		if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
			if ([CommonUtils hayConexion]) {
				[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
				[self performSelectorInBackground:@selector(actualizarInformacion) withObject:Nil];
			}
			else {
				AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
				[alert show];
				[self revertirGuardado];
			}
		}
		else {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}else if (self.modifico && (btextField || btextArea)) {
        informacion = [[KeywordDataModel alloc] init];
        [informacion setKeywordField:[self.txtTitulo text]];
		if(btextArea){
			[informacion setKeywordValue:[self.txtInfo text]];
		}else{
			[informacion setKeywordValue:@" "];
		}
        
        arregloInformacionAux = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloInformacionAdicional count]];
        for (KeywordDataModel *keyData in self.datosUsuario.arregloInformacionAdicional) {
            KeywordDataModel *keyAux = [[KeywordDataModel alloc] init];
            [keyAux setKeywordField:[keyData keywordField]];
            [keyAux setKeywordValue:[keyData keywordValue]];
            [keyAux setKeywordPos:[keyData KeywordPos]];
            [keyAux setIdKeyword:[keyData idKeyword]];
            [arregloInformacionAux addObject:keyAux];
        }
        [arregloInformacionAux addObject:informacion];
        self.modifico = NO;
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarInformacion) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if([self.txtTitulo.text isEqualToString:@""] || [self.txtInfo.text isEqualToString:@""]){
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			AlertView *alert = [AlertView initWithDelegate:nil message:@"Enter any information" andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}else{
			AlertView *alert = [AlertView initWithDelegate:nil message:@"Ingresa alguna información" andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
    }
	else{
		[self.navigationController popViewControllerAnimated:YES];
        
	}
}


#pragma mark - UITextFieldDelegate

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self muestraContadorTexto:[textField.text length] conLimite:32 paraVista:textField];
//    [self apareceTeclado];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self ocultaContadorTexto];
//	[self desapareceElTeclado];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string isEqualToString:@"\n"] )
        return NO;
    if ( [self shouldChangeText:string withLimit:32 forFinalLenght:[textField.text length] - range.length + [string length]] == YES )
    {
        btextField = YES;
        return YES;
    }
    
    return NO;
}

@end
