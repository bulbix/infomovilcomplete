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
    //    [self.tituloVista setText:NSLocalizedString(@"video", @" ")];
    // Do any additional setup after loading the view from its nib.
    [self.scrollVideo setContentSize:CGSizeMake(320, 450)];
    //    [self.vistaCircular setImage:[UIImage imageNamed:@"plecaverde.png"]];
    //    [self.vistaCircular setImage:[UIImage imageNamed:@"plecacreasitio.png"]];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"video", @" ") nombreImagen:@"NBverde.png"];
	}
    self.txtUrlVideo.layer.cornerRadius = 5.0f;
    
    //    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    //    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    //    [backButton setImage:image forState:UIControlStateNormal];
    //    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    self.navigationItem.leftBarButtonItem = buttonBack;
    
    self.navigationItem.rightBarButtonItem = Nil;
    [self.labelBuscaYoutube setText:NSLocalizedString(@"buscaVideo", Nil)];
    [self.labelDatosVideo setText:NSLocalizedString(@"datosVideo", Nil)];
    [self.labelTituloVideo setText:NSLocalizedString(@"tituloVideo", Nil)];
    [self.labelAutorVideo setText:NSLocalizedString(@"autorVideo", Nil)];
    [self.labelCategoriaVideo setText:NSLocalizedString(@"categoriaVideo", Nil)];
    [self.labelUrlVideo setText:NSLocalizedString(@"labelURLVideo", Nil)];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
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
            NSLog(@"el string del video es %@", self.datosUsuario.urlVideo);
            
            NSArray *arregloUrl = [self.datosUsuario.urlVideo componentsSeparatedByString:@"/"];
            NSString *idVideo = [arregloUrl lastObject];
            
            NSLog(@"El id es %@", idVideo); //http://i.ytimg.com/vi/rT_OmTMwvZI/3.jpg
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
        AlertView *alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"noConexion", @" ") andAlertViewType:AlertViewTypeInfo];
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
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
        if ([CommonUtils hayConexion]) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(actualizarVideo) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
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
    if ([CommonUtils validarYoutubeURL:strUrl]) {
        NSArray *arrayVideo;
        if ([strUrl rangeOfString:@"youtube"].location != NSNotFound) {
            arrayVideo = [strUrl componentsSeparatedByString:@"watch?v="];
        }
        else {
            arrayVideo = [strUrl componentsSeparatedByString:@"be/"];
        }
        
        if ([arrayVideo count] >= 2) {
            arrayVideo = [[arrayVideo objectAtIndex:1] componentsSeparatedByString:@"&"];
            self.idVideo = [arrayVideo objectAtIndex:0];
            //            NSLog(@"el id del video es %@", idVideo);
        }
        self.tipoBusqueda = 2;
    }
    else {
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
//        EditarVideoViewController *editarVideo = [[EditarVideoViewController alloc] initWithNibName:@"EditarVideoViewController" bundle:Nil];
//        [editarVideo setVideoSeleccionado:[self.arregloVideos objectAtIndex:0]];
//        [self.navigationController pushViewController:editarVideo animated:YES];
        self.datosUsuario = [DatosUsuario sharedInstance];
        self.datosUsuario.videoSeleccionado = [self.arregloVideos objectAtIndex:0];
        VistaVideoViewController *vistaVideo = [[VistaVideoViewController alloc] initWithNibName:@"VistaVideoViewController" bundle:Nil];
        vistaVideo.videoSeleccionado = [self.arregloVideos objectAtIndex:0];
        vistaVideo.modifico = YES;
        [self.navigationController pushViewController:vistaVideo animated:YES];
    }
}

-(void) guardaURLVideo:(NSString *)urlVideo {
    self.urlVideo = urlVideo;
    
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    AlertView *alertView;
    if (self.modifico) {
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
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerVideo *handlerVideo = [[WS_HandlerVideo alloc] init];
        [handlerVideo setVideoDelegate:self];
        [handlerVideo eliminarVideo];
    }
    else {
        if (self.alertaVideo)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertaVideo hide];
        }
        self.alertaVideo = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertaVideo show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
    self.alertaVideo = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertaVideo show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) sessionTimeout
{
    if (self.alertaVideo)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaVideo hide];
    }
    self.alertaVideo = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertaVideo show];
    [StringUtils terminarSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - UITextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField {
    [self apareceTeclado:_scrollVideo withRefFrame:textField.frame];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
	[self desapareceElTeclado:_scrollVideo];
}
@end
