//
//  TerminosCondicionesViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 24/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "TerminosCondicionesViewController.h"

@interface TerminosCondicionesViewController ()

@property (nonatomic, strong) AlertView *alert;

@end

@implementation TerminosCondicionesViewController

@synthesize index;

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
    // Do any additional setup after loading the view from its nib.
	
	NSString* url;
    NSString *titulo = nil;
    NSString *imagenBarra = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? @"barramorada.png" : @"NBlila.png";

    if(index == 0)
    {
        titulo  = NSLocalizedString(@"condicionesServicio",nil);
        
#if DEBUG
        url     = @"http://infomovil.com/pages/legal/terminos.html";
#else
        url     = [NSString stringWithFormat:@"%@/pages/legal/terminos.html",rutaWS];
#endif
    }else{
        titulo = NSLocalizedString(@"politicaPrivacidad",nil);
        
#if DEBUG
        url = @"http://infomovil.com/pages/legal/aviso.html";
#else
        url = [NSString stringWithFormat:@"%@/pages/legal/aviso.html",rutaWS ];
#endif
        
        
    }
    
    [self acomodarBarraNavegacionConTitulo:titulo nombreImagen:imagenBarra];
    
    self.alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", @" ") andAlertViewType:AlertViewTypeActivity];
    [self.alert show];
    //NSString* url = @"http://www.bancoazteca.com.mx/PortalBancoAzteca/publica/conocenos/historia/AvisoPrivacidad.htm";
    
    NSURL* nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self.webView loadRequest:request];
    [self.vistaCircular setHidden:YES];
    [self.vistaInferior setHidden:YES];
    self.navigationItem.leftBarButtonItem = Nil;
}

-(void)viewWillAppear:(BOOL)animated{
 [self.vistaInferior setHidden:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.alert)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alert hide];
    }
}

-(IBAction)guardarInformacion:(id)sender {
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
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

@end
