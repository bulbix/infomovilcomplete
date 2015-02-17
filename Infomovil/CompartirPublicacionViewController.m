//
//  CompartirPublicacionViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 19/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "CompartirPublicacionViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "MenuPasosViewController.h"
#import <GooglePlus/GooglePlus.h>
#import "AppsFlyerTracker.h"

@interface CompartirPublicacionViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation CompartirPublicacionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.guardarVista = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tituloVista setText:NSLocalizedString(@"compartir", @" ")];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecamagenta.png"]];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecacreasitio.png"]];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"felicidades", @" ") nombreImagen:@"roja.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"felicidades", @" ") nombreImagen:@"plecaroja.png"];
	}
	
    [self.labelDominio setText:[NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio]];
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    self.navigationItem.rightBarButtonItem = Nil;
	
	self.label1.text = NSLocalizedString(@"felicidades2", nil);
	self.label2.text = [NSString stringWithFormat:NSLocalizedString(@"fechas", nil),self.datosUsuario.fechaFinalTel] ;
//	self.label3.text = NSLocalizedString(@"valido", nil);
//	self.label4.text = NSLocalizedString(@"promueve", nil);
    self.label3.text = NSLocalizedString(@"promueve", nil);
	_labelPublicaTiempo.text = NSLocalizedString(@"tiempoPublica", nil);
	
	self.vistaInferior.hidden=YES;
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"roja.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"plecaroja.png"];
		
	}
	self.vistaInferior.hidden=YES;
	self.vistaInferior.hidden=YES;
	self.vistaInferior.hidden=YES;
	self.vistaInferior.hidden=YES;
	self.vistaInferior.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)compartirFacebook:(UIButton *)sender {
//    NSString *message = NSLocalizedString(@"mensajeGoogle", Nil);
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
		// [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
		//[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        controller.completionHandler = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"FB sharing cancelled");
            } else {
                NSLog(@"FB sharing successful");
            }
			
            [self dismissViewControllerAnimated:YES completion:Nil];
        };
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[controller setInitialText:[NSString stringWithFormat: @"I just created a mobile website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio]];
		}else{
			[controller setInitialText:[NSString stringWithFormat: @"Acabo de crear un sitio web móvil con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio]];
		}
		//        [controller addURL:currentDomain.absoluteUrl];
		//        if (currentDomain.logo.image != nil) {
		//            [controller addImage:currentDomain.logo.image];
		//        }
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
		
//		NSLog(@"Facebook: %@",[NSString stringWithFormat: @"http://www.facebook.com/sharer.php?u=www.%@.tel&t=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0A¡Visitalo%%20y%%20ayudanos%%20a%%20crecer!%%0Awww.%@.tel" ,self.datosUsuario.dominio,self.datosUsuario.dominio]);
//		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
//			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.facebook.com/sharer.php?u=www.%@.tel&t=I%%20just%%20created%%20a%%20mobile%%20website%%20with%%20infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0Awww.%@.tel" ,self.datosUsuario.dominio,self.datosUsuario.dominio]]];
//			
//		}else{
//			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.facebook.com/sharer.php?u=www.%@.tel&t=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0Awww.%@.tel" ,self.datosUsuario.dominio,self.datosUsuario.dominio]]];
//		}
        NSString *strSharer = [NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=http://www.%@.tel" ,self.datosUsuario.dominio];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strSharer]];
        NSLog(@"%@",strSharer);
    }
//	[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Facebook" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Facebook"];
}

- (IBAction)compartirTwitter:(UIButton *)sender {
//    NSString *message = NSLocalizedString(@"mensajeTwitter", Nil);
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
//		[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        controller.completionHandler = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"FB sharing cancelled");
            } else {
                NSLog(@"FB sharing successful");
            }
            [self dismissViewControllerAnimated:YES completion:Nil];
        };
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[controller setInitialText:[NSString stringWithFormat:@"I just created a mobile website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio]];
		}else{
			[controller setInitialText:[NSString stringWithFormat:@"Acabo de crear un sitio web móvil con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio]];
		}
		
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
		//        [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"notwitter", Nil) andAlertViewType:AlertViewTypeInfo] show];
		
//		NSString * aux = @"http://twitter.com/intent/tweet?text=Muy%20buen%20sitio%20web%20movil%0Awww.%@.tel";
		//aux = [[aux stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
//		NSLog(@"Twitter: %@",[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0A¡Visitalo%%20y%%20ayudanos%%20a%%20crecer!%%0Awww.%@.tel" ,self.datosUsuario.dominio]);
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=I%%20just%%20created%%20a%%20mobile%%20website%%20with%%20infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0Awww.%@.tel" ,self.datosUsuario.dominio]]];
		}else{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0Awww.%@.tel" ,self.datosUsuario.dominio]]];
		}
		
		
    }
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Twitter" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Twitter"];
}

- (IBAction)enviarEmail:(UIButton *)sender {

	if ([MFMailComposeViewController canSendMail]){
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		
		NSString *message;
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[controller setSubject:@"Check our mobile website"];
			message = [[NSString stringWithFormat:@"I just created a mobile website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
		}else{
			[controller setSubject:@"Checa nuestro sitio web móvil"];
			message = [[NSString stringWithFormat:@"Acabo de crear un sitio web móvil con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
		}
		
		[controller setMessageBody:message isHTML:YES];
		
        [self presentViewController:controller animated:YES completion:NULL];
	}else{
		AlertView * alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"configuracionCorreo", nil) andAlertViewType:AlertViewTypeInfo];
		[alert show];
	}
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Email" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"E-mail"];
}

- (IBAction)enviarSMS:(UIButton *)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noSMS", Nil) andAlertViewType:AlertViewTypeInfo] show];
        return;
    }
	NSString *mensaje;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		mensaje = @"I just created a mobile website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel";
	}else{
		mensaje = @"Acabo de crear un sitio web móvil con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel";
	}
	
    //NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat: mensaje,self.datosUsuario.dominio];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    //[messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir SMS" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"SMS"];
}

- (IBAction)compartirWhatsapp:(UIButton *)sender {

//	NSString *message = @"Checa este sitio web móvil\nwww.%@.tel";
//	message = [[message stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
	
	NSURL *whatsappURL;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=I%%20just%%20created%%20a%%20mobile%%20website%%20with%%20infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0Awww.%@.tel", self.datosUsuario.dominio]];
	}else{
		whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0Awww.%@.tel", self.datosUsuario.dominio]];
	}
	
//	NSLog(@"La url whatsapp es %@, dominio:%@", whatsappURL,self.datosUsuario.dominio);
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noWhatsapp", Nil) andAlertViewType:AlertViewTypeInfo] show];
    }
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir WhatsApp" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"WhatsApp"];
}

- (IBAction)compartirGooglePlus:(id)sender {

	
	/*GPPSignIn *signIn = [GPPSignIn sharedInstance];
	 // Previamente habrás configurado kClientID en el paso "Inicializa el cliente de Google+"
	 signIn.clientID = @"585514192998.apps.googleusercontent.com";
	 signIn.scopes = [NSArray arrayWithObjects:
	 kGTLAuthScopePlusLogin, // definido en GTLPlusConstants.h
	 nil];
	 signIn.delegate = self;
	 
	 //[signIn authenticate];
	 if (![signIn trySilentAuthentication]){
	 [signIn authenticate];
	 }*/
	
	/*GPPShare *gppShare = [GPPShare sharedInstance];
	 [[gppShare shareDialog] open];
	 
	 id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
	 
	 NSString *inputURL = [@"http://infomovil.com/" stringByAppendingString:self.datosUsuario.dominio] ;//@"http://developers.google.com/+/mobile/ios/";
	 NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
	 if (urlToShare) {
	 [shareBuilder setURLToShare:urlToShare];
	 }
	 NSString *message = NSLocalizedString(@"estoyLinea", Nil);
	 NSString *inputText = [NSString stringWithFormat:@"%@ http://infomovil.com/%@",message, self.datosUsuario.dominio];
	 NSString *text = [inputText length] ? inputText : nil;
	 if (text) {
	 [shareBuilder setPrefillText:text];
	 }
	 
	 //[shareBuilder open];
	 
	 NSLog(@"Aqui");
	 if (![shareBuilder open]) {
	 NSLog(@"Aqui2");*/
	id<GPPShareBuilder> shareBuilder2 = [[GPPShare sharedInstance] shareDialog];
	
	NSString *inputURL = [self.datosUsuario.dominio stringByAppendingString:@".tel"] ;//@"http://developers.google.com/+/mobile/ios/";
	NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
	if (urlToShare) {
		[shareBuilder2 setURLToShare:urlToShare];
	}
	
	NSString *message;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		message = @"I just created a mobile website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel";
	}else{
		message = @"Acabo de crear un sitio web móvil con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel";
	}
	
	NSString *inputText = [NSString stringWithFormat:message, self.datosUsuario.dominio];
	NSString *text = [inputText length] ? inputText : nil;
	if (text) {
		[shareBuilder2 setPrefillText:text];
	}
	
	if (![shareBuilder2 open]) {
		//shareStatus_.text = @"Status: Error (see console).";
	}
	//}
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Google+" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Google+"];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:Nil];
}

-(IBAction)regresar:(id)sender {
//    if (self.datosUsuario.vistaOrigen == 12) {
//        NSArray *vcs = [self.navigationController viewControllers];
//        [self.navigationController popToViewController:[vcs objectAtIndex:[vcs count]-3] animated:YES];
//    }
//    else {
        if (self.tipoVista == 1) {
//        MenuPasosViewController *menuPasos = [[MenuPasosViewController alloc] initWithNibName:@"MenuPasosViewController" bundle:Nil];
//        [self.na]
            [self.delegado tipoCuentView];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
        }
//	}
	
}

#pragma mark - Métodos delegados de MessageUI

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"errorSMS", Nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end