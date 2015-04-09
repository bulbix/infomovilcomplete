//  ContactoPaso2ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 15/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "ContactoPaso2ViewController.h"
#import "SelectorPaisViewController.h"
#import "Contacto.h"
#import "WS_HandlerContactos.h"
#import "StringUtils.h"
#import "AppsFlyerTracker.h"

@interface ContactoPaso2ViewController () {
    id textoPulsado;
    BOOL actualizoCorrecto;
    NSInteger idEliminarContacto;
    BOOL estaGuardando;
    
    NSInteger idContacto;
	
	NSString *url;
	BOOL fueGuardado;
    Contacto *contactoAux;
	
	NSString * codigo;
	NSString *codigoAnterior;
	
	NSMutableArray * arregloContactosAux;
}

@property (nonatomic, strong) NSArray *arregloTitulos;
@property (nonatomic, strong) AlertView *alertaContacto;

@end

@implementation ContactoPaso2ViewController

@synthesize arregloTitulos, labelInfo, seleccionoPais;

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
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"NBverde.png"];
	}
	
    arregloTitulos = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    [self.labelPais setText:NSLocalizedString(@"pais", Nil)];
    [self.labelDescripcion setText:NSLocalizedString(@"descripcion", Nil)];
    _labelInfoMexico.text = NSLocalizedString(@"movilMexico", Nil);
    self.txtDescripcion.layer.cornerRadius = 5;
    self.modifico = NO;
    self.txtLada.layer.cornerRadius = 5;
    self.txtTelefono.layer.cornerRadius = 5.0f;
    self.vistaPais.layer.cornerRadius = 5;
	self.casillaMovil.hidden = YES;
	url = @"";
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.labelTipoContacto setText:[self.tipoContacto objectForKey:@"text"]];
    [self acomodaVista];
	
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"NBverde.png"];
	}
    
    if(IS_STANDARD_IPHONE_6_PLUS){
        self.scrollVista.frame = CGRectMake(50, 20, 364, 500);
        [self.btnEliminar setFrame:CGRectMake(270, 325, 29, 35)];
    }else if(IS_STANDARD_IPHONE_6){
        self.imagenSiguiente.frame = CGRectMake(310, 6, 11, 18);
        self.btnSeleccionarPais.frame = CGRectMake(20, 86, 335, 30);
        [self.btnEliminar setFrame:CGRectMake(320, 300, 29, 35)];
        self.vistaPais.frame = CGRectMake(20, 86, 335, 30);
        
    }else if(IS_IPAD){
        self.btnSeleccionarPais.frame = CGRectMake(84, 86, 600, 30);
        self.imagenSiguiente.frame = CGRectMake(450, 6, 11, 18);
        self.scrollVista.frame = CGRectMake(134, 20, 500, 850);
        self.vistaPais.frame = CGRectMake(20, 86, 500, 30);
        self.txtDescripcion.frame = CGRectMake(20, 180, 500, 100);
        [self.btnEliminar setFrame:CGRectMake(450, 325, 29, 35)];
    }
    
}

-(void) acomodaVista {
    if (self.contactosOperacion == ContactosOperacionAgregar) {
		[self.btnEliminar setHidden:NO];
		[self.btnEliminar setFrame:CGRectMake(271, 300, 29, 35)];
        switch (self.opcionSeleccionada) {
            case 0:
            case 1:
            case 2:
            case 4:
                [self.vistaPais setHidden:NO];
                [self.txtTelefono setHidden:NO];
                [self.txtTelefono setKeyboardType:UIKeyboardTypePhonePad];
                [self.btnSeleccionarPais setHidden:NO];
                [self.labelDescripcion setFrame:CGRectMake(self.labelDescripcion.frame.origin.x, 158, self.labelDescripcion.frame.size.width, self.labelDescripcion.frame.size.height)];
                [self.scrollVista setContentSize:CGSizeMake(320, 280)];
                if (self.opcionSeleccionada == 1 && [self.labelCodigo.text isEqualToString:@"+52"]){                     [self.labelInfoMexico setHidden:NO];
                    if(IS_STANDARD_IPHONE_6){
                        self.txtDescripcion.frame = CGRectMake(20, 190, 335, 100);
                        self.txtTelefono.frame = CGRectMake(70, 120, 335, 30);
                    }else if(IS_STANDARD_IPHONE_6_PLUS){
                        self.txtTelefono.frame = CGRectMake(70, 120, 280, 30);
                    }else if(IS_IPAD){
                        self.txtTelefono.frame = CGRectMake(20, 120, 600, 30);
                    }else{
                        [self.txtDescripcion setFrame:CGRectMake(self.txtDescripcion.frame.origin.x, 181, self.txtDescripcion.frame.size.width, self.txtDescripcion.frame.size.height)];
                        [self.txtTelefono setFrame:CGRectMake(70, 120, 230, 30)];
                    }
					self.casillaMovil.hidden = NO;
					self.casillaMovil.layer.cornerRadius = 5;
					
					[self.labelDescripcion setFrame:CGRectMake(self.labelDescripcion.frame.origin.x, 188, self.labelDescripcion.frame.size.width, self.labelDescripcion.frame.size.height)];
					[self.txtDescripcion setFrame:CGRectMake(self.txtDescripcion.frame.origin.x, 211, self.txtDescripcion.frame.size.width, self.txtDescripcion.frame.size.height)];
					
                }
				else{
                    if(IS_STANDARD_IPHONE_6){
                         self.txtDescripcion.frame = CGRectMake(20, 190, 335, 100);
                         self.txtTelefono.frame = CGRectMake(20, 120, 335, 30);
                    }else if(IS_STANDARD_IPHONE_6_PLUS){
                        self.txtTelefono.frame = CGRectMake(20, 120, 280, 30);
                    }else if(IS_IPAD){
                         self.txtTelefono.frame = CGRectMake(20, 120, 600, 30);
                    }else{
                        [self.txtTelefono setFrame:CGRectMake(20, 120, 280, 30)];
                    }
					
					self.casillaMovil.hidden = YES;
					[self.labelInfoMexico setHidden:YES];
				}
                break;
                
            default:
				seleccionoPais = NO;
                [self.vistaPais setHidden:YES];
                
                if(IS_STANDARD_IPHONE_6){
                    self.txtDescripcion.frame = CGRectMake(20, 160, 335, 100);
                    self.txtTelefono.frame = CGRectMake(20, 86, 335, 30);
                }else if(IS_STANDARD_IPHONE_6_PLUS){
                    self.txtTelefono.frame = CGRectMake(20, 86, 280, 30);
                }else if(IS_IPAD){
                    self.txtTelefono.frame = CGRectMake(20, 86, 600, 30);
                
                }else{
                    [self.txtTelefono setFrame:CGRectMake(20, 86, 280, 30)];
                    [self.txtDescripcion setFrame:CGRectMake(self.txtDescripcion.frame.origin.x, 153, self.txtDescripcion.frame.size.width, self.txtDescripcion.frame.size.height)];
                }
                
                [self.txtTelefono setHidden:NO];
                [self.btnSeleccionarPais setHidden:YES];
                [self.txtTelefono setPlaceholder:@""];
                [self.txtTelefono setKeyboardType:UIKeyboardTypeURL];
                [self.labelDescripcion setFrame:CGRectMake(self.labelDescripcion.frame.origin.x, 124, self.labelDescripcion.frame.size.width, self.labelDescripcion.frame.size.height)];
                
                [self.scrollVista setContentSize:CGSizeMake(320, 250)];
                break;
        }
        
        NSDictionary *dictAux = [arregloTitulos objectAtIndex:self.opcionSeleccionada];
        [self.imagenTipoContacto setImage:[UIImage imageNamed:[dictAux objectForKey:@"image"]]];
        [self.labelNumeroTelefonico setText:[dictAux objectForKey:@"mensaje"]];
        if (self.txtTelefono.text.length == 0) {
            [self.txtTelefono setPlaceholder:[dictAux objectForKey:@"ejemplo"]];
        }
    }
    else {
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.opcionSeleccionada = self.contactoSeleccionado.indice;
        [self.btnEliminar setHidden:NO];
#ifdef _DEBUG
		NSLog(@"id: %i",self.contactoSeleccionado.idContacto);
#endif
        switch (self.opcionSeleccionada) {
            case 0:
            case 1:
				
            case 2:
            case 4:
				self.seleccionoPais = YES;
                [self.vistaPais setHidden:NO];
                [self.txtTelefono setHidden:NO];
                [self.btnSeleccionarPais setHidden:NO];
                [self.txtTelefono setKeyboardType:UIKeyboardTypePhonePad];
                [self.labelDescripcion setFrame:CGRectMake(self.labelDescripcion.frame.origin.x, 158, self.labelDescripcion.frame.size.width, self.labelDescripcion.frame.size.height)];
              
                [self.scrollVista setContentSize:CGSizeMake(320, 280)];
                [self.txtDescripcion setText:[self.contactoSeleccionado descripcion]];
                if ([self.labelPais.text isEqualToString:@"País"] || [self.labelPais.text isEqualToString:@"Country"]) {
                    [self.labelPais setText:[self.contactoSeleccionado pais]];
                    [self.labelCodigo setText:[self.contactoSeleccionado idPais]];
                }
                [self.txtTelefono setText:[self.contactoSeleccionado noContacto]];
                [self.txtDescripcion setText:[self.contactoSeleccionado descripcion]];
                [self.imagenSiguiente setHidden:YES];
                [self.btnEliminar setFrame:CGRectMake(271, 305, 29, 35)];
				
				if (self.opcionSeleccionada == 1 && [codigoAnterior isEqualToString:@"+52"] && ![self.labelCodigo.text isEqualToString:@"+52"]) {
					self.txtTelefono.text = [self.txtTelefono.text substringFromIndex:1];
                    
                    if(IS_STANDARD_IPHONE_6){
                        self.txtDescripcion.frame = CGRectMake(20, 190, 335, 100);
                        self.txtTelefono.frame = CGRectMake(20, 120, 335, 30);
                    }else if(IS_STANDARD_IPHONE_6_PLUS){
                        self.txtTelefono.frame = CGRectMake(20, 120, 280, 30);
                    }else if(IS_IPAD){
                        self.txtTelefono.frame = CGRectMake(20, 120, 600, 30);
                    }else{
                        [self.txtTelefono setFrame:CGRectMake(20, 120, 280, 30)];
                        [self.txtDescripcion setFrame:CGRectMake(self.txtDescripcion.frame.origin.x, 181, self.txtDescripcion.frame.size.width, self.txtDescripcion.frame.size.height)];
                    }
                    
					
					self.casillaMovil.hidden = YES;
					[self.labelInfoMexico setHidden:YES];
				}else if (self.opcionSeleccionada == 1 && [self.labelCodigo.text isEqualToString:@"+52"] && ![codigoAnterior isEqualToString:@"+52"] && self.opcionSeleccionada == 1) {
					//                    [self.txtTelefono setText:@"1"];
                    [self.labelInfoMexico setHidden:NO];
                    if(IS_STANDARD_IPHONE_6){
                        self.txtDescripcion.frame = CGRectMake(20, 190, 335, 100);
                        self.txtTelefono.frame = CGRectMake(20, 120, 335, 30);
                    }else if(IS_STANDARD_IPHONE_6_PLUS){
                        self.txtTelefono.frame = CGRectMake(20, 120, 280, 30);
                    }else if(IS_IPAD){
                        self.txtTelefono.frame = CGRectMake(20, 120, 600, 30);
                    
                    }else{
                        [self.txtTelefono setFrame:CGRectMake(70, 120, 230, 30)];
                        [self.txtDescripcion setFrame:CGRectMake(self.txtDescripcion.frame.origin.x, 181, self.txtDescripcion.frame.size.width, self.txtDescripcion.frame.size.height)];
                    }
					
					self.casillaMovil.hidden = NO;
					self.casillaMovil.layer.cornerRadius = 5;
					
					[self.labelDescripcion setFrame:CGRectMake(self.labelDescripcion.frame.origin.x, 188, self.labelDescripcion.frame.size.width, self.labelDescripcion.frame.size.height)];
					
					if(codigoAnterior == nil){
						self.txtTelefono.text = [self.txtTelefono.text substringFromIndex:1];
					}
                }
				else{
					if([codigoAnterior isEqualToString:@"+52"]){
						self.txtTelefono.text = [self.txtTelefono.text substringFromIndex:1];
					}
                    if(IS_STANDARD_IPHONE_6){
                        self.txtDescripcion.frame = CGRectMake(20, 190, 335, 100);
                        self.txtTelefono.frame = CGRectMake(20, 120, 335, 30);
                    }else if(IS_STANDARD_IPHONE_6_PLUS){
                        self.txtTelefono.frame = CGRectMake(20, 120, 280, 30);
                    }else if(IS_IPAD){
                        self.txtTelefono.frame = CGRectMake(20, 120, 600, 30);
                    
                    }else{
                        [self.txtTelefono setFrame:CGRectMake(20, 120, 280, 30)];
                        [self.txtDescripcion setFrame:CGRectMake(self.txtDescripcion.frame.origin.x, 181, self.txtDescripcion.frame.size.width, self.txtDescripcion.frame.size.height)];
                    }
					
					self.casillaMovil.hidden = YES;
					[self.labelInfoMexico setHidden:YES];
					
				}
				
                break;
                
            default:
                [self.vistaPais setHidden:YES];
                if(IS_STANDARD_IPHONE_6){
                    self.txtDescripcion.frame = CGRectMake(20, 160, 335, 100);
                    self.txtTelefono.frame = CGRectMake(20, 86, 335, 30);
                }else if(IS_STANDARD_IPHONE_6_PLUS){
                    self.txtTelefono.frame = CGRectMake(20, 86, 280, 30);
                }else if(IS_IPAD){
                    self.txtTelefono.frame = CGRectMake(20, 86, 600, 30);
                }else{
                    [self.txtTelefono setFrame:CGRectMake(20, 86, 280, 30)];
                    [self.txtDescripcion setFrame:CGRectMake(self.txtDescripcion.frame.origin.x, 153, self.txtDescripcion.frame.size.width, self.txtDescripcion.frame.size.height)];
                }
                
                [self.txtTelefono setHidden:NO];
                [self.btnSeleccionarPais setHidden:YES];
                [self.txtTelefono setPlaceholder:@""];
                [self.txtTelefono setKeyboardType:UIKeyboardTypeURL];
                [self.labelDescripcion setFrame:CGRectMake(self.labelDescripcion.frame.origin.x, 124, self.labelDescripcion.frame.size.width, self.labelDescripcion.frame.size.height)];
                
                [self.scrollVista setContentSize:CGSizeMake(320, 250)];
                [self.txtTelefono setText:[self.contactoSeleccionado noContacto]];
                [self.txtDescripcion setText:[self.contactoSeleccionado descripcion]];
                [self.btnEliminar setFrame:CGRectMake(271, 250, 29, 35)];
                break;
        }
        NSDictionary *dictAux = [arregloTitulos objectAtIndex:self.contactoSeleccionado.indice];
        [self.labelTipoContacto setText:[dictAux objectForKey:@"text"]];
        [self.imagenTipoContacto setImage:[UIImage imageNamed:[dictAux objectForKey:@"image"]]];
        [self.labelNumeroTelefonico setText:[dictAux objectForKey:@"mensaje"]];
        if (self.txtTelefono.text.length == 0) {
            [self.txtTelefono setPlaceholder:[dictAux objectForKey:@"ejemplo"]];
        }
		[self.txtTelefono setPlaceholder:[dictAux objectForKey:@"ejemplo"]];
		fueGuardado = YES;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)textViewDidBeginEditing:(UITextView *)textView {
    textoPulsado = textView;
//    self.modifico = YES;
    [self muestraContadorTexto:[textView.text length] conLimite:255 paraVista:textView];
    [self apareceTeclado];
}
-(void) textViewDidEndEditing:(UITextView *)textView {
    [self ocultaContadorTexto];
    [self desapareceElTeclado];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    textoPulsado = textField;
    NSInteger textoLength = [textField.text length];
    [labelInfo setText:[NSString stringWithFormat:@"%i/%i", textoLength, 255]];
    [UIView animateWithDuration:0.4f animations:^{
        [labelInfo setFrame:CGRectMake(284, textField.frame.origin.y + textField.frame.size.height, 33, 21)];
    }];
//    [self muestraContadorTexto:[textField.text length] conLimite:255 paraVista:textField];
    [self apareceTeclado];
}
-(void) textFieldDidEndEditing:(UITextField *)textField {
//    [self ocultaContadorTexto];
    [self desapareceElTeclado];
    [UIView animateWithDuration:0.4f animations:^{
        [self.labelInfo setFrame:CGRectMake(284, 600, 33, 21)];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger maxLength = 255;
    self.modifico = YES;
    NSInteger textoLength = [textField.text length];
    if ([string isEqualToString:@"<"] || [string isEqualToString:@">"]) {
        return NO;
    }
    else {
        if (textoLength < maxLength) {
            if ([string isEqualToString:@""]) {
            }
            else {
                [labelInfo setText:[NSString stringWithFormat:@"%i/%i", textoLength+1, maxLength]];
            }
            return YES;
        }
        else {
            if ([string isEqualToString:@""]) {
                [labelInfo setText:[NSString stringWithFormat:@"%i/%i", textoLength-1, maxLength]];
                return YES;
            }
            return NO;
        }
    }
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger maxLength = 255;
    NSInteger textoLength = [textView.text length] - range.length + [text length];
	
    if ( [text isEqualToString:@"<"] || [text isEqualToString:@">"] || textoLength > maxLength )
		return NO;
	
	if ( textoLength <= maxLength )
	{
		[self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength, (long)maxLength]];
		self.modifico = YES;
		return YES;
    }
	
	return NO;
}

-(void) apareceTeclado {
    CGSize tamanioTeclado = CGSizeMake(320, 216);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [self.scrollVista setContentInset:edgeInsets];
    [self.scrollVista setScrollIndicatorInsets:edgeInsets];
    if ([textoPulsado isKindOfClass:[UITextView class]]) {
        [[self scrollVista] scrollRectToVisible:((UITextView *)textoPulsado).frame animated:YES];
    }
    else {
        [[self scrollVista] scrollRectToVisible:((UITextField *)textoPulsado).frame animated:YES];
    }
}
-(void) desapareceElTeclado {
    [UIView beginAnimations:nil context:Nil];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollVista] setContentInset:edgeInsets];
    [[self scrollVista] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

- (IBAction)eliminarContacto:(UIButton *)sender {
	
	 if (self.contactosOperacion == ContactosOperacionAgregar) {
		 [self.navigationController popViewControllerAnimated:YES];
		 
	 }else{
	
		 self.datosUsuario = [DatosUsuario sharedInstance];
		 idEliminarContacto = self.contactoSeleccionado.idContacto;
		 arregloContactosAux = [[NSMutableArray alloc] initWithArray:[self.datosUsuario arregloContacto] copyItems:YES];
		 [arregloContactosAux removeObjectAtIndex:[self.datosUsuario.arregloContacto indexOfObject:self.contactoSeleccionado]];
		 [self.btnEliminar setHidden:YES];
		 [self.labelPais setText:NSLocalizedString(@"pais", Nil)];
		 [self.labelCodigo setText:@" "];
		 [self.txtTelefono setText:@""];
		 [self.txtDescripcion setText:@""];
		 if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
			 self.contactosOperacion = ContactosOperacionEliminar;
			 if ([CommonUtils hayConexion]) {
				 [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
				 [self performSelectorInBackground:@selector(actualizarContactos) withObject:Nil];
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
}

- (IBAction)seleccionarCodigoPais:(UIButton *)sender {
    SelectorPaisViewController *selector = [[SelectorPaisViewController alloc] initWithNibName:@"SelectorPaisViewController" bundle:Nil];
    selector.contactoController = self;
    selector.nombreTituloVista = @"barraverde.png";
    [self.navigationController pushViewController:selector animated:YES];
	
	codigoAnterior = self.labelCodigo.text;
}

-(IBAction)guardarInformacion:(id)sender {
    [self.view endEditing:YES];
	switch (self.opcionSeleccionada) {
        case 3:
            if ([CommonUtils validarEmail:[self.txtTelefono text]]) {
                url = [self.txtTelefono text];
            }
            else {
                url = NSLocalizedString(@"emailInvalido", @" ");
            }
            break;
        case 0:
        case 1:
        case 2:
        case 4:
			
            if ([CommonUtils validaNumeroDeTel:[self.txtTelefono text]]) {
				if (self.opcionSeleccionada == 1 &&[self.labelCodigo.text isEqualToString:@"+52"] && [self.txtTelefono.text length] != 0 && self.opcionSeleccionada == 1) {
					url = [@"1" stringByAppendingString:[self.txtTelefono text]];
				}else{
					url = [self.txtTelefono text];
				}
            }
            else {
                url = NSLocalizedString(@"numeroInvalido", @" ");
            }
            break;
		case 5:
			url = [CommonUtils validaFacebookUrl:[self.txtTelefono text]];
			break;
		case 6:
			url = [CommonUtils validaTwitterUrl:[self.txtTelefono text]];
			break;
		case 7:
			url = [CommonUtils validaGooglePlus:[self.txtTelefono text]];
			break;
		case 8:
			url = [CommonUtils validaSkype:[self.txtTelefono text]];
			break;
		case 9:
			url = [CommonUtils validaLinkedIn:[self.txtTelefono text]];
			break;
		case 10:
			url = [CommonUtils validaSecureWebside:[self.txtTelefono text]];
			break;
	}
    if (self.modifico) {
        if (seleccionoPais) {
            if (![url isEqualToString:NSLocalizedString(@"urlInvalida", @" ")] && ![url isEqualToString:NSLocalizedString(@"numeroInvalido", @" ")] && ![url isEqualToString:NSLocalizedString(@"emailInvalido", @" ")] && ![url isEqualToString:NSLocalizedString(@"cuentaInvalida", @" ")]) {
                if (self.contactosOperacion == ContactosOperacionAgregar) {
                    Contacto *contacto = [[Contacto alloc] initWithNumber:url description:[self.txtDescripcion text] andStatus:YES];
                    [contacto setIndice:self.opcionSeleccionada];
                    [contacto setHabilitado:YES];
                    [contacto setPais:[self.labelPais text]];
                    [contacto setIdPais:[self.labelCodigo text]];
                    self.datosUsuario = [DatosUsuario sharedInstance];
					arregloContactosAux = [[NSMutableArray alloc] initWithArray:[self.datosUsuario arregloContacto] copyItems:YES];
                    //[self.datosUsuario.arregloContacto addObject:contacto];
					[arregloContactosAux addObject:contacto];
                    self.modifico = NO;
                    
                    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
                        if ([CommonUtils hayConexion]) {
                            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(actualizarContactos) withObject:Nil];
                        }
                        else {
                            //[self revertirGuardado];
                            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                            [alert show];
                        }
                    }
                    else {
                        NSArray *arregloVistas = [self.navigationController viewControllers];
                        [self.navigationController popToViewController:[arregloVistas objectAtIndex:arregloVistas.count-3] animated:YES];
                    }
                }
                else
				{
					if([url isEqualToString:NSLocalizedString(@"urlInvalida", @" ")] || [url isEqualToString:NSLocalizedString(@"numeroInvalido", @" ")] || [url isEqualToString:NSLocalizedString(@"emailInvalido", @" ")] || [url isEqualToString:NSLocalizedString(@"cuentaInvalida", @" ")]){
						AlertView *alertView = [AlertView initWithDelegate:self message:url andAlertViewType:AlertViewTypeInfo];
						[alertView show];
					}else{
					
						Contacto *contacto = [[Contacto alloc] initWithNumber:url description:[self.txtDescripcion text] andStatus:YES];
						[contacto setIndice:self.opcionSeleccionada];
						[contacto setHabilitado:YES];
						[contacto setPais:[self.labelPais text]];
						[contacto setIdPais:[self.labelCodigo text]];
						[contacto setIdContacto:self.contactoSeleccionado.idContacto];
						self.datosUsuario = [DatosUsuario sharedInstance];
						DatosUsuario * datos = [DatosUsuario sharedInstance];
                        contactoAux = self.contactoSeleccionado;
						arregloContactosAux = [[NSMutableArray alloc] initWithArray:[datos arregloContacto] copyItems:YES];
						
						//arregloContactosAux = [[NSMutableArray alloc] initWithArray:[datos arregloContacto]]
						[arregloContactosAux replaceObjectAtIndex:self.indexContacto withObject:contacto];
						if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
							if ([CommonUtils hayConexion]) {
								[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
								[self performSelectorInBackground:@selector(actualizarContactos) withObject:Nil];
							}
							else {
                                //[self revertirGuardado];
								AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
								[alert show];
							}
						}
						else {
							[self.navigationController popViewControllerAnimated:YES];
						}
					}
                }
            }
            else {
				if(!fueGuardado  && ([self.txtTelefono.text isEqualToString:@""] && [self.txtDescripcion.text isEqualToString:@""])){
					[self.navigationController popViewControllerAnimated:YES];
				}else if([url isEqualToString:NSLocalizedString(@"urlInvalida", @" ")] || [url isEqualToString:NSLocalizedString(@"numeroInvalido", @" ")] || [url isEqualToString:NSLocalizedString(@"emailInvalido", @" ")] || [url isEqualToString:NSLocalizedString(@"cuentaInvalida", @" ")]){
					AlertView *alertView = [AlertView initWithDelegate:self message:url andAlertViewType:AlertViewTypeInfo];
					[alertView show];
				}else{
					AlertView *alertaInfo = [AlertView initWithDelegate:Nil message:@"Verifica tus datos" andAlertViewType:AlertViewTypeInfo];
					[alertaInfo show];
				}
            }
            
        }
        else {
			if(!self.modifico){
				[self.navigationController popViewControllerAnimated:YES];
			}else{
				
				if(self.opcionSeleccionada<=4 && self.opcionSeleccionada != 3){
					AlertView *alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"seleccionaPais", Nil) andAlertViewType:AlertViewTypeInfo];
					[alertView show];
				}else if([url isEqualToString:NSLocalizedString(@"urlInvalida", @" ")] || [url isEqualToString:NSLocalizedString(@"numeroInvalido", @" ")] || [url isEqualToString:NSLocalizedString(@"emailInvalido", @" ")] || [url isEqualToString:NSLocalizedString(@"cuentaInvalida", @" ")]){
					AlertView *alertView = [AlertView initWithDelegate:self message:url andAlertViewType:AlertViewTypeInfo];
					[alertView show];
				}
				else{

						Contacto *contacto = [[Contacto alloc] initWithNumber:url description:[self.txtDescripcion text] andStatus:YES];
						[contacto setIndice:self.opcionSeleccionada];
						[contacto setHabilitado:YES];
						[contacto setPais:[self.labelPais text]];
						[contacto setIdPais:[self.labelCodigo text]];
						[contacto setIdContacto:self.contactoSeleccionado.idContacto];
						self.datosUsuario = [DatosUsuario sharedInstance];
						arregloContactosAux = [[NSMutableArray alloc] initWithArray:[self.datosUsuario arregloContacto] copyItems:YES];
						//[self.datosUsuario.arregloContacto addObject:contacto];
					if (self.contactosOperacion == ContactosOperacionAgregar){
						[arregloContactosAux addObject:contacto];
					}else{
						[arregloContactosAux replaceObjectAtIndex:self.indexContacto withObject:contacto];
					}
						self.modifico = NO;
						
						if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
							if ([CommonUtils hayConexion]) {
								[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
								[self performSelectorInBackground:@selector(actualizarContactos) withObject:Nil];
							}
							else {
								//[self revertirGuardado];
								AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
								[alert show];
							}
						}
						else {
							NSArray *arregloVistas = [self.navigationController viewControllers];
							[self.navigationController popToViewController:[arregloVistas objectAtIndex:arregloVistas.count-3] animated:YES];
						}
					

				}
			}
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
	
	switch (self.opcionSeleccionada) {
        case 3:
            if ([CommonUtils validarEmail:[self.txtTelefono text]]) {
                url = [self.txtTelefono text];
            }
            else {
                url = NSLocalizedString(@"emailInvalido", @" ");
            }
            break;
        case 0:
        case 1:
        case 2:
        case 4:
            if ([CommonUtils validaNumeroDeTel:[self.txtTelefono text]]) {
				if (self.opcionSeleccionada == 1 &&[self.labelCodigo.text isEqualToString:@"+52"] && [self.txtTelefono.text length] != 0 && self.opcionSeleccionada == 1) {
					url = [@"1" stringByAppendingString:[self.txtTelefono text]];
				}else{
					url = [self.txtTelefono text];
				}
            }
            else {
                url = NSLocalizedString(@"numeroInvalido", @" ");
            }
            break;
		case 5:
			url = [CommonUtils validaFacebookUrl:[self.txtTelefono text]];
			break;
		case 6:
			url = [CommonUtils validaTwitterUrl:[self.txtTelefono text]];
			break;
		case 7:
			url = [CommonUtils validaGooglePlus:[self.txtTelefono text]];
			break;
		case 8:
			url = [CommonUtils validaSkype:[self.txtTelefono text]];
			break;
		case 9:
			url = [CommonUtils validaLinkedIn:[self.txtTelefono text]];
			break;
		case 10:
			url = [CommonUtils validaSecureWebside:[self.txtTelefono text]];
			break;
	}
	
	if (![url isEqualToString:NSLocalizedString(@"urlInvalida", @" ")] && ![url isEqualToString:NSLocalizedString(@"numeroInvalido", @" ")] && ![url isEqualToString:NSLocalizedString(@"emailInvalido", @" ")] && ![url isEqualToString:NSLocalizedString(@"cuentaInvalida", @" ")]) {
		AlertView *alertView;
		if (self.modifico && [CommonUtils hayConexion]) {
                alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
                [alertView show];
		}
		else {
			if (self.contactosOperacion == ContactosOperacionAgregar) {
				NSArray *arregloVistas = [self.navigationController viewControllers];
				[self.navigationController popToViewController:[arregloVistas objectAtIndex:arregloVistas.count-3] animated:YES];
			}
			else {
				[self.navigationController popViewControllerAnimated:YES];
			}
		}
	}
	else{
		if(fueGuardado && [self.txtTelefono.text isEqualToString:@""]){
			AlertView *alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
			[alertView show];
		}
		else if(!self.modifico || ([self.txtTelefono.text isEqualToString:@""] && [self.txtDescripcion.text isEqualToString:@""])){
			[self.navigationController popViewControllerAnimated:YES];
		}else{
			//AlertView *alertaInfo = [AlertView initWithDelegate:Nil message:@"Verifica tus datos" andAlertViewType:AlertViewTypeInfo];
			//[alertaInfo show];
			AlertView *alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
			[alertView show];
		}
	}
}

-(void)accionNo {
    if (self.contactosOperacion == ContactosOperacionAgregar) {
        NSArray *arregloVistas = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[arregloVistas objectAtIndex:arregloVistas.count-3] animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) accionSi {
	[self guardarInformacion:nil];
}

-(void) accionAceptar {
    if (actualizoCorrecto) {
        if (self.contactosOperacion == ContactosOperacionAgregar) {
            NSArray *arregloVistas = [self.navigationController viewControllers];
            [self.navigationController popToViewController:[arregloVistas objectAtIndex:arregloVistas.count-3] animated:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void) mostrarActivity {
    self.alertaContacto = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarContacto", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaContacto show];
}
-(void) ocultarActivity {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    if (actualizoCorrecto) {
        if (self.contactosOperacion == ContactosOperacionEliminar) {
         //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro Contacto" withValue:@""];
            [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Contacto"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.contactosOperacion == ContactosOperacionAgregar) {
        //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito Contacto" withValue:@""];
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Contacto"];
            self.datosUsuario = [DatosUsuario sharedInstance];
            NSMutableArray *arrayAux = self.datosUsuario.arregloContacto;
            Contacto *contactoFinal = [arrayAux lastObject];
            [contactoFinal setIdContacto:idContacto];
            [arrayAux replaceObjectAtIndex:[arrayAux count]-1 withObject:contactoFinal];
            //self.datosUsuario.arregloContacto = arrayAux;
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
        else {
         //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito contacto" withValue:@""];
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Contacto"];
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
    else {
        //[self revertirGuardado];
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}
-(void) actualizarContactos {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerContactos *handlerContactos = [[WS_HandlerContactos alloc] init];
        [handlerContactos setContactosDelegate:self];
        
        [handlerContactos setArregloContactos:arregloContactosAux];
        if (self.contactosOperacion == ContactosOperacionAgregar) {
            [handlerContactos insertarContacto];
        }
        else if (self.contactosOperacion == ContactosOperacionEliminar) {
            [handlerContactos eliminarContacto:idEliminarContacto];
        }
        else {
           [handlerContactos actualizaContacto:self.indexContacto contactosOperacion:ContactosOperacionAgregar];
        }
    }
    else {
        if ( self.alertaContacto )
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertaContacto hide];
        }
        self.alertaContacto = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertaContacto show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
	DatosUsuario * datos = [DatosUsuario sharedInstance];
    if (self.contactosOperacion == ContactosOperacionAgregar) {
        idContacto = [datos.arregloContacto.lastObject idContacto];//[resultado integerValue];
        if (idContacto > 0) {
            actualizoCorrecto = YES;
        }
        else {
            actualizoCorrecto = NO;
        }
    }
	else if (self.contactosOperacion == ContactosOperacionEditar) {
		actualizoCorrecto = YES;
    }else {
        if ([resultado isEqualToString:@"Exito"]) {
            actualizoCorrecto = YES;
        }
        else {
            actualizoCorrecto = NO;
        }
    }
    
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorContacto) withObject:Nil waitUntilDone:YES];
}

-(void) errorContacto {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
    [alert show];
}


-(void) errorToken {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    self.alertaContacto = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertaContacto show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sessionTimeout
{   
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    self.alertaContacto = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertaContacto show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
