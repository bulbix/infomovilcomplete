//
//  EnviarPedacitoCodigoViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/18/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "EnviarPedacitoCodigoViewController.h"
#import <MessageUI/MessageUI.h>

@interface EnviarPedacitoCodigoViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation EnviarPedacitoCodigoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"movilizaActual", @" ") nombreImagen:@"barramorada.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"movilizaActual", @" ") nombreImagen:@"NBlila.png"];
    }
    self.navigationItem.rightBarButtonItem = Nil;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.vistaInferior setHidden:YES];
    self.tituloMoviliza.text = NSLocalizedString(@"movilizaTituloWeb", @" ");
    self.textoMoviliza.text = NSLocalizedString(@"movilizaTextoWeb", @" ");
    [self.btnMovilizaText setTitle:NSLocalizedString(@"movilizaBotonEnviar", Nil) forState:UIControlStateNormal];


    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.tituloMoviliza setFrame:CGRectMake(37, 70, 300, 30)];
        [self.textoMoviliza setFrame:CGRectMake(37, 100, 300, 300)];
        [self.btnMovilizaImg setFrame:CGRectMake(100, 400, 50, 40)];
        [self.btnMovilizaText setFrame:CGRectMake(160, 400, 150, 40)];
    
    }else if(IS_IPAD){
        [self.tituloMoviliza setFrame:CGRectMake(134, 140, 500, 50)];
        [self.textoMoviliza setFrame:CGRectMake(134, 160, 500, 400)];
        [self.btnMovilizaImg setFrame:CGRectMake(264, 560, 66, 45)];
        [self.btnMovilizaText setFrame:CGRectMake(340, 560, 300, 40)];
        
       [self.tituloMoviliza setFont:[UIFont fontWithName:@"Avenir-Medium" size:24]];
        [self.textoMoviliza setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
        [self.btnMovilizaText.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:24]];
        
    
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)movilizaImgAct:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        NSArray *usersTo = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@", self.datosUsuario.emailUsuario]];
        [controller setToRecipients:usersTo];
        NSString *message;
        [controller setSubject:NSLocalizedString(@"subjectMoviliza", @" ")];
        message = [NSString stringWithFormat:NSLocalizedString(@"codigoCompletoMoviliza", nil),self.datosUsuario.pedacito];
        [controller setMessageBody:message isHTML:NO];
        [self presentViewController:controller animated:YES completion:NULL];
        NSLog(@"EL PEDACITO DE CODIGO ES: %@    ", self.datosUsuario.pedacito);
    }else{
        AlertView * alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"configuracionCorreo", nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}

- (IBAction)movilizaTextAct:(id)sender {
       self.datosUsuario = [DatosUsuario sharedInstance];
        if ([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            NSArray *usersTo = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@", self.datosUsuario.emailUsuario]];
            [controller setToRecipients:usersTo];
            NSString *message;
            [controller setSubject:NSLocalizedString(@"subjectMoviliza", @" ")];
            message = [NSString stringWithFormat:NSLocalizedString(@"codigoCompletoMoviliza", nil),self.datosUsuario.pedacito];
            [controller setMessageBody:message isHTML:NO];
            [self presentViewController:controller animated:YES completion:NULL];
             NSLog(@"EL PEDACITO DE CODIGO ES: %@    ", self.datosUsuario.pedacito);
        }else{
            AlertView * alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"configuracionCorreo", nil) andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:Nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end


