//
//  CambiarPasswordViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "CambiarPasswordViewController.h"
#import "CommonUtils.h"
#import "WS_HandlerCambiarPassword.h"

@interface CambiarPasswordViewController (){
	
	BOOL actualizoCorrecto;
	BOOL noExixte;
}

@property (nonatomic, strong) AlertView *alertaContacto;

@end

@implementation CambiarPasswordViewController

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

    [self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"miconfiguracionon.png"] forState:UIControlStateNormal];
    [self.botonConfiguracion setFrame:CGRectMake(240, 0, 80, 68)];
    self.txtEmail.layer.cornerRadius = 5.0f;

	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"cambioPassword", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"cambioPassword", @" ") nombreImagen:@"NBlila.png"];
	}
    if (!((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
        self.navigationItem.leftBarButtonItem = Nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"btncancelar.png"];
	
	self.guardarVista = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
	
	self.label.text = NSLocalizedString(@"cambiarLabel1", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)guardarInformacion:(id)sender {
    [self.view endEditing:YES];
    if ([CommonUtils validarEmail:self.txtEmail.text]) {
		if ([CommonUtils hayConexion]) {
			[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
			[self performSelectorInBackground:@selector(actualizarPassword) withObject:Nil];
		}
		else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
        /*[[AlertView initWithDelegate:self titulo:NSLocalizedString(@"cambioPassword2", Nil) message:NSLocalizedString(@"cambioPasswordMensaje", Nil) dominio:self.txtEmail.text andAlertViewType:AlertViewTypeInfo2] show];
		
		[self.navigationController popViewControllerAnimated:YES];*/
    }
    else {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"verificaEmail", Nil) andAlertViewType:AlertViewTypeInfo] show];
    }
    
}

-(void) mostrarActivity {
    self.alertaContacto = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaContacto show];
}
-(void) ocultarActivity {
    if (self.alertaContacto)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
	if(noExixte){
		AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"noExisteUsuario", Nil) andAlertViewType:AlertViewTypeInfo];
		[alert show];
	}
    else if (actualizoCorrecto) {
		AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"cambiarAlerta", Nil) andAlertViewType:AlertViewTypeInfo];
		[alert show];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    if (!((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    }
}
-(void) actualizarPassword {
//    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
//        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerCambiarPassword *handlerPass = [[WS_HandlerCambiarPassword alloc] init];
        [handlerPass setCambiarPasswordDelegate:self];
        [handlerPass actualizaPasswordConEmail:[self.txtEmail text]];
//    }
//    else {
//        [self.alertaContacto hide];
//        self.alertaContacto = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
//        [self.alertaContacto show];
//        [StringUtils terminarSession];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

-(void) resultadoPassword:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        actualizoCorrecto = YES;
    }
	else if([resultado isEqualToString:@"No existe usuario"]){
		noExixte = YES;
	}
    else {
        actualizoCorrecto = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorContacto) withObject:Nil waitUntilDone:YES];
}
//-(void) errorToken {
//    
//}

- (void)errorToken
{
    [self errorContacto];
}

-(void) sessionTimeout
{
    [self errorContacto];
}

-(void) errorContacto {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}

- (void)cancel:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

@end
