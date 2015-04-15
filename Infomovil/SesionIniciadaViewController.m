//
//  SesionIniciadaViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 4/14/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "SesionIniciadaViewController.h"
#import "WS_HandlerLogin.h"
#import "MenuPasosViewController.h"

@interface SesionIniciadaViewController ()
@property (nonatomic, strong) AlertView *alerta;
@end

@implementation SesionIniciadaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *passLogin = nil;
    NSString *emailLogin = nil;
    NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view from its nib.
    self.datosUsuario = [DatosUsuario sharedInstance];
    WS_HandlerLogin *login = [[WS_HandlerLogin alloc] init];
    [login setLoginDelegate:self];
    if ( [prefSesion integerForKey:@"intSesionFacebook"] == 1){
        [login setRedSocial:@"Facebook"];
    }
    
    passLogin = [prefSesion stringForKey:@"strSesionPass"];
    emailLogin = [prefSesion stringForKey:@"strSesionUser"];
    
    [login obtieneLogin:emailLogin conPassword:passLogin];
    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
    
    [self mostrarLogo];
    [self.vistaInferior setHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.btnReintentar.layer.borderWidth = 1.0f;
    self.btnReintentar.layer.cornerRadius = 15.0f;
    self.btnReintentar.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WS_HandlerProtocol
-(void) resultadoLogin:(NSInteger) idDominio { NSLog(@"si me respondio! con %i", idDominio);
    if (idDominio > 0) {
        ((AppDelegate*) [[UIApplication sharedApplication] delegate]).logueado =YES;
        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:nil];
        [self.navigationController pushViewController:menuPasos animated:YES];
        
    }
    else {
      
    }
    
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];

}


-(void) mostrarActivity {
   self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgValidandoUsuario", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}

-(void) ocultarActivity {
    if (self.alerta)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alerta hide];
    }
}









@end
