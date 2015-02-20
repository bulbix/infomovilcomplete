//
//  TipsViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 23/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "TipsViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <GooglePlus/GooglePlus.h>
#import "AppsFlyerTracker.h"

@interface TipsViewController () {
    NSInteger pagSeleccionada;
}

@property (nonatomic, strong) AlertView *alertActivity;
@end

@implementation TipsViewController

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
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"barrarosa.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"NBrosa.png"];
    }
    self.navigationItem.rightBarButtonItem = Nil;
    [self.scrollVistaTips setContentSize:CGSizeMake(960, 312)];
    
    self.vistaTip1.layer.cornerRadius = 5.0f;
    self.vistaTip2.layer.cornerRadius = 5.0f;
    self.vistaTip3.layer.cornerRadius = 5.0f;
//    self.vistaTip4.layer.cornerRadius = 5.0f;
    
//    [self.myPageControl addTarget:self
//                           action:@selector(cambiarPagina:)
//                 forControlEvents:UIControlEventValueChanged];
    
//	if(IS_IPHONE_5){
//		self.myPageControl.frame = CGRectMake(112, 300, 97, 37);
//	}else{
		self.myPageControl.frame = CGRectMake(112, 300, 97, 37);
//	}

}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"barrarosa.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"NBrosa.png"];
    }
	
	self.seccionUnoTItulo.text = NSLocalizedString(@"tipsTitulo1", nil);
	self.seccionUnoLabel1.text = [NSString stringWithFormat:NSLocalizedString(@"tipsLabel11", nil), self.datosUsuario.dominio];
	self.seccionUnoLabel2.text = NSLocalizedString(@"tipsLabel12", nil);
	self.seccionUnoLabel3.text = NSLocalizedString(@"tipsLabel13", nil);
	self.seccionUnoLabel4.text = NSLocalizedString(@"tipsLabel14", nil);
	
//	self.seccionDosTitulo.text = NSLocalizedString(@"tipsTitulo2", nil);
//	self.seccionDosLabel1.text = NSLocalizedString(@"tipsLabel21", nil);
//	self.seccionDosLabel2.text = NSLocalizedString(@"tipsLabel22", nil);
//	self.seccionDosLabel3.text = NSLocalizedString(@"tipsLabel23", nil);
//	self.seccionDosLabel4.text = NSLocalizedString(@"tipsLabel24", nil);
	
	self.seccionTresTitulo.text = NSLocalizedString(@"tipsTitulo3", nil);
	self.seccionTresLabel1.text = NSLocalizedString(@"tipsLabel31", nil);
	self.seccionTresLabel2.text = NSLocalizedString(@"tipsLabel32", nil);
	self.seccionTresLabel3.text = NSLocalizedString(@"tipsLabel33", nil);
	
	self.seccionCuatroTitulo.text = NSLocalizedString(@"tipsTitulo4", nil);
	self.seccionCuatroLabel1.text = NSLocalizedString(@"tipsLabel41", nil);
	
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		self.seccionTresLabel2.frame = CGRectMake(37, 115, 243, 47);
		self.vineta32.frame = CGRectMake(17, 115, 12, 24);
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cambiarPagina:(UIPageControl *)sender {
    int page = self.myPageControl.currentPage;
    CGRect frame = self.scrollVistaTips.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollVistaTips scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
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
	//[[AppsFlyerTracker sharedTracker] trackEvent:@"Compartir Facebook" withValue:@""];
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
		NSLog(@"Twitter: %@",[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0A¡Visitalo%%20y%%20ayudanos%%20a%%20crecer!%%0Awww.%@.tel" ,self.datosUsuario.dominio]);
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

- (IBAction)compartirSMS:(UIButton *)sender {
    
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
	
	NSLog(@"La url whatsapp es %@, dominio:%@", whatsappURL,self.datosUsuario.dominio);
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else {
        [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noWhatsapp", Nil) andAlertViewType:AlertViewTypeInfo] show];
    }

    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"WhatsApp"];
}

- (IBAction)compartirGooglePlus:(id)sender {
	
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

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
