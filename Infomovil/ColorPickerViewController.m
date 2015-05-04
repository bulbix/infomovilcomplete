//
//  ColorPickerViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "WS_HandlerActualizarDominio.h"
#import "MainViewController.h"


@interface ColorPickerViewController () {
//    BOOL modifico;
    BOOL actualizo;
    UIColor *colorAux;
}

@property (nonatomic, strong) AlertView *alertActivity;

//@property (nonatomic, strong) DatosUsuario *datosUsuario;

@end

@implementation ColorPickerViewController

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
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloColorfondo", Nil) nombreImagen:@"barraturquesa.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloColorfondo", Nil) nombreImagen:@"NBturquesa.png"];
	}
    
    self.datosUsuario = [DatosUsuario sharedInstance];
    
    UIColor *c;
    if (self.datosUsuario.colorSeleccionado == Nil) {
        c=[UIColor colorWithRed:(arc4random()%100)/100.0f
                          green:(arc4random()%100)/100.0f
                           blue:(arc4random()%100)/100.0f
                          alpha:1.0];
    }
    else {
        c = self.datosUsuario.colorSeleccionado;
    }
    
    colorChip.backgroundColor=c;
    colorPicker.color=c;
    huePicker.color=c;
    
    self.navigationItem.hidesBackButton = YES;
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    self.viewContenido.layer.cornerRadius = 5;
    if (!IS_IPHONE_5) {
        [self.viewContenido setFrame:CGRectMake(self.viewContenido.frame.origin.x, self.viewContenido.frame.origin.y, self.viewContenido.frame.size.width, 289)];
        [colorChip setFrame:CGRectMake(14, 6, 220, 25)];
        [colorPicker setFrame:CGRectMake(14, 34, 220, 220)];
        [huePicker setFrame:CGRectMake(14, 257, 220, 26)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - ILSaturationBrightnessPickerDelegate implementation

-(void)colorPicked:(UIColor *)newColor forPicker:(ILSaturationBrightnessPickerView *)picker
{
    self.modifico = YES;
    colorChip.backgroundColor=newColor;
}

-(IBAction)guardarInformacion:(id)sender {
    colorAux = colorChip.backgroundColor;
        if ([CommonUtils hayConexion]) {
			self.datosUsuario.colorSeleccionado = colorChip.backgroundColor;
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(actualizar) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) accionSi {

    [self guardarInformacion:nil];
}
-(void) accionNo {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) accionAceptar {
    if (actualizo) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) mostrarActivity {
    self.alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarColor", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertActivity show];
}

-(void) ocultarActivity {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    if (actualizo) {
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.datosUsuario.colorSeleccionado = colorAux;
        //self.datosUsuario.eligioColor = YES;
        self.modifico = NO;
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    
}

-(void) actualizar {
  
        WS_HandlerActualizarDominio *actualizarDominio = [[WS_HandlerActualizarDominio alloc] init];
        [actualizarDominio setActualizarDominioDelegate:self];
        [actualizarDominio actualizarDominio:k_UPDATE_BACKGRUOUND];
   
    
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        actualizo = YES;
    }
    else {
        actualizo = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo] show];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
    
}

@end
