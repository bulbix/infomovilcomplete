//
//  VistaVideoViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "VistaVideoViewController.h"
#import "WS_HandlerVideo.h"
#import "MainViewController.h"

@interface VistaVideoViewController () {
    NSString *idVideoSel;
    BOOL exito;
	
	VideoModel * respaldo;
}

@property (nonatomic, strong) AlertView *alertVideo;

@end

@implementation VistaVideoViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    [self.webView setDelegate:self];
    [self.webView setUserInteractionEnabled:YES];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    self.datosUsuario = [DatosUsuario sharedInstance];
	 respaldo = self.datosUsuario.videoSeleccionado;
    if (self.videoSeleccionado == nil) {
        self.videoSeleccionado = self.datosUsuario.videoSeleccionado;
    }
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"NBverde.png"];
	}
	NSString *htmlString;

    
    if(IS_IPAD){
        htmlString = @"<html><head>\
        <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 768\"/></head>\
        <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
        <iframe id=\"ytplayer\" type=\"text/html\" width=\"768\" height=\"700\"\
        src=\"%@?autoplay=0\"\
        frameborder=\"0\"/>\
        </body></html>";
    
   /* }else if(IS_STANDARD_IPHONE_6_PLUS){
        htmlString = @"<html><head>\
        <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 414\"/></head>\
        <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
        <iframe id=\"ytplayer\" type=\"text/html\" width=\"414\" height=\"400\"\
        src=\"%@?autoplay=0\"\
        frameborder=\"0\"/>\
        </body></html>";
    */
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        htmlString = @"<html><head>\
        <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 414\"/></head>\
        <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
        <iframe id=\"ytplayer\" type=\"text/html\" width=\"375\" height=\"270\"\
        src=\"%@?autoplay=0\"\
        frameborder=\"0\"/>\
        </body></html>";
    
    }else{
		htmlString = @"<html><head>\
		<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 320\"/></head>\
		<body style=\"background:#000;margin-top:0px;margin-left:0px\">\
		<iframe id=\"ytplayer\" type=\"text/html\" width=\"320\" height=\"240\"\
		src=\"%@?autoplay=0\"\
		frameborder=\"0\"/>\
		</body></html>";
    }
		htmlString = [NSString stringWithFormat:htmlString, self.videoSeleccionado.linkSolo];
 
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.vistaInferior setHidden:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regresar:(id)sender {
    AlertView *alertView;
    if (self.modifico && [CommonUtils hayConexion]) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        NSArray *vcs = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count-3] animated:YES];
    }
}

-(IBAction)guardarInformacion:(id)sender {
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.datosUsuario.videoSeleccionado = self.videoSeleccionado;
    self.datosUsuario.urlVideo = self.videoSeleccionado.linkSolo;//[NSString stringWithFormat:@"//www.youtube.com/embed/%@", idVideoSel];
    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:6 withObject:@YES];
    self.modifico = NO;
    
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(agregarVideo) withObject:Nil];
    
}

-(void) accionNo {
    self.datosUsuario.videoSeleccionado = Nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) accionSi {
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.datosUsuario.videoSeleccionado = self.videoSeleccionado;
//    self.datosUsuario.urlVideo = self.videoSeleccionado.linkSolo;
    self.datosUsuario.urlVideo = self.videoSeleccionado.linkSolo; //[NSString stringWithFormat:@"//www.youtube.com/embed/%@", idVideoSel];
    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:6 withObject:@YES];
    self.modifico = NO;
   
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(agregarVideo) withObject:Nil];
    
}

-(void) accionAceptar {
    if (exito) {
        NSArray *vcs = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count-3] animated:YES];
    }
    
}

-(void)  mostrarActivity {
    self.alertVideo = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertVideo show];
}

-(void) ocultarActivity {
    if (self.alertVideo)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertVideo hide];
    }
    if (exito) {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }else{
		[self revertirGuardado];
	}
}

-(void) agregarVideo {
  
        WS_HandlerVideo *handlerVideo = [[WS_HandlerVideo alloc] init];
        [handlerVideo setVideoDelegate:self];
        [handlerVideo insertarVideo];
   
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
    
        [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Video"];
        exito = YES;
    }
    else {
        exito = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertVideo)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertVideo hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar {
    if (self.alertVideo)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertVideo hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo] show];
	[self revertirGuardado];
}

-(void)revertirGuardado{
	self.datosUsuario.videoSeleccionado = respaldo;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.mediaPlaybackRequiresUserAction=NO;
}

@end
