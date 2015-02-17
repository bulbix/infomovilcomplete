//
//  PromocionesViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 08/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "PromocionesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PromocionesCell.h"
#import "Datos.h"
#import "Base64.h"
#import "WS_HandlerPromocion.h"
#import "NSDateFormatterUtiles.h"
#import "UIViewDefs.h"
#import "GaleriaPaso2ViewController.h"
#import "NSStringUtiles.h"

#define VIGENCIA_FORMAT @"dd - MMMM - YYYY"

@interface PromocionesViewController ()
{
    UIView *viewEditado;
//    BOOL self.modifico;
    BOOL estaBorrando;
	NSInteger seleccionAnterior;
    BOOL exito;
	NSDictionary *dictPromo;
	NSString *strImagenPath;
    NSString *textEspAux;
    NSString *txtRedencionAux;
}

@property (nonatomic, strong) NSArray *arregloPromociones;
@property (nonatomic, strong) NSDate *fechaSeleccionada;
@property (nonatomic, strong) NSString *txtRedencion;
@property (nonatomic, strong) AlertView *alertPromocion;
@property (nonatomic, strong) OffertRecord *promocionActual;


@end

@implementation PromocionesViewController

@synthesize textInformacion, textDescripcion, txtTituloPromocion;
@synthesize arregloPromociones;
@synthesize btnBorrar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        DatosUsuario *dataUsr = [DatosUsuario sharedInstance];
        OffertRecord *offerTemp = dataUsr.promocionActual;
        
        self.strTituloVista     = NSLocalizedString(@"promociones", @" ");
        self.strImagenTitulo    = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ?
                                    @"barraverde.png" : @"NBverde.png";
        
        self.promocionActual = [[OffertRecord alloc] init];
        _promocionActual.idOffer        = offerTemp.idOffer;
        _promocionActual.titleOffer     = offerTemp.titleOffer;
        _promocionActual.descOffer      = offerTemp.descOffer;
        _promocionActual.endDateOffer   = offerTemp.endDateOffer;
        _promocionActual.termsOffer     = offerTemp.termsOffer;
        _promocionActual.endDateAux     = offerTemp.endDateAux;
        _promocionActual.redeemOffer    = offerTemp.redeemOffer;
        _promocionActual.pathImageOffer = offerTemp.pathImageOffer;
        _promocionActual.imageClobOffer = offerTemp.imageClobOffer;
        _promocionActual.linkOffer      = offerTemp.linkOffer;
        _promocionActual.promoCodeOffer = offerTemp.promoCodeOffer;
        _promocionActual.discountOffer  = offerTemp.discountOffer;
        _promocionActual.redeemAux      = offerTemp.redeemAux;
        
        NSDate *dateDefault = [NSDateFormatter getDateFromString:@"1970-01-01" withFormat:@"yyyy-MM-dd"];
        
        if ( _promocionActual.endDateAux != Nil &&
            [_promocionActual.endDateAux compare:dateDefault]!= NSOrderedSame &&
            [NSString isEmptyString:_promocionActual.endDateOffer] )
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:VIGENCIA_FORMAT];
            [_promocionActual setEndDateOffer:[formatter stringFromDate:_promocionActual.endDateAux]];
        } else if ( _promocionActual.endDateAux == nil ||
                   [_promocionActual.endDateAux compare:dateDefault]!= NSOrderedSame )
            self.fechaSeleccionada = dateDefault;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modifico		 = NO;
	
    [_fechaPicker addTarget:self action:@selector(fechaseleccionda:) forControlEvents:UIControlEventValueChanged];
    
    [_labelNombrePromocion      setText:NSLocalizedString(@"nombrePromocion", Nil)];
    [_labelDescripcionPromocion setText:NSLocalizedString(@"descripcionPromocion", Nil)];
    [_labelVigenciaAl           setText:NSLocalizedString(@"vigencia", Nil)];
    [_labelInformacionAdicional setText:NSLocalizedString(@"informacionAdicional", Nil)];
    
    txtTituloPromocion.layer.cornerRadius	= 5;
    _vistaVigencia.layer.cornerRadius		= 5;
	textDescripcion.layer.cornerRadius		= 5;
    textInformacion.layer.cornerRadius		= 5;
    
    CGSize size = _scrollPromocion.frame.size;
    size.height = btnBorrar.frame.origin.y + btnBorrar.frame.size.height + 30;
    [self.scrollPromocion setContentSize:size];
//    [self.scrollPromocion setContentSize:CGSizeMake(size.width, 800)]; //590
    
    [self llenaCampos];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self acomodarBarraNavegacionConTitulo:nil nombreImagen:nil];
    if ([[self.datosUsuario.arregloEstatusEdicion objectAtIndex:7] isEqual:@YES]) {
        [btnBorrar setEnabled:YES];
    }
    else {
        [btnBorrar setEnabled:NO];
    }
}

- (void) llenaArregloPromociones
{
	NSMutableArray *promoTemp = [[NSMutableArray alloc] init];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([self.datosUsuario.arregloEstatusPromocion count] == 0)
	{
        NSArray *arregloSec1 = @[[[Datos alloc] initWithTitle:NSLocalizedString(@"sinFoto", @" ") andStatus:NO],
								 [[Datos alloc] initWithTitle:NSLocalizedString(@"tomarFoto", @" ") andStatus:NO]];
        NSArray *arregloSec2 = @[[[Datos alloc] initWithTitle:NSLocalizedString(@"noEspecificado", @" ") withSpanishTitle:NSLocalizedStringFromTable(@"noEspecificado", @"Spanish",@" ") andStatus:NO],
								 [[Datos alloc] initWithTitle:NSLocalizedString(@"llamanos", @" ") withSpanishTitle:NSLocalizedStringFromTable(@"llamanos", @"Spanish",@" ") andStatus:NO],
								 [[Datos alloc] initWithTitle:NSLocalizedString(@"enviaEmail", @" ") withSpanishTitle:NSLocalizedStringFromTable(@"enviaEmail", @"Spanish",@" ") andStatus:NO],
								 [[Datos alloc] initWithTitle:NSLocalizedString(@"visitanos", @" ") withSpanishTitle:NSLocalizedStringFromTable(@"visitanos", @"Spanish",@" ") andStatus:NO]];
        
        if ( ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion )
		{
            if ([[_promocionActual pathImageOffer] length] > 0)
			{
                Datos *datosAux = [arregloSec1 objectAtIndex:1];
                [datosAux setEstatus:YES];
            } else {
                Datos *datosAux = [arregloSec1 objectAtIndex:0];
                [datosAux setEstatus:YES];
            }
			
            NSString *opcionAux2 = [_promocionActual redeemAux];
            
            for (int i = 0; i < [arregloSec2 count]; i++)
			{
                Datos *datosAux = [arregloSec2 objectAtIndex:i];
                if ([[datosAux tituloMostrar] isEqualToString:opcionAux2])
                    [datosAux setEstatus:YES];
            }
        }
        
        [promoTemp addObject:arregloSec1];
        [promoTemp addObject:arregloSec2];
    } else {
		for (Datos *datos in self.datosUsuario.arregloEstatusPromocion)
			[promoTemp addObject:[[Datos alloc] initWithTitle:datos.tituloMostrar andStatus:datos.estatus]];
	}
	
	self.arregloPromociones = promoTemp;
    [self.tablaPromociones reloadData];
}

-(void) llenaCampos
{
    self.datosUsuario = [DatosUsuario sharedInstance];

	self.fechaPicker.minimumDate	= [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
    self.txtTituloPromocion.text    = [_promocionActual titleOffer];
    self.textDescripcion.text       = [_promocionActual descOffer];
    self.labelVigencia.text         = [_promocionActual endDateOffer];
    self.textInformacion.text       = [_promocionActual termsOffer];
    self.fechaSeleccionada          = [_promocionActual endDateAux];
    self.txtRedencion               = [_promocionActual redeemOffer];
    
	[self llenaArregloPromociones];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    viewEditado = textField;
    [self muestraContadorTexto:[textField.text length] conLimite:255 paraVista:textField];
    [self apareceTeclado];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self ocultaContadorTexto];
	[self desapareceElTeclado];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string isEqualToString:@"\n"] )
        return NO;
    
    return [self shouldChangeText:string withLimit:255 forFinalLenght:[textField.text length] - range.length + [string length]];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    viewEditado = textView;
    [self muestraContadorTexto:[textView.text length] conLimite:255 paraVista:textView];
    [self apareceTeclado];
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    [self ocultaContadorTexto];
    [self desapareceElTeclado];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 )
    {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [self shouldChangeText:text withLimit:255 forFinalLenght:[textView.text length] - range.length + [text length]];
}

#pragma mark

-(void) apareceTeclado
{
    [self ocultaPicker];
	[_tablaPromociones setUserInteractionEnabled:NO];
    
    CGRect refFrame       = viewEditado.frame;
    refFrame.origin.y    -= 30;
    refFrame.size.height += 30;
    [self apareceTeclado:_scrollPromocion withRefFrame:refFrame];
}

-(void) desapareceElTeclado
{
    [_tablaPromociones setUserInteractionEnabled:YES];
    [self desapareceElTeclado:_scrollPromocion];
}

//- (void)muestraContadorTexto:(NSInteger)contador conLimite:(NSInteger)limite paraVista:(UIView *)view
//{
//    [self.labelInfo setText:[NSString stringWithFormat:@"%i/%i", contador, limite]];
//    [UIView animateWithDuration:0.4f animations:^{
//        [self.labelInfo setFrame:CGRectMake(284, view.frame.origin.y + view.frame.size.height, 33, 21)];
//        self.labelInfo.hidden = NO;
//    }];
//}

//- (void)ocultaContadorTexto
//{
//    [UIView animateWithDuration:0.4f animations:^{
//        self.labelInfo.hidden = YES;
//    }];
//}

//- (BOOL)shouldChangeText:(NSString *)string withLimit:(NSInteger)maxLength forFinalLenght:(NSInteger)textoLength
//{
//    if ( [string isEqualToString:@"<"] || [string isEqualToString:@">"] || textoLength > maxLength )
//		return NO;
//	
//	if ( textoLength <= maxLength )
//	{
//		[self.labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength, (long)maxLength]];
//		self.modifico = YES;
//		return YES;
//    }
//	
//	return NO;
//}


- (IBAction)mostrarFecha:(id)sender
{
    viewEditado = sender;
    [self apareceTeclado];
	
    if ( [_vistaPicker isHidden] )
	{
        [_vistaPicker setHidden:NO];
		[self.vistaInferior setAlpha:0];
    }
}

- (void)ocultaPicker
{
	[self.vistaPicker setHidden:YES];
	[self.vistaInferior setAlpha:1];
	[self desapareceElTeclado];
}

- (IBAction)seleccionarFecha:(UIBarButtonItem *)sender
{
	[self fechaseleccionda:_fechaPicker];
	[self ocultaPicker];
}

- (IBAction)borrarPromocion:(id)sender {
    estaBorrando = YES;
    self.alertPromocion = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeEliminarPerfil", Nil) andAlertViewType:AlertViewTypeQuestion];
    [self.alertPromocion show];
}

#pragma mark - TableViewDatasource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[arregloPromociones objectAtIndex:section] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PromocionesCell";
    PromocionesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == Nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PromocionesCell" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
    }
    Datos *datosPromocion = [[arregloPromociones objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.vistaFondo.layer.cornerRadius = 5.0f;
    [cell.labelConcepto setText:[datosPromocion tituloMostrar]];
	[cell.labelConcepto setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
	
    if (datosPromocion.estatus)
    {
        [cell.imagenEstatus setImage:[UIImage imageNamed:@"editado.png"]];
		cell.labelConcepto.textColor = colorFuenteAzul;
    } else {
        [cell.imagenEstatus setImage:[UIImage imageNamed:@"noeditado.png"]];
        cell.labelConcepto.textColor = colorFuenteVerde;
    }
	
    return cell;
}

#pragma mark - TableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 42)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, tableView.frame.size.width, 20)];
    [label setBackgroundColor:colorBackground];
    [label setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    [label setTextColor:colorFuenteVerde];
    
    [label setText:(section == 0) ? NSLocalizedString(@"imagenPromocion", Nil) :
                                    NSLocalizedString(@"comoRedimir", Nil)];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}

- (void)eligeRedimir:(NSInteger )index
{
	NSArray *promo		= [arregloPromociones objectAtIndex:1];
	NSInteger i			= 0;
	
	for (Datos *datosPromocion in promo)
	{
		if ( i == index && datosPromocion.estatus == YES )
			break;
		
		if ( i == index )
		{
			self.modifico = YES;
			_txtRedencion = datosPromocion.tituloAux;
            txtRedencionAux = datosPromocion.tituloMostrar;
			[datosPromocion setEstatus:YES];
		} else
			[datosPromocion setEstatus:NO];
		i++;
    }
}

- (void)eligeTipoFoto:(NSInteger )index
{
		
	switch (index)
	{
		case 1:
        {
            GaleriaPaso2ViewController *galeriaPaso2 = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:Nil];
            [galeriaPaso2 setGaleryType:PhotoGaleryTypeOffer];
            [galeriaPaso2 setTituloPaso:NSLocalizedString(@"promociones", nil)];
            galeriaPaso2.delegadoGaleria = self;
            galeriaPaso2.strImagenPath = _promocionActual.pathImageOffer;
            [self.navigationController pushViewController:galeriaPaso2 animated:YES];
        }
			break;
		case 0:
        {
            NSArray *promo		= [arregloPromociones objectAtIndex:0];
            NSInteger i			= 0;
            
            for (Datos *datosPromocion in promo)
            {
                if ( datosPromocion.estatus == YES )
                    seleccionAnterior = i;
                
                if ( i++ == index )
                    [datosPromocion setEstatus:YES];
                else
                    [datosPromocion setEstatus:NO];
            }

			[_promocionActual setPathImageOffer:@""];
			if ( index != seleccionAnterior )
				self.modifico = YES;
        }
			break;
		default:break;
	}
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.section == 0 )
		[self eligeTipoFoto:indexPath.row];
	else
		[self eligeRedimir:indexPath.row];
	
	[_tablaPromociones reloadData];
}

#pragma mark
-(IBAction)regresar:(id)sender
{
    [[self view] endEditing:YES];
    if ( self.modifico )
	{
        AlertView *alertView = [AlertView initWithDelegate:self
												   message:NSLocalizedString(@"preguntaGuardar", @" ")
										  andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) accionSi
{
    if (estaBorrando) {
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:NO];
            [self performSelectorInBackground:@selector(actualizarPromocion) withObject:Nil];
        }
        else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
        
    }
    else {
        [self guardarInformacion:nil];
    }
	
}

-(void) accionNo {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) validaCampos
{
    if( [NSString isEmptyString:txtTituloPromocion.text] )
	{
		AlertView *alert = [AlertView initWithDelegate:self
											   message:NSLocalizedString(@"mensajePromocion2", nil)
									  andAlertViewType:AlertViewTypeInfo];
		[alert show];
		return NO;
	}
    
	if( [NSString isEmptyString:textDescripcion.text] )
    {
		AlertView *alert = [AlertView initWithDelegate:self
											   message:NSLocalizedString(@"mensajePromocion3", nil)
									  andAlertViewType:AlertViewTypeInfo];
		[alert show];
		return NO;
	}
	
    if ( [NSString isEmptyString:_labelVigencia.text] )
    {
		AlertView *alert = [AlertView initWithDelegate:self
											   message:NSLocalizedString(@"mensajePromocion4", nil)
									  andAlertViewType:AlertViewTypeInfo];
		[alert show];
		return NO;
    }
    
    if ( [NSString isEmptyString:_txtRedencion] )
    {
        AlertView *alert = [AlertView initWithDelegate:self
											   message:NSLocalizedString(@"mensajePromocion5", nil)
									  andAlertViewType:AlertViewTypeInfo];
		[alert show];
		return NO;
    }
    
    return YES;
}

-(IBAction)guardarInformacion:(id)sender
{
    [[self view] endEditing:YES];
	
	if ( !self.modifico )
	{
        [self.navigationController popViewControllerAnimated:YES];
        return;
	}
    
    if ( ![self validaCampos] )
        return;
	
    [_promocionActual setTitleOffer:txtTituloPromocion.text];
    [_promocionActual setDescOffer:textDescripcion.text];
    [_promocionActual setTermsOffer:textInformacion.text];
	
	if (_labelVigencia.text == nil)
        [_promocionActual setEndDateOffer:[NSDateFormatter getStringFromDate:_fechaSeleccionada withFormat:VIGENCIA_FORMAT]];
	else
        [_promocionActual setEndDateOffer:_labelVigencia.text];
	
    [_promocionActual setEndDateAux:_fechaSeleccionada];
	
    if (_txtRedencion != Nil) {
        [_promocionActual setRedeemOffer:_txtRedencion];
        [_promocionActual setRedeemAux:txtRedencionAux];
    }
	
	
    if ( ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion )
	{
        if ( [CommonUtils hayConexion] )
		{
			[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:NO];
			[self performSelectorInBackground:@selector(actualizarPromocion) withObject:Nil];
        } else {
            AlertView *alert = [AlertView initWithDelegate:Nil
													titulo:NSLocalizedString(@"sentimos", @" ")
												   message:NSLocalizedString(@"noConexion", @" ")
												   dominio:Nil
										  andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
	}
}

-(IBAction)fechaseleccionda:(UIDatePicker *)sender
{
    self.fechaSeleccionada	= [sender date];
    _labelVigencia.text		= [NSDateFormatter getStringFromDate:_fechaSeleccionada
												   withFormat:VIGENCIA_FORMAT];
    self.modifico = YES;
}

-(void) accionAceptar {
    if ( exito )
    {
        self.datosUsuario = [DatosUsuario sharedInstance];
        if (estaBorrando) {
        //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito Promocion" withValue:@""];
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Promocion"];
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:7 withObject:@NO];
        }
        else {
        //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro Promocion" withValue:@""];
            [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Promocion"];
            if ( _promocionActual.titleOffer.length > 0 && _promocionActual.descOffer.length > 0 )
            {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:7 withObject:@YES];
                self.datosUsuario.rutaImagenPromocion = _promocionActual.pathImageOffer;
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) mostrarActivity {
    self.alertPromocion = [AlertView initWithDelegate:self
											  message:NSLocalizedString(@"msgGuardarPromocion", Nil)
									 andAlertViewType:AlertViewTypeActivity];
    [_alertPromocion show];
}

-(void) ocultarActivity {
    if (_alertPromocion)
    {
        [NSThread sleepForTimeInterval:1];
        [_alertPromocion hide];
    }
    if (exito)
	{
        AlertView *alerta = [AlertView initWithDelegate:self
												message:NSLocalizedString(@"actualizacionCorrecta", Nil)
									   andAlertViewType:AlertViewTypeInfo];
        [alerta show];
		self.modifico = NO;
    }
}

-(void) actualizarPromocion
{
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerPromocion *handlerPromocion = [[WS_HandlerPromocion alloc] init];
        [handlerPromocion setOferta:_promocionActual];
        [handlerPromocion setPromocionDelegate:self];
        if (estaBorrando) {
            [handlerPromocion eliminaPromocion];
        }
        else {
            [handlerPromocion actualizaPromocion];
        }
    }
    else {
        if (_alertPromocion)
        {
            [NSThread sleepForTimeInterval:1];
            [_alertPromocion hide];
        }
        self.alertPromocion = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertPromocion show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        exito = YES;
//		self.datosUsuario.diccionarioPromocion = promociones;
        // !!!: revisar si se guardan los datos como debe ser
    }
    else {
        exito = NO;
		[[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", NIl) andAlertViewType:AlertViewTypeInfo] show];
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (_alertPromocion)
    {
        [NSThread sleepForTimeInterval:1];
        [_alertPromocion hide];
    }
    self.alertPromocion = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertPromocion show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) sessionTimeout
{
    if (_alertPromocion)
    {
        [NSThread sleepForTimeInterval:1];
        [_alertPromocion hide];
    }
    self.alertPromocion = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [_alertPromocion show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar
{
    if (_alertPromocion)
    {
        [NSThread sleepForTimeInterval:1];
        [_alertPromocion hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", nil) andAlertViewType:AlertViewTypeInfo] show];
}

#pragma mark
- (void)imagenSeleccionada:(UIImage *)imagen
{
    //
}

- (void)rutaImagenGuardada:(NSString *)rutaImagen
{
    [_promocionActual setPathImageOffer:rutaImagen];
    self.modifico = YES;
    
    NSArray *promo		= [arregloPromociones objectAtIndex:0];
    ((Datos *)[promo objectAtIndex:0]).estatus = NO;
    ((Datos *)[promo objectAtIndex:1]).estatus = YES;
    [_tablaPromociones reloadData];
}

- (void)seleccionCancelada
{
    
}

- (void)imagenBorrada
{
    [self eligeTipoFoto:0];
    [_tablaPromociones reloadData];
}

- (void)operacionConError:(NSString *)strError
{
    
}

@end