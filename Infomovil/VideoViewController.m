//
//  VideoViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "VideoViewController.h"
#import "SeleccionaVideoViewController.h"
#import "EditarVideoViewController.h"
#import "VistaVideoViewController.h"
#import "WS_HandlerVideo.h"
#import "JsonParserVideo.h"
#import "MainViewController.h"

@interface VideoViewController () {
    //    BOOL modifico;
    BOOL elimino;
    BOOL exito;
	
}

@property (nonatomic, strong) AlertView *alertaVideo;
@property (nonatomic, strong) NSString *idVideo;

@end

@implementation VideoViewController

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
    [self.scrollVideo setContentSize:CGSizeMake(320, 450)];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"NBverde.png"];
	}
    self.txtUrlVideo.layer.cornerRadius = 5.0f;
    
    self.navigationItem.rightBarButtonItem = Nil;
    [self.labelBuscaYoutube setText:NSLocalizedString(@"buscaVideo", Nil)];
    [self.labelDatosVideo setText:NSLocalizedString(@"datosVideo", Nil)];
    [self.labelTituloVideo setText:NSLocalizedString(@"tituloVideo", Nil)];
    [self.labelAutorVideo setText:NSLocalizedString(@"autorVideo", Nil)];
    [self.labelCategoriaVideo setText:NSLocalizedString(@"categoriaVideo", Nil)];
    [self.labelUrlVideo setText:NSLocalizedString(@"labelURLVideo", Nil)];
    self.buscarBtn.layer.cornerRadius = 12.0f;
    
    if(IS_IPAD){
        [self.vistaSeleccionaVideo setFrame:CGRectMake(0, 20, 768, 500 )];
        [self.labelBuscaYoutube setFrame:CGRectMake(84, 20, 600, 30)];
        [self.labelBuscaYoutube setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.logoYoutube setFrame:CGRectMake(284, 80, 200,81 )];
        [self.labelUrlVideo setFrame:CGRectMake(84, 180, 600, 80)];
        [self.labelUrlVideo setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.txtUrlVideo setFrame:CGRectMake(234, 260, 300, 35)];
        [self.buscarBtn setFrame:CGRectMake(234, 330, 300, 40)];
        [self.buscarBtn.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20]];
        [self.vistaVisualizaVideo setFrame:CGRectMake(0, 20, 768, 600)];
        [self.btnEliminar setFrame:CGRectMake( 520, 380, 29, 38)];
        [self.imagenVistaPrevia setFrame:CGRectMake(184, 40, 400, 300)];
        [self.vistaDatosVideo setFrame:CGRectMake(84, 60, 600, 300)];
        [self.btnPlayer setFrame:CGRectMake(184, 40, 400, 300)];
    }else if(IS_STANDARD_IPHONE_6_PLUS){
        [self.vistaSeleccionaVideo setFrame:CGRectMake(0, 20, 414, 500 )];
        [self.labelBuscaYoutube setFrame:CGRectMake(0, 20, 414, 30)];
        [self.logoYoutube setFrame:CGRectMake(100, 80, 200,81 )];
        [self.labelUrlVideo setFrame:CGRectMake(20, 180, 374, 80)];
        [self.txtUrlVideo setFrame:CGRectMake(50, 260, 300, 35)];
        [self.buscarBtn setFrame:CGRectMake(50, 330, 300, 40)];
        [self.vistaVisualizaVideo setFrame:CGRectMake(0, 20, 414, 600)];
        [self.btnEliminar setFrame:CGRectMake( 300, 380, 29, 38)];
        [self.imagenVistaPrevia setFrame:CGRectMake(30, 40, 350, 300)];
        [self.vistaDatosVideo setFrame:CGRectMake(0, 60, 414, 300)];
        [self.btnPlayer setFrame:CGRectMake(0, 40, 414, 300)];
        
    }
     [self.vistaInferior setHidden:NO];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSLog(@"EL VALOR DE VIDEO SELECCIONADO ES: %@ Y EL VALODE  URLVIDEO ES: %@", self.datosUsuario.videoSeleccionado, self.datosUsuario.urlVideo);
    if (self.datosUsuario.videoSeleccionado == Nil && self.datosUsuario.urlVideo == Nil) {
        [self.vistaSeleccionaVideo setHidden:NO];
        [self.vistaVisualizaVideo setHidden:YES];
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:6 withObject:@NO];
    }
    else {
        [self.vistaSeleccionaVideo setHidden:YES];
        [self.vistaVisualizaVideo setHidden:NO];
        if (self.datosUsuario.videoSeleccionado != Nil) {
            VideoModel *video = self.datosUsuario.videoSeleccionado;
            [self.imagenVistaPrevia setImage:video.imagenPrevia];
            [self.labelAutor setText:video.descripcionVideo];
            [self.labelTitulo setText:video.titulo];
            [self.labelCategoria setText:video.categoria];
            
        }
        else {
            NSArray *arregloUrl = [self.datosUsuario.urlVideo componentsSeparatedByString:@"/"];
            NSString *idVideo = [arregloUrl lastObject];
            
          
            [self.imagenVistaPrevia setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.ytimg.com/vi/%@/0.jpg", idVideo]]]]];
            
            if (self.datosUsuario.videoSeleccionado == Nil) {
                [self.vistaDatosVideo setHidden:YES];
            }
            else {
                [self.vistaDatosVideo setHidden:YES];
            }
        }
        
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:6 withObject:@YES];
    }
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"NBverde.png"];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)seleccionarProveedor:(UIButton *)sender {
    if ([CommonUtils hayConexion]) {
        SeleccionaVideoViewController *seleccionaVideo = [[SeleccionaVideoViewController alloc] initWithNibName:@"SeleccionaVideoViewController" bundle:Nil];//@"http://www.google.com.mx"
        [self.navigationController pushViewController:seleccionaVideo animated:YES];
    }
    else {
        AlertView *alerta = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alerta show];
    }
    
}

- (IBAction)verVideo:(UIButton *)sender {
    VistaVideoViewController *vistaVideo = [[VistaVideoViewController alloc] initWithNibName:@"VistaVideoViewController" bundle:Nil];
    [self.navigationController pushViewController:vistaVideo animated:YES];
}

- (IBAction)eliminarVideo:(UIButton *)sender {
    [self.vistaVisualizaVideo setHidden:YES];
    [self.vistaSeleccionaVideo setHidden:NO];
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.datosUsuario.videoSeleccionado = Nil;
    self.datosUsuario.urlVideo = Nil;
    [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:6 withObject:@NO];
   
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(actualizarVideo) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.txtUrlVideo.text.length == 0) {
        return NO;
    }
    [textField resignFirstResponder];
    [self buscarVideoConURL:Nil];
    return YES;
}

- (IBAction)buscarVideoConURL:(id)sender {
    NSString *strUrl = self.txtUrlVideo.text;
    NSLog(@"EL VIDEO ES: %@", self.txtUrlVideo.text);
    if ([CommonUtils validarYoutubeURL:strUrl] == NO) {
        self.idVideo = strUrl;
        self.tipoBusqueda = 1;
    }
    self.alertaVideo = [AlertView initWithDelegate:self message:@"" andAlertViewType:AlertViewTypeActivity];
    [self.alertaVideo show];
    [self performSelectorInBackground:@selector(consultarVideo) withObject:Nil];
    
}

-(void) consultarVideo {
    JsonParserVideo *parseVideo = [[JsonParserVideo alloc] init];
    [parseVideo setDelegate:self];
    [parseVideo buscarVideo:self.idVideo conTipo:self.tipoBusqueda];
}

-(void) terminaConsultaVideo {
    [self.alertaVideo hide];
    if (self.tipoBusqueda == 1) {
        SeleccionaVideoViewController *seleccionaVideo = [[SeleccionaVideoViewController alloc] initWithNibName:@"SeleccionaVideoViewController" bundle:Nil];
        [seleccionaVideo setArregloVideos:self.arregloVideos];
        [self.navigationController pushViewController:seleccionaVideo animated:YES];
    }
    else {
        self.datosUsuario = [DatosUsuario sharedInstance];
        if([self.arregloVideos count] > 0){
            self.datosUsuario.videoSeleccionado = [self.arregloVideos objectAtIndex:0];
            VistaVideoViewController *vistaVideo = [[VistaVideoViewController alloc] initWithNibName:@"VistaVideoViewController" bundle:Nil];
            vistaVideo.videoSeleccionado = [self.arregloVideos objectAtIndex:0];
            vistaVideo.modifico = YES;
            [self.navigationController pushViewController:vistaVideo animated:YES];
        }else{
            AlertView *alertInfo = [AlertView initWithDelegate:self message:NSLocalizedString(@"noVideo", Nil) andAlertViewType:AlertViewTypeInfo];
            [alertInfo show];
        }
    }
}

-(void) guardaURLVideo:(NSString *)urlVideo {
    self.urlVideo = urlVideo;
    
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    AlertView *alertView;
    if (self.modifico && [CommonUtils hayConexion]) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) accionAceptar {
    if (elimino && exito) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) mostrarActivity {
    self.alertaVideo = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaVideo show];
}

-(void) ocultarActivity {
    if (self.alertaVideo)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaVideo hide];
    }
}

-(void) actualizarVideo {
   
        WS_HandlerVideo *handlerVideo = [[WS_HandlerVideo alloc] init];
        [handlerVideo setVideoDelegate:self];
        [handlerVideo eliminarVideo];
   
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
     //   [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro Video" withValue:@""];
        [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Video"];
        exito = YES;
    }
    else {
        exito = NO;
    }
    
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertaVideo)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaVideo hide];
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
    if (self.alertaVideo)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaVideo hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}
-(void) resultadoVideo:(NSMutableArray*)arregloVideos {
    self.arregloVideos = arregloVideos;
    [self performSelectorOnMainThread:@selector(terminaConsultaVideo) withObject:Nil waitUntilDone:YES];
}

-(void)errorBusqueda{
 [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    AlertView *alerta = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"videoDesconocido", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
    [alerta show];

}

#pragma mark - UITextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField {
   // [self apareceTeclado:_scrollVideo withRefFrame:textField.frame];
    CGSize tamanioTeclado = CGSizeMake(320, 235);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height+20, 0);
    [self.scrollVideo setContentInset:edgeInsets];
    [self.scrollVideo setScrollIndicatorInsets:edgeInsets];
    [self.scrollVideo scrollRectToVisible:textField.frame animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
	[self desapareceElTeclado:_scrollVideo];
}
@end
