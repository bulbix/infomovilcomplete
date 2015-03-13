//
//  InfomovilViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "EstadisticasViewController.h"
#import "CompartirViewController.h"
#import "CuentaViewController.h"
#import "ConfiguracionViewController.h"
#import "UIViewDefs.h"
#import "NSStringUtiles.h"


@interface InfomovilViewController ()

@end

@implementation InfomovilViewController

@synthesize tituloVista, vistaInferior;// vistaMenuMapa;
@synthesize vistaCircular;// esMapa;
@synthesize keyboardControls;
@synthesize modifico;


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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.view setBackgroundColor:colorBackground];
    if([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"barradenavegacion.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    [self setBotonRegresar];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImage *imagenSalvar = [UIImage imageNamed:@"btnaceptar"];
    UIButton *btAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
    [btAceptar setFrame:CGRectMake(0, 0, imagenSalvar.size.width, imagenSalvar.size.height)];
    [btAceptar setImage:imagenSalvar forState:UIControlStateNormal];
    [btAceptar addTarget:self action:@selector(guardarInformacion:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc] initWithCustomView:btAceptar];
    self.navigationItem.rightBarButtonItem = buttonSave;
    vistaCircular = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    [self.view addSubview:vistaCircular];
    
    tituloVista = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, 220, 21)];
    [tituloVista setFont:[UIFont fontWithName:@"Avenir-Book" size:19]];
    [tituloVista setTextAlignment:NSTextAlignmentCenter];
    [tituloVista setTextColor:[UIColor whiteColor]];
    [tituloVista setBackgroundColor:[UIColor clearColor]];
    [tituloVista setMinimumScaleFactor:0.5];
    [tituloVista setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:tituloVista];
    
    if (IS_IPHONE_5) {
        vistaInferior = [[UIView alloc] initWithFrame:CGRectMake(0, 440, 320, 68)];//458
    }else if(IS_STANDARD_IPHONE_6){
        vistaInferior = [[UIView alloc] initWithFrame:CGRectMake(0, 540, 400, 88)];//458
    }
    //MBC
    else if(IS_STANDARD_IPHONE_6_PLUS){
        vistaInferior = [[UIView alloc] initWithFrame:CGRectMake(35, 607, 400, 88)];//458
    }else {
        vistaInferior = [[UIView alloc] initWithFrame:CGRectMake(0, 352, 320, 68)];//370
    }
    
    
    
    self.botonEstadisticas = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 64, 41)];
    [self.botonEstadisticas setBackgroundImage:[UIImage imageNamed:@"mireportes.png"] forState:UIControlStateNormal];
    [self.botonEstadisticas addTarget:self action:@selector(mostrarEstadisticas:) forControlEvents:UIControlEventTouchUpInside];
    [vistaInferior addSubview:self.botonEstadisticas];
    
    self.botonNotificaciones = [[UIButton alloc] initWithFrame:CGRectMake(64, 25, 64, 41)];
    [self.botonNotificaciones setBackgroundImage:[UIImage imageNamed:@"micompartir.png"] forState:UIControlStateNormal];
    [self.botonNotificaciones addTarget:self action:@selector(compartir:) forControlEvents:UIControlEventTouchUpInside];
    [vistaInferior addSubview:self.botonNotificaciones];
    
    self.botonCuenta = [[UIButton alloc] initWithFrame:CGRectMake(128, 25, 64, 41)];
    [self.botonCuenta setBackgroundImage:[UIImage imageNamed:@"micuenta.png"] forState:UIControlStateNormal];
    [self.botonCuenta addTarget:self action:@selector(comprarCuenta:) forControlEvents:UIControlEventTouchUpInside];
    [vistaInferior addSubview:self.botonCuenta];
    
    self.botonConfiguracion = [[UIButton alloc] initWithFrame:CGRectMake(192, 25, 64, 41)];
    [self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"miconfiguracion.png"] forState:UIControlStateNormal];
    [self.botonConfiguracion addTarget:self action:@selector(configurar:) forControlEvents:UIControlEventTouchUpInside];
    [vistaInferior addSubview:self.botonConfiguracion];
    
    self.botonFeeds = [[UIButton alloc] initWithFrame:CGRectMake(256, 25, 64, 41)];
    [self.botonFeeds setBackgroundImage:[UIImage imageNamed:@"miFeed.png"] forState:UIControlStateNormal];
    [self.botonFeeds addTarget:self action:@selector(mostrarFeed:) forControlEvents:UIControlEventTouchUpInside];
    [vistaInferior addSubview:self.botonFeeds];
    
    
    
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && (![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Tramite"] && ![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Tramite PRO"])) {
        [self.vistaInferior setHidden:NO];
    }
    else {
        [self.vistaInferior setHidden:YES];
    }
    
    [self.view addSubview:vistaInferior];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vistaPulsada)];
    [tapRecognizer setCancelsTouchesInView:NO];
    [[self view] addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.guardarVista) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView = self;
    }
    
    
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion && (![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Tramite"] && ![((AppDelegate*) [[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Tramite PRO"])) {
        [self.vistaInferior setHidden:NO];
    }
    else {
        [self.vistaInferior setHidden:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)mostrarEstadisticas:(id)sender {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        if ([CommonUtils hayConexion]) {
            EstadisticasViewController *estadisticas = [[EstadisticasViewController alloc] initWithNibName:@"EstadisticasViewController" bundle:Nil];
            [self.navigationController pushViewController:estadisticas animated:YES];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    }
    else {
        AlertView *alertActivity = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertActivity show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

-(IBAction)compartir:(id)sender {
    CompartirViewController *comparte = [[CompartirViewController alloc] initWithNibName:@"CompartirViewController" bundle:Nil];
    [self.navigationController pushViewController:comparte animated:YES];
}

-(IBAction)comprarCuenta:(id)sender {
    CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
    [self.navigationController pushViewController:cuenta animated:YES];
}

-(IBAction)configurar:(id)sender {
    ConfiguracionViewController *configuracion = [[ConfiguracionViewController alloc] initWithNibName:@"ConfiguracionViewController" bundle:Nil];
    [self.navigationController pushViewController:configuracion animated:YES];
}

-(void) acomodaSesion {
    [vistaCircular setFrame:CGRectMake(0, 0, 320, 72)];
    UILabel *labelHola = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 280, 21)];
    [labelHola setText:NSLocalizedString(@"hola", Nil)];
    [labelHola setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
    [labelHola setTextColor:[UIColor whiteColor]];
    [labelHola setTextAlignment:NSTextAlignmentCenter];
    [vistaCircular setImage:[UIImage imageNamed:@"plecasesion.png"]];
    [self.tituloVista setFrame:CGRectMake(50, 30, 220, 21)];
    [self.view addSubview:labelHola];
}

#pragma mark
- (void)setBotonRegresar
{
    self.navigationItem.hidesBackButton = YES;
    UIImage *image						= [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton				= [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack				= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem	= buttonBack;
}

#pragma mark - Métodos de acción adicionales
- (void) vistaPulsada
{
    [[self view] endEditing:YES];
}

-(IBAction)guardarInformacion:(id)sender {
}

-(IBAction)regresar:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)mostrarFeed:(id)sender {
    ABKFeedViewControllerNavigationContext *feedNavigationContext = [[ABKFeedViewControllerNavigationContext alloc] init];
    [feedNavigationContext setAppboyDelegate:self];
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeModalNaviagationView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    feedNavigationContext.navigationItem.leftBarButtonItem = buttonBack;
    
    [self.navigationController pushViewController:feedNavigationContext animated:YES];
}

-(IBAction)openFeedbackFromModalFeed:(id)sender {
    
}

-(IBAction)closeModalNaviagationView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) mostrarLogo {
    UIImageView *imagenBarra = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [imagenBarra setImage:[UIImage imageNamed:@"sbarnuevo.png"]];
    [self.view addSubview:imagenBarra];
    [self.vistaCircular setFrame:CGRectMake(27, 52, 267, 49)];
    [self.vistaCircular setImage:[UIImage imageNamed:@"logoRegistrado.png"]];
}

-(void) mostrarLogo6 {
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    [self.vistaCircular setFrame:CGRectMake(27, 52, 267, 49)];
    //    [self.vistaCircular setImage:[UIImage imageNamed:@"logonuevo.png"]];
    [self.vistaCircular setImage:[UIImage imageNamed:@"logoRegistrado.png"]];
}

-(void) mostrarLogoBarraNavegacion {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"barramorada.png"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationItem setTitle:titulo];
    [self.navigationItem setTitle:@"Ingresa a tu cuenta"];
    UIFont *fuente = [UIFont fontWithName:@"Avenir-Book" size:19];
    
    UIColor *colorTexto = [UIColor whiteColor];
    UIColor *colorSombra = [UIColor whiteColor];
    
    NSDictionary *atributos = @{
                                UITextAttributeFont: fuente,
                                UITextAttributeTextColor: colorTexto,
                                UITextAttributeTextShadowColor: colorSombra,
                                };
    
    [self.navigationController.navigationBar setTitleTextAttributes:atributos];
    
    [self.vistaCircular removeFromSuperview];
}

-(void) mostrarLogoBarraNavegacion6 {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NBlila.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setTitle:@"Ingresa a tu cuenta"];
    UIFont *fuente = [UIFont fontWithName:@"Avenir-Book" size:19];
    
    UIColor *colorTexto = [UIColor whiteColor];
    UIColor *colorSombra = [UIColor whiteColor];
    
    NSDictionary *atributos = @{
                                UITextAttributeFont: fuente,
                                UITextAttributeTextColor: colorTexto,
                                UITextAttributeTextShadowColor: colorSombra,
                                };
    
    [self.navigationController.navigationBar setTitleTextAttributes:atributos];
    
    [self.vistaCircular removeFromSuperview];
}

-(void) acomodarBarraNavegacionConTitulo:(NSString *)titulo nombreImagen:(NSString *)nombreImagen
{
    if ( [NSString isEmptyString:_strTituloVista] )
        self.strTituloVista = titulo;
    if ( [NSString isEmptyString:_strImagenTitulo] )
        self.strImagenTitulo = nombreImagen;
    
    [vistaCircular removeFromSuperview];
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:_strImagenTitulo]
                                                     forBarPosition:UIBarPositionAny
                                                         barMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:_strImagenTitulo]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor redColor];
    }
    //    [self.navigationController.navigationItem setTitle:titulo];
    [self.navigationItem setTitle:_strTituloVista];
    UIFont *fuente = [UIFont fontWithName:@"Avenir-Heavy" size:19];
    UIColor *colorTexto = [UIColor whiteColor];
    NSDictionary *atributos = @{
                                UITextAttributeFont: fuente,
                                UITextAttributeTextColor: colorTexto,
                                };
    
    [self.navigationController.navigationBar setTitleTextAttributes:atributos];
}

-(void) apareceTeclado: (UIScrollView *) scrollView withView:(UIView *) vistaReferencia {
    CGSize tamanioTeclado = TAMANIO_TECLADO;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height-30, 0);
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    [scrollView scrollRectToVisible:vistaReferencia.frame animated:YES];
    NSLog(@"el frame del textview es %f, %f, %f, %f", vistaReferencia.frame.origin.x, vistaReferencia.frame.origin.y, vistaReferencia.frame.size.width, vistaReferencia.frame.size.height);
}

-(void) apareceTeclado: (UIScrollView *) scrollView withRefFrame:(CGRect) refFrame
{
    CGSize tamanioTeclado = TAMANIO_TECLADO;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    [scrollView scrollRectToVisible:refFrame animated:YES];
}

-(void) desapareceElTeclado: (UIScrollView *) scrollView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

- (BOOL)shouldChangeText:(NSString *)string withLimit:(NSInteger)maxLength forFinalLenght:(NSInteger)textoLength
{
    if ( [string isEqualToString:@"<"] || [string isEqualToString:@">"] || textoLength > maxLength )
        return NO;
    
    if ( textoLength <= maxLength )
    {
        [_labelInfo setText:[NSString stringWithFormat:@"%i/%li", textoLength, (long)maxLength]];
        modifico = YES;
        return YES;
    }
    
    return NO;
}

- (void)muestraContadorTexto:(NSInteger)contador conLimite:(NSInteger)limite paraVista:(UIView *)view
{
    [self.labelInfo setText:[NSString stringWithFormat:@"%i/%i", contador, limite]];
    [UIView animateWithDuration:0.4f animations:^{
        [self.labelInfo setFrame:CGRectMake(284, view.frame.origin.y + view.frame.size.height, 33, 21)];
        self.labelInfo.hidden = NO;
    }];
}

- (void)ocultaContadorTexto
{
    [UIView animateWithDuration:0.4f animations:^{
        self.labelInfo.hidden = YES;
    }];
}

-(void)enviarEventoGAconCategoria:(NSString *)categoria yEtiqueta:(NSString *)etiqueta {
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSString *accionGA = (self.datosUsuario.emailUsuario == nil || self.datosUsuario.emailUsuario.length<2)?@"Presiono pruebalo" : self.datosUsuario.emailUsuario;
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:categoria action:accionGA label:etiqueta value:nil] build]];
}




@end
