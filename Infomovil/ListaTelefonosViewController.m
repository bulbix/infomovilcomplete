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
#import "AppsFlyerTracker.h"
#import "AppDelegate.h"

@interface ListaTelefonosViewController () <ContactosCellDelegate> {
    BOOL actualizoContactos;

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

	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"contacto", @" ") nombreImagen:@"NBverde.png"];
	}
    self.arregloTitulos = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];

    [self.labelEditar setText:NSLocalizedString(@"instrucciones", Nil)];
    
    [self mostrarBotones];
	
	if(existeItems){
		 self.datosUsuario = [DatosUsuario sharedInstance];
         self.label.text = NSLocalizedString(@"mensajeContactos", @"");
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
	

		self.datosUsuario = [DatosUsuario sharedInstance];
		ItemsDominio * item = [self.datosUsuario.itemsDominio objectAtIndex:4];
		maxNumContactos = item.estatus;

	
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
    NSLog(@"El numero maximo de contactos es: %i", maxNumContactos);
  
    if (!((AppDelegate*)[[UIApplication sharedApplication] delegate]).existeSesion){
             AlertView *alert = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
             [alert show];
             [StringUtils terminarSession];
             [self.navigationController popToRootViewControllerAnimated:YES];
    }else if([self.datosUsuario.arregloContacto count] < 2) {
            TipoContactoViewController *tipoContacto = [[TipoContactoViewController alloc] initWithNibName:@"TipoContactoViewController" bundle:Nil];
            [self.navigationController pushViewController:tipoContacto animated:YES];
    }else if([self.datosUsuario.arregloContacto count] >= 2 && [self.datosUsuario.arregloContacto count] < 10 && [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        TipoContactoViewController *tipoContacto = [[TipoContactoViewController alloc] initWithNibName:@"TipoContactoViewController" bundle:Nil];
        [self.navigationController pushViewController:tipoContacto animated:YES];
    
     }else if([self.datosUsuario.arregloContacto count] >= 2 && [self.datosUsuario.arregloContacto count] < 10 && [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && [self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
         alertaContactos = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeContactosPrueba", Nil) andAlertViewType:AlertViewTypeQuestion];
         [alertaContactos show];
    
     }else if([self.datosUsuario.arregloContacto count] == 2 && ![((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"]){
         alertaContactos = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeContactosPrueba", Nil) andAlertViewType:AlertViewTypeQuestion];
         [alertaContactos show];
     
     }else if([self.datosUsuario.arregloContacto count] >= 10){
         NSLog(@"Si entro pero no mostro la alarma!");
         alertaContactos = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeContactosPro", nil) andAlertViewType:AlertViewTypeInfo];
         [alertaContactos show];
     
     }
}



-(void) accionSi
{
        [alertaContactos hide];
		CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
		[self.navigationController pushViewController:cuenta animated:YES];

}

-(void) accionNo{

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
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setInteger:0 forKey:@"ActualizandoEstatus1SolaVez"];
                [prefs synchronize];
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
	
    NSDictionary *dict = [self.arregloTitulos objectAtIndex:contacto.indice];

    [cell.btnTipo setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"image"]] forState:UIControlStateNormal];
    
    
    if( [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && [self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"] && indexPath.row > 2){
        cell.opacarContacto.hidden = NO;
    }else{
        cell.opacarContacto.hidden = YES;
    }
    
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
    NSLog(@"Cuantas veces entras aki!!!!");
    
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
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setInteger:0 forKey:@"ActualizandoEstatus1SolaVez"];
            [prefs synchronize];
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"ActualizandoEstatus1SolaVez"];
    [prefs synchronize];
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
