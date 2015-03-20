//
//  GaleriaPaso2ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "GaleriaPaso2ViewController.h"
#import "GaleriaImagenes.h"
#import "JFRandom.h"
#import "WS_HandlerGaleria.h"
#import "OffertRecord.h"
#import "NSStringUtiles.h"


@interface GaleriaPaso2ViewController () {
    UITextField *textoPieFoto;
    NSInteger imagenes;
//    BOOL self.modifico;
    BOOL exitoModificar;
    BOOL estaBorrando;
    NSInteger idImagen;
    BOOL seleccionoImagen;
    BOOL esCamara;
	BOOL estaEditando;
	BOOL cambioPie;
    BOOL existeFoto;
    BOOL noEditando;
    
    UIImage *imagenTemp;

}

@property(nonatomic, strong) NSMutableArray *arregloImagenes;
@property(nonatomic, strong) GaleriaImagenes *imagenActual;
@property (nonatomic, strong) AlertView *alertGaleria;
@property(nonatomic, strong) UIImage *imagenTemp;

@end

@implementation GaleriaPaso2ViewController

@synthesize pieFoto;
@synthesize imagenTemp;

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
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirImagen", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirImagen", @" ") nombreImagen:@"NBverde.png"];
	}
    
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.modifico = NO;
    
    [self.labelTituloFoto setText:NSLocalizedString(@"tituloFoto", Nil)];
    [self.labelTomarFoto setText:NSLocalizedString(@"tomarFoto", Nil)];
    [self.labelFotoExistente setText:NSLocalizedString(@"fotoExistente", Nil)];
    
    
    self.vistaTomar.layer.cornerRadius = 5.0f;
    self.vistaUsar.layer.cornerRadius = 5.0f;
    
    self.vistaPreviaImagen.layer.cornerRadius = 5.0f;
    self.vistaPreviaImagen.layer.masksToBounds = YES;
    
    self.pieFoto.layer.cornerRadius = 5.0f;
    imagenes = 0;
    [self.scrollFoto setContentSize:CGSizeMake(320, 240)];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.datosUsuario.arregloGaleriaImagenes.count > 0) {
        self.arregloImagenes = self.datosUsuario.arregloGaleriaImagenes;
    }
    else {
        self.arregloImagenes = [[NSMutableArray alloc] initWithCapacity:5];
    }
    [self acomodarVista];
    if (self.operacion == GaleriaImagenesEditar) {
        [self cargarVista];
        estaEditando = YES;
    }
    else {
        estaEditando = NO;
    }
    
    
    if(IS_STANDARD_IPHONE_6_PLUS){
        [self.vistaContenedorBoton setFrame:CGRectMake(70, 260, 280, 61)];
        [self.vistaTomar setFrame:CGRectMake(0, 0, 280, 30)];
        [self.vistaUsar setFrame:CGRectMake(0, 31, 280, 30)];
        [self.btnEliminar setFrame:CGRectMake(310, 370, 29, 35)];
        [self.labelTituloFoto setFrame:CGRectMake(70, 186 ,203, 21)];
        [self.pieFoto setFrame:CGRectMake(70,215 ,300 ,30 )];
    }else if(IS_STANDARD_IPHONE_6){
        [self.vistaContenedorBoton setFrame:CGRectMake(40, 260, 280, 61)];
        [self.vistaTomar setFrame:CGRectMake(0, 0, 280, 30)];
        [self.vistaUsar setFrame:CGRectMake(0, 31, 280, 30)];
        [self.btnEliminar setFrame:CGRectMake(270, 370, 29, 35)];
        [self.labelTituloFoto setFrame:CGRectMake(40, 186 ,203, 21)];
        [self.pieFoto setFrame:CGRectMake(40,215 ,300 ,30 )];
    }
}

-(void)viewWillAppear:(BOOL)animated{
	NSLog(@"id imagen: %i",self.imagenActual.idImagen);
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {//NSLocalizedString(@"anadirImagen", @" ")
		[self acomodarBarraNavegacionConTitulo:self.tituloPaso nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:self.tituloPaso nombreImagen:@"NBverde.png"];
	}
	[super viewWillAppear:animated];
}

-(void) acomodarVista {
    self.datosUsuario = [DatosUsuario sharedInstance];
    switch (self.galeryType) {
        case PhotoGaleryTypeLogo:
            [self.labelTituloFoto setHidden:YES];
            [self.pieFoto setHidden:YES];
            [self.vistaContenedorBoton setFrame:CGRectMake(20, 186, 280, 61)];
            [self.btnEliminar setFrame:CGRectMake(271, 257, 29, 35)];
            if (self.datosUsuario.imagenLogo != nil && (self.datosUsuario.imagenLogo.rutaImagen != nil && self.datosUsuario.imagenLogo.rutaImagen.length > 0)) {
                self.operacion = GaleriaImagenesEditar;
            }
            else {
                self.operacion = GaleriaImagenesAgregar;
            }
            
            break;
        case PhotoGaleryTypeOffer:
            [self.labelTituloFoto setHidden:YES];
            [self.pieFoto setHidden:YES];
            self.navigationItem.rightBarButtonItem = nil;
            [self.vistaContenedorBoton setFrame:CGRectMake(20, 186, 280, 61)];
            [self.btnEliminar setFrame:CGRectMake(271, 257, 29, 35)];
            if ( ![NSString isEmptyString:_strImagenPath ]  )
            {
                self.imagenActual = [[GaleriaImagenes alloc] init];
                [_imagenActual setRutaImagen:_strImagenPath];
                self.operacion = GaleriaImagenesEditar;
                estaEditando = YES;

            } else {
                self.imagenActual = [[GaleriaImagenes alloc] init];
            }
            break;
            
        default:
            break;
    }
}

-(void) cargarVista {
    self.datosUsuario = [DatosUsuario sharedInstance];
    
    switch (self.galeryType) {
        case PhotoGaleryTypeLogo:
            self.imagenActual = self.datosUsuario.imagenLogo;
            break;
        case PhotoGaleryTypeImage:
            self.imagenActual = [self.datosUsuario.arregloGaleriaImagenes objectAtIndex:self.index];
            break;
        case PhotoGaleryTypeOffer:
//            self.imagenActual = [[GaleriaImagenes alloc] init];
            break;
            
        default:
            break;
    }
    NSData *pngData = [NSData dataWithContentsOfFile:self.imagenActual.rutaImagen];
    
    UIImage *image = [UIImage imageWithData:pngData];
    [self.vistaPreviaImagen setImage:image];
    [self.btnEliminar setEnabled:YES];
    existeFoto = YES;
    [self.pieFoto setEnabled:YES];
    [self.pieFoto setText:[self.imagenActual pieFoto]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tomarFoto:(UIButton *)sender {
    if (existeFoto) {
        AlertView *alertaFoto = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"eliminaImagenAviso", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertaFoto show];
    }
    else {
        esCamara = YES;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setSourceType:(UIImagePickerControllerSourceTypeCamera)];
        [self presentViewController:picker animated:YES completion:Nil];
    }
    
}

- (IBAction)usarFoto:(UIButton *)sender {
    if (existeFoto) {
        AlertView *alertaFoto = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"eliminaImagenAviso", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertaFoto show];
    }
    else {
        esCamara = NO;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setSourceType:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)];//UIImagePickerControllerSourceTypePhotoLibrary
        [self presentViewController:picker animated:YES completion:Nil];
    }
    
}

- (IBAction)eliminarFoto:(UIButton *)sender {
    if (self.operacion == GaleriaImagenesEditar) {
        estaBorrando = YES;
        
    }else {
        noEditando = YES;
    }
    AlertView *alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"eliminarImagen", @" ") andAlertViewType:AlertViewTypeQuestion];
    [alerta show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imagenTemp = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:NO completion:^{
        if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
            [self guardarCarrete:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self openEditor:Nil];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textoPieFoto = textField;
    self.modifico = YES;

}

-(void) textFieldDidEndEditing:(UITextField *)textField{
	//NSLog(@"index: %@",self.index);
	if(self.operacion == GaleriaImagenesEditar){
		[[self.arregloImagenes objectAtIndex:self.index] setPieFoto: textField.text];
		cambioPie = YES;
	}
}

- (IBAction)openEditor:(id)sender {
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = imagenTemp;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    NSLog(@"Aqui se deberia de mostar");
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self.vistaPreviaImagen setImage:croppedImage];
    self.modifico = YES;
    seleccionoImagen = YES;
    [self.btnEliminar setEnabled:YES];
    self.imagenTemp = nil;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
        self.modifico = NO;
        [self.btnEliminar setEnabled:NO];
    }];
}

-(void) apareceElTeclado:(NSNotification*)aNotification {
    NSDictionary *infoNotificacion = [aNotification userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"El tamaño del teclado es %f, %f", tamanioTeclado.width, tamanioTeclado.height);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [self.scrollFoto setContentInset:edgeInsets];
    [self.scrollFoto setScrollIndicatorInsets:edgeInsets];
    [[self scrollFoto] scrollRectToVisible:textoPieFoto.frame animated:YES];
}

-(void) desapareceElTeclado:(NSNotification *)aNotificacion {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [[self scrollFoto] setContentInset:edgeInsets];
    [[self scrollFoto] setScrollIndicatorInsets:edgeInsets];
    [UIView commitAnimations];
}

-(IBAction)guardarInformacion:(id)sender {
	[[self view] endEditing:YES];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.operacion == GaleriaImagenesAgregar) {
        if (self.modifico && seleccionoImagen) {
            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(salvaImagen) withObject:nil];
        }else{
			[self.navigationController popViewControllerAnimated:YES];
		}
    }
	else if(self.operacion == GaleriaImagenesEditar){
		if(cambioPie){
            self.arregloImagenes = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloGaleriaImagenes count]];
            for (GaleriaImagenes *galeria in self.datosUsuario.arregloGaleriaImagenes) {
                GaleriaImagenes *galeriaAux = [[GaleriaImagenes alloc] init];
                [galeriaAux setIdImagen:[galeria idImagen]];
                [galeriaAux setPieFoto:[galeria pieFoto]];
                [galeriaAux setRutaImagen:[galeria rutaImagen]];
                [galeriaAux setImagenIdAux:[galeria imagenIdAux]];
                [galeriaAux setAlto:[galeria alto]];
                [galeriaAux setAncho:[galeria ancho]];
                [self.arregloImagenes addObject:galeriaAux];
            }
			if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
                if ([CommonUtils hayConexion]) {
					estaBorrando = NO;
                    [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(modificarImagen) withObject:Nil];
                }
                else {
                    AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                    [alert show];
                    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                }
            }
		}else{
            [self validaEditados];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
    
}

-(IBAction)regresar:(id)sender {
    [self.view endEditing:YES];
    if ( _delegadoGaleria != nil )
        [_delegadoGaleria seleccionCancelada];
    
    if (self.galeryType == PhotoGaleryTypeOffer) {
        self.datosUsuario = [DatosUsuario sharedInstance];
        
        if (self.modifico) {
            [self performSelectorInBackground:@selector(salvaImagen) withObject:Nil];

            [self mostrarActivity];
        }
        else {
         
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    else {
        if (self.modifico && seleccionoImagen && [CommonUtils hayConexion]  ) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
            [alert show];
        }
        else if (self.modifico && [CommonUtils hayConexion]) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
            [alert show];
        }
        else {
            [self validaEditados];
            [NSThread sleepForTimeInterval:1];
            [self.alertGaleria hide];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void) accionNo {
    if (noEditando) {
        noEditando = NO;
    }
    else {
        if (self.operacion == GaleriaImagenesAgregar) {
            [self validaEditados];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void) terminaRegreso:(NSString *) path {
    [self ocultarActivity];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) salvaImagen {
  
        NSString *nombreImagen = [StringUtils randomStringWithLength:15];
        UIImage *imagenTomada = [self.vistaPreviaImagen image];
        NSData *pngData = UIImageJPEGRepresentation(imagenTomada, 1.0); //UIImagePNGRepresentation(imagenTomada);
        
        while([pngData length] > 100000) {
            @autoreleasepool {
                NSLog(@"Entrando a redimension de imagen *************************");
                CGSize newSize = CGSizeMake(imagenTomada.size.width*0.85, imagenTomada.size.height*0.85);
                NSLog(@"La nuevas dimensiones son %f, %f", newSize.width, newSize.height);
                imagenTomada = [ImageUtils resizeImage:imagenTomada newSize:newSize];
                NSLog(@"Verificando el nuevo tamaño %f, %f", imagenTomada.size.width, imagenTomada.size.height);
                pngData = UIImageJPEGRepresentation(imagenTomada, 1.0); //UIImagePNGRepresentation(imagenTomada);
            }
        }
    
    if ( _delegadoGaleria != nil )
        [_delegadoGaleria imagenSeleccionada:[UIImage imageWithData:pngData]];
        
        NSLog(@"el tamaño es %lu", (unsigned long)[pngData length]);
        //        }
        NSString *path = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", nombreImagen]];
        [pngData writeToFile:path atomically:YES];
    
        // IDM
        if ( _delegadoGaleria != nil )
            [_delegadoGaleria rutaImagenGuardada:path];
    
    
        self.imagenActual = [[GaleriaImagenes alloc] initWithPath:path andFooter:[pieFoto text]];
        NSLog(@"El tamño de las imagenes tomadas es: %f y alto %f",imagenTomada.size.width, imagenTomada.size.height);
        [self.imagenActual setAncho:imagenTomada.size.width];
        [self.imagenActual setAlto:imagenTomada.size.height];
    if (self.galeryType == PhotoGaleryTypeOffer) {
        [self performSelectorOnMainThread:@selector(terminaRegreso:) withObject:path waitUntilDone:YES];
    }
    else {
        [self performSelectorOnMainThread:@selector(terminaGuardado) withObject:Nil waitUntilDone:YES];
    }
}

-(void)accionSi {
    //IDM
    if ( _delegadoGaleria != nil )
        [_delegadoGaleria imagenBorrada];
    
    if (noEditando) {
        [self.btnEliminar setEnabled:NO];
        [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
        self.modifico = NO;
    }
    else {
    
    if ( !estaBorrando && (self.operacion == GaleriaImagenesAgregar || self.operacion == GaleriaImagenesEditar) ) {
        if([CommonUtils hayConexion]){
            [self guardarInformacion:nil];
        }else{
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
            }
    }
    else {
        if (self.galeryType == PhotoGaleryTypeOffer) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else {
                if (self.galeryType == PhotoGaleryTypeImage) {
                    self.imagenActual = [self.arregloImagenes objectAtIndex:self.index];
                }
                
                idImagen = self.imagenActual.idImagen;
                [self.pieFoto setText:@" "];
                [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
                self.modifico = NO;
                if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
                    if ([CommonUtils hayConexion]) {
                        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                        [self performSelectorInBackground:@selector(modificarImagen) withObject:Nil];
                    }
                    else {
                        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                        [alert show];
                    }
                }
                else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
        }
    }
    }
}

-(void) accionAceptar {
    if (estaBorrando) {
        [self validaEditados];
        estaBorrando = NO;
        existeFoto = NO;
        self.operacion = GaleriaImagenesAgregar;
        [self.btnEliminar setEnabled:NO];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if (exitoModificar) {
            [self validaEditados];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void) mostrarActivity {
    self.alertGaleria = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarImagen", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertGaleria show];
}

-(void) ocultarActivity {
    
        [NSThread sleepForTimeInterval:1];
        [self.alertGaleria hide];
    
    if ( _galeryType == PhotoGaleryTypeOffer )
    {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"imagenPromoCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
        return;
    }
    
    if (exitoModificar) {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
	else if(cambioPie){
        [self validaEditados];
		[self.navigationController popViewControllerAnimated:YES];
	}
    else {
        self.modifico = YES;
        AlertView *alertImagen = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"noGuardoImagen", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertImagen show];
    }
    
}

-(void) modificarImagen {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerGaleria *galeria = [[WS_HandlerGaleria alloc] init];
        [galeria setArregloGaleria:self.arregloImagenes];
        [galeria setImagenInsertarAux:self.imagenActual];
        [galeria setIndiceSeleccionado:self.index];
        [galeria setTipoGaleria:self.galeryType];
        [galeria setGaleriaDelegate:self];
        if (estaBorrando) {
            [galeria eliminarImagen:idImagen];
        }
        else {
                if (cambioPie) {
                    [galeria actualizarGaleria];
                }
                else {
                    [galeria insertarImagen:self.imagenActual];
                }
            
        }
    }
    else {
        if (self.alertGaleria)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertGaleria hide];
        }
        self.alertGaleria = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertGaleria show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
	self.datosUsuario = [DatosUsuario sharedInstance];
    if ([resultado isEqualToString:@"Exito"] || [resultado integerValue] > 0) {
        exitoModificar = YES;
        if (!estaBorrando) {
            idImagen = [resultado integerValue];
        }
		
		
    }
    else {
        exitoModificar = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertGaleria)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertGaleria hide];
    }
    self.alertGaleria = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
    [self.alertGaleria show];
    [StringUtils terminarSession];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) sessionTimeout
{
    if (self.alertGaleria)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertGaleria hide];
    }
    self.alertGaleria = [AlertView initWithDelegate:Nil
                                             message:NSLocalizedString(@"sessionCaduco", Nil)
                                    andAlertViewType:AlertViewTypeInfo];
    [self.alertGaleria show];
    [StringUtils terminarSession];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar {
    if (self.alertGaleria)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertGaleria hide];
    }
   // [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"noGuardoImagen", Nil) andAlertViewType:AlertViewTypeInfo] show];
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) guardarCarrete:(UIImage *) imagen {
    UIImageWriteToSavedPhotosAlbum(imagen,
                                   self,
                                   @selector(image:finishedSavingWithError:contextInfo:),
                                   nil);
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"No se guardo la imagen, inténtalo nuevamente");
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    } else {
        NSLog(@"La imagen se guardo correctamento");
    }
}

-(void) validaEditados {
    if (self.galeryType == PhotoGaleryTypeLogo) {
        self.datosUsuario = [DatosUsuario sharedInstance];
        if (self.datosUsuario.imagenLogo.rutaImagen != nil && self.datosUsuario.imagenLogo.rutaImagen.length > 0) {
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:1 withObject:@YES];
        //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito Logo" withValue:@""];
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Logo"];
        }
        else {
        //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro Logo" withValue:@""];
            [self enviarEventoGAconCategoria:@"Borro" yEtiqueta:@"Logo"];
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:1 withObject:@NO];
        }
    }
    else if (self.galeryType == PhotoGaleryTypeImage) {
        if (self.datosUsuario.imagenLogo.rutaImagen != nil && self.datosUsuario.imagenLogo.rutaImagen.length > 0) {
        //    [[AppsFlyerTracker sharedTracker] trackEvent:@"Edito Imagen" withValue:@""];
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Imagen"];
        }
        else {
       //     [[AppsFlyerTracker sharedTracker] trackEvent:@"Borro Imagen" withValue:@""];
            [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Imagen"];
        }
    }
}

-(void) terminaGuardado {
    if (self.galeryType == PhotoGaleryTypeImage) {
        self.arregloImagenes = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloGaleriaImagenes count]];
        for (GaleriaImagenes *galeria in self.datosUsuario.arregloGaleriaImagenes) {
            GaleriaImagenes *galeriaAux = [[GaleriaImagenes alloc] init];
            [galeriaAux setIdImagen:[galeria idImagen]];
            [galeriaAux setPieFoto:[galeria pieFoto]];
            [galeriaAux setRutaImagen:[galeria rutaImagen]];
            [galeriaAux setImagenIdAux:[galeria imagenIdAux]];
            [galeriaAux setAlto:[galeria alto]];
            [galeriaAux setAncho:[galeria ancho]];
            [self.arregloImagenes addObject:galeriaAux];
        }
    }
    self.modifico = NO;
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion) {
        if ([CommonUtils hayConexion]) {
            estaBorrando = NO;
            [self performSelectorInBackground:@selector(modificarImagen) withObject:Nil];
        }
        else {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
        }
    }
}

@end