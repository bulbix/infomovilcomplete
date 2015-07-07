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
            htmlStringToLoad = @"http://infomovil.com/divertido?vistaPrevia=true";
            /*
#if DEBUG
      htmlStringToLoad = @"http://qa.mobileinfo.io:8080/divertido?vistaPrevia=true";
#endif
             */
            [self.navigationItem setTitle:@"Divertido"];
            break;
        case 1:
            htmlStringToLoad = @"http://infomovil.com/clasico?vistaPrevia=true";
            /*
#if DEBUG
            htmlStringToLoad = @"http://qa.mobileinfo.io:8080/clasico?vistaPrevia=true";
#endif
             */
            [self.navigationItem setTitle:@"Clásico"];
            break;
        case 2:
            htmlStringToLoad = @"http://infomovil.com/creativo?vistaPrevia=true";
            /*
#if DEBUG
            htmlStringToLoad = @"http://qa.mobileinfo.io:8080/creativo?vistaPrevia=true";
#endif
            */
            [self.navigationItem setTitle:@"Creativo"];
            break;
        case 3:
            htmlStringToLoad = @"http://infomovil.com/moderno?vistaPrevia=true";
            /*
#if DEBUG
            htmlStringToLoad = @"http://qa.mobileinfo.io:8080/moderno?vistaPrevia=true";
#endif
            */
            [self.navigationItem setTitle:@"Moderno"];
            break;
        case 4:
            htmlStringToLoad = @"http://infomovil.com/estandar1?vistaPrevia=true";
            /*
#if DEBUG
            htmlStringToLoad = @"http://qa.mobileinfo.io:8080/estandar1?vistaPrevia=true";
#endif
             */
            
            [self.navigationItem setTitle:@"Estandar"];
            break;
            case 5:
            htmlStringToLoad = @"https://s3.amazonaws.com/images.infomovil/templates/templates.html";
            [self.navigationItem setTitle:@"Estilos"];
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
    UIImage *image = defRegresar;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    // URL PARA CARGAR //
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlStringToLoad]];
    [self.webView loadRequest:urlRequest];
    [self.view addSubview:self.webView];
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];

    self.vistaInferior.hidden=YES;
    
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.webView setFrame:CGRectMake(0, 0, 375, 667)];
    }else if(IS_IPAD){
        [self.webView setFrame:CGRectMake(0, 0, 768, 1024)];
    }
    
   
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:urlRequest];
}

-(IBAction)regresar:(id)sender {
    self.pagCargada = NO;
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    self.webView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.pagCargada = YES;
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
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
