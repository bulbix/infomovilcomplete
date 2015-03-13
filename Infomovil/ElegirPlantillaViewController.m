//
//  ElegirPlantillaViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/11/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "ElegirPlantillaViewController.h"
#import "PlantillaViewController.h"
#import "VerEjemploPlantillaViewController.h"
#import "WS_HandlerActualizarDominio.h"

@interface ElegirPlantillaViewController (){
BOOL actualizo;
}

@property (nonatomic, strong) AlertView *alertActivity;

@end

@implementation ElegirPlantillaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.plantillaAPublicar = 0;
    [self.scrollTemplate setShowsHorizontalScrollIndicator:NO];
    [self.scrollTemplate setShowsVerticalScrollIndicator:NO];
    [self.scrollTemplate setPagingEnabled:YES];
    self.scrollTemplate.delegate = self;
    
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSLog(@"La plantilla seleccionada es: %@", self.datosUsuario.nombreTemplate);
    [self setupScrollView];
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 450, 320, 20)];
    [pgCtr setTag:5];
    pgCtr.numberOfPages=5;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:pgCtr];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"elegirEstilo", nil) nombreImagen:@"barraturquesa.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"elegirEstilo", nil) nombreImagen:@"NBturquesa.png"];
    }
    
    self.navigationItem.rightBarButtonItems = Nil;
    UIImage *imageAceptar = [UIImage imageNamed:@"btnaceptar.png"];
    UIButton *btAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
    [btAceptar setFrame:CGRectMake(0, 0, imageAceptar.size.width, imageAceptar.size.height)];
    [btAceptar setImage:imageAceptar forState:UIControlStateNormal];
    [btAceptar addTarget:self action:@selector(guardarTemplate:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *botonAceptar = [[UIBarButtonItem alloc] initWithCustomView:btAceptar];
    self.navigationItem.rightBarButtonItem = botonAceptar;
    
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.vistaInferior.hidden==NO){
        self.vistaInferior.hidden = YES;
    }

}

- (void)setupScrollView {
    nombrePlantilla = @[@"Estilo Divertido", @"Estilo Clásico", @"Estilo Creativo",
                        @"Estilo Moderno", @"Estilo Estándar"];
    
    nombreWebServiceTemplate = @[@"Divertido", @"Clasico", @"Creativo",@"Moderno", @"Estandar1"];
    
    descripcionPlantilla = @[@"Estilo popular para Restaurantes, Pizzerias, Taquerías, Antros, Bares, etc.", @"Estilo popular para eventos formales, bodas, quinceaños, abogados, despachos, profesionistas, etc.", @"Estilo popular para creativos, músicos, estudiantes, fotógrafos, agencias, diseñadores, artistas,etc.",@"Estilo popular para empresas de tecnología, freelancers, distribuidoras de productos electrónicos, etc.", @"Estilo popular para todo tipo de productos y servicios."];
    self.scrollTemplate.tag = 1;
    self.scrollTemplate.autoresizingMask=UIViewAutoresizingNone;
    
    
    for (int i=0; i<5; i++) {
       PlantillaViewController *pController = [[PlantillaViewController alloc] initWithNibName:@"Plantilla" bundle:[NSBundle mainBundle]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"t%i.png",i+1]];
        pController.view.frame = CGRectMake(320*i, 0, 320, 420);
        [pController.imgTemplate setImage:image];
        pController.nombrePlantilla.text = [nombrePlantilla objectAtIndex:i];
       
        if([[nombreWebServiceTemplate objectAtIndex:i] isEqualToString:self.datosUsuario.nombreTemplate]){
            [pController.btnTemplateSeleccionado setImage:[UIImage imageNamed:@"recordarOn"] forState:UIControlStateNormal];
        }else{
            [pController.btnTemplateSeleccionado setImage:[UIImage imageNamed:@"recordarOff"] forState:UIControlStateNormal];
        }
        
        pController.descripcionPlantilla.text = [descripcionPlantilla objectAtIndex:i];
        pController.btnVerEjemploPlantilla.tag = i;
        [pController.btnVerEjemploPlantilla addTarget:self
                                               action:@selector(irVerEjemplo:)
         forControlEvents:UIControlEventTouchUpInside];
        pController.btnTemplateSeleccionado.tag =  i;
        [pController.btnTemplateSeleccionado addTarget:self action:@selector(estiloSeccionado:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollTemplate addSubview:pController.view];
    }
   
     [self.scrollTemplate setContentSize:CGSizeMake(self.scrollTemplate.frame.size.width*5, self.scrollTemplate.frame.size.height)];
    [NSTimer scheduledTimerWithTimeInterval:6000 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

-(void)irVerEjemplo:(UIButton*)sender{
      //  NSLog(@"El tag del boton es: %i",sender.tag );
    
    switch (sender.tag) {
        case 0:{
                VerEjemploPlantillaViewController *verEjemplo = [[VerEjemploPlantillaViewController alloc]  initWithNibName:@"VerEjemploPlantillaViewController" bundle:Nil];
                [verEjemplo setIndex:0];
                [self.navigationController pushViewController:verEjemplo animated:YES];
            }
            break;
        case 1:{
                VerEjemploPlantillaViewController *verEjemplo = [[VerEjemploPlantillaViewController alloc]  initWithNibName:@"VerEjemploPlantillaViewController" bundle:Nil];
                [verEjemplo setIndex:1];
                [self.navigationController pushViewController:verEjemplo animated:YES];
            }
            break;
        case 2: {
                VerEjemploPlantillaViewController *verEjemplo = [[VerEjemploPlantillaViewController alloc]  initWithNibName:@"VerEjemploPlantillaViewController" bundle:Nil];
                [verEjemplo setIndex:2];
                [self.navigationController pushViewController:verEjemplo animated:YES];
            }
            break;
        case 3: {
                VerEjemploPlantillaViewController *verEjemplo = [[VerEjemploPlantillaViewController alloc]  initWithNibName:@"VerEjemploPlantillaViewController" bundle:Nil];
                [verEjemplo setIndex:3];
                [self.navigationController pushViewController:verEjemplo animated:YES];
            }
            break;
        case 4: {
                VerEjemploPlantillaViewController *verEjemplo = [[VerEjemploPlantillaViewController alloc]  initWithNibName:@"VerEjemploPlantillaViewController" bundle:Nil];
                [verEjemplo setIndex:4];
                [self.navigationController pushViewController:verEjemplo animated:YES];
            }
            break;
            
        default:
            break;
    }
}

-(void)estiloSeccionado:(UIButton*)sender{
 
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
    static NSInteger previousPage = 1;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != 6) {
        self.plantillaAPublicar = page;
        previousPage = page;
    }
    
}


-(void)guardarTemplate:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    switch (self.plantillaAPublicar) {
        case 0:{
            self.datosUsuario.nombreTemplate = @"Divertido";
        }
            break;
        case 1:{
            self.datosUsuario.nombreTemplate = @"Clasico";
        }
            break;
        case 2:{
            self.datosUsuario.nombreTemplate = @"Creativo";
        }
            break;
        case 3:{
            self.datosUsuario.nombreTemplate = @"Moderno";
        }
            break;
        case 4:{
            self.datosUsuario.nombreTemplate = @"Estandar1";
        }
            break;
        default:
            break;
    }
   
        
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
        if ([CommonUtils hayConexion]) {
       
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(actualizar) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
    else {
  
        self.modifico = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) mostrarActivity {
    self.alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarImagen", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertActivity show];
    
}

-(void) ocultarActivity {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    if (actualizo) {
        self.alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertActivity show];
    }
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
    
    [[AlertView initWithDelegate:Nil message:@"No se ha publicado, inténtalo nuevamente" andAlertViewType:AlertViewTypeInfo] show];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
    self.alertActivity = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertActivity show];
    [StringUtils terminarSession];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void) sessionTimeout
{
    if ( self.alertActivity )
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


-(void) actualizar {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerActualizarDominio *actualizarDominio = [[WS_HandlerActualizarDominio alloc] init];
        [actualizarDominio setActualizarDominioDelegate:self];
        [actualizarDominio actualizarDominio:k_UPDATE_TEMPLATE ];
    }
    else {
        if ( self.alertActivity )
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












@end
