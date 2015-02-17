//
//  PerfilPaso2ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "PerfilPaso2ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HorarioCell.h"
#import "ListaHorarios.h"
#import "KeywordDataModel.h"
#import "WS_ActualizarDireccion.h"
#import "UIViewDefs.h"

@interface PerfilPaso2ViewController () {
    ListaHorarios *horarioSeleccionado;
//    BOOL modifico;
    NSIndexPath *indexSeleccionado;
    BOOL modificoPickerC1;
    BOOL modificoPickerC2;
    BOOL exito;
    BOOL estaEditando;
    NSInteger idPerfil;
    BOOL estaEliminando;
    NSMutableArray *arregloPerfilAux;
    
    NSInteger anterior1, anterior2;
	
	UITextView *textViewEditado;
	
}
@property (nonatomic, strong) NSArray *arrayTextos;
@property (nonatomic, strong) NSArray *arrayHorarios;
@property (nonatomic, strong) NSArray *arrayDias;
@property (nonatomic, strong) NSMutableArray *arrayDataContent;
@property (nonatomic, strong) NSArray *arregloKeys;
@property (nonatomic, strong) AlertView *alertPerfil;

@property (nonatomic, copy) NSMutableArray *respaldoHorarios;
@property (nonatomic, copy) NSMutableArray *respaldo;

@end

@implementation PerfilPaso2ViewController

@synthesize tituloPerfil, index;
@synthesize arrayTextos, arrayHorarios, arrayDias, arregloKeys;
@synthesize respaldo,respaldoHorarios;

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
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:tituloPerfil nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:tituloPerfil nombreImagen:@"NBverde.png"];
	}
    arrayTextos = @[NSLocalizedString(@"describeProductos", @" "),
					NSLocalizedString(@"areaGeografica", @" "),
					NSLocalizedString(@"horario", @" "),
					NSLocalizedString(@"formasPago", @" "),
					NSLocalizedString(@"miembroAsociacion", @" "),
					NSLocalizedString(@"queMasQuiere", @" "),
					NSLocalizedString(@"perfinNegocioProfesion", @"")];
    arrayHorarios = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Horarios" ofType:@"plist"]];
    arregloKeys = [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CatalogoInformacion" ofType:@"plist"]] objectForKey:@"perfil"];
    anterior2 = 0;
    anterior1 = 0;
    
    arregloPerfilAux = [[NSMutableArray alloc] init];
	
	[self setBotonRegresar];
    
    arrayDias = @[NSLocalizedString(@"lunes", @" "),
				  NSLocalizedString(@"martes", @" "),
				  NSLocalizedString(@"miercoles", @" "),
				  NSLocalizedString(@"jueves", @" "),
				  NSLocalizedString(@"viernes", @" "),
				  NSLocalizedString(@"sabado", @" "),
				  NSLocalizedString(@"domingo", @" ")];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (index == 2) {
        [self.vistaHorarios setHidden:NO];
        [self.vistaPerfil setHidden:YES];
		
		if (self.datosUsuario.arregloDatosPerfil.count == 0 || self.datosUsuario.arregloDatosPerfil == nil) {
            NSMutableArray *arregloAux = [[NSMutableArray alloc] init];
            [arregloAux addObjectsFromArray:@[[[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init]]];
            self.datosUsuario.arregloDatosPerfil = arregloAux;
        }
    }
    else {
        [self.vistaHorarios setHidden:YES];
        [self.vistaPerfil setHidden:NO];
        [self configuraVista];
        if (self.datosUsuario.arregloDatosPerfil.count == 0 || self.datosUsuario.arregloDatosPerfil == nil) {
            NSMutableArray *arregloAux = [[NSMutableArray alloc] init];
            [arregloAux addObjectsFromArray:@[[[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init], [[KeywordDataModel alloc] init]]];
            self.datosUsuario.arregloDatosPerfil = arregloAux;
        }
    }
    self.modifico = NO;
    [self.labelTituloHorarios setText:NSLocalizedString(@"defineHorario", Nil)];
    
    self.txtDescripcion.layer.cornerRadius = 5;
    
    self.tablaHorarios.layer.cornerRadius = 5;
	
	[self.vistaPerfil setContentSize:CGSizeMake(320, 0)];
	
	self.datosUsuario = [DatosUsuario sharedInstance];
//	respaldoHorarios = [self.datosUsuario.arregloHorario copy];
//	respaldo = [self.datosUsuario.arregloDatosPerfil copy];
	respaldo = [[NSMutableArray alloc] initWithArray:self.datosUsuario.arregloDatosPerfil copyItems:YES];
//	respaldoHorarios = [[NSMutableArray alloc] initWithArray:self.datosUsuario.arregloHorario copyItems:YES];
}


-(void) configuraVista {
    [self.labelInformacion setText:[arrayTextos objectAtIndex:index]];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (index == 2)
	{
//        if (self.datosUsuario.arregloHorario.count > 0) {
//            self.arrayDataContent = self.datosUsuario.arregloHorario;
//            estaEditando = YES;
//        }
//        else {
//            self.arrayDataContent = [[NSMutableArray alloc] init];
        
//        }
        self.arrayDataContent = [[NSMutableArray alloc] init];
        KeywordDataModel *keyAux = [self.datosUsuario.arregloDatosPerfil objectAtIndex:index];
        if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0)
		{
            NSInteger k = 0;
            NSArray *arrayHorarioAux = [keyAux.keywordValue componentsSeparatedByString:@"|"];
            for (int j = 0; j < [arrayHorarioAux count]; j++)
			{
                if (j % 2 == 0 && j > 0)
				{
                    NSArray *arrayDiaAux = [[arrayHorarioAux objectAtIndex:j] componentsSeparatedByString:@" - "];
                    ListaHorarios *lista = [[ListaHorarios alloc] init];
                    [lista setDia:[arrayDias objectAtIndex:k]];
                    [lista setInicio:[arrayDiaAux objectAtIndex:0]];
                    [lista setCierre:[arrayDiaAux objectAtIndex:1]];
                    if (![[arrayDiaAux objectAtIndex:0] isEqualToString:@"00:00"] || ![[arrayDiaAux objectAtIndex:1] isEqualToString:@"00:00"]) {
                        [lista setEditado:YES];
                    }
                    else {
                        [lista setEditado:NO];
                    }
                    [self.arrayDataContent addObject:lista];
                    k++;
                }
            }
            estaEditando = YES;
			
			[self.btnEliminar2 setEnabled:YES];
			//self.btnEliminar2.frame = CGRectMake(268, 500, 29, 35);
        } else {
            for (int i = 0; i < arrayDias.count; i++)
            {
                ListaHorarios *lista = [[ListaHorarios alloc] init];
                [lista setDia:[arrayDias objectAtIndex:i]];
                [lista setInicio:@"00:00"];
                [lista setCierre:@"00:00"];
                [lista setEditado:NO];
                [self.arrayDataContent addObject:lista];
            }
            estaEditando = NO;
			
        }
		self.vistaInferior.hidden = YES;
        [self.pickerHorarios reloadAllComponents];
    }
    else {
//        NSMutableArray *arregloPerfil = self.datosUsuario.arregloDatosPerfil;
        KeywordDataModel *dataModel = [self.datosUsuario.arregloDatosPerfil objectAtIndex:index];
        [self.txtDescripcion setText:dataModel.keywordValue];
        if (dataModel.keywordValue.length > 0) {
            estaEditando = YES;
            [self.btnEliminar setEnabled:YES];
        }
        else {
            estaEditando = NO;
            [self.btnEliminar setEnabled:NO];
        }
    }
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:tituloPerfil nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:tituloPerfil nombreImagen:@"NBverde.png"];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [arrayHorarios count];
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayHorarios objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
		//modifico = YES;
    if (component == 0) {
        modificoPickerC1 = YES;
        anterior1 = row;
        [horarioSeleccionado setInicio:[arrayHorarios objectAtIndex:row]];
//        if (row+1 < [arrayHorarios count]) {
//            anterior2 = row+1;
//            [horarioSeleccionado setCierre:[arrayHorarios objectAtIndex:row+1]];
//            [pickerView selectRow:row+1 inComponent:1 animated:YES];
//            modificoPickerC2 = YES;
//        }
//        else {
//            anterior2 = row;
//            [horarioSeleccionado setCierre:[arrayHorarios objectAtIndex:row]];
//            [pickerView selectRow:row inComponent:1 animated:YES];
//            modificoPickerC2 = YES;
//        }
        
    }
    else {
        modificoPickerC2 = YES;
        [horarioSeleccionado setCierre:[arrayHorarios objectAtIndex:row]];
        anterior2 = row;
//		if([self.pickerHorarios selectedRowInComponent:0]>=row){
//            if (row > 0) {
//                [pickerView selectRow:row-1 inComponent:0 animated:YES];
//                anterior1 = row-1;
//                [horarioSeleccionado setInicio:[arrayHorarios objectAtIndex:row-1]];
//            }
//            else {
//                [pickerView selectRow:row inComponent:0 animated:YES];
//                anterior1 = row;
//                [horarioSeleccionado setInicio:[arrayHorarios objectAtIndex:row]];
//            }
//			modificoPickerC1 = YES;
//		}
    }
}

#pragma mark - UITableView Datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayDias count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HorarioCell";
    HorarioCell *cell = (HorarioCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HorarioCell" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
    }
    ListaHorarios *lista = [self.arrayDataContent objectAtIndex:indexPath.row];
    [cell.dia setText:[lista dia]];
	[cell.dia setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    [cell.horario setText:[NSString stringWithFormat:@"%@ - %@", lista.inicio, lista.cierre]];
	[cell.horario setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    if (lista.editado) {
        [cell.horario setTextColor:colorFuenteAzul];
    }
    else {
        [cell.horario setTextColor:colorFuenteVerde];
    }
    return cell;
}

#pragma mark - UITableView Delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect framePicker;
    if (IS_IPHONE_5) {
        framePicker = CGRectMake(0, 248, 320, 206);
    }
    else {
        framePicker = CGRectMake(0, 210, 320, 206);
    }
    modificoPickerC1 = modificoPickerC2 = NO;
	[self.pickerHorarios selectRow:anterior1 inComponent:0 animated:YES];
	[self.pickerHorarios selectRow:anterior2 inComponent:1 animated:YES];
    horarioSeleccionado = [self.arrayDataContent objectAtIndex:indexPath.row];
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
        [UIView animateWithDuration:0.2f animations:^{
            [self.vistaInferior setAlpha:0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                [self.vistaPicker setFrame:framePicker];
            }];
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            [self.vistaPicker setFrame:framePicker];
        }];
    }
    [self.vistaHorarios setContentSize:CGSizeMake(320, 500)];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    indexSeleccionado = indexPath;
    [self apareceDatePicker:indexPath];
}

- (IBAction)seleccionarHorario:(UIBarButtonItem *)sender {
    if (modificoPickerC1) {
        if(!modificoPickerC2) {
            [horarioSeleccionado setCierre:[arrayHorarios objectAtIndex:anterior2]];
        }
    }
    else if (modificoPickerC2) {
        if (!modificoPickerC1) {
            [horarioSeleccionado setInicio:[arrayHorarios objectAtIndex:anterior1]];
        }
    }
    else {
        [horarioSeleccionado setInicio:[arrayHorarios objectAtIndex:anterior1]];
        [horarioSeleccionado setCierre:[arrayHorarios objectAtIndex:anterior2]];
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self.vistaPicker setFrame:CGRectMake(0, 562, 320, 206)];
    } completion:^(BOOL finished) {
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
            [UIView animateWithDuration:0.2f animations:^{
                [self.vistaInferior setAlpha:1];
            }];
        }
    }];
    [self.pickerHorarios selectRow:0 inComponent:0 animated:NO];
    [self.pickerHorarios selectRow:0 inComponent:1 animated:NO];
	
	if([horarioSeleccionado.inicio isEqualToString:@"00:00"] && [horarioSeleccionado.cierre isEqualToString:@"00:00"]){
		[horarioSeleccionado setEditado:NO];
		self.modifico = YES;
	}else{
		[horarioSeleccionado setEditado:YES];
		self.modifico = YES;
	}
    [self desapareceDatePicker];
    [self.tablaHorarios reloadData];
    //    [self.vistaHorarios setContentSize:CGSizeMake(320, 300)];
}

- (IBAction)eliminarPerfil:(UIButton *)sender {
    
    estaEliminando = YES;
    self.alertPerfil = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeEliminarPerfil", nil) andAlertViewType:AlertViewTypeQuestion];
    [self.alertPerfil show];
}

- (IBAction)eliminarHorario:(UIButton *)sender {
    estaEliminando = YES;
    self.alertPerfil = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeEliminarPerfil", nil) andAlertViewType:AlertViewTypeQuestion];
    [self.alertPerfil show];
//	NSMutableArray *aux = [[NSMutableArray alloc] init];
//	
//	for (int i = 0; i < arrayDias.count; i++) {
//		ListaHorarios *lista = [[ListaHorarios alloc] init];
//		[lista setDia:[arrayDias objectAtIndex:i]];
//		[lista setInicio:@"00:00"];
//		[lista setCierre:@"00:00"];
//		[lista setEditado:NO];
//		[aux addObject:lista];
//		estaEditando = YES;
//	}
//	
//	self.arrayDataContent = aux;
//	
//	[self guardaDatos];
}

-(IBAction)guardarInformacion:(id)sender {
    [self.view endEditing:YES];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.modifico) {
        [self guardaDatos];
    }
	else{
		if(index == 2){
			int aux = 0;
			for (ListaHorarios *horario in self.arrayDataContent){
				if([horario.inicio isEqualToString:@"00:00"] && [horario.cierre isEqualToString:@"00:00"]){
					aux++;
				}
			}
			if(aux > 0){
//				if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
//					AlertView *alert = [AlertView initWithDelegate:nil message:@"Enter opening hours" andAlertViewType:AlertViewTypeInfo];
//					[alert show];
//				}else{
//					AlertView *alert = [AlertView initWithDelegate:nil message:@"Ingresa horario de atención" andAlertViewType:AlertViewTypeInfo];
//					[alert show];
//				}
                AlertView *alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"ingresaHorario",nil) andAlertViewType:AlertViewTypeInfo];
                [alert show];
			}else{
                [self validaEditados];
				[self.navigationController popViewControllerAnimated:YES];
			}
		}else{
			if([self.txtDescripcion.text isEqualToString:@""]){
//				if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
//					AlertView *alert = [AlertView initWithDelegate:nil message:@"Enter desired text" andAlertViewType:AlertViewTypeInfo];
//					[alert show];
//				}else{
//					AlertView *alert = [AlertView initWithDelegate:nil message:@"Ingresa texto deseado" andAlertViewType:AlertViewTypeInfo];
//					[alert show];
//				}
                AlertView *alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"ingresaTexto",nil) andAlertViewType:AlertViewTypeInfo];
                [alert show];
			}else{
                [self validaEditados];
				[self.navigationController popViewControllerAnimated:YES];
			}
		}
	}
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    AlertView *alertView;
    if (self.modifico) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        [self validaEditados];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) accionSi {
	[self.view endEditing:YES];
    if (estaEliminando && index != 2 )
    {
        self.datosUsuario = [DatosUsuario sharedInstance];
        idPerfil = [[self.datosUsuario.arregloDatosPerfil objectAtIndex:index] idKeyword];
        [self copiarArreglo];
        [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:index withObject:@NO];
        if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
            if ([CommonUtils hayConexion]) {
                estaEliminando = YES;
                estaEditando = NO;
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarPerfil) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }
    } else if (estaEditando){
        NSMutableArray *aux = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < arrayDias.count; i++) {
            ListaHorarios *lista = [[ListaHorarios alloc] init];
            [lista setDia:[arrayDias objectAtIndex:i]];
            [lista setInicio:@"00:00"];
            [lista setCierre:@"00:00"];
            [lista setEditado:NO];
            [aux addObject:lista];
            estaEditando = YES;
        }
        
        self.arrayDataContent = aux;
        
        [self guardaDatos];
    }else {
        self.datosUsuario = [DatosUsuario sharedInstance];
        if (self.modifico) {
            [self guardaDatos];
        }
        else{
            [self validaEditados];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    

}

-(void) accionNo {
    if (!estaEliminando) {
        [self validaEditados];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) accionAceptar {
    if (exito) {
        [self validaEditados];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if ([text isEqualToString:@"<"] || [text isEqualToString:@">"]) {
//        return NO;
//    }
//    self.modifico = YES;
//    return YES;
//}

-(void) apareceDatePicker:(NSIndexPath *)indexPath {
    CGSize tamanioTeclado;
    if (IS_IPHONE_5) {
        tamanioTeclado = CGSizeMake(320, 126);
    }
    else {
        tamanioTeclado = CGSizeMake(320, 206);
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [[self tablaHorarios] setContentInset:edgeInsets];
    [[self tablaHorarios] setScrollIndicatorInsets:edgeInsets];
    [[self tablaHorarios] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void) desapareceDatePicker {
    [self.tablaHorarios deselectRowAtIndexPath:indexSeleccionado animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self tablaHorarios] setContentInset:edgeInsets];
    [[self tablaHorarios] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

-(void) mostrarActivity {
    self.alertPerfil = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarPerfil", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertPerfil show];
}

-(void) ocultarActivity {
    if (self.alertPerfil)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertPerfil hide];
    }
    if (exito) {
        if (estaEliminando) {
            switch (index) {
                case 0:
              //      [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro (Perfil)Productos|Servicios" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"(Perfil)Productos|Servicios"];
                    break;
                case 1:
               //     [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro (Perfil)Areas de servicio" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"(Perfil)Areas de servicio"];
                    break;
                case 2:
               //     [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro (Perfil)Horario" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"(Perfil)Horario"];
                    break;
                case 3:
               //     [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro (Perfil)Medios de pago" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"(Perfil)Medios de pago"];
                    break;
                case 4:
                 //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro (Perfil)Asociaciones" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"(Perfil)Asociaciones"];
                    break;
                case 5:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro (Perfil)Biografia" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"(Perfil)Biografia"];
                    break;
                case 6:
                 //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro (Perfil)Negocio|Profesion" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"(Perfil)Negocio|Profesion"];
                    break;
                    
                default:
                    break;
            }
        }
        else {
            switch (index) {
                case 0:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito (Perfil)Productos|Servicios" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"(Perfil)Productos|Servicios"];
                    break;
                case 1:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito (Perfil)Areas de servicio" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"(Perfil)Areas de servicio"];
                    break;
                case 2:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito (Perfil)Horario" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"(Perfil)Horario"];
                    break;
                case 3:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito (Perfil)Medios de pago" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"(Perfil)Medios de pago"];
                    break;
                case 4:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito (Perfil)Asociaciones" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"(Perfil)Asociaciones"];
                    break;
                case 5:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito (Perfil)Biografia" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"(Perfil)Biografia"];
                    break;
                case 6:
                //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito (Perfil)Negocio|Profesion" withValue:@""];
                    [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"(Perfil)Negocio|Profesion"];
                    break;
                    
                default:
                    break;
            }
        }
        AlertView *alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertView show];
    }
    else {
        AlertView *alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertView show];
//		[self revertirGuardado];
    }
}

-(void) actualizarPerfil {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_ActualizarDireccion *actualizarDireccion = [[WS_ActualizarDireccion alloc] init];
        [actualizarDireccion setDireccionDelegate:self];
        [actualizarDireccion setArregloPerfil:arregloPerfilAux];
        [actualizarDireccion setIndexSeleccionado:index];
        if (estaEditando) {
            KeywordDataModel *dataModel = [arregloPerfilAux objectAtIndex:index];
            [actualizarDireccion actualizarElementoPerfil:dataModel];
        }
        else if (estaEliminando) {
            [actualizarDireccion eliminarKeywordConId:idPerfil];
        }
        else {
            [actualizarDireccion insertarPerfil:index];
        }
    }
    else {
        if (self.alertPerfil)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertPerfil hide];
        }
        self.alertPerfil = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertPerfil show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar {
    if (self.alertPerfil)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertPerfil hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
	[self revertirGuardado];
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"] || [resultado integerValue] > 0) {
        exito = YES;
        if (!estaEditando) {
            idPerfil = [resultado integerValue];
        }
    }
    else {
        exito = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertPerfil)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertPerfil hide];
    }
    self.alertPerfil = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertPerfil show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sessionTimeout
{
    if (self.alertPerfil)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertPerfil hide];
    }
    self.alertPerfil = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertPerfil show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Teclado

-(void)textViewDidBeginEditing:(UITextView *)textView {
//	NSLog(@"Editar");
//	textViewEditado = textView;
    [self muestraContadorTexto:[textView.text length] conLimite:255 paraVista:textView];
	[self apareceTeclado:self.vistaPerfil withView:textView];
}
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [self shouldChangeText:text withLimit:255 forFinalLenght:[textView.text length] - range.length + [text length]];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self ocultaContadorTexto];
	[self desapareceElTeclado: self.vistaPerfil];
}

-(void)revertirGuardado{
	self.datosUsuario = [DatosUsuario sharedInstance];
}

- (void) guardaDatos {
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSMutableArray *arregloAux = self.datosUsuario.arregloEstatusPerfil;
    if (index == 2) {
//        BOOL comprobacion = NO;
        int i = 0;
        for (ListaHorarios *horario in self.arrayDataContent) {
            if(![horario.cierre isEqualToString:@"00:00"] && ![horario.inicio isEqualToString:@"00:00"]){
                i++;
            }
        }
//        if(i != 0){
//            comprobacion = YES;
//        }else if(i == 0){
//            comprobacion = NO;
//            
//        }
//        
//        if(comprobacion){
//            [arregloAux replaceObjectAtIndex:index withObject:@YES];
//        }else{
//            [arregloAux replaceObjectAtIndex:index withObject:@NO];
//        }
//        self.datosUsuario.arregloEstatusPerfil = arregloAux;
        
//        self.datosUsuario.arregloHorario = self.arrayDataContent;
        NSMutableString *stringHorarios = [[NSMutableString alloc] initWithString:@"|"];
        for (ListaHorarios *horario in self.arrayDataContent) {
            [stringHorarios appendFormat:@"%@|%@ - %@|", horario.dia, horario.inicio, horario.cierre];
        }
        [self copiarArreglo];
        KeywordDataModel *keyData = [arregloPerfilAux objectAtIndex:index];
        keyData.keywordField = [arregloKeys objectAtIndex:index];
        [stringHorarios replaceOccurrencesOfString:@"é" withString:@"e" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringHorarios length])];
        [stringHorarios replaceOccurrencesOfString:@"á" withString:@"a" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringHorarios length])];
        keyData.keywordValue = stringHorarios;
    }
    else {
        [arregloAux replaceObjectAtIndex:index withObject:@YES];
        self.datosUsuario.arregloEstatusPerfil = arregloAux;
        
        [self copiarArreglo];
        
        KeywordDataModel *keyData = [arregloPerfilAux objectAtIndex:index];
        keyData.keywordField = [arregloKeys objectAtIndex:index];
        keyData.keywordValue = [self.txtDescripcion text];
        
//        arregloAux = self.datosUsuario.arregloEstatusEdicion;
    }
//    modifico = NO;
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(actualizarPerfil) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
//            [self revertirGuardado];
        }
    }
    else {
        [self validaEditados];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) validaEditados {
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@NO];
    int i = 0, k = 0;
    for (KeywordDataModel *keyAux in self.datosUsuario.arregloDatosPerfil) {
        if (i == 2) {
            if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0) {
                NSArray *arrayHorarioAux = [keyAux.keywordValue componentsSeparatedByString:@"|"];
                for (int j = 0; j < [arrayHorarioAux count]; j++) {
                    if (j % 2 == 0 && j > 0) {
                        NSArray *arrayDiaAux = [[arrayHorarioAux objectAtIndex:j] componentsSeparatedByString:@" - "];
                        if (![[arrayDiaAux objectAtIndex:0] isEqualToString:@"00:00"] || ![[arrayDiaAux objectAtIndex:1] isEqualToString:@"00:00"]) {
                            k++;
                        }
                    }
                }
                if (k > 0) {
                    [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@YES];
                    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@YES];
                }
                else {
                    [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@NO];
                }
            }
            
        }
        else if (i == 6) {
            if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0) {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:2 withObject:@YES];
            }
            else {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:2 withObject:@NO];
            }
        }
        else {
            if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0) {
                [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@YES];
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:9 withObject:@YES];
            }
            else {
                [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:i withObject:@NO];
            }

            }
        i++;
    }
    
    
}

-(void) copiarArreglo {
    self.datosUsuario = [DatosUsuario sharedInstance];
    arregloPerfilAux = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloDatosPerfil count]];
    for (KeywordDataModel *keyData in self.datosUsuario.arregloDatosPerfil) {
        KeywordDataModel *keyAux = [[KeywordDataModel alloc] init];
        keyAux.idKeyword = keyData.idKeyword;
        keyAux.keywordField = keyData.keywordField;
        keyAux.keywordValue = keyData.keywordValue;
        keyAux.KeywordPos = keyData.KeywordPos;
        [arregloPerfilAux addObject:keyAux];
    }
}

@end
