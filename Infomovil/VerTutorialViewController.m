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


@end




@implementation VerTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
    [self.navigationItem hidesBackButton];
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion)
    {
        self.navigationItem.backBarButtonItem	= Nil;
        self.navigationItem.leftBarButtonItem	= Nil;
        self.navigationItem.hidesBackButton		= YES;
    }
    
    self.navigationItem.rightBarButtonItem = Nil;
    
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView = self;
    
    
    self.navigationItem.hidesBackButton = YES;
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

-(IBAction)regresar:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Termino de cargar");
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

   [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorAlCargar", Nil) andAlertViewType:AlertViewTypeInfo];
    [alert show];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
