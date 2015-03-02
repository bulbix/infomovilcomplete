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
#import "GTLPlusConstants.h"
#import "AppsFlyerTracker.h"
@class GPPSignInButton;



@interface CompartirViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) AlertView *alertActivity;

@end

@implementation CompartirViewController

@synthesize signInButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.datosUsuario = [DatosUsuario sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
   [self.botonNotificaciones setFrame:CGRectMake(64, 14, 64, 54)];
    self.navigationItem.rightBarButtonItem = Nil;
	
	
	[super viewDidLoad];
	
	
	
	
	
}

-(void) viewWillAppear:(BOOL)animated {
	
    [self.labelNombreDominio setText:[NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio]];
	
	self.label1.text = NSLocalizedString(@"compartirLabel1", nil);
	self.label2.text = NSLocalizedString(@"compartirLabel2", nil);
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"compartir", @" ") nombreImagen:@"NBlila.png"];
	}
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonNotificaciones setBackgroundImage:[UIImage imageNamed:@"shareEn.png"] forState:UIControlStateNormal];
		self.vistaContenidoCompartir.frame = CGRectMake(17, 80, 287, 130);
	}else{
		[self.botonNotificaciones setBackgroundImage:[UIImage imageNamed:@"micompartiron.png"] forState:UIControlStateNormal];
	}
	[self.botonNotificaciones setFrame:CGRectMake(64, 14, 64, 54)];
    self.navigationItem.rightBarButtonItem = Nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regresar:(id)sender {

		[self.navigationController popToViewController:((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView
											  animated:YES];

}

- (IBAction)compartirFacebook:(UIButton *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {

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
			[controller setInitialText:[NSString stringWithFormat: @"I just created a website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio]];
		}else{
			[controller setInitialText:[NSString stringWithFormat: @"Acabo de crear un sitio web con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio]];
		}
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
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
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Facebook" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Facebook"];
}

- (IBAction)compartirTwitter:(UIButton *)sender {
//    NSString *message = NSLocalizedString(@"mensajeTwitter", Nil);
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
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
			[controller setInitialText:[NSString stringWithFormat:@"I just created a website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio]];
		}else{
			[controller setInitialText:[NSString stringWithFormat:@"Acabo de crear un sitio web con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio]];
		}
       
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=I%%20just%%20created%%20a%%20mobile%%20website%%20with%%20infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0Awww.%@.tel" ,self.datosUsuario.dominio]]];
		}else{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0Awww.%@.tel" ,self.datosUsuario.dominio]]];
		}
    }
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Twitter" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Twitter"];
}

- (IBAction)compartirEmail:(UIButton *)sender {
	if ([MFMailComposeViewController canSendMail]){
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		
		NSString *message;
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[controller setSubject:@"Check our website"];
			message = [[NSString stringWithFormat:@"I just created a website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
		}else{
			[controller setSubject:@"Checa nuestro sitio web"];
			message = [[NSString stringWithFormat:@"Acabo de crear un sitio web con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
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

- (IBAction)compartirSMS:(UIButton *)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noSMS", Nil) andAlertViewType:AlertViewTypeInfo] show];
        return;
    }
	NSString *mensaje;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		mensaje = @"I just created a website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel";
	}else{
		mensaje = @"Acabo de crear un sitio web con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel";
	}
	
    NSString *message = [NSString stringWithFormat: mensaje,self.datosUsuario.dominio];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    
    [self presentViewController:messageController animated:YES completion:nil];
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir SMS" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"SMS"];
}

- (IBAction)compartirWhatsapp:(UIButton *)sender {
	 NSURL *whatsappURL;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		 whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=I%%20just%%20created%%20a%%20mobile%%20website%%20with%%20infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0Awww.%@.tel", self.datosUsuario.dominio]];
	}else{
		 whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0Awww.%@.tel", self.datosUsuario.dominio]];
	}
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noWhatsapp", Nil) andAlertViewType:AlertViewTypeInfo] show];
    }
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir WhatsApp" withValue:@""];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"WhatsApp"];
}

- (IBAction)compartirGooglePlus:(id)sender
{
		id<GPPShareBuilder> shareBuilder2 = [[GPPShare sharedInstance] shareDialog];
				
		NSString *inputURL = [self.datosUsuario.dominio stringByAppendingString:@".tel"] ;//@"http://developers.google.com/+/mobile/ios/";
		NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
		if (urlToShare) {
			[shareBuilder2 setURLToShare:urlToShare];
		}
	
	NSString *message;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		message = @"I just created a website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel";
	}else{
		message = @"Acabo de crear un sitio web con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel";
	}
		
		NSString *inputText = [NSString stringWithFormat:message, self.datosUsuario.dominio];
		NSString *text = [inputText length] ? inputText : nil;
		if (text) {
			[shareBuilder2 setPrefillText:text];
		}
		
		if (![shareBuilder2 open]) {
		}
	
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Google+" withValue:@""];
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

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
//	NSLog(@"Received error %@ and auth object %@",error, auth);
	if (error) {
		// Haz algún error de control aquí.
	} else {
		
	}

}



@end
