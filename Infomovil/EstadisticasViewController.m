//
//  EstadisticasViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "EstadisticasViewController.h"
#import "AppDelegate.h"
#import "WS_HandlerVisitas.h"
#import "VisitasModel.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "CuentaViewController.h"
#import "UIView+LayerShot.h"
#import "PNChartDelegate.h"
#import "MenuPasosViewController.h"
#import "AppsFlyerTracker.h"



@interface EstadisticasViewController () <PNChartDelegate> {
    NSInteger opcionConsulta;
    NSInteger botonPulsado;
    BOOL exito;
    BOOL visitantesTotales;
    PNLineChart *chartLine;
    BOOL errorToken;
}

@property (nonatomic, strong) AlertView *alertActivity;

@end

@implementation EstadisticasViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.guardarVista = YES;
    
    //MBC
    if(IS_STANDARD_IPHONE_6_PLUS){
        [self.botonCambioEstadisticas setFrame:CGRectMake(20, 570, 280, 29)];
    }
    else if(IS_STANDARD_IPHONE_6){
         [self.botonCambioEstadisticas setFrame:CGRectMake(20, 500, 280, 29)];
    }else if(IS_IPHONE_5){
        [self.botonCambioEstadisticas setFrame:CGRectMake(20, 375, 280, 29)];
    }else{
        [self.botonCambioEstadisticas setFrame:CGRectMake(20, 320, 280, 29)];
    }
    

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Avenir-Book" size:12], NSFontAttributeName, nil];
    [self.botonCambioEstadisticas setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary
                                           dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.botonCambioEstadisticas setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    botonPulsado = 0;
    opcionConsulta = 2;
    if ([CommonUtils hayConexion]) {
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(consultaVisitas) withObject:Nil];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    errorToken = NO;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"reportes", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"reportes", @" ") nombreImagen:@"NBlila.png"];
	}
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    self.navigationItem.rightBarButtonItem = Nil;
    
	
	[self.botonCambioEstadisticas setTitle:NSLocalizedString(@"estadisticasLabel1", nil) forSegmentAtIndex:0];
	[self.botonCambioEstadisticas setTitle:NSLocalizedString(@"estadisticasLabel2", nil) forSegmentAtIndex:1];
	[self.botonCambioEstadisticas setTitle:NSLocalizedString(@"estadisticasLabel3", nil) forSegmentAtIndex:2];
	[self.botonCambioEstadisticas setTitle:NSLocalizedString(@"estadisticasLabel4", nil) forSegmentAtIndex:3];
	[self.botonCambioEstadisticas setTitle:NSLocalizedString(@"estadisticasLabel5", nil) forSegmentAtIndex:4];
    
    ////
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Reportes" withValue:@""];
    [self enviarEventoGAconCategoria:@"Consultar" yEtiqueta:@"Reportes"];
    
}

-(void) viewWillAppear:(BOOL)animated {

    [self.botonEstadisticas setFrame:CGRectMake(0, 14, 64, 54)];
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonEstadisticas setBackgroundImage:[UIImage imageNamed:@"reportsEn.png"] forState:UIControlStateNormal];
	}else{
		[self.botonEstadisticas setBackgroundImage:[UIImage imageNamed:@"mireporteson.png"] forState:UIControlStateNormal];
	}
	

	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonTotales setTitle:@"Total Visits" forSegmentAtIndex:0];
		[self.botonTotales setTitle:@"Unique visitors" forSegmentAtIndex:1];
	}
    else {
        [self.botonTotales setTitle:@"Visitas Totales" forSegmentAtIndex:0];
		[self.botonTotales setTitle:@"Visitantes Únicos" forSegmentAtIndex:1];
    }
	errorToken = NO;
//	[[AppsFlyerTracker sharedTracker] trackEvent:@"Consultar Reportes" withValue:@""];
    [self enviarEventoGAconCategoria:@"Consultar" yEtiqueta:@"Reportes"];
		
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

-(void) consultaVisitas {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime)
    {
        self.datosUsuario = [DatosUsuario sharedInstance];
        WS_HandlerVisitas *handlerVisitas = [[WS_HandlerVisitas alloc] init];
        [handlerVisitas setWSHandlerDelegate:self];
        [handlerVisitas consultaVisitasDominio:self.datosUsuario.dominio conOpcionConsulta:opcionConsulta];

    }
    else {
        if (self.alertActivity)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertActivity hide];
        }
        self.alertActivity = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertActivity show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (IBAction)cambiarEstadisticas:(UISegmentedControl *)sender {
    BOOL consultar = NO;
    switch (sender.selectedSegmentIndex) {
        case 0: //por semana
            opcionConsulta = 2;
            botonPulsado = 0;
            consultar = YES;
            break;
        case 1: //por mes
            opcionConsulta = 3;
            if ([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]) {
                consultar = YES;
            }
            else {
                consultar = NO;
            }
            
            break;
        case 2: //por 3 meses
            opcionConsulta = 4;
            if ([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]) {
                consultar = YES;
            }
            else {
                consultar = NO;
            }
            break;
        case 3: //por 6 meses
            opcionConsulta = 5;
            if ([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]) {
                consultar = YES;
            }
            else {
                consultar = NO;
            }
            break;
        case 4: // por año
            opcionConsulta = 6;
            botonPulsado = 4;
            consultar = YES;
            break;
        default:
            break;
    }
    if (consultar) {
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(consultaVisitas) withObject:Nil];

        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
    else {
        
        [[AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeNoPrueba", Nil) andAlertViewType:AlertViewTypeQuestion] show];
        [sender setSelectedSegmentIndex:botonPulsado];
        
    }
}

- (IBAction)cambiarVisitas:(UISegmentedControl *)sender {
    if (![((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] ) {
        if (sender.selectedSegmentIndex == 1) {
            [[AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeNoPrueba", Nil) andAlertViewType:AlertViewTypeQuestion] show];
        }
    }else if([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && [self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        if (sender.selectedSegmentIndex == 1) {
            [[AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeNoPrueba", Nil) andAlertViewType:AlertViewTypeQuestion] show];
        }
        
    }
    
    [sender setSelectedSegmentIndex:0];
}

-(void) accionSi {
    CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
    [cuenta setRegresarAnterior:YES];
    [self.navigationController pushViewController:cuenta animated:YES];
}
-(void) accionAceptar {
    if (errorToken) {
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) mostrarActivity {
    self.alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertActivity show];
}

-(void) ocultarActivity {
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSMutableArray *arregloVisitas = self.datosUsuario.arregloVisitas;
    NSMutableArray *arregloDatos = [[NSMutableArray alloc] init];
    NSMutableArray *arregloTitulos = [[NSMutableArray alloc] init];;
    VisitasModel *visitaActual;
    NSInteger numeroVisitantes = 0;
    VisitasModel *visitaTotales = [arregloVisitas lastObject];
    [arregloVisitas removeLastObject];
    if ([arregloVisitas count] > 0) {
        for (int i = [arregloVisitas count]-1; i >=0; i--) {
            visitaActual = [arregloVisitas objectAtIndex:i];
            [arregloDatos addObject:[NSString stringWithFormat:@"%i", visitaActual.visitas]];
            if (opcionConsulta == 6) {
                NSArray *arrayAux = [visitaActual.fecha componentsSeparatedByString:@"/"];
                [arregloTitulos addObject:[arrayAux objectAtIndex:0]];
            }
            else {
                [arregloTitulos addObject:visitaActual.fecha];
            }
            numeroVisitantes = numeroVisitantes + visitaActual.visitas;
            NSLog(@"El numero de visitas es %i", numeroVisitantes);
            
        }
        chartLine = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, self.vistaEstadisticas.frame.size.width, self.vistaEstadisticas.frame.size.height)];
        [chartLine setXLabels:arregloTitulos];
        chartLine.delegate = self;
        PNLineChartData *dataChart = [PNLineChartData new];
        dataChart.color = colorFuenteVerde;
        dataChart.itemCount = chartLine.xLabels.count;
        dataChart.getData = ^(NSUInteger index) {
            CGFloat yValue = [[arregloDatos objectAtIndex:index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        [chartLine setArregloValores:arregloDatos];
        
        chartLine.chartData = @[dataChart];
        [chartLine strokeChart];
        [self.vistaEstadisticas addSubview:chartLine];
        
        if ([self.datosUsuario.arregloVisitantes count] > 0) {
            UILabel *labelTexto = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
            [labelTexto setNumberOfLines:2];
            [labelTexto setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
			NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
			if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
				[labelTexto setText:[NSString stringWithFormat:@"Total Visits %i", numeroVisitantes]];
			}
            else {
                [labelTexto setText:[NSString stringWithFormat:@"Visitas Totales %i", numeroVisitantes]];
            }
            [labelTexto setTextAlignment:NSTextAlignmentCenter];
            UIImage *imagenAux = [labelTexto imageFromLayer];
            
            UILabel *labelTexto2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
            [labelTexto2 setNumberOfLines:2];
            [labelTexto2 setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
            
            if ([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]) {
                if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                    [labelTexto2 setText:[NSString stringWithFormat:@"Unique visitors %i", [visitaTotales visitas]]];
                }
                else {
                    [labelTexto2 setText:[NSString stringWithFormat:@"Visitantes Únicos %i", [visitaTotales visitas]]];
                }
            }
            else {
                if([language isEqualToString:@"es"]){
                    [labelTexto2 setText:@"Visitantes Únicos ?"];
                }else if([language isEqualToString:@"en"]){
                    [labelTexto2 setText:@"Unique visitors ?"];
                }
                else {
                    [labelTexto2 setText:@"Visitantes Únicos ?"];
                }
            }
			
            [labelTexto2 setTextAlignment:NSTextAlignmentCenter];
            UIImage *imageAux2 = [labelTexto2 imageFromLayer];
            
            [self.botonTotales setImage:imagenAux forSegmentAtIndex:0];
            [self.botonTotales setImage:imageAux2 forSegmentAtIndex:1];
        }
        else {
            
            UILabel *labelTexto = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
            [labelTexto setNumberOfLines:2];
            [labelTexto setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
			NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];

            if([language rangeOfString:@"es"].location != NSNotFound ){
				[labelTexto setText:[NSString stringWithFormat:@"Visitas Totales %i", numeroVisitantes]];
			}else if( [language rangeOfString:@"en"].location != NSNotFound ){
				[labelTexto setText:[NSString stringWithFormat:@"Total Visits %i", numeroVisitantes]];
			}
            else {
                [labelTexto setText:[NSString stringWithFormat:@"Visitas Totales %i", numeroVisitantes]];
            }
            
			[labelTexto setTextAlignment:NSTextAlignmentCenter];
            UIImage *imagenAux = [labelTexto imageFromLayer];
            UILabel *labelTexto2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
            [labelTexto2 setNumberOfLines:2];
            [labelTexto2 setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
            if ([((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]) {
                if([language rangeOfString:@"es"].location != NSNotFound ){
                    [labelTexto2 setText:[NSString stringWithFormat:@"Visitantes Únicos %i", [visitaTotales visitas]]];
                }else if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                    [labelTexto2 setText:[NSString stringWithFormat:@"Unique visitors %i", [visitaTotales visitas]]];
                }
                else {
                    [labelTexto2 setText:[NSString stringWithFormat:@"Visitantes Únicos %i", [visitaTotales visitas]]];
                }
            }
            else {
                if([language rangeOfString:@"es"].location != NSNotFound ){
                    [labelTexto2 setText:@"Visitantes Únicos ?"];
                }else if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                    [labelTexto2 setText:@"Unique visitors ?"];
                }
                else {
                    [labelTexto2 setText:@"Visitantes Únicos ?"];
                }
            }
            [labelTexto2 setTextAlignment:NSTextAlignmentCenter];
            UIImage *imageAux2 = [labelTexto2 imageFromLayer];
            [self.botonTotales setImage:imagenAux forSegmentAtIndex:0];
            [self.botonTotales setImage:imageAux2 forSegmentAtIndex:1];
        }
    }
}
-(void) errorActivity {
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    [AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo];
}

-(void) resultadoConsultaDominio:(NSString *)resultado {

        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];

    
}

-(void) errorConsultaWS {
    if (visitantesTotales) {
        visitantesTotales = NO;
        self.datosUsuario = [DatosUsuario sharedInstance];
        WS_HandlerVisitas *handlerVisitas = [[WS_HandlerVisitas alloc] init];
        [handlerVisitas setWSHandlerDelegate:self];
        [handlerVisitas consultaVisitasDominio:self.datosUsuario.dominio conOpcionConsulta:opcionConsulta];
    }
    else {
        [self performSelectorOnMainThread:@selector(errorActivity) withObject:Nil waitUntilDone:YES];
    }
    
}

#pragma - mark PNChartDelegate
-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
#ifdef _DEBUG
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
#endif
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
#ifdef _DEBUG
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
#endif
}

-(void) errorToken {
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    errorToken = YES;
    self.alertActivity = [AlertView initWithDelegate:nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertActivity show];

    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sessionTimeout
{
    if (self.alertActivity)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    self.alertActivity = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertActivity show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end