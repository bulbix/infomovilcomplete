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
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
@interface TipsViewController () {
    NSInteger pagSeleccionada;
}

@property (nonatomic, strong) AlertView *alertActivity;
@end

@implementation TipsViewController

@synthesize dialogoTwitter;
@synthesize dialogoFacebook;

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
    self.myPageControl.frame = CGRectMake(112, 300, 97, 37);


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
  
}

- (IBAction)compartirFacebook:(UIButton *)sender {

    [self publishWithWebDialog];
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Facebook"];
    
    
}

- (void) publishWithWebDialog {
    NSString *mensaje = nil;
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        mensaje =[NSString stringWithFormat: @"I just created a website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio];
    }else{
        mensaje =[NSString stringWithFormat: @"Acabo de crear un sitio web con infomovil.com. ¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio];
    }
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Infomovil", @"name",
     @"http://infomovil.com", @"caption",
     mensaje, @"description",
     @"http://www.infomovil.com/", @"link",
     @"http://info-movil.com/images/259-X-49.png",@"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             [self checkErrorMessage:error];
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
               //  [self showAlertCancel];
                 NSLog(@"El usuario cancelo el post de face");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     [self checkErrorMessage: error];
                 } else {
                     // User clicked the Share button
                    //[self checkPostId:urlParams];
                     [self showAlert];
                 }
             }
         }
     }];
}






- (void)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    if (error.fberrorUserMessage) {
        errorMessage = error.fberrorUserMessage;
    } else {
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            errorMessage = @"Operation failed due to a connection problem, retry later.";
        }else{
            errorMessage = @"No hay conexión, intentalo nuevamente.";
            }
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Aviso"
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void ) checkPostId:(NSDictionary *)results {
    NSString *message = nil;
    if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
        message = @"Posted successfully.";
    }else{
        message = @"Se completo el post.";
    }
    // Share Dialog
    NSString *postId = results[@"postId"];
    if (!postId) {
        // Web Dialog
        postId = results[@"post_id"];
    }
    if (postId) {
        message = [NSString stringWithFormat:@"Posted story, id: %@", postId];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Aviso"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
  
}
- (void)showAlert{
   
        [[[UIAlertView alloc] initWithTitle:@"Aviso"
                                    message:NSLocalizedString(@"mensajePost",nil)
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
   /* if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {

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

		NSLog(@"Twitter: %@",[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0A¡Visitalo%%20y%%20ayudanos%%20a%%20crecer!%%0Awww.%@.tel" ,self.datosUsuario.dominio]);
		if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=I%%20just%%20created%%20a%%20mobile%%20website%%20with%%20infomovil.com.%%0ACheck%%20it%%20out%%20and%%20help%%20us%%20grow%%0Awww.%@.tel" ,self.datosUsuario.dominio]]];
		}else{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://twitter.com/intent/tweet?text=Acabo%%20de%%20crear%%20un%%20sitio%%20web%%20movil%%20con%%20infomovil.com.%%0AVisitalo%%20y%%20ayudanos%%20a%%20crecer%%0Awww.%@.tel" ,self.datosUsuario.dominio]]];
		}
		
		
    }
*/
    NSString *mensaje = nil;
    NSString *titulo = nil;
    NSString *advertencia = nil;
    if ([TWTweetComposeViewController canSendTweet])
    {
       
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            mensaje = [NSString stringWithFormat:@"I just created a website with infomovil.com.\nCheck it out and help us grow!\nwww.%@.tel",self.datosUsuario.dominio];
            titulo = @"Alert!";
            advertencia = @"Do not have a Twitter account linked to this device. Configure your account: \nAjustes the device-> Twitter";
        }else{
            mensaje = [NSString stringWithFormat:@"Acabo de crear un sitio web con infomovil.com.\n¡Visítalo y ayúdanos a crecer!\nwww.%@.tel",self.datosUsuario.dominio];
            titulo = @"Advertencia!";
            advertencia = @"No tienes una cuenta de Twitter vinculada a este dispositivo. Configura tu cuenta en:\nAjustes del dispositivo->Twitter";
        }
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        NSString *tweet = mensaje;
        [tweetSheet setInitialText:tweet];
        [tweetSheet addURL:[NSURL URLWithString:@"http://www.infomovil.com"]];
        [tweetSheet addImage:[UIImage imageNamed:@"icono57.png"]];
        [self presentModalViewController:tweetSheet animated:YES];
    } else {
        
        dialogoTwitter = [[UIAlertView alloc]
                          initWithTitle:titulo
                          message:advertencia
                          delegate:self
                          cancelButtonTitle:@"cancel"
                          otherButtonTitles:nil];
        [dialogoTwitter show];
        
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
