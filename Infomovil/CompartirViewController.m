//
//  CompartirViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 20/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "CompartirViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <GooglePlus/GooglePlus.h>
#import "MenuPasosViewController.h"
#import "NombrarViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@class GPPSignInButton;

@interface CompartirViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, FBLoginViewDelegate>

@property (nonatomic, strong) NSMutableArray *arregloDominio;
@property (nonatomic, strong) NSString *dominioParaCompartir;
@property (nonatomic, strong) AlertView *alertActivity;

@end

@implementation CompartirViewController

@synthesize signInButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
   /* if(IS_STANDARD_IPHONE_6_PLUS){
        [self.btnFacebook setFrame:CGRectMake(102, 243, 47, 47)];
        [self.btnGooglePlus setFrame:CGRectMake(185, 243, 47, 47)];
        [self.btnTwitter setFrame:CGRectMake(271, 243, 47, 47)];
        [self.btnMail setFrame:CGRectMake(102, 298, 47, 47)];
        [self.btnSMS setFrame:CGRectMake(185, 298, 47, 47)];
        [self.btnWhat setFrame:CGRectMake(271, 298, 47, 47)];
    }else
        */
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.btnFacebook setFrame:CGRectMake(80, 243, 47, 47)];
        [self.btnGooglePlus setFrame:CGRectMake(160, 243, 47, 47)];
        [self.btnTwitter setFrame:CGRectMake(250, 243, 47, 47)];
        [self.btnMail setFrame:CGRectMake(80, 298, 47, 47)];
        [self.btnSMS setFrame:CGRectMake(160, 298, 47, 47)];
        [self.btnWhat setFrame:CGRectMake(250, 298, 47, 47)];
    }else if(IS_IPAD){
        [self.btnFacebook setFrame:CGRectMake(234, 400, 60, 60)];
        [self.btnGooglePlus setFrame:CGRectMake(354, 400, 60, 60)];
        [self.btnTwitter setFrame:CGRectMake(474, 400, 60, 60)];
        [self.btnMail setFrame:CGRectMake(234, 520, 60, 60)];
        [self.btnSMS setFrame:CGRectMake(354, 520, 60 ,60)];
        [self.btnWhat setFrame:CGRectMake(474, 520, 60, 60)];
    
    }else{
        [self.btnFacebook setFrame:CGRectMake(52, 243, 47, 47)];
        [self.btnGooglePlus setFrame:CGRectMake(135, 243, 47, 47)];
        [self.btnTwitter setFrame:CGRectMake(221, 243, 47, 47)];
        [self.btnMail setFrame:CGRectMake(52, 298, 47, 47)];
        [self.btnSMS setFrame:CGRectMake(135, 298, 47, 47)];
        [self.btnWhat setFrame:CGRectMake(221, 298, 47, 47)];
    }
    
    self.vistaContenidoCompartir.layer.cornerRadius = 5.0f;
	self.guardarVista = YES;
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"NBlila.png"];
	}
	
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonNotificaciones setBackgroundImage:[UIImage imageNamed:@"shareEn.png"] forState:UIControlStateNormal];
	}else{
		[self.botonNotificaciones setBackgroundImage:[UIImage imageNamed:@"micompartiron.png"] forState:UIControlStateNormal];
	}
    if(IS_IPAD){
        [self.botonNotificaciones setFrame:CGRectMake(88, 10, 88, 80)];
    }else{
        [self.botonNotificaciones setFrame:CGRectMake(64, 14, 64, 54)];
    }
    self.navigationItem.rightBarButtonItem = Nil;
	[super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
	
    self.datosUsuario = [DatosUsuario sharedInstance];
    if(self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
        self.arregloDominio = self.datosUsuario.dominiosUsuario;
        self.labelNombreDominio.text = @"";
    
        for(int i= 0; i< [self.arregloDominio count]; i++){
            DominiosUsuario *usuarioDom = [self.arregloDominio objectAtIndex:i];
            
            if([usuarioDom.domainType isEqualToString:@"tel"]){
              
                if([usuarioDom.vigente isEqualToString:@"SI"] || [usuarioDom.vigente isEqualToString:@"si"]){
                 
                    [self.labelNombreDominio setText:[NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio]];
                    self.dominioParaCompartir = self.labelNombreDominio.text;
                }
            }
        }
     
        if([self.labelNombreDominio.text isEqualToString:@""] || [self.labelNombreDominio.text isEqualToString:@"(null)"] || self.labelNombreDominio == nil ) {
            for(int i= 0; i< [self.arregloDominio count]; i++){
                DominiosUsuario *usuarioDom = [self.arregloDominio objectAtIndex:i];
                if([usuarioDom.domainType isEqualToString:@"recurso"]){
                    [self.labelNombreDominio setText:usuarioDom.urlSitio];
                    self.dominioParaCompartir = usuarioDom.urlSitio;
                 
                }
            }
        }
    
    }
    
  
	
	self.label1.text = NSLocalizedString(@"compartirEtiqueta1", nil);
	self.label2.text = NSLocalizedString(@"compartirLabel2", nil);
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"NBlila.png"];
	}
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonNotificaciones setBackgroundImage:[UIImage imageNamed:@"shareEn.png"] forState:UIControlStateNormal];
       /* if(IS_STANDARD_IPHONE_6_PLUS){
            self.vistaContenidoCompartir.frame = CGRectMake(70, 80, 287, 130);
        } else
            */
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            self.vistaContenidoCompartir.frame = CGRectMake(50, 80, 287, 130);
        }else if(IS_IPAD){
            self.label1.frame = CGRectMake(134, 70, 500, 80);
            [self.label1 setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            [self.labelNombreDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
            self.vistaContenidoCompartir.frame = CGRectMake(134, 180, 500, 160);
        }else{
            self.vistaContenidoCompartir.frame = CGRectMake(17, 105, 287, 130);
        }
        
	}else{
		[self.botonNotificaciones setBackgroundImage:[UIImage imageNamed:@"micompartiron.png"] forState:UIControlStateNormal];
       /* if(IS_STANDARD_IPHONE_6_PLUS){
            self.vistaContenidoCompartir.frame = CGRectMake(70, 80, 287, 130);
        } else*/
        if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
            self.vistaContenidoCompartir.frame = CGRectMake(50, 80, 287, 130);
        }else if(IS_IPAD){
            self.label1.frame = CGRectMake(184, 70, 400, 60);
            self.vistaContenidoCompartir.frame = CGRectMake(184, 180, 400, 130);
        }else{
            self.vistaContenidoCompartir.frame = CGRectMake(17, 105, 287, 130);
        }
	}
    
    if(IS_IPAD){
        [self.botonNotificaciones setFrame:CGRectMake(88, 10, 88, 80)];
    }else{
        [self.botonNotificaciones setFrame:CGRectMake(64, 14, 64, 54)];
    }
    self.navigationItem.rightBarButtonItem = Nil;
    
    [self.vistaInferior setHidden:NO];
    
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    if(datosUsuario.dominio == nil || [datosUsuario.dominio isEqualToString:@""] || (datosUsuario.dominio == (id)[NSNull null]) || [CommonUtils validarEmail:datosUsuario.dominio] || [datosUsuario.dominio isEqualToString:@"(null)"]){
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"msjCompartirPublicar", Nil) andAlertViewType:AlertViewTypeQuestion];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regresar:(id)sender {

    MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
    [self.navigationController pushViewController:comparte animated:YES];

}

- (IBAction)compartirFacebook:(UIButton *)sender
{
    if ([CommonUtils hayConexion]) {
        [self publishWithWebDialog];
        [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Facebook"];
    } else{
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    
    }
}


- (void) publishWithWebDialog {
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      
                                      if (session.isOpen) {
                                          NSString *mensaje = nil;
                                          if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                                              mensaje =[NSString stringWithFormat: @"I just created a website with www.infomovil.com.\nCheck it out and help us grow!\n%@",self.dominioParaCompartir];
                                          }else{
                                              mensaje =[NSString stringWithFormat: @"Acabo de crear un sitio web con www.infomovil.com. ¡Visítalo y ayúdanos a crecer!\n%@",self.dominioParaCompartir];
                                          }
                                          NSMutableDictionary *params =
                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Infomovil", @"name",
                                           @"www.infomovil.com", @"caption",
                                           mensaje, @"description",
                                           @"www.infomovil.com/", @"link",
                                           @"http://infomovil.com/templates/Index/images/icn_infomovil_200.png",@"picture",
                                           nil];
                                          [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                                                 parameters:params
                                                                                    handler:
                                           ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                               if (error) {
                                                   [self checkErrorMessage:error];
                                               } else {
                                                   if (result == FBWebDialogResultDialogNotCompleted) {
#if DEBUG
                                                       NSLog(@"El usuario cancelo el post de face");
#endif
                                                   } else {
                                                       // Handle the publish feed callback
                                                       NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                       if (![urlParams valueForKey:@"post_id"]) {
                                                           //[self checkErrorMessage2: error];
                                                       } else {
                                                           // User clicked the Share button
                                                           //[self checkPostId:urlParams];
                                                           [self showAlert];
                                                       }
                                                   }
                                               }
                                           }];
                                          
                                      }}];
}


- (void)showAlert{
    
    [[[UIAlertView alloc] initWithTitle:@"Aviso"
                                message:NSLocalizedString(@"mensajePost",nil)
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    if (error.fberrorUserMessage) {
        errorMessage = error.fberrorUserMessage;
     
     } else {
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            errorMessage = @"Operation failed due to a connection problem, retry later.";
        }else{
            errorMessage = @"No hay conexión, inténtalo nuevamente.";
        }
    }

    [[[UIAlertView alloc] initWithTitle:@"Aviso"
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (IBAction)compartirTwitter:(UIButton *)sender {
    if ([CommonUtils hayConexion]) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            controller.completionHandler = ^(SLComposeViewControllerResult result){
#if DEBUG
                if (result == SLComposeViewControllerResultCancelled) {
                    NSLog(@"FB sharing cancelled");
                } else {
                    NSLog(@"FB sharing successful");
                }
#endif
                [self dismissViewControllerAnimated:YES completion:Nil];
            };
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                [controller setInitialText:[NSString stringWithFormat:@"I just created a website with www.infomovil.com.\nCheck it out and help us grow!\n%@",self.dominioParaCompartir]];
            }else{
                [controller setInitialText:[NSString stringWithFormat:@"Acabo de crear un sitio web con www.infomovil.com.\n¡Visítalo y ayúdanos a crecer!\n%@",self.dominioParaCompartir]];
            }
            
            [self presentViewController:controller animated:YES completion:nil];
        }
        else {
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://twitter.com/intent/tweet?text=I%%20just%%20created%%20a%%20mobile%%20website%%20with%%20www.infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0A%@" ,self.dominioParaCompartir]]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://twitter.com/intent/tweet?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20www.infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0A%@" ,self.dominioParaCompartir]]];
            }
        }
        
    }else{
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
        
    }
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Twitter"];
}

- (IBAction)compartirEmail:(UIButton *)sender {
	if ([MFMailComposeViewController canSendMail]){
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		
		NSString *message;
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[controller setSubject:@"Check our website"];
			message = [[NSString stringWithFormat:@"I just created a website with www.infomovil.com.\nCheck it out and help us grow!\n%@",self.dominioParaCompartir] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
		}else{
			[controller setSubject:@"Checa nuestro sitio web"];
			message = [[NSString stringWithFormat:@"Acabo de crear un sitio web con www.infomovil.com.\n¡Visítalo y ayúdanos a crecer!\n%@",self.dominioParaCompartir] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
		}
		
		[controller setMessageBody:message isHTML:YES];
		
        [self presentViewController:controller animated:YES completion:NULL];
	}else{
		AlertView * alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"configuracionCorreo", nil) andAlertViewType:AlertViewTypeInfo];
		[alert show];
	}
	

    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"E-mail"];
}

- (IBAction)compartirSMS:(UIButton *)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noSMS", Nil) andAlertViewType:AlertViewTypeInfo] show];
        return;
    }
	NSString *mensaje;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		mensaje = @"I just created a website with www.infomovil.com.\nCheck it out and help us grow!\n%@";
	}else{
		mensaje = @"Acabo de crear un sitio web con www.infomovil.com.\n¡Visítalo y ayúdanos a crecer!\n%@";
	}
	
    NSString *message = [NSString stringWithFormat: mensaje,self.dominioParaCompartir];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    
    [self presentViewController:messageController animated:YES completion:nil];

    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"SMS"];
}

- (IBAction)compartirWhatsapp:(UIButton *)sender {
  
	 NSURL *whatsappURL;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		 whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=I%%20just%%20created%%20a%%20website%%20with%%20www.infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0A%@", self.dominioParaCompartir]];
	}else{
		 whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20con%%20www.infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0A%@", self.dominioParaCompartir]];
	}
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noWhatsapp", Nil) andAlertViewType:AlertViewTypeInfo] show];
    }
	

    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"WhatsApp"];
}

- (IBAction)compartirGooglePlus:(id)sender
{
		id<GPPShareBuilder> shareBuilder2 = [[GPPShare sharedInstance] shareDialog];
				
		NSString *inputURL = self.dominioParaCompartir ;
		NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
		if (urlToShare) {
			[shareBuilder2 setURLToShare:urlToShare];
		}
	
	NSString *message;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		message = @"I just created a website with www.infomovil.com.\nCheck it out and help us grow!\n%@";
	}else{
		message = @"Acabo de crear un sitio web con www.infomovil.com.\n¡Visítalo y ayúdanos a crecer!\n%@";
	}
		
		NSString *inputText = [NSString stringWithFormat:message, self.dominioParaCompartir];
		NSString *text = [inputText length] ? inputText : nil;
		if (text) {
			[shareBuilder2 setPrefillText:text];
		}
		
		if (![shareBuilder2 open]) {
		}
	
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Google+"];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:Nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) mostrarActivity {
    self.alertActivity = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertActivity show];
}

-(void) ocultarActivity {
    if ( self.alertActivity )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertActivity hide];
    }
}

#pragma mark - GPPShareDelegate

- (void)finishedSharing:(BOOL)shared {

}

-(void)accionSi{
    self.datosUsuario = [DatosUsuario sharedInstance];
        if(self.datosUsuario.eligioTemplate){
            if( [self perfilEditado]) {
                NombrarViewController *comparte = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:Nil];
                [self.navigationController pushViewController:comparte animated:YES];
            }else{
                MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
                [self.navigationController pushViewController:comparte animated:YES];
                AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"editaPagina", Nil) andAlertViewType:AlertViewTypeInfo];
                [vistaNotificacion show];
            }
           
        }else{
            MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
            [self.navigationController pushViewController:comparte animated:YES];
            AlertView *vistaNotificacion = [AlertView initWithDelegate:self message:NSLocalizedString(@"eligeTemplate", Nil) andAlertViewType:AlertViewTypeInfo];
            [vistaNotificacion show];
        }
   
}
-(void)accionNo{
    MenuPasosViewController *comparte = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
    [self.navigationController pushViewController:comparte animated:YES];

}

-(BOOL) perfilEditado {
    BOOL fueEditado = NO;
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([self.datosUsuario.arregloEstatusEdicion count] > 0) {
        for (int i = 0; i < [self.datosUsuario.arregloEstatusEdicion count]; i++) {
            if ([[self.datosUsuario.arregloEstatusEdicion objectAtIndex:i]  isEqual: @YES]) {
                fueEditado = YES;
                break;
            }
        }
    }
    return fueEditado;
}

@end
