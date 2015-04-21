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
#import "InicioViewController.h"

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
    
    if(IS_STANDARD_IPHONE_6){
        [self.txtDescripcion setFrame:CGRectMake(50, 70, 275, 150)];
        
        [self.btnEliminar2 setFrame:CGRectMake(325, 368, 29, 35)];// Horarios
        [self.labelInfo setFrame:CGRectMake(335, 290, 33, 21)];
        [self.fixed setWidth:280.0f];
        [self.labelTituloHorarios setFrame:CGRectMake(20, 5, 335, 60)];
        [self.vistaPicker setFrame:CGRectMake(0, 667, 375, 250)];
        [self.vistaHorarios setFrame:CGRectMake(0, 0, 375, 667)];
        [self.tablaHorarios setFrame:CGRectMake(20, 60, 335, 350)];
        
    }else if(IS_STANDARD_IPHONE_6_PLUS){
        [self.txtDescripcion setFrame:CGRectMake(50, 70, 314, 170)];
        [self.btnEliminar setFrame:CGRectMake(335, 250, 29, 35)];
        [self.btnEliminar2 setFrame:CGRectMake(335, 425, 29, 35)];// Horarios
        [self.labelInfo setFrame:CGRectMake(335, 290, 33, 21)];
        [self.fixed setWidth:320.0f];
        [self.labelTituloHorarios setFrame:CGRectMake(50, 5, 314, 60)];
        [self.vistaPicker setFrame:CGRectMake(0, 736, 414, 206)];
        [self.vistaHorarios setFrame:CGRectMake(0, 0, 414, 736)];
        [self.tablaHorarios setFrame:CGRectMake(50, 60, 314, 350)];
    }else if(IS_IPAD){
        [self.txtDescripcion setFrame:CGRectMake(134, 70, 500, 200)];
        [self.btnEliminar setFrame:CGRectMake(550, 300, 29, 35)];
        [self.btnEliminar2 setFrame:CGRectMake(650, 450, 29, 35)];
        [self.labelInfo setFrame:CGRectMake(550, 300, 33, 21)];
        [self.fixed setWidth:600.0f];
        [self.labelTituloHorarios setFrame:CGRectMake(0, 20, 768, 30)];
        [self.vistaPicker setFrame:CGRectMake(0, 1024, 768, 1024)];
        [self.vistaHorarios setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.tablaHorarios setFrame:CGRectMake(134, 60, 500, 350)];
    }else{
        [self.vistaPicker setFrame:CGRectMake(0, 568, 320, 206)];
        [self.vistaHorarios setFrame:CGRectMake(0, 0, 320, 568)];
    
    }
}


-(void) configuraVista {
    [self.labelInformacion setText:[arrayTextos objectAtIndex:index]];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (index == 2)
	{

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
        KeywordDataModel *dataModel = [self.datosUsuario.arregloDatosPerfil objectAtIndex:index];
        NSLog(@"datamodel para eliminar!! : %i", dataModel.idKeyword);
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

        
    }
    else {
        modificoPickerC2 = YES;
        [horarioSeleccionado setCierre:[arrayHorarios objectAtIndex:row]];
        anterior2 = row;

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
        framePicker = CGRectMake(0, 288, 320, 280);
    }else if(IS_IPAD){
        framePicker = CGRectMake(0, 724, 768, 300);
    }else if(IS_STANDARD_IPHONE_6){
        framePicker = CGRectMake(0, 420, 375, 206);
    }else if(IS_STANDARD_IPHONE_6_PLUS){
        framePicker = CGRectMake(0, 486, 414, 250);
    }else {
        framePicker = CGRectMake(0, 210, 320, 206);
    }
    modificoPickerC1 = modificoPickerC2 = NO;
	[self.pickerHorarios selectRow:anterior1 inComponent:0 animated:YES];
	[self.pickerHorarios selectRow:anterior2 inComponent:1 animated:YES];
    horarioSeleccionado = [self.arrayDataContent objectAtIndex:indexPath.row];
   
        [UIView animateWithDuration:0.2f animations:^{
            [self.vistaInferior setAlpha:0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                [self.vistaPicker setFrame:framePicker];
            }];
        }];
   
    [self.vistaHorarios setContentSize:CGSizeMake(320, 500)];
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
        if(IS_STANDARD_IPHONE_6_PLUS){
            [self.vistaPicker setFrame:CGRectMake(0, 736, 414, 206)];
        }else if(IS_STANDARD_IPHONE_6){
            [self.vistaPicker setFrame:CGRectMake(0, 667, 375, 206)];
        }else if(IS_IPAD){
            [self.vistaPicker setFrame:CGRectMake(0, 1024, 768, 300)];
        }else if(IS_IPHONE_5){
            [self.vistaPicker setFrame:CGRectMake(0, 582, 320, 206)];
        }else{
            [self.vistaPicker setFrame:CGRectMake(0, 562, 320, 206)];
        }
    } completion:^(BOOL finished) {
       
            [UIView animateWithDuration:0.2f animations:^{
                [self.vistaInferior setAlpha:1];
            }];
        
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

                AlertView *alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"ingresaHorario",nil) andAlertViewType:AlertViewTypeInfo];
                [alert show];
			}else{
                [self validaEditados];
				[self.navigationController popViewControllerAnimated:YES];
			}
		}else{
			if([self.txtDescripcion.text isEqualToString:@""]){

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
    if (self.modifico && [CommonUtils hayConexion]) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        [self validaEditados];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) accionSi {
    
    NSLog(@"MANDO A LLAMAR ELIMINAR DE NEGOCIO PROFESION");
	[self.view endEditing:YES];
    if (estaEliminando && index != 2 )
    {
        NSLog(@"EL INDEX A ELIMINAR ES: %i",index);
        self.datosUsuario = [DatosUsuario sharedInstance];
        idPerfil = [[self.datosUsuario.arregloDatosPerfil objectAtIndex:index] idKeyword];
        [self copiarArreglo];
        [self.datosUsuario.arregloEstatusPerfil replaceObjectAtIndex:index withObject:@NO];
       
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
            
                    [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"(Perfil)Productos|Servicios"];
                    break;
                case 1:
              
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
    
        WS_ActualizarDireccion *actualizarDireccion = [[WS_ActualizarDireccion alloc] init];
        [actualizarDireccion setDireccionDelegate:self];
        [actualizarDireccion setArregloPerfil:arregloPerfilAux];
        [actualizarDireccion setIndexSeleccionado:index];
        if (estaEditando) {
            KeywordDataModel *dataModel = [arregloPerfilAux objectAtIndex:index];
            [actualizarDireccion actualizarElementoPerfil:dataModel];
        }
        else if (estaEliminando) {
            NSLog(@"ESTA ELIMINANDO WE con el idPerfil: %i", idPerfil);
            [actualizarDireccion eliminarKeywordConId:idPerfil];
        }
        else {
            [actualizarDireccion insertarPerfil:index];
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
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    InicioViewController *inicio = [[InicioViewController alloc] initWithNibName:@"InicioViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}



#pragma mark - Teclado

-(void)textViewDidBeginEditing:(UITextView *)textView {

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
    }
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(actualizarPerfil) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
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
