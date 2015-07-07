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
#import "MenuPasosViewController.h"
#import "MainViewController.h"

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
   
    [self setupScrollView];
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 450, 320, 20)];
    [pgCtr setTag:6];
    pgCtr.numberOfPages=6;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    
    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"elegirEstilo", nil) nombreImagen:@"barraturquesa.png"];
    
    self.navigationItem.rightBarButtonItems = Nil;
    self.navigationItem.rightBarButtonItem = self.btnAceptar;
    
    UIImage *image = defRegresar;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.vistaInferior.hidden==NO){
        self.vistaInferior.hidden = YES;
    }
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

- (void)setupScrollView {
    self.nombrePlantilla = @[@"DIVERTIDO", @"CLÁSICO", @"CREATIVO",
                        @"MODERNO", @"ESTÁNDAR"];
    
    self.nombrePlantillaEn = @[@"FUN", @"CLASSIC", @"CREATIVE",
                         @"MODERN", @"STANDARD"];
    
    self.nombreWebServiceTemplate = @[@"Divertido", @"Clasico", @"Creativo",@"Moderno", @"Estandar1"];
    
    self.descripcionPlantilla = @[@"Estilo popular para Restaurantes, Pizzerías, Taquerías, Antros, Bares, etc.", @"Estilo popular para eventos formales, bodas, quinceaños, abogados, despachos, profesionistas, etc.", @"Estilo popular para creativos, músicos, estudiantes, fotógrafos, agencias, diseñadores, artistas,etc.",@"Estilo popular para empresas de tecnología, freelancers, distribuidoras de productos electrónicos, etc.", @"Estilo popular para todo tipo de productos y servicios."];
    
    self.descripcionPlantillaEn = @[@"Popular style for Restaurants, Pizzerías, Taquerías, Nightclubs, Bars.", @"Popular style for formal events, weddings, professionals.", @"Popular style for creatives, musicians, students, photographers, agencies, designers, artists.", @"Popular style for technology companies, freelancers, distributors of electronic products.", @"Popular style for general products and services."];
    
    
    self.scrollTemplate.tag = 1;
    self.scrollTemplate.autoresizingMask=UIViewAutoresizingNone;
    
    
    for (int i=0; i<5; i++) {
       PlantillaViewController *pController = [[PlantillaViewController alloc] initWithNibName:@"Plantilla" bundle:[NSBundle mainBundle]];
        UIImage *image;
        
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
           image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"template%i@3x.png", i+1] ofType:nil]]];
            pController.view.frame = CGRectMake(375*i, 40, 375, 667);
       }else if(IS_IPAD){
            pController.view.frame = CGRectMake(768*i, 0, 768, 1024);
           image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"template%i@3x.png", i+1] ofType:nil]]];
        }else if(IS_IPHONE_5){
            image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"template%i@3x.png", i+1] ofType:nil]]];
            pController.view.frame = CGRectMake(320*i, 10, 320, 480);
        }else{
            image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"template%i@3x.png", i+1] ofType:nil]]];
            pController.view.frame = CGRectMake(320*i, 0, 320, 480);
        }
        
        
        
        [pController.imgTemplate setImage:image];
       
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            pController.nombrePlantilla.text = [self.nombrePlantillaEn objectAtIndex:i];
            pController.descripcionPlantilla.text = [self.descripcionPlantillaEn objectAtIndex:i];
            if(IS_IPAD){
            [pController.btnVerEjemploPlantilla setBackgroundImage:[UIImage imageNamed:@"verEjemplo-en@3x.png"] forState:UIControlStateNormal];
            }else{
            [pController.btnVerEjemploPlantilla setBackgroundImage:[UIImage imageNamed:@"verEjemplo-en.png"] forState:UIControlStateNormal];
            }
            
        }else{
            pController.nombrePlantilla.text = [self.nombrePlantilla objectAtIndex:i];
            pController.descripcionPlantilla.text = [self.descripcionPlantilla objectAtIndex:i];
            if(IS_IPAD){
            [pController.btnVerEjemploPlantilla setBackgroundImage:[UIImage imageNamed:@"verEjemplo-es@3x.png"] forState:UIControlStateNormal];
            }else{
            [pController.btnVerEjemploPlantilla setBackgroundImage:[UIImage imageNamed:@"verEjemplo-es.png"] forState:UIControlStateNormal];
            }
        }
        NSString *bullString =  [NSString stringWithFormat:@"slider%i",i+1];
        UIImage *imgBullet = [UIImage imageNamed:bullString];
        pController.imgBullets.image = imgBullet;
        
        pController.etiquetaEstatica.text = NSLocalizedString(@"etiquetaEstilo", nil);
        
        if([[self.nombreWebServiceTemplate objectAtIndex:i] isEqualToString:self.datosUsuario.nombreTemplate]){
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
        
       
        if(IS_IPHONE_5){
            pController.btnTemplateSeleccionado.frame = CGRectMake(20, 320, 36, 37);
            pController.etiquetaEstatica.frame = CGRectMake(20, 365, 52, 21);
            pController.nombrePlantilla.frame = CGRectMake(77, 365, 84, 21);
            pController.btnVerEjemploPlantilla.frame = CGRectMake(201, 361, 97, 25);
            pController.descripcionPlantilla.frame = CGRectMake(20, 386, 280, 67);
        }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            pController.btnTemplateSeleccionado.frame = CGRectMake(40, 320, 36, 37);
            pController.etiquetaEstatica.frame = CGRectMake(40, 365, 52, 21);
            pController.nombrePlantilla.frame = CGRectMake(90, 365, 84, 21);
            pController.btnVerEjemploPlantilla.frame = CGRectMake(231, 361, 97, 25);
            pController.descripcionPlantilla.frame = CGRectMake(40, 386, 280, 67);
            pController.imgTemplate.frame = CGRectMake(25, 0, 315, 315);
            pController.imgBullets.frame = CGRectMake(100, 480, 176, 13);
     
        }else if(IS_IPAD){
            pController.btnTemplateSeleccionado.frame = CGRectMake(134, 590, 60, 60);
            pController.etiquetaEstatica.frame = CGRectMake(134, 650, 70, 40);
            [pController.etiquetaEstatica setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                pController.nombrePlantilla.frame = CGRectMake(200, 650, 120, 40);
            }else{
                pController.nombrePlantilla.frame = CGRectMake(210, 650, 120, 40);
            }
            
            [pController.nombrePlantilla setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            pController.btnVerEjemploPlantilla.frame = CGRectMake(484, 645, 150, 40);
            pController.descripcionPlantilla.frame = CGRectMake(134, 690, 500, 67);
            [pController.descripcionPlantilla setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            pController.imgTemplate.frame = CGRectMake(100, 50, 580, 540);
            pController.imgBullets.frame = CGRectMake(296, 800, 176, 13);
        
        }
        
        pController.btnVerEjemploPlantilla.tag = i;
        [pController.btnVerEjemploPlantilla addTarget:self
                                               action:@selector(irVerEjemplo:)
                                     forControlEvents:UIControlEventTouchUpInside];
        pController.btnTemplateSeleccionado.tag =  i;
        
        [self.scrollTemplate addSubview:pController.view];
    }
   
    
    self.labelDelViewExtra2.text = NSLocalizedString(@"templateCreativosDesc",Nil);
    
    if(IS_IPAD){
            [self.imgVerMasAzul setFrame:CGRectMake(84, 40, 600, 600)];
            self.labelDelViewExtra1.frame = CGRectMake(100,680,600,20);
            [self.labelDelViewExtra1 setFont:[UIFont fontWithName:@"Avenir-Medium" size:20]];
            self.labelDelViewExtra2.frame = CGRectMake(100, 690, 600, 200 );
            [self.labelDelViewExtra2 setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            [self.viewExtra setFrame: CGRectMake(768*5, 00, 768, 1024)];
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            [self.imgVerMasAzul setFrame:CGRectMake(28, 0, 320, 338)];
            self.labelDelViewExtra1.frame = CGRectMake(30,350,315,35);
            self.labelDelViewExtra2.frame = CGRectMake(30, 385, 315, 115 );
            [self.viewExtra setFrame: CGRectMake(375*5, 40, 375, 480)];
    }else if(IS_IPHONE_4){
        [self.imgVerMasAzul setFrame:CGRectMake(10, 0, 300, 300)];
        self.labelDelViewExtra1.frame = CGRectMake(30,300,315,20);
        self.labelDelViewExtra2.frame = CGRectMake(30, 310, 315, 115 );
        [self.labelDelViewExtra1 setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        [self.labelDelViewExtra2 setFont:[UIFont fontWithName:@"Avenir-Book" size:13]];
            [self.viewExtra setFrame: CGRectMake(320*5, 0, 320, 420)];
    }else {
            [self.viewExtra setFrame: CGRectMake(320*5, 10, 320, 420)];
    }
    
    [self.scrollTemplate addSubview:self.viewExtra];
    
    if(IS_IPAD){
        [self.imgVerMasTemplates setFrame:CGRectMake(84, 40, 600, 600)];
        [self.verMasTemplates setFrame:CGRectMake(234, 700, 300, 40)];
        [self.viewVerMas setFrame: CGRectMake(768*6, 40, 768, 1024)];
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.imgVerMasTemplates setFrame:CGRectMake(28, 0, 320, 338)];
        [self.verMasTemplates setFrame:CGRectMake(87, 430, 200, 35)];
        [self.viewVerMas setFrame: CGRectMake(375*6, 50, 375, 480)];
    }else if(IS_IPHONE_4){
         [self.imgVerMasTemplates setFrame:CGRectMake(10, 5, 300,300 )];
        [self.verMasTemplates setFrame:CGRectMake(60, 360, 200, 35)];
        [self.viewVerMas setFrame: CGRectMake(320*6, 5, 320, 420)];
    }else {
        [self.imgVerMasTemplates setFrame:CGRectMake(10, 50, 300,270 )];
        [self.verMasTemplates setFrame:CGRectMake(60, 350, 200, 50)];
        [self.viewVerMas setFrame: CGRectMake(320*6, 15, 320, 457)];
    }
    
    [self.scrollTemplate addSubview:self.viewVerMas];
    
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        self.scrollTemplate.frame = CGRectMake(0, 0, 375, 667);
    }else if(IS_IPAD){
        self.scrollTemplate.frame = CGRectMake(0, 0, 768, 1024 );
    }
    
    
     [self.scrollTemplate setContentSize:CGSizeMake(self.scrollTemplate.frame.size.width*7, self.scrollTemplate.frame.size.height)];

}

-(void)irVerEjemplo:(UIButton*)sender{
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
    if(page == 6 || page == 5){
        self.navigationItem.rightBarButtonItem = nil ;
    }else{
        self.navigationItem.rightBarButtonItem = self.btnAceptar;
    }
    if (previousPage != 6) {
        self.plantillaAPublicar = page;
        previousPage = page;
    }
    
}

-(IBAction)regresar:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}


-(void) mostrarActivity {
    self.alertActivity = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarTemplate", Nil) andAlertViewType:AlertViewTypeActivity];
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

        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
        [self.navigationController pushViewController:menuPasos animated:YES];
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
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
   // [StringUtils terminarSession];
  //  MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
  //  [self.navigationController pushViewController:inicio animated:YES];
    
}



-(void) actualizar {
        WS_HandlerActualizarDominio *actualizarDominio = [[WS_HandlerActualizarDominio alloc] init];
        [actualizarDominio setActualizarDominioDelegate:self];
        [actualizarDominio actualizarDominio:k_UPDATE_TEMPLATE ];
   
}


- (IBAction)verMasTemplatesAct:(id)sender {
    VerEjemploPlantillaViewController *verEjemplo = [[VerEjemploPlantillaViewController alloc]  initWithNibName:@"VerEjemploPlantillaViewController" bundle:Nil];
    [verEjemplo setIndex:5];
    [self.navigationController pushViewController:verEjemplo animated:YES];
    
}
- (IBAction)btnAceptarAct:(id)sender {
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
    
    
    
    if ([CommonUtils hayConexion]) {
        
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(actualizar) withObject:Nil];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}
@end
