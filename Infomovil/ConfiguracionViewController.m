//
//  ConfiguracionViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 20/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "ConfiguracionViewController.h"
#import "InformacionRegistroViewController.h"
#import "EliminarCuentaViewController.h"
#import "CambiarPasswordViewController.h"
#import "MenuPasosViewController.h"
#import "WS_HandlerCambiarPassword.h"
#import "WS_HandlerDominio.h"
#import "FeedbackViewController.h"
#import "InicioViewController.h"

@interface ConfiguracionViewController () <WS_HandlerProtocol> {
	
	BOOL actualizoCorrecto;
}

@property (nonatomic, strong) NSArray *arregloConfiguracion;
@property (nonatomic, strong) AlertView *alertaContacto;

@end

@implementation ConfiguracionViewController

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

    self.guardarVista = YES;

    NSArray *arregloSecc1 = @[NSLocalizedString(@"cambiaPass", Nil), /*NSLocalizedString(@"eliminaCuenta", Nil),*/ NSLocalizedString(@"salirCuenta", Nil)];
    NSArray *arregloSecc2 = @[NSLocalizedString(@"soportaEmail", Nil), [NSString stringWithFormat:NSLocalizedString(@"version", Nil),[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]]];

    self.arregloConfiguracion = @[arregloSecc1, arregloSecc2];
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"configuracion", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"configuracion", @" ") nombreImagen:@"NBlila.png"];
	}
    
    self.tablaConfiguracion.layer.cornerRadius = 5.0f;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"settingsEn.png"] forState:UIControlStateNormal];
	}else{
		[self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"miconfiguracionon.png"] forState:UIControlStateNormal];
	}
    
   
    self.navigationItem.rightBarButtonItem = Nil;
	
	self.datosUsuario = [DatosUsuario sharedInstance];
	self.label.text = self.datosUsuario.emailUsuario;
	self.label.textColor = colorFuenteVerde;
	
    if(IS_IPAD){
        [self.botonConfiguracion setFrame:CGRectMake(264, 10, 88, 80)];
        self.label.font = [UIFont fontWithName:@"Avenir-Book" size:20];
    }else{
        [self.botonConfiguracion setFrame:CGRectMake(192, 14, 64, 54)];
        self.label.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    }
    
   
}

-(void)viewWillAppear:(BOOL)animated{
[self.vistaInferior setHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regresar:(id)sender {

	[self.navigationController popToViewController:((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView
										  animated:YES];
}

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.arregloConfiguracion objectAtIndex:section] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ([[self.arregloConfiguracion objectAtIndex:indexPath.section] count] == indexPath.row+1 && indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellValue1"];
        [cell.detailTextLabel setText:[[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [cell.detailTextLabel setTextColor:colorFuenteVerde];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellDefault"];
        [cell.textLabel setText:[[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [cell.textLabel setTextColor:colorFuenteAzul];
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
        if ([[self.arregloConfiguracion objectAtIndex:indexPath.section] count] != indexPath.row+1) {
            UIImageView *imagenAccesory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnsiguiente.png"]];
            [cell setAccessoryView:imagenAccesory];
        }
        
    }
    return cell;
}

#pragma mark - TableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    else {
        return 20;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
			AlertView * alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeContrasenia", @" ") andAlertViewType:AlertViewTypeInfo3];
			[alerta show];
			
            
        }
      /*  else if(indexPath.row == 1) {
            EliminarCuentaViewController *eliminarCuenta = [[EliminarCuentaViewController alloc] initWithNibName:@"EliminarCuentaViewController" bundle:Nil];
            [self.navigationController pushViewController:eliminarCuenta animated:YES];
        }
       */
        else if (indexPath.row == 1) {
            
            [[AlertView initWithDelegate:self message:NSLocalizedString(@"salirMensaje", nil)
						andAlertViewType:AlertViewTypeQuestion] show];
        }
    }
    else {
        if (indexPath.row == 0) {
			self.datosUsuario = [DatosUsuario sharedInstance];
			if ([MFMailComposeViewController canSendMail]){
				MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
				controller.mailComposeDelegate = self;
				[controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"emailAsunto", Nil),[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]]];
				[controller setToRecipients:@[@"info@infomovil.com"]];
				
				[self presentViewController:controller animated:YES completion:NULL];
			}else{
				AlertView * alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"configuracionCorreo", nil) andAlertViewType:AlertViewTypeInfo];
				[alert show];
			}
        }
    }
    
}

-(void)accionAceptar2{
	if ([CommonUtils hayConexion]) {
		[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
		[self performSelectorInBackground:@selector(actualizarPassword) withObject:Nil];
	}
	else {
		AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
		[alert show];
	}
}

-(void)accionCancelar{
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

-(void) accionSi {
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSString *correo = self.datosUsuario.emailUsuario;
    if ([self.datosUsuario.redSocial isEqualToString:@"Facebook"]) {
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) fbDidlogout];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        WS_HandlerDominio *handlerDominio = [[WS_HandlerDominio alloc] init];
        [handlerDominio setWSHandlerDelegate:self];
        [handlerDominio cerrarSession:correo];
    });
    
    ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
    
    
    InicioViewController *Inicio = [[InicioViewController alloc] initWithNibName:@"InicioViewController" bundle:Nil];
    [self.navigationController pushViewController:Inicio animated:YES];
}
-(void) actualizarPassword {
   
        WS_HandlerCambiarPassword *handlerPass = [[WS_HandlerCambiarPassword alloc] init];
        [handlerPass setCambiarPasswordDelegate:self];
	
        [handlerPass actualizaPassword];
     
}

-(void) mostrarActivity {
    self.alertaContacto = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaContacto show];
}
-(void) ocultarActivity {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    if (actualizoCorrecto) {
		
		AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"cambiarAlerta", Nil) andAlertViewType:AlertViewTypeInfo];
		[alert show];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }

}
-(void) resultadoConsultaDominio:(NSString *)resultado {
    
}


-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorContacto) withObject:Nil waitUntilDone:YES];
}

- (void)errorToken
{
        [self performSelectorOnMainThread:@selector(errorContacto) withObject:Nil waitUntilDone:YES];
}

-(void) errorContacto {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    InicioViewController *inicio = [[InicioViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}
-(void) resultadoPassword:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        actualizoCorrecto = YES;
    }
    else {
        actualizoCorrecto = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

@end
