//
//  VerTutorialViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 18/02/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "VerTutorialViewController.h"
#import "CommonUtils.h"

@interface VerTutorialViewController ()
@property (nonatomic, strong) AlertView *alertaContacto;
@property (nonatomic,assign) BOOL pagCargada;
@end


@implementation VerTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.pagCargada = NO;
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    self.navigationItem.rightBarButtonItem = Nil;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"verTutorialInicio", @" ") nombreImagen:@"barramorada.png"];
    }
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
   
        
    NSString *htmlStringToLoad = @"http://www.youtube.com/watch?v=XyHTERaAlXg&feature=youtu.be";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlStringToLoad]]];
    [self.view addSubview:self.webView];
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //MBC
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.webView setFrame:CGRectMake(0, 0, 375, 667)];
    /*}else if(IS_STANDARD_IPHONE_6_PLUS){
        [self.webView setFrame:CGRectMake(0, 0, 414, 680)];
    */
     }else if(IS_IPAD){
        [self.webView setFrame:CGRectMake(0, 0, 768, 1024)];
    }else{
        [self.webView setFrame:CGRectMake(0, 0, 320, 568)];
    }

}



-(IBAction)regresar:(id)sender {
    self.pagCargada = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.pagCargada = YES;
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(self.pagCargada == NO){
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
