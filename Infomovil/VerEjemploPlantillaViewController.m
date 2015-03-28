//
//  VerEjemploPlantillaViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/11/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "VerEjemploPlantillaViewController.h"

@interface VerEjemploPlantillaViewController ()
@property (nonatomic, strong) AlertView *alertaContacto;
@property (nonatomic,assign) BOOL pagCargada;
@end

@implementation VerEjemploPlantillaViewController

@synthesize index;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.pagCargada = NO;
    self.webView.delegate = self;
    self.navigationItem.rightBarButtonItem = Nil;
    
    NSString *htmlStringToLoad;
    
    switch (index) {
        case 0:
            htmlStringToLoad = @"http://info-movil.net/divertido?vistaPrevia=true";
            [self.navigationItem setTitle:@"Divertido"];
            break;
        case 1:
            htmlStringToLoad = @"http://info-movil.net/clasico?vistaPrevia=true";
            [self.navigationItem setTitle:@"Clásico"];
            break;
        case 2:
            htmlStringToLoad = @"http://info-movil.net/creativo?vistaPrevia=true";
            [self.navigationItem setTitle:@"Creativo"];
            break;
        case 3:
            htmlStringToLoad = @"http://info-movil.net/moderno?vistaPrevia=true";
            [self.navigationItem setTitle:@"Moderno"];
            break;
        case 4:
            htmlStringToLoad = @"http://info-movil.net/estandar1?vistaPrevia=true";
            [self.navigationItem setTitle:@"Estandar"];
            break;
        default:
            break;
    }
    
    
    
    // TITULO DEL TEMPLATE //
    
    UIFont *fuente = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    UIColor *colorTexto = [UIColor whiteColor];
    NSDictionary *atributos = @{
                                NSFontAttributeName: fuente,
                                NSForegroundColorAttributeName: colorTexto,
                                };
    
    [self.navigationController.navigationBar setTitleTextAttributes:atributos];
  
    // BOTON DE REGRESAR //
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    // URL PARA CARGAR //
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlStringToLoad]]];
    [self.view addSubview:self.webView];
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];

    self.vistaInferior.hidden=YES;
    
    if(IS_STANDARD_IPHONE_6_PLUS){
        [self.webView setFrame:CGRectMake(0, 0, 414, 736)];
    }else if(IS_STANDARD_IPHONE_6){
        [self.webView setFrame:CGRectMake(0, 0, 375, 667)];
    }else if(IS_IPAD){
        [self.webView setFrame:CGRectMake(0, 0, 768, 1024)];
    }
    
}

-(IBAction)regresar:(id)sender {
    self.pagCargada = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Termino de cargar");
    self.pagCargada = YES;
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"El error es: %@ con codigo : %ld", error.userInfo, (long)error.code);
    if(!self.pagCargada){
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    
}



-(void) mostrarActivity {
    self.alertaContacto = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaContacto show];
}

-(void) ocultarActivity {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    
}

@end
