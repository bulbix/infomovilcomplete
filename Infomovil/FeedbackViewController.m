//
//  FeedbackViewController.m
//  Infomovil
//
//  Created by Sergio Sanchez on 11/10/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController () {
    BOOL esBug;
}

@property (nonatomic, strong) AlertView *alert;
@end

@implementation FeedbackViewController

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
    esBug = NO;
    NSString *imagenBarra = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? @"barramorada.png" : @"NBlila.png";
    [self acomodarBarraNavegacionConTitulo:@"Feedback" nombreImagen:imagenBarra];
    [self.vistaCircular setHidden:YES];
    [self.vistaInferior setHidden:YES];
    [self.labelPregunta setText:NSLocalizedString(@"txtReportar", Nil)];
    [self.labelMensaje setText:NSLocalizedString(@"txtMensaje", Nil)];
    self.txtMensaje.layer.cornerRadius = 5.0f;
}

-(void) viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)guardarInformacion:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([self.txtMensaje.text length] > 0) {
       
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    }
    else {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"txtIngresaMensaje", Nil) andAlertViewType:AlertViewTypeInfo] show];
    }
    
}
-(IBAction)regresar:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)enviarError:(UISwitch *)sender {
    if ([sender isOn]) {
        esBug = YES;
    }
    else {
        esBug = NO;
    }
}
@end
