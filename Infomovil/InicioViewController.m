//
//  InicioViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 22/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InicioViewController.h"
#import "MainViewController.h"
#import "MenuPasosViewController.h"
#import "TerminosCondicionesViewController.h"
#import "WS_HandlerLogin.h"
#import "WS_ItemsDominio.h"
#import "WS_HandlerDominio.h"
#import "AlertView.h"
#import "ItemsDominio.h"
#import "FormularioRegistroViewController.h"
#import "AppsFlyerTracker.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "MenuRegistroViewController.h"
#import "VerTutorialViewController.h"

@interface InicioViewController () {
    BOOL loginExitoso, buscandoSesion, existeUnaSesion;
    NSInteger respuestaError;
}

@end

@implementation InicioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		
        if(IS_STANDARD_IPHONE_6){
            self.leyenda1.frame = CGRectMake(47, 510, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(90, 533, 144, 21);
            self.leyenda2.frame = CGRectMake(190, 511, 80, 21);
            self.leyenda5.frame = CGRectMake(190,532, 83, 21);
        }else if(IS_IPAD){
            [self.leyenda1 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda2.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda3 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda4.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda5 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            
            self.leyenda1.frame = CGRectMake(240, 896, 250, 25);
            self.leyenda2.frame = CGRectMake(475, 897, 80, 25);
            self.leyenda3.frame = CGRectMake(230, 930, 40, 25);
            self.leyenda4.frame = CGRectMake(255, 930, 200, 25);
            self.leyenda5.frame = CGRectMake(385,930, 150, 25);
            
        }else if(IS_IPHONE_4){
            self.leyenda1.frame = CGRectMake(47, 410, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 432, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 433, 144, 21);
            self.leyenda2.frame = CGRectMake(217, 411, 80, 21);
            self.leyenda5.frame = CGRectMake(190,432, 83, 21);
        }else{
            self.leyenda1.frame = CGRectMake(47, 510, 200, 21);
            self.leyenda3.frame = CGRectMake(45, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda2.frame = CGRectMake(217, 511, 80, 21);
            self.leyenda5.frame = CGRectMake(190,532, 83, 21);
        
        }
		
	}else{
		
        if(IS_STANDARD_IPHONE_6){
            self.leyenda1.frame = CGRectMake(6, 510, 152, 21);
            self.leyenda2.frame = CGRectMake(160, 511, 152, 21);
            self.leyenda3.frame = CGRectMake(37, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda5.frame = CGRectMake(202,532, 83, 21);
        }else if(IS_IPAD){
            [self.leyenda1 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda2.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda3 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda4.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18]];
            [self.leyenda5 setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
            
            self.leyenda1.frame = CGRectMake(190, 897, 210, 25);
            self.leyenda2.frame = CGRectMake(376, 898, 240, 25);
            self.leyenda3.frame = CGRectMake(214, 931, 40, 25);
            self.leyenda4.frame = CGRectMake(246, 932, 200, 25);
            self.leyenda5.frame = CGRectMake(385,931, 150, 25);
      
      }else if(IS_IPHONE_4){
          self.leyenda1.frame = CGRectMake(6, 410, 152, 21);
          self.leyenda2.frame = CGRectMake(160, 411, 152, 21);
          self.leyenda3.frame = CGRectMake(37, 432, 28, 21);
          self.leyenda4.frame = CGRectMake(65, 433, 144, 21);
          self.leyenda5.frame = CGRectMake(202,432, 83, 21);
      }else{
          
          
            self.leyenda1.frame = CGRectMake(6, 510, 152, 21);
            self.leyenda2.frame = CGRectMake(160, 511, 152, 21);
            self.leyenda3.frame = CGRectMake(37, 532, 28, 21);
            self.leyenda4.frame = CGRectMake(65, 533, 144, 21);
            self.leyenda5.frame = CGRectMake(202,532, 83, 21);
        }
		
	
		
	}
    [self.navigationController.navigationBar setHidden:YES];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self mostrarLogo];
    }
    
    
    self.botonSesions.layer.borderWidth = 1.0f;
    self.botonSesions.layer.cornerRadius = 15.0f;
    self.botonSesions.layer.borderColor = [UIColor whiteColor].CGColor;
    
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.vistaInferior setHidden:YES];
    
   
    [self.conoceMas setTitle:NSLocalizedString(@"conoceMasInicio", nil) forState:UIControlStateNormal] ;
	
	self.label.text = NSLocalizedString(@"inicioLabel", nil);
	[self.botonPruebalos setTitle:NSLocalizedString(@"inicioBotonPruebalo", nil) forState:UIControlStateNormal];
	[self.botonSesions setTitle:NSLocalizedString(@"inicioBotonSesion", nil) forState:UIControlStateNormal] ;
	
	self.leyenda1.text = NSLocalizedString(@"inicioLeyenda1", nil);
	[self.leyenda2 setTitle:NSLocalizedString(@"inicioLeyenda2", nil) forState:UIControlStateNormal] ;
	self.leyenda3.text = NSLocalizedString(@"inicioLeyenda3", nil);
	[self.leyenda4 setTitle:NSLocalizedString(@"inicioLeyenda4", nil) forState:UIControlStateNormal] ;
	self.leyenda5.text = NSLocalizedString(@"inicioLeyenda5", nil);
	
	self.version.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
	 self.datosUsuario = [DatosUsuario sharedInstance];
	if (existeItems) {
       
        if ([CommonUtils hayConexion]) {
            if ([self.datosUsuario.fechaConsulta compare:[NSDate date]] == NSOrderedAscending || self.datosUsuario.fechaConsulta == nil) {
                self.datosUsuario.fechaConsulta = [NSDate date];
            }
        }

    }
   
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonPruebalos setBackgroundImage:[UIImage imageNamed:@"btnfreesiteEn.png"] forState:UIControlStateNormal];
	}
	
	((AppDelegate *)[[UIApplication sharedApplication] delegate]).logueado = NO;
	 ((AppDelegate*)	[[UIApplication sharedApplication] delegate]).statusDominio = @"Gratuito";
   
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).logueado = NO;
    
    if(self.navigationController.navigationBar.hidden == NO){
        [self.navigationController.navigationBar setHidden:YES];
    }
   
    if( IS_IPHONE_4 ){
        self.conoceMas.frame = CGRectMake(126, 380, 143 , 30);
        self.conoceMasPlay.frame = CGRectMake(83, 375, 35, 35);
        self.botonPruebalos.frame = CGRectMake(30, 220, 260, 55);
        self.botonSesions.frame = CGRectMake(32, 290, 256, 55);
        self.label.frame = CGRectMake(20, 118, 280, 97);
    }else if(IS_STANDARD_IPHONE_6){
        self.conoceMas.frame = CGRectMake(170, 380, 143 , 30);
        self.conoceMasPlay.frame = CGRectMake(120, 375, 35, 35);
        self.botonPruebalos.frame = CGRectMake(35, 220, 305, 55);
        self.botonSesions.frame = CGRectMake(35, 290, 305, 55);
        self.label.frame = CGRectMake(30, 118, 315, 97);
        
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            self.leyenda1.frame = CGRectMake(74, 510, 200, 21);
            self.leyenda2.frame = CGRectMake(244, 511, 80, 21);
            
        }else{
            self.leyenda1.frame = CGRectMake(50, 510, 200, 21);
            self.leyenda2.frame = CGRectMake(220, 511, 80, 21);
            
        }
        self.leyenda3.frame = CGRectMake(70, 532, 28, 21);
        self.leyenda4.frame = CGRectMake(90, 533, 144, 21);
        self.leyenda5.frame = CGRectMake(216,532, 83, 21);
        
    }
    //MBC
    else if(IS_STANDARD_IPHONE_6_PLUS){
        self.label.frame = CGRectMake(50, 118, 315, 97);
        self.conoceMas.frame = CGRectMake(190, 420, 143 , 30);
       if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
           self.leyenda1.frame = CGRectMake(94, 510, 200, 21);
           self.leyenda2.frame = CGRectMake(264, 511, 80, 21);
           
       }else{
           self.leyenda1.frame = CGRectMake(70, 510, 200, 21);
           self.leyenda2.frame = CGRectMake(240, 511, 80, 21);
       
       }
        self.leyenda3.frame = CGRectMake(90, 532, 28, 21);
        self.leyenda4.frame = CGRectMake(110, 533, 144, 21);
        self.leyenda5.frame = CGRectMake(236,532, 83, 21);
        self.botonPruebalos.frame = CGRectMake(50, 247, 315, 51);
        self.botonSesions.frame = CGRectMake(50, 322, 315, 51);
    }else if(IS_IPAD){
        self.label.frame = CGRectMake(100, 340, 568, 97);
        [self.label setFont: [UIFont fontWithName:@"Avenir-Book" size:30]];
        self.version.frame = CGRectMake(500, 180, 100, 50);
        self.conoceMas.frame = CGRectMake(326, 770, 160 , 30);
        [self.conoceMas.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        self.conoceMasPlay.frame = CGRectMake(286, 765, 35, 35);
        self.botonPruebalos.frame = CGRectMake(198, 520, 372, 65);
        [self.botonPruebalos.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        [self.botonPruebalos setBackgroundImage:[UIImage imageNamed:@"btn_pruebalo@1x.png" ] forState:UIControlStateNormal];
        UIImage *lineImg = [UIImage imageNamed:@"line@1x.png"];
        UIImageView * myImageView = [[UIImageView alloc] initWithImage:lineImg];
        CGRect myFrame = CGRectMake(146, 600, 475, 2);
        [myImageView setFrame:myFrame];
        [self.view addSubview:myImageView];
        
        self.botonSesions.frame = CGRectMake(206, 620, 353, 51);
        [self.botonSesions.titleLabel setFont: [UIFont fontWithName:@"Avenir-Book" size:18]];
        
    }
   
    [self.vistaInferior setHidden:YES];
    

}

- (IBAction)probarInfomovil:(UIButton *)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self enviarEventoGAconCategoria:@"Pruebalo" yEtiqueta:@"pruebalo"];
    if (self.datosUsuario.existeLogin) {
        [StringUtils deleteResourcesWithExtension:@"jpg"];
        [StringUtils deleteFile];
        [self.datosUsuario eliminarDatos];
    }
	
	if([[self.datosUsuario.itemsDominio objectAtIndex:0] descripcionIdioma] == nil){
		
		NSMutableArray *items = [[NSMutableArray alloc] init];
		NSArray *arregloDescripcion = @[NSLocalizedString(@"nombreEmpresa", @" "), NSLocalizedString(@"logo", @" "), NSLocalizedString(@"descripcionCorta", @" "), NSLocalizedString(@"contacto", @" "), NSLocalizedString(@"mapa", @" "), NSLocalizedString(@"video", @" "), NSLocalizedString(@"promociones", @" "), NSLocalizedString(@"galeriaImagenes", @" "), NSLocalizedString(@"perfil", @" "), NSLocalizedString(@"direccion", @" "),  NSLocalizedString(@"informacionAdicional", @" ")];
		NSArray *arregloStatus = @[@"1",@"1",@"1",@"3",@"1",@"0",@"1",@"2",@"7",@"7",@"1"];
		
		for(int i = 0; i<11;i++){
			ItemsDominio * item = [[ItemsDominio alloc] init];
			[item setDescripcionItem:[arregloDescripcion objectAtIndex:i]];
			[item setDescripcionIdioma:[arregloDescripcion objectAtIndex:i]];
			[item setEstatus:[[arregloStatus objectAtIndex:i] integerValue]];
		
			[items addObject:item];
		}
		self.datosUsuario.itemsDominio = items;
	}
	
   
    MenuRegistroViewController *registro = [[MenuRegistroViewController alloc] initWithNibName:@"MenuRegistroViewController" bundle:nil];
    [self.navigationController pushViewController:registro animated:YES];
    
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Pruebalo ios" withValue:@""];
    
}

- (IBAction)loguearInfomovil:(UIButton *)sender {

        MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:mainController animated:YES];

}

- (IBAction)mostrarTerminos:(id)sender {
    TerminosCondicionesViewController *terminosCondiciones = [[TerminosCondicionesViewController alloc] initWithNibName:@"TerminosCondicionesViewController" bundle:Nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:terminosCondiciones];
	[terminosCondiciones setIndex:0];
    [self.navigationController presentViewController:navController animated:YES completion:Nil];
}

- (IBAction)mostrarCondiciones:(id)sender {
	TerminosCondicionesViewController *terminosCondiciones = [[TerminosCondicionesViewController alloc] initWithNibName:@"TerminosCondicionesViewController" bundle:Nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:terminosCondiciones];
	[terminosCondiciones setIndex:1];
    [self.navigationController presentViewController:navController animated:YES completion:Nil];
}

- (IBAction)conoceMasAct:(id)sender {
    [self videoConoceMas];
}

- (IBAction)conoceMasPlayAct:(id)sender {
    [self videoConoceMas];
}

-(void)videoConoceMas{
    VerTutorialViewController *verTutorial = [[VerTutorialViewController alloc] initWithNibName:@"VerTutorialViewController" bundle:nil];
    [self.navigationController pushViewController:verTutorial animated:YES];
    
}





@end
