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

- (IBAction)movilizaImgAct:(id)sender {
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        NSString *message;
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            [controller setSubject:@"Check our website"];
            message = self.datosUsuario.pedacito;
        }else{
            [controller setSubject:@"Checa nuestro sitio web"];
            message = self.datosUsuario.pedacito;
        }
        
        [controller setMessageBody:message isHTML:YES];
        
        [self presentViewController:controller animated:YES completion:NULL];
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
            [controller setSubject:NSLocalizedString(@"movilizaActual", @" ")];
            message = [NSString stringWithFormat:@"Código de enlace para versión optimizada para móviles.\n\n Pasos a seguir:\n 1.- Coloca el código entre las etiquetas siguientes \n<header></header>\n del archivo principal (index).\n 2.- El siguiente código que deberas copiar y pegar dentro de las etiquetas anteriormente mencionadas es: \n\n %@ \n\n3.- Una vez colocado el código accede a través de tu smartphone al sitio y podrás ver la versión optimizada de este.\n\n Saludos", self.datosUsuario.pedacito ];
            [controller setMessageBody:message isHTML:NO];
            NSLog(@"EL PEDACITO DE CODIGO ES: %@    ", self.datosUsuario.pedacito);
            [self presentViewController:controller animated:YES completion:NULL];
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


