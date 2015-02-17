//
//  ListaTelefonosViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "ListaTelefonosViewController.h"
#import "TipoContactoViewController.h"
#import "VistaContactos.h"
#import "Contacto.h"
#import "ContactosCell.h"
#import "ContactoPaso2ViewController.h"
#import "WS_HandlerContactos.h"
#import "DatosUsuario.h"
#import "ItemsDominio.h"
#import "CuentaViewController.h"
#import "TextAndGraphAlertView.h"

@interface ListaTelefonosViewController () <ContactosCellDelegate> {
    BOOL actualizoContactos;
//    BOOL self.modifico;
    BOOL esReacomodo;
    BOOL esNoPremium;
	
	NSInteger maxNumContactos;
	AlertView *alertaContactos;
}

@property (nonatomic, strong) NSMutableArray *arregloContactos;

@property (nonatomic, strong) NSArray *arregloTitulos;

@property (nonatomic, strong) AlertView *alertaLista;

@property (nonatomic, strong) Contacto *contactoCelda;

@end

@implementation ListaTelefonosViewController

@synthesize arregloContactos;

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
//    [self.tituloVista setText:NSLocalizedString(@"contacto", @" ")];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecaverde.png"]];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecacreasitio.png"]];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"NBverde.png"];
	}
    self.arregloTitulos = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
    
//    [self.labelEditar setText:NSLocalizedString(@"pulsaContacto", Nil)];
    [self.labelEditar setText:NSLocalizedString(@"instrucciones", Nil)];
    
    [self mostrarBotones];
	
	if(existeItems){
		 self.datosUsuario = [DatosUsuario sharedInstance];
//		ItemsDominio * item = [self.datosUsuario.itemsDominio objectAtIndex:3];
		self.label.text = NSLocalizedString(@"mensajeContactos", @"");
	}else{
		//self.label.text = @"Puedes agregar hasta 10 formas de contacto";
	}
    self.labelTelefono.text = NSLocalizedString(@"mensajeContactoTelefono", Nil);
    self.labelEmail.text = NSLocalizedString(@"mensajeContactoMail", Nil);
    [self.labelAgregaDatos setText:NSLocalizedString(@"agregaDatos", Nil)];
    [self.labelBotonesGrandes setText:NSLocalizedString(@"datosBotonesGrandes", Nil)];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"NBverde.png"];
	}
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([self.datosUsuario.arregloContacto count] > 0) {
        arregloContactos = self.datosUsuario.arregloContacto;
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:self.indiceSeleccionado withObject:@YES];
        [self.labelEditar setHidden:NO];
        [self.btnInstrucciones setHidden:NO];
        [self.tablaContactos setHidden:NO];
        [self.vistaInfo setHidden:YES];
    }
    else {
        arregloContactos = [[NSMutableArray alloc] init];
        self.datosUsuario.arregloContacto = arregloContactos;
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:self.indiceSeleccionado withObject:@NO];
        
        [self.labelEditar setHidden:YES];
        [self.btnInstrucciones setHidden:YES];
        [self.tablaContactos setHidden:YES];
        [self.vistaInfo setHidden:NO];
        
        self.vistaInfo.layer.cornerRadius = 5.0f;
    }
    
    [self.tablaContactos reloadData];
	
//	if(existeItems){
		self.datosUsuario = [DatosUsuario sharedInstance];
		ItemsDominio * item = [self.datosUsuario.itemsDominio objectAtIndex:4];
		maxNumContactos = item.estatus;
//	}else{
//		maxNumContactos = 10;
//	}
	
	[self mostrarBotones];
}

-(void) mostrarBotones {
    
    if (self.editing) {
        self.navigationItem.rightBarButtonItems = Nil;
        UIImage *imageAceptar = [UIImage imageNamed:@"btnaceptar.png"];
        UIButton *btAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
        [btAceptar setFrame:CGRectMake(0, 0, imageAceptar.size.width, imageAceptar.size.height)];
        [btAceptar setImage:imageAceptar forState:UIControlStateNormal];
        [btAceptar addTarget:self action:@selector(editarTabla:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonAceptar = [[UIBarButtonItem alloc] initWithCustomView:btAceptar];
        self.navigationItem.rightBarButtonItem = botonAceptar;
    }
    else {
        self.navigationItem.rightBarButtonItem = Nil;
        UIImage *imageAdd = [UIImage imageNamed:@"btnagregar.png"];
        UIButton *btAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btAdd setFrame:CGRectMake(0, 0, imageAdd.size.width, imageAdd.size.height)];
        [btAdd setImage:imageAdd forState:UIControlStateNormal];
        [btAdd addTarget:self action:@selector(agregarContacto:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonAdd = [[UIBarButtonItem alloc] initWithCustomView:btAdd];
        UIImage *imagenEdit = [UIImage imageNamed:@"btnorganizar.png"];
        UIButton *btEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btEdit setFrame:CGRectMake(0, 0, imagenEdit.size.width, imagenEdit.size.height)];
        [btEdit setImage:imagenEdit forState:UIControlStateNormal];
        [btEdit addTarget:self action:@selector(editarTabla:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonEdit = [[UIBarButtonItem alloc] initWithCustomView:btEdit];
		
		if([self.datosUsuario.arregloContacto count]>1){
			self.navigationItem.rightBarButtonItems = @[botonEdit, botonAdd];
		}else{
			self.navigationItem.rightBarButtonItems = @[botonAdd];
		}
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)agregarContacto:(id)sender {
    
    if ([self.datosUsuario.arregloContacto count] < maxNumContactos) {
        TipoContactoViewController *tipoContacto = [[TipoContactoViewController alloc] initWithNibName:@"TipoContactoViewController" bundle:Nil];
        [self.navigationController pushViewController:tipoContacto animated:YES];
    }
	
    else {
		if([self.datosUsuario.arregloContacto count] == maxNumContactos && ((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion && ([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] || [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Tramite PRO"])){
			alertaContactos = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeContactosPro", nil) andAlertViewType:AlertViewTypeInfo];
			[alertaContactos show];
		}
		else if(!((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion){
			alertaContactos = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeContactosPrueba", Nil) andAlertViewType:AlertViewTypeQuestion];
			[alertaContactos show];
		}else{
			alertaContactos = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeContactosPrueba", Nil) andAlertViewType:AlertViewTypeQuestion];
			[alertaContactos show];
		}
    }
}

//- (void)regresar:(id)sender
//{
//	if ( modifico )
//	{
//		alertaContactos = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
//		[alertaContactos show];
//	} else
//		[self.navigationController popViewControllerAnimated:YES];
//}

-(void) accionSi
{
	[alertaContactos hide];
//	if ( modifico )
//	{
//		NSLog(@"Es loq ue quiero");
//		[self editarTabla:nil];
//		[self.navigationController popViewControllerAnimated:YES];
//	} else {
		CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
		[self.navigationController pushViewController:cuenta animated:YES];
//	}
}

-(void) accionNo{
//	if ( modifico )
//	{
//		[self.navigationController popViewControllerAnimated:YES];
//	}
	[alertaContactos hide];
}

-(IBAction)editarTabla:(UIBarButtonItem*)sender {
    if (self.editing) {
        [self.tablaContactos setEditing:NO animated:YES];
        [self setEditing:NO animated:YES];
        if (self.modifico && ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
            esReacomodo = YES;
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarContactos) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }
    }
    else {
        [self.tablaContactos setEditing:YES animated:YES];
        [self setEditing:YES animated:YES];
    }
    [self mostrarBotones];
}


#pragma mark - UITableViewDatasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arregloContactos count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifierContacto = @"ContactoCell";
    ContactosCell *cell = (ContactosCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierContacto];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactosCell" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
    }
    cell.vistaContenedora.layer.cornerRadius = 5.0f;
    Contacto *contacto = [arregloContactos objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell setContacto:contacto];
	if([[cell contacto].idPais isEqualToString:@"+52"]){
		//[cell contacto].noContacto = [[cell contacto].noContacto substringFromIndex:1];
	}
    NSDictionary *dict = [self.arregloTitulos objectAtIndex:contacto.indice];
//    [cell.imagenTipo setImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
    [cell.btnTipo setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"image"]] forState:UIControlStateNormal];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    Contacto *contacto = [self.arregloContactos objectAtIndex:fromIndexPath.row];
    [self.arregloContactos removeObject:contacto];
    [self.arregloContactos insertObject:contacto atIndex:toIndexPath.row];
    self.modifico = YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDelegate 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactoPaso2ViewController *contactoPaso2 = [[ContactoPaso2ViewController alloc] initWithNibName:@"ContactoPaso2ViewController" bundle:Nil];
    Contacto *contactoSeleccionado = [arregloContactos objectAtIndex:indexPath.row];
    [contactoPaso2 setContactoSeleccionado:contactoSeleccionado];
    [contactoPaso2 setIndexContacto:indexPath.row];
    [contactoPaso2 setContactosOperacion:ContactosOperacionEditar];
    [self.navigationController pushViewController:contactoPaso2 animated:YES];
    [self.tablaContactos deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ContactosCellDelegate

-(void)cell:(ContactosCell *)cell changeSwitchValue:(UISwitch *)aSwitch
{
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion)
    {
        esReacomodo = YES;
        self.contactoCelda = cell.contacto;
        if ([CommonUtils hayConexion])
        {
            if (aSwitch.on)
                cell.contacto.habilitado = YES;
            else
                cell.contacto.habilitado = NO;
            
            [cell setNeedsLayout];
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(actualizarContactos) withObject:Nil];
        }
        else {
            aSwitch.on = !aSwitch.on;
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
}

#pragma mark

-(void) accionAceptar {
}

-(void) mostrarActivity {
    self.alertaLista = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarContacto", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaLista show];
}

-(void) ocultarActivity {
    if (self.alertaLista)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaLista hide];
    }
    if (actualizoContactos) {
        if (esReacomodo) {
            AlertView *alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
            [alerta show];
        }
    }
    
}

-(void) actualizarContactos {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerContactos *contactos = [[WS_HandlerContactos alloc] init];
        [contactos setContactosDelegate:self];
        if (esReacomodo) {
            [contactos actualizarEstatusContacto];
        }
        else {
            [contactos actualizaConContacto:self.contactoCelda];
        }
    }
    else {
        if (self.alertaLista)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertaLista hide];
        }
        self.alertaLista = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertaLista show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
     //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito Contacto" withValue:@""];
        [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Contacto"];
        actualizoContactos = YES;
    }
    else {
        actualizoContactos = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertaLista)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaLista hide];
    }
    self.alertaLista = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertaLista show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) sessionTimeout
{
    if (self.alertaLista)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaLista hide];
    }
    self.alertaLista = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertaLista show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorContacto) withObject:Nil waitUntilDone:YES];
}

-(void) errorContacto {
    if (self.alertaLista)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaLista hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}

- (IBAction)muestraInstrucciones:(id)sender
{
    TextAndGraphAlertView *alert = [TextAndGraphAlertView initInstruccionesContacto];
    [alert show];
}
@end
