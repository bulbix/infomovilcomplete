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
#import "MainViewController.h"

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
    if(IS_IPAD){
        [self.botonConfiguracion setFrame:CGRectMake(264, 10, 88, 80)];
    }else{
        [self.botonConfiguracion setFrame:CGRectMake(240, 0, 80, 68)];
    }
    self.txtEmail.layer.cornerRadius = 5.0f;

    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"cambioPassword", @" ") nombreImagen:@"barramorada.png"];
	
  
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"btncancelar.png"] ofType:nil]]];
	
	self.guardarVista = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
	
	self.label.text = NSLocalizedString(@"cambiarLabel1", nil);
    [self.vistaInferior setHidden:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    if(IS_IPAD){
        self.label.frame = CGRectMake(84, 150, 600, 80);
        [self.label setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
        self.txtEmail.frame = CGRectMake(84, 250, 600, 40);
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        self.label.frame = CGRectMake(47, 60, 280, 80);
        self.txtEmail.frame = CGRectMake(47, 160, 280, 40);
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.txtEmail becomeFirstResponder];
    
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
            [[Appboy sharedInstance] changeUser:self.txtEmail.text];
			[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
			[self performSelectorInBackground:@selector(actualizarPassword) withObject:Nil];
		}
		else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
    
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
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"cambiarAlerta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
 
}
-(void) actualizarPassword {

        WS_HandlerCambiarPassword *handlerPass = [[WS_HandlerCambiarPassword alloc] init];
        [handlerPass setCambiarPasswordDelegate:self];
        [handlerPass actualizaPasswordConEmail:[self.txtEmail text]];

}

-(void) resultadoPassword:(NSString *)resultado {
    if ([resultado isEqualToString:@"-1"]) {
        actualizoCorrecto = NO;
    }
    else if([resultado isEqualToString:@"-2"]){
        actualizoCorrecto = NO;
    }else{
        actualizoCorrecto = YES;
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"hashCambioPassword" andStringValue:resultado];
        [[Appboy sharedInstance] logCustomEvent:@"ChangePassword"];
        
        
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorContacto) withObject:Nil waitUntilDone:YES];
}


- (void)errorToken
{
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
 
    AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"cambiarAlerta", Nil) andAlertViewType:AlertViewTypeInfo];
    [alert show];
   
}

-(void) errorContacto {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"    ", Nil) andAlertViewType:AlertViewTypeInfo] show];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

- (void)cancel:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

@end
