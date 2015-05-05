//
//  EliminarCuentaViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 25/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "EliminarCuentaViewController.h"
#import "WS_HandlerDominio.h"
#import "CambiarPasswordViewController.h"
#import "MainViewController.h"

@interface EliminarCuentaViewController () {
    BOOL selectOculto;
    id txtSeleccionado;
    BOOL esOtro;
    NSInteger valorSeleccionado;
    BOOL exito;
}

@property (nonatomic, strong) NSArray *opcionesCancelacion;
@property (nonatomic, strong) AlertView *alertEliminar;

@end

@implementation EliminarCuentaViewController

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
    
    self.vistaCombo.layer.cornerRadius = 5.0f;
    self.tablaOption.layer.cornerRadius = 5.0f;
    self.guardarVista = YES;
    
    self.opcionesCancelacion = @[NSLocalizedString(@"noGusto", Nil), NSLocalizedString(@"complicada", Nil), NSLocalizedString(@"noNecesito", Nil), NSLocalizedString(@"servicioCaro", Nil), NSLocalizedString(@"otro", Nil)];

	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"eliminar", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"eliminar", @" ") nombreImagen:@"NBlila.png"];
	}
    self.txtPassword.layer.cornerRadius = 5.0f;
    self.textEspecifica.layer.cornerRadius = 5.0f;
    selectOculto = YES;
    [self.scrollEliminarCuenta setContentSize:CGSizeMake(320, 260)];

	
	self.label.text = NSLocalizedString(@"eliminarLabel1", nil);
	self.labelPassword.text = NSLocalizedString(@"eliminarLabel2", nil);
	self.labelEspecifica.text = NSLocalizedString(@"eliminarLabel3", nil);
	self.label2.text = NSLocalizedString(@"eliminarLabel4", nil);
    
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        [self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"settingsEn.png"] forState:UIControlStateNormal];
    }else{
        [self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"miconfiguracionon.png"] forState:UIControlStateNormal];
    }
    
    if(IS_IPAD){
        [self.botonConfiguracion setFrame:CGRectMake(264, 10, 88, 80)];
        self.label.font = [UIFont fontWithName:@"Avenir-Book" size:20];
    }else{
        [self.botonConfiguracion setFrame:CGRectMake(192, 14, 64, 54)];
        self.label.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    }
    
    [self.olvidasteContrasena setTitle:NSLocalizedString(@"olvidasteContrasenaElimininarCuenta", nil) forState:UIControlStateNormal]  ;
}


-(void)viewWillAppear:(BOOL)animated{
    if(IS_IPAD){
        self.vistaCombo.frame = CGRectMake(84, 50, 600, 30);
        self.btnEligeOpcion.frame = CGRectMake(84, 56, 600, 30);
        [self.tablaOption setFrame:CGRectMake(84, 56, 600, 20)];
        self.imgSelecciona.frame = CGRectMake(550, 10, 18, 11);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.opcionesCancelacion count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellCombo"];
    [cell.textLabel setText:[self.opcionesCancelacion objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:colorFuenteVerde];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.labelOpcionSeleccionada setText:[self.opcionesCancelacion objectAtIndex:indexPath.row]];
    [self acomodaVista:indexPath.row];
    [self mostrarOption:Nil];
}

#pragma mark

- (IBAction)olvidasteContraseñaAct:(id)sender {
    CambiarPasswordViewController *cambiaPass = [[CambiarPasswordViewController alloc] initWithNibName:@"CambiarPasswordViewController" bundle:Nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cambiaPass];
    [self.navigationController presentViewController:navController animated:YES completion:Nil];
}

- (IBAction)mostrarOption:(UIButton *)sender {
    if (selectOculto) {
        [UIView animateWithDuration:0.5f animations:^{
            
            if(IS_IPAD){
                [self.tablaOption setFrame:CGRectMake(84, 80, 600, 220)];
            }else{
                [self.tablaOption setFrame:CGRectMake(20, 79, 280, 220)];
            }
            
            
        } completion:^(BOOL finished) {
            selectOculto = NO;
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            if(IS_IPAD){
                [self.tablaOption setFrame:CGRectMake(84, 56, 600, 20)];
            }else{
                [self.tablaOption setFrame:CGRectMake(20, 56, 280, 30)];
            }
            
            
            
        } completion:^(BOOL finished) {
            selectOculto = YES;
        }];
    }
}

-(void) acomodaVista:(NSInteger) opcionSeleccionada {
    valorSeleccionado = opcionSeleccionada;
    if (opcionSeleccionada == 4) {
        [self.labelEspecifica setHidden:NO];
        [self.labelPassword setHidden:NO];
        [self.olvidasteContrasena setHidden:NO];
        [self.txtPassword setHidden:NO];
        [self.textEspecifica setHidden:NO];
        
        [self.labelEspecifica setFrame:CGRectMake(20, 94, 280, 21)];
        [self.textEspecifica setFrame:CGRectMake(20, 123, 280, 65)];
        [self.olvidasteContrasena setFrame:CGRectMake(120, 153, 180, 50)];
        [self.labelPassword setFrame:CGRectMake(20, 196, 280, 21)];
        [self.txtPassword setFrame:CGRectMake(20, 225, 280, 30)];
        esOtro = YES;
    }
    else {
        [self.labelEspecifica setHidden:YES];
        [self.labelPassword setHidden:NO];
        [self.olvidasteContrasena setHidden:NO];
        [self.txtPassword setHidden:NO];
        [self.textEspecifica setHidden:YES];
        
        [self.labelPassword setFrame:CGRectMake(20, 94, 280, 21)];
        [self.txtPassword setFrame:CGRectMake(20, 123, 280, 30)];
        [self.olvidasteContrasena setFrame:CGRectMake(120, 153, 180, 50)];
        esOtro = NO;
    }
}

-(void) apareceTeclado {
    CGSize tamanioTeclado = CGSizeMake(320, 216);
    UIEdgeInsets edgeInsets;
    if (IS_IPHONE_5) {
        edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    }
    else {
        edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+30, 0);
    }
    
    [self.scrollEliminarCuenta setContentInset:edgeInsets];
    [self.scrollEliminarCuenta setScrollIndicatorInsets:edgeInsets];
    if ([txtSeleccionado isKindOfClass:[UITextField class]]) {
        [[self scrollEliminarCuenta] scrollRectToVisible:((UITextField *)txtSeleccionado).frame animated:YES];
    }
    else {
        [[self scrollEliminarCuenta] scrollRectToVisible:((UITextView *)txtSeleccionado).frame animated:YES];
    }
    
}

-(void) desapareceTeclado {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollEliminarCuenta] setContentInset:edgeInsets];
    [[self scrollEliminarCuenta] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    txtSeleccionado = textField;
    [self apareceTeclado];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [self desapareceTeclado];
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    txtSeleccionado = textView;
    [self apareceTeclado];
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    [self desapareceTeclado];
}

-(void) guardarInformacion:(id)sender {
    [self.view endEditing:YES];
	DatosUsuario * datos = [DatosUsuario sharedInstance];
	if([self.txtPassword.text isEqualToString:@""] || ![self.txtPassword.text isEqualToString:datos.passwordUsuario]){
		AlertView * alerta = [AlertView initWithDelegate:nil
												 message:NSLocalizedString(@"passwordIncorrcto", nil)
										andAlertViewType:AlertViewTypeInfo];
		[alerta show];
	}
    else if (![self.txtPassword.text isEqualToString:@""] && [self.txtPassword.text isEqualToString:datos.passwordUsuario] && [CommonUtils hayConexion]) {
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(eliminarCuenta) withObject:Nil];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    
}

-(void) mostrarActivity {
    self.alertEliminar = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertEliminar show];
}

-(void) ocultarActivity {
    if ( self.alertEliminar )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertEliminar hide];
    }
    if (exito) {
     
        MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
        [self.navigationController pushViewController:inicio animated:YES];
		self.alertEliminar = [AlertView initWithDelegate:self message:NSLocalizedString(@"cuentaEliminada", nil) andAlertViewType:AlertViewTypeInfo];
		[self.alertEliminar show];
		
		self.datosUsuario = [DatosUsuario sharedInstance];
		[StringUtils deleteResourcesWithExtension:@"jpg"];
		//[StringUtils deleteFile];
		[self.datosUsuario eliminarDatos];
		((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
	
    }
    else {
        [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"errorEliminar", Nil) andAlertViewType:AlertViewTypeInfo] show];
    }
}

-(void) eliminarCuenta {
   
        WS_HandlerDominio *handlerDominio = [[WS_HandlerDominio alloc] init];
        [handlerDominio setWSHandlerDelegate:self];
        NSString *motivo;
        if (valorSeleccionado == 4) {
            motivo = [self.textEspecifica text];
        }
        else {
            motivo = [self.opcionesCancelacion objectAtIndex:valorSeleccionado];
        }

        [handlerDominio cancelarCuenta:motivo];
   
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        exito = YES;
    }
    else {
        exito = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaWS {
    if ( self.alertEliminar )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertEliminar hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"errorEliminar", Nil) andAlertViewType:AlertViewTypeInfo] show];
}

-(void) errorToken {
    if ( self.alertEliminar )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertEliminar hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}



@end

