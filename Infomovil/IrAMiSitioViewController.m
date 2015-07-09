//
//  IrAMiSitioViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/4/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "IrAMiSitioViewController.h"

@interface IrAMiSitioViewController ()
@property (nonatomic, strong) AlertView *alertaContacto;
@property (nonatomic,assign) BOOL pagCargada;
@end

@implementation IrAMiSitioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //MBC
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.view setFrame:CGRectMake(0, 0, 375, 667)];
        [self.webView setFrame:CGRectMake(0, 0, 375, 604)];
   
     }else if(IS_IPAD){
        [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.webView setFrame:CGRectMake(0, 0, 768, 960)];
     }else if(IS_IPHONE_4){
         [self.webView setFrame:CGRectMake(0, 0, 320, 416)];
     }else{
        [self.webView setFrame:CGRectMake(0, 0, 320, 504)];
    }

    self.pagCargada = NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.webView.delegate = self;
    self.navigationItem.rightBarButtonItem = Nil;
   
    [self.navigationItem setTitle:[prefs stringForKey:@"urlMisitio"]];
    UIFont *fuente = [UIFont fontWithName:@"Avenir-Heavy" size:15];
    UIColor *colorTexto = [UIColor whiteColor];
    NSDictionary *atributos = @{
                                NSFontAttributeName: fuente,
                                NSForegroundColorAttributeName: colorTexto,
                                };
    
    [self.navigationController.navigationBar setTitleTextAttributes:atributos];

    UIImage *image = defRegresar;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    
    NSString *htmlStringToLoad = [prefs stringForKey:@"urlMisitio"];
    
    if([CommonUtils hayConexion]){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlStringToLoad]]];
        [self.view addSubview:self.webView];
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    }else{
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    
    }
   
}
-(void)viewWillAppear:(BOOL)animated{
    [self.vistaInferior setHidden:YES];

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
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"errorVerMiSitio", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
