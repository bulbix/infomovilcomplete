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
    if(self.datosUsuario.nombreTemplate  == nil || [self.datosUsuario.nombreTemplate isEqualToString:@""] || [self.datosUsuario.nombreTemplate isEqualToString:@"(null)"])
    {
        self.datosUsuario.nombreTemplate = @"Estandar1";
    }
    NSLog(@"La plantilla seleccionada es: %@", self.datosUsuario.nombreTemplate);
    [self setupScrollView];
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 450, 320, 20)];
    [pgCtr setTag:5];
    pgCtr.numberOfPages=5;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
   // [self.view addSubview:pgCtr];
    
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
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.vistaInferior.hidden==NO){
        self.vistaInferior.hidden = YES;
    }

}

- (void)setupScrollView {
    nombrePlantilla = @[@"DIVERTIDO", @"CLÁSICO", @"CREATIVO",
                        @"MODERNO", @"ESTÁNDAR"];
    
    nombrePlantillaEn = @[@"FUNNY", @"CLASSIC", @"CREATIVE",
                         @"MODERN", @"STANDARD"];
    
    nombreWebServiceTemplate = @[@"Divertido", @"Clasico", @"Creativo",@"Moderno", @"Estandar1"];
    
    descripcionPlantilla = @[@"Estilo popular para Restaurantes, Pizzerias, Taquerías, Antros, Bares, etc.", @"Estilo popular para eventos formales, bodas, quinceaños, abogados, despachos, profesionistas, etc.", @"Estilo popular para creativos, músicos, estudiantes, fotógrafos, agencias, diseñadores, artistas,etc.",@"Estilo popular para empresas de tecnología, freelancers, distribuidoras de productos electrónicos, etc.", @"Estilo popular para todo tipo de productos y servicios."];
    
    descripcionPlantillaEn = @[@"Popular style for Restaurants, Pizzerias, Taquerías, Nightclubs, Bars, etc.", @"Popular style for formal events, weddings, quinceanera, lawyers, law firms, professionals, etc.", @"Popular style for creatives, musicians, students, photographers, agencies, designers, artists, etc.", @"Popular style for technology companies, freelancers, distributors of electronic products, etc.", @"Popular style for all kinds of products and services"];
    
    
    self.scrollTemplate.tag = 1;
    self.scrollTemplate.autoresizingMask=UIViewAutoresizingNone;
    
    
    for (int i=0; i<5; i++) {
       PlantillaViewController *pController = [[PlantillaViewController alloc] initWithNibName:@"Plantilla" bundle:[NSBundle mainBundle]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"template%i",i+1]];
        
        if(IS_STANDARD_IPHONE_6){
            pController.view.frame = CGRectMake(375*i, 0, 375, 480);
        }else if(IS_STANDARD_IPHONE_6_PLUS){
            pController.view.frame = CGRectMake(414*i, 0, 414, 480);
        }else if(IS_IPAD){
            pController.view.frame = CGRectMake(768*i, 0, 768, 480);
        }else{
            pController.view.frame = CGRectMake(320*i, 0, 320, 480);
        }
        
        
        
        [pController.imgTemplate setImage:image];
       
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            pController.nombrePlantilla.text = [nombrePlantillaEn objectAtIndex:i];
            pController.descripcionPlantilla.text = [descripcionPlantillaEn objectAtIndex:i];
            [pController.btnVerEjemploPlantilla setBackgroundImage:[UIImage imageNamed:@"verEjemplo-en.png"] forState:UIControlStateNormal];
        }else{
            pController.nombrePlantilla.text = [nombrePlantilla objectAtIndex:i];
            pController.descripcionPlantilla.text = [descripcionPlantilla objectAtIndex:i];
            [pController.btnVerEjemploPlantilla setBackgroundImage:[UIImage imageNamed:@"verEjemplo-es.png"] forState:UIControlStateNormal];
        }
        NSString *bullString =  [NSString stringWithFormat:@"slider%i",i+1];
        UIImage *imgBullet = [UIImage imageNamed:bullString];
        pController.imgBullets.image = imgBullet;
        
        pController.etiquetaEstatica.text = NSLocalizedString(@"etiquetaEstilo", nil);
        
        if([[nombreWebServiceTemplate objectAtIndex:i] isEqualToString:self.datosUsuario.nombreTemplate]){
            if(IS_IPAD){
            [pController.btnTemplateSeleccionado setImage:[UIImage imageNamed:@"tempOn-"] forState:UIControlStateNormal];
            }else{
                [pController.btnTemplateSeleccionado setImage:[UIImage imageNamed:@"tempOn.png"] forState:UIControlStateNormal];
            }
        }else{
            if(IS_IPAD){
            [pController.btnTemplateSeleccionado setImage:[UIImage imageNamed:@"tempOff-"] forState:UIControlStateNormal];
            }else{
            [pController.btnTemplateSeleccionado setImage:[UIImage imageNamed:@"tempOff.png"] forState:UIControlStateNormal];
            }
        }
        
        pController.btnVerEjemploPlantilla.tag = i;
        [pController.btnVerEjemploPlantilla addTarget:self
                                               action:@selector(irVerEjemplo:)
         forControlEvents:UIControlEventTouchUpInside];
        pController.btnTemplateSeleccionado.tag =  i;
        //[pController.btnTemplateSeleccionado addTarget:self action:@selector(estiloSeccionado:) forControlEvents:UIControlEventTouchUpInside];
        if(IS_IPHONE_5){
            pController.btnTemplateSeleccionado.frame = CGRectMake(20, 320, 36, 37);
            pController.etiquetaEstatica.frame = CGRectMake(20, 365, 52, 21);
            pController.nombrePlantilla.frame = CGRectMake(77, 365, 84, 21);
            pController.btnVerEjemploPlantilla.frame = CGRectMake(201, 361, 97, 25);
            pController.descripcionPlantilla.frame = CGRectMake(20, 386, 280, 67);
        }else if(IS_STANDARD_IPHONE_6){
            pController.btnTemplateSeleccionado.frame = CGRectMake(40, 320, 36, 37);
            pController.etiquetaEstatica.frame = CGRectMake(40, 365, 52, 21);
            pController.nombrePlantilla.frame = CGRectMake(90, 365, 84, 21);
            pController.btnVerEjemploPlantilla.frame = CGRectMake(231, 361, 97, 25);
            pController.descripcionPlantilla.frame = CGRectMake(40, 386, 280, 67);
            pController.imgTemplate.frame = CGRectMake(40, 0, 280, 315);
            pController.imgBullets.frame = CGRectMake(100, 480, 176, 13);
        }else if(IS_STANDARD_IPHONE_6_PLUS){
            pController.btnTemplateSeleccionado.frame = CGRectMake(70, 320, 36, 37);
            pController.etiquetaEstatica.frame = CGRectMake(70, 365, 52, 21);
            pController.nombrePlantilla.frame = CGRectMake(127, 365, 84, 21);
            pController.btnVerEjemploPlantilla.frame = CGRectMake(241, 361, 97, 25);
            pController.descripcionPlantilla.frame = CGRectMake(70, 386, 280, 67);
            pController.imgTemplate.frame = CGRectMake(70, 0, 300, 320);
            pController.imgBullets.frame = CGRectMake(122, 480, 176, 13);
        }else if(IS_IPAD){
            pController.btnTemplateSeleccionado.frame = CGRectMake(134, 590, 60, 60);
            pController.etiquetaEstatica.frame = CGRectMake(134, 650, 70, 40);
            [pController.etiquetaEstatica setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            pController.nombrePlantilla.frame = CGRectMake(200, 650, 120, 40);
            [pController.nombrePlantilla setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            pController.btnVerEjemploPlantilla.frame = CGRectMake(484, 645, 150, 40);
            pController.descripcionPlantilla.frame = CGRectMake(134, 690, 500, 67);
            [pController.descripcionPlantilla setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            pController.imgTemplate.frame = CGRectMake(134, 50, 500, 540);
            pController.imgBullets.frame = CGRectMake(296, 800, 176, 13);
        
        }
        
        
        
        [self.scrollTemplate addSubview:pController.view];
    }
   
    if(IS_STANDARD_IPHONE_6){
        self.scrollTemplate.frame = CGRectMake(0, 0, 375, 667);
    }else if(IS_STANDARD_IPHONE_6_PLUS){
        self.scrollTemplate.frame = CGRectMake(0, 30, 414, 736);
    }else if(IS_IPAD){
        self.scrollTemplate.frame = CGRectMake(0, 30, 768, 1024 );
    }
    
    
     [self.scrollTemplate setContentSize:CGSizeMake(self.scrollTemplate.frame.size.width*5, self.scrollTemplate.frame.size.height)];
  //  [NSTimer scheduledTimerWithTimeInterval:6000 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
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

-(IBAction)regresar:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}





-(void) resultadoConsultaDominio:(NSString *)resultado {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([resultado isEqualToString:@"Exito"]) {
        actualizo = YES;
        self.datosUsuario.eligioTemplate = YES;
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
