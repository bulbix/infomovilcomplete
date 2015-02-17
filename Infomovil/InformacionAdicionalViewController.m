//
//  InformacionAdicionalViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InformacionAdicionalViewController.h"
#import "InformacionPaso2ViewController.h"
#import "InformacionAdicional.h"
#import "KeywordDataModel.h"
#import "ItemsDominio.h"
#import "CuentaViewController.h"

@interface InformacionAdicionalViewController (){
	
	NSInteger maxNumInformacion;
	
	AlertView * alertaIndormacion;
	
}

@end

@implementation InformacionAdicionalViewController

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
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecaverde.png"]];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecacreasitio.png"]];
	
	if(existeItems){
		self.datosUsuario = [DatosUsuario sharedInstance];
		ItemsDominio * item = [self.datosUsuario.itemsDominio objectAtIndex:11];
		maxNumInformacion = item.estatus;
	}else{
		maxNumInformacion = 1;
	}

	//self.label.text = [NSString stringWithFormat:NSLocalizedString(@"mensageInformacionAdiciona", @" "),maxNumInformacion];
	NSString * text=[NSString stringWithFormat:NSLocalizedString(@"mensajeInformacionAdicional", @" "),maxNumInformacion];
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		self.label.text = text;

	}else{
		self.label.text = NSLocalizedString(@"mensajeInformacionAdicional", @" ");

	}
	
	self.labelTexto1.text = NSLocalizedString(@"infoAdicionalTexto", Nil);
	
    
    UIImage *imagenAgregar = [UIImage imageNamed:@"btnagregar.png"];
    UIButton *botonAgregar = [UIButton buttonWithType:UIButtonTypeCustom];
    [botonAgregar setFrame:CGRectMake(0, 0, imagenAgregar.size.width, imagenAgregar.size.height)];
    [botonAgregar setBackgroundImage:imagenAgregar forState:UIControlStateNormal];
    [botonAgregar addTarget:self action:@selector(agregarInformacion:) forControlEvents:UIControlEventTouchUpInside];
    
    self.datosUsuario = [DatosUsuario sharedInstance];
    
    if (self.datosUsuario.arregloInformacionAdicional.count == 0) {
        self.arregloInformacion = [[NSMutableArray alloc] init];
        self.datosUsuario.arregloInformacionAdicional = self.arregloInformacion;
    }
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithCustomView:botonAgregar];
    self.navigationItem.rightBarButtonItem = buttonAdd;
//    [self.tituloVista setText:NSLocalizedString(@"informacionAdicional", @" ")];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"informacionAdicional", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"informacionAdicional", @" ") nombreImagen:@"NBverde.png"];
	}
    
    self.vistaInformacion.layer.cornerRadius = 5.0f;
    
    self.tablaInformacion.layer.cornerRadius = 5.0f;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"informacionAdicional", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"informacionAdicional", @" ") nombreImagen:@"NBverde.png"];
	}
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.datosUsuario.arregloInformacionAdicional.count == 0) {
        [self.vistaInformacion setHidden:NO];
        [self.tablaInformacion setHidden:YES];
    }
    else {
        [self.vistaInformacion setHidden:YES];
        [self.tablaInformacion setHidden:NO];
        self.arregloInformacion = self.datosUsuario.arregloInformacionAdicional;
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:11 withObject:@YES];
        [self.tablaInformacion reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)agregarInformacion:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.datosUsuario.arregloInformacionAdicional.count < maxNumInformacion) {
        InformacionPaso2ViewController *info = [[InformacionPaso2ViewController alloc] initWithNibName:@"InformacionPaso2ViewController" bundle:Nil];
        [info setOperacionInformacion: InfoAdicionalOperacionAgregar];
        [self.navigationController pushViewController:info animated:YES];
    }
	else{
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		if(self.datosUsuario.arregloInformacionAdicional.count == maxNumInformacion && ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion && ([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] || [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Tramite PRO"])){
			AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeInformacionPro", nil) andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
		else if(!((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion){
			alertaIndormacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeInformacionAdicionalPrueba", @" ") andAlertViewType:AlertViewTypeQuestion];
			[alertaIndormacion show];
		}else{
			AlertView *alert = [AlertView initWithDelegate:self message:[NSString stringWithFormat:NSLocalizedString(@"mensajeInformacionAdicionalPrueba", @" "),maxNumInformacion] andAlertViewType:AlertViewTypeQuestion];
			[alert show];
		}
	}
}

-(void) accionSi{
	[alertaIndormacion hide];
    CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
    [self.navigationController pushViewController:cuenta animated:YES];
}

-(void) accionNo{
	[alertaIndormacion hide];
}

#pragma mark - UITableViewDatasource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arregloInformacion count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellInformacion";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    KeywordDataModel *info = [self.arregloInformacion objectAtIndex:indexPath.row];
    [cell.textLabel setText:[info keywordField]];
    [cell.textLabel setTextColor:colorFuenteAzul];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InformacionPaso2ViewController *informacion = [[InformacionPaso2ViewController alloc] initWithNibName:@"InformacionPaso2ViewController" bundle:Nil];
    [informacion setOperacionInformacion:InfoAdicionalOperacionEditar];
    [informacion setIndex:indexPath.row];
    [self.navigationController pushViewController:informacion animated:YES];
}

@end
