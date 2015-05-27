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
@interface TipsViewController () <FBLoginViewDelegate>{
    NSInteger pagSeleccionada;
}
@property (nonatomic, strong) NSMutableArray *arregloDominio;
@property (nonatomic, strong) NSString *dominioParaCompartir;
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
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"public_profile", @"email"];
   
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
#if DEBUG
                                          NSLog(@"Entrando a sesion activa");
#endif
                                      }];
    }
    
    
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"barrarosa.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"NBrosa.png"];
    }
    self.navigationItem.rightBarButtonItem = Nil;
    
    
    self.vistaTip1.layer.cornerRadius = 5.0f;
    self.vistaTip2.layer.cornerRadius = 5.0f;
    self.vistaTip3.layer.cornerRadius = 5.0f;
    
    /*if(IS_STANDARD_IPHONE_6_PLUS){
        self.view.frame = CGRectMake(0, 0, 414, 736);
        self.scrollVistaTips.frame = CGRectMake(0, 50, 414, 300);
        [self.scrollVistaTips setContentSize:CGSizeMake(1242, 300)];
        self.vistaTip1.frame = CGRectMake( 57, 0, 300,300 );
        self.vistaTip2.frame = CGRectMake( 471, 0, 300,300 );
        self.vistaTip3.frame = CGRectMake( 885, 0, 300,300 );
        self.myPageControl.frame = CGRectMake(157, 410, 100, 37);
        
        [self.btnFace setFrame:CGRectMake(29, 150, 47, 47)];
        [self.btnGoogle setFrame:CGRectMake(126, 150, 47, 47)];
        [self.btnTwit setFrame:CGRectMake(223, 150, 47, 47)];
        [self.btnEmail setFrame:CGRectMake(29, 230, 47, 47)];
        [self.btnSms setFrame:CGRectMake(126, 230, 47, 47)];
        [self.btnWhats setFrame:CGRectMake(223, 230, 47, 47)];
        
    }else 
     */
     if(IS_IPAD){
        self.view.frame = CGRectMake(0, 0, 768, 1024);
        self.scrollVistaTips.frame = CGRectMake(0, 100, 768, 600);
        [self.scrollVistaTips setContentSize:CGSizeMake(2304, 600)];
        self.vistaTip1.frame = CGRectMake( 84, 0, 600,600 );
        self.vistaTip2.frame = CGRectMake( 852, 0, 600,600 );
        self.vistaTip3.frame = CGRectMake( 1620, 0, 600,600 );
        self.myPageControl.frame = CGRectMake(334, 750, 100, 37);
        
        [self.btnFace setFrame:CGRectMake(150, 280, 60, 60)];
        [self.btnGoogle setFrame:CGRectMake(270, 280, 60, 60)];
        [self.btnTwit setFrame:CGRectMake(390, 280, 60, 60)];
        [self.btnEmail setFrame:CGRectMake(150, 400, 60, 60)];
        [self.btnSms setFrame:CGRectMake(270, 400, 60 ,60)];
        [self.btnWhats setFrame:CGRectMake(390, 400, 60, 60)];
        
        self.seccionUnoTItulo.frame = CGRectMake(40, 10, 520, 60);
        [self.seccionUnoTItulo setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.seccionUnoLabel1.frame = CGRectMake(40, 80, 520, 100);
        self.seccionUnoLabel2.frame = CGRectMake(40, 150, 520, 60);
        self.seccionUnoLabel3.frame =CGRectMake(40, 220, 520, 60);
        self.seccionUnoLabel4.frame = CGRectMake(40, 290, 520, 60);
        self.b1.frame = CGRectMake(20, 180, 10, 10);
        self.b2.frame = CGRectMake(20, 250, 10, 10);
        self.b3.frame = CGRectMake(20, 320, 10, 10);
       
        self.seccionTresTitulo.frame = CGRectMake(40, 10, 520, 60);
        [self.seccionTresTitulo setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.seccionTresLabel1.frame = CGRectMake(40, 80, 520, 60);
        self.seccionTresLabel2.frame = CGRectMake(40, 150, 520, 60);
        self.seccionTresLabel3.frame = CGRectMake(40, 220, 520, 60);
       
        self.b4.frame = CGRectMake(20, 110, 10, 10);
        self.b5.frame = CGRectMake(20, 180, 10, 10);
        self.b6.frame = CGRectMake(20, 250, 10, 10);
        
        self.seccionCuatroTitulo.frame = CGRectMake(40, 10, 520, 60);
        [self.seccionCuatroTitulo setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        self.seccionCuatroLabel1.frame = CGRectMake(40, 80, 520, 60);
        
    }else{
        [self.scrollVistaTips setContentSize:CGSizeMake(960, 312)];
        self.myPageControl.frame = CGRectMake(112, 300, 97, 37);
    }

}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
#ifdef _DEBUG
    NSLog(@"Entrando a loginViewShowingLoggedInUser:");
#endif
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
    
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSLog(@"EL USUARIO DOMINIO ES: %@", self.datosUsuario.dominio);
    if(self.datosUsuario.dominio && ![self.datosUsuario.dominio isEqualToString:@""] && ! (self.datosUsuario.dominio == (id)[NSNull null]) && ![CommonUtils validarEmail:self.datosUsuario.dominio] && ![self.datosUsuario.dominio isEqualToString:@"(null)"]){
        self.arregloDominio = self.datosUsuario.dominiosUsuario;
        self.dominioParaCompartir = @"";
        NSLog(@"LA CANTIDAD DE DOMINIOS SON: %lu", (unsigned long)[self.arregloDominio count]);
        for(int i= 0; i< [self.arregloDominio count]; i++){
            DominiosUsuario *usuarioDom = [self.arregloDominio objectAtIndex:i];
            NSLog(@"EL USUARIODOM CON TIPO DE DOMINIO: %@", usuarioDom.domainType);
            NSLog(@"EL USUARIODOM VIGENTE: %@", usuarioDom.vigente);
            if([usuarioDom.domainType isEqualToString:@"tel"]){
                NSLog(@"EL DOMINIO FUE TEL ");
                if([usuarioDom.vigente isEqualToString:@"SI"] || [usuarioDom.vigente isEqualToString:@"si"]){
                    NSLog(@"EL DOMINIO FUE VIGENTE ");
                    self.dominioParaCompartir = [NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio];
                }
            }
        }
        NSLog(@"EL VALOR DEL TITULO ES: %@", self.dominioParaCompartir);
        if([self.dominioParaCompartir isEqualToString:@""] || [self.dominioParaCompartir isEqualToString:@"(null)"] || self.dominioParaCompartir == nil ) {
            for(int i= 0; i< [self.arregloDominio count]; i++){
                DominiosUsuario *usuarioDom = [self.arregloDominio objectAtIndex:i];
                if([usuarioDom.domainType isEqualToString:@"recurso"]){
                    NSLog(@"EL DOMINIO FUE RECURSO ");
                    self.dominioParaCompartir = [NSString stringWithFormat:@"www.infomovil.com/%@", self.datosUsuario.dominio];
                }
            }
        }
        
    }
    
    
    
    
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"barrarosa.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tituloTips", @" ") nombreImagen:@"NBrosa.png"];
    }
	
	self.seccionUnoTItulo.text = NSLocalizedString(@"tipsTitulo1", nil);
    if([self.datosUsuario.tipoDeUsuario isEqualToString:@"canal"]){
        self.seccionUnoLabel1.text = [NSString stringWithFormat:NSLocalizedString(@"tipsLabel11", nil), self.datosUsuario.dominio];
    }else if([self.datosUsuario.tipoDeUsuario isEqualToString:@"normal"]){
        self.seccionUnoLabel1.text = [NSString stringWithFormat:NSLocalizedString(@"tipsLabel111", nil), self.datosUsuario.dominio];
    }else{
        self.seccionUnoLabel1.text = [NSString stringWithFormat:NSLocalizedString(@"tipsLabel11", nil), self.datosUsuario.dominio];
    }
    
	self.seccionUnoLabel2.text = NSLocalizedString(@"tipsLabel12", nil);
	self.seccionUnoLabel3.text = NSLocalizedString(@"tipsLabel13", nil);
	self.seccionUnoLabel4.text = NSLocalizedString(@"tipsLabel14", nil);
	self.seccionTresTitulo.text = NSLocalizedString(@"tipsTitulo3", nil);
	self.seccionTresLabel1.text = NSLocalizedString(@"tipsLabel31", nil);
	self.seccionTresLabel2.text = NSLocalizedString(@"tipsLabel32", nil);
	self.seccionTresLabel3.text = NSLocalizedString(@"tipsLabel33", nil);
	self.seccionCuatroTitulo.text = NSLocalizedString(@"tipsTitulo4", nil);
	self.seccionCuatroLabel1.text = NSLocalizedString(@"tipsLabel41", nil);

	
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
                                           @"http://info-movil.com:8080/templates/Index/images/icn_infomovil_200.png",@"picture",
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





- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url
                             sourceApplication:sourceApplication];
    
    // add app-specific handling code here
    return wasHandled;
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

- (void)checkErrorMessage2:(NSError *)error {
    NSString *errorMessage = @"";
    if (error.fberrorUserMessage) {
        errorMessage = error.fberrorUserMessage;
    } else {
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            errorMessage = @"It has not been connected to facebook, try again.";
        }else{
            errorMessage = @"No te has conectado a facebook, inténtalo nuevamente.";
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
		mensaje = @"I just created a website with www.infomovil.com.\nCheck it out and help us grow!\n%@";
	}else{
		mensaje = @"Acabo de crear un sitio web con www.infomovil.com.\n¡Visítalo y ayúdanos a crecer!\n%@";
	}
	
    //NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat: mensaje,self.dominioParaCompartir];
    
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

- (IBAction)compartirGooglePlus:(id)sender {
	
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
		NSLog(@"COMPARTIR GMAIL con la cadena %@", text);
        [shareBuilder2 setPrefillText:text];
	}
   
   
	if (![shareBuilder2 open]) {
		//shareStatus_.text = @"Status: Error (see console).";
	}
	
    [self enviarEventoGAconCategoria:@"Compartir" yEtiqueta:@"Google+"];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:Nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    
}




@end
