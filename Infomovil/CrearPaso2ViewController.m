//
//  CrearPaso2ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CrearPaso2ViewController.h"
#import "TipoContactoViewController.h"
#import "Base64.h"
#import "WS_HandlerActualizarDominio.h"
#import "GaleriaImagenes.h"
#import "WS_HandlerGaleria.h"
#import "UIViewDefs.h"

#import "AppDelegate.h"
#import "MainViewController.h"


@interface CrearPaso2ViewController () {
    id textoPulsado;
    BOOL actualizoDominio;
    BOOL esCamara;
    BOOL estaBorrando;
    NSInteger idLogo;
	UITextView *textViewEditado;
    NSString *nombre;
	NSString *descripcion;
    GaleriaImagenes *imagenesAux;
	
	BOOL borrar;
}

@property (nonatomic, strong) NSDictionary *diccionarioCampos;
@property (nonatomic, strong) NSArray *arregloTitulos;
@property (nonatomic, strong) UIImage *imagenTomada;
@property (nonatomic, strong) AlertView *alertActivity;

@end

@implementation CrearPaso2ViewController

@synthesize index, tituloPaso;
@synthesize textEmpresa, txtDescripcion; //vistaLogo;
@synthesize diccionarioCampos;
@synthesize arregloTitulos, labelInfo;

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
    
    txtDescripcion.layer.cornerRadius = 5.0f;
    textEmpresa.layer.cornerRadius = 5.0f;
	
	[self.scrollEmpresa setContentSize:CGSizeMake(320, 504)];
    
    self.datosUsuario = [DatosUsuario sharedInstance];
    
    if (index == 0) {
        [self.textEmpresa setText:[self.datosUsuario nombreEmpresa]];
    }else {
        [self.txtDescripcion setText:[self.datosUsuario descripcion]];
    }
	
	if(index == 0 && ![self.textEmpresa.text isEqualToString:@""]){
		self.botonEliminar.hidden = NO;
	}else if(index == 3 && ![self.txtDescripcion.text isEqualToString:@""]){
		self.botonEliminar.hidden = NO;
	}
    
    self.modifico = NO;
    
	[self setBotonRegresar];
	
	borrar = NO;
   
}




-(void) viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tituloVista setHidden:NO];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:tituloPaso nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:tituloPaso nombreImagen:@"NBverde.png"];
	}
    [self configuraVista];
    
    if(IS_IPAD){
        self.labelInstruccion.frame = CGRectMake(84, 6, 600, 83);
        self.textEmpresa.frame = CGRectMake(84,65 , 600, 30);
        self.txtDescripcion.frame = CGRectMake(84, 83, 600, 109);
        self.botonEliminar.frame = CGRectMake(655,258 , 29, 35);
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        self.labelInstruccion.frame = CGRectMake(0, 6, 375, 40);
        self.textEmpresa.frame = CGRectMake(50,65 , 275, 30);
        self.txtDescripcion.frame = CGRectMake(50, 60, 275, 109);
    
    }
    
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void) configuraVista
{
	switch (index)
	{
		case 0:
            [self.textEmpresa becomeFirstResponder];
            
			[self.vistaEmpresa setHidden:NO];
			[self.labelInstruccion setText:NSLocalizedString(@"agregaNombreEmpresa", nil)];
			[textEmpresa setHidden:NO];
			[txtDescripcion setHidden:YES];
			break;
		case  3:
            [self.txtDescripcion becomeFirstResponder];
			[self.vistaEmpresa setHidden:NO];
			[self.labelInstruccion setText:NSLocalizedString(@"agregaDescripcion", @" ")];
			[textEmpresa setHidden:YES];
			[txtDescripcion setHidden:NO];
			break;
	}


}


#pragma mark - Teclado
// IDM Al padre
-(void) apareceTeclado {

	[self apareceTeclado:_scrollEmpresa withView:_vista];
}
// IDM Al padre
-(void) desapareceElTeclado {
	[self desapareceElTeclado:_scrollEmpresa];
	[[self scrollEmpresa] scrollRectToVisible:_vista.frame animated:YES];
}


#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger textoLength = [textField.text length];
    [labelInfo setText:[NSString stringWithFormat:@"%li/%i", (long)textoLength, 128]];
    [UIView animateWithDuration:0.4f animations:^{
        [labelInfo setFrame:CGRectMake(265, textField.frame.origin.y + textField.frame.size.height, 33, 21)];
    }];
	labelInfo.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4f animations:^{
        [labelInfo setFrame:CGRectMake(265, 600, 33, 21)];
    }];
//    [self ocultaContadorTexto];
	labelInfo.hidden = YES;
}
// IDM al padre
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger maxLength = 128;
    NSInteger textoLength = [textField.text length] - range.length + [string length];
	
	
    if ( [string isEqualToString:@"<"] || [string isEqualToString:@">"] || [string isEqualToString:@"\n"] || textoLength > maxLength )
		return NO;
	
	if ( textoLength <= maxLength )
	{
		[self.labelInfo setText:[NSString stringWithFormat:@"%li/%li", (long)textoLength, (long)maxLength]];
		self.modifico = YES;
		return YES;
    }
	
	return NO;

}

#pragma mark - UITextViewDelegate
// IDM al padre
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	NSInteger maxLength = 128;
    NSInteger textoLength = [textView.text length] - range.length + [text length];
	
    if ( [text isEqualToString:@"<"] || [text isEqualToString:@">"] || textoLength > maxLength )
		return NO;
	
	if ( textoLength <= maxLength )
	{
		[self.labelInfo setText:[NSString stringWithFormat:@"%li/%li", (long)textoLength, (long)maxLength]];
		self.modifico = YES;
		return YES;
    }
	
	return NO;
[self apareceTeclado];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
	textViewEditado = textView;
    NSInteger textoLength = [textView.text length];
    [labelInfo setText:[NSString stringWithFormat:@"%li/%i", (long)textoLength, 128]];
    [UIView animateWithDuration:0.4f animations:^{
        [labelInfo setFrame:CGRectMake(265, textView.frame.origin.y + textView.frame.size.height, 33, 21)];
    }];
	[self apareceTeclado];
	labelInfo.hidden = NO;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.4f animations:^{
        [labelInfo setFrame:CGRectMake(265, 600, 33, 21)];
    }];
	[self desapareceElTeclado];
	labelInfo.hidden = YES;
}

-(IBAction)guardarInformacion:(id)sender { NSLog(@"ENTRO A GUARDAR INFORMACIÓN!!");
	BOOL procesando = NO;
    [[self view] endEditing:YES];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (index == 0) {
		if (borrar) {
			nombre = @"";
		}else{
			nombre = self.textEmpresa.text;
		}
		descripcion = self.datosUsuario.descripcion;
    }else {
		if (borrar) {
			descripcion = @"";
		}else{
			descripcion = self.txtDescripcion.text;
		}
		nombre		= self.datosUsuario.nombreEmpresa;
    }

    if ((self.modifico || borrar) ) {
        if ([CommonUtils hayConexion]) {
			if(!procesando){
				[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
			}
            [self performSelectorInBackground:@selector(actualizar) withObject:Nil];
        }
        else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
    }else{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void) accionSi {
    [self guardarInformacion:nil];

}

-(void) accionNo {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) accionAceptar {
    if (actualizoDominio) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

-(void) mostrarActivity {
    self.alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertActivity show];
}

-(void) ocultarActivity {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    if (actualizoDominio) {
        self.modifico = NO;
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    else {
        //[self revertirGuardado];
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
	
	[self.navigationController popViewControllerAnimated:YES];
    
}

-(void) actualizar {
  
        WS_HandlerActualizarDominio *actualizarDominio = [[WS_HandlerActualizarDominio alloc] init];
        [actualizarDominio setActualizarDominioDelegate:self];
        [actualizarDominio setNombre:nombre];
        [actualizarDominio setDescripcion:descripcion];
        
        switch (index)
        {
            case 0:
                [actualizarDominio actualizarDominio:k_UPDATE_TITULO];
                break;
            case 3:
                [actualizarDominio actualizarDominio:k_UPDATE_DESC_CORTA];
            default:
                break;
        }
   
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
	NSMutableArray *arrayAux = self.datosUsuario.arregloEstatusEdicion;
    if (([resultado isEqualToString:@"Exito"] || [resultado integerValue] > 0) && borrar==NO) {
        actualizoDominio = YES;
		[arrayAux replaceObjectAtIndex:index withObject:@YES];
        if (index == 0) {
      
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Nombre"];
        }
        else {
     
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Descripcion"];
        }
    }
    else {
		if( ([resultado isEqualToString:@"Exito"] || [resultado integerValue] > 0) && borrar){
			actualizoDominio = YES;
            if (index == 0) {
                self.datosUsuario.nombreEmpresa = nil;
           
                [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Nombre"];
            } else{
                self.datosUsuario.descripcion = nil;
           
                [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Descripcion"];
            }
            [arrayAux replaceObjectAtIndex:index withObject:@NO];
		}else{
			actualizoDominio = NO;
		}
		borrar = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorPublicar) withObject:Nil waitUntilDone:YES];
}

-(void) errorPublicar {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
    [alert show];
}

-(void) guardarCarrete:(UIImage *) imagen {
    UIImageWriteToSavedPhotosAlbum(imagen,
                                   self,
                                   @selector(image:finishedSavingWithError:contextInfo:),
                                   nil);
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
#if DEBUG
    if (error) {
        NSLog(@"No se guardo la imagen, inténtalo nuevamente");
    } else {
        NSLog(@"La imagen se guardo correctamento");
    }
#endif
}

- (IBAction)borrar:(UIButton *)sender {
	AlertView * alerta = [AlertView initWithDelegate:self
											 message:NSLocalizedString(@"paso2Eliminar", nil)
									andAlertViewType:AlertViewTypeQuestion];
	[alerta show];
	borrar = YES;
//	self.modifico = YES;
}

-(void) errorToken {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}



@end
