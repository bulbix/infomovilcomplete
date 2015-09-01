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
#import "MainViewController.h"
#import "MenuPasosViewController.h"
#import "AlbumsFacebookViewController.h"


@interface GaleriaPaso2ViewController () {
    UITextField *textoPieFoto;
    NSInteger imagenes;
//    BOOL self.modifico;
    BOOL exitoModificar;
    BOOL estaBorrando;
    BOOL seleccionoImagen;
    BOOL esCamara;
	BOOL estaEditando;
	BOOL cambioPie;
    BOOL existeFoto;
    BOOL noEditando;
    BOOL eliminarFotoOferta;
    UIImage *imagenTemp;

}

@property(nonatomic, strong) NSMutableArray *arregloImagenes;
@property(nonatomic, strong) GaleriaImagenes *imagenActual;
@property (nonatomic, strong) AlertView *alertGaleria;
@property(nonatomic, strong) UIImage *imagenTemp;
@property(nonatomic, strong) NSString *descripcionGaleria;
@property(nonatomic, strong) NSString *InicioTexto;
@property(nonatomic, strong) NSString *FinalizoTexto;
@property(nonatomic, strong) NSString *descripcionTemp;

@end

@implementation GaleriaPaso2ViewController

@synthesize pieFoto;
@synthesize imagenTemp;
@synthesize idImagen;
@synthesize urlImagen;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        eliminarFotoOferta = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"el tipo de galeria es: %u y la operacion es: %u", self.galeryType, self.operacion);
    [super viewDidLoad];
    UIImage *image = defRegresar;
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
    seleccionoImagen = NO;
    existeFoto = NO;
    
    self.vistaTomar.layer.cornerRadius = 5.0f;
    self.vistaUsar.layer.cornerRadius = 5.0f;
    self.viewFacebok.layer.cornerRadius = 5.0f;
    self.vistaPreviaImagen.layer.cornerRadius = 5.0f;
    self.vistaPreviaImagen.layer.masksToBounds = YES;
    self.pieFoto.layer.cornerRadius = 5.0f;
    imagenes = 0;
    [self.scrollFoto setContentSize:CGSizeMake(320, 240)];
    
    [self acomodarVista];
    
    if (self.operacion == GaleriaImagenesEditar) {
        [self cargarVista];
        estaEditando = YES;
    }
    else {
        estaEditando = NO;
    }
    
   
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.vistaContenedorBoton setFrame:CGRectMake(40, 280, 280, 104)];
        [self.vistaTomar setFrame:CGRectMake(0, 0, 280, 30)];
        [self.vistaUsar setFrame:CGRectMake(0, 31, 280, 30)];
        [self.btnEliminar setFrame:CGRectMake(290, 400, 29, 35)];
        [self.labelTituloFoto setFrame:CGRectMake(40, 186 ,203, 21)];
        [self.pieFoto setFrame:CGRectMake(40,215 ,280 ,30 )];
        [self.scrollFoto setContentSize:CGSizeMake(375, 500)];
        [self.btnIrAFacebook setFrame:CGRectMake(self.btnIrAFacebook.frame.origin.x, self.btnIrAFacebook.frame.origin.y, 280, 30)];
        [self.btnTomarFoto setFrame:CGRectMake(0,0,280,30)];
        //[self.btnUsarFoto setFrame:CGRectMake(0, 0, 280, 100)];
    }else if(IS_IPAD){
        [self.vistaContenedorBoton setFrame:CGRectMake(134, 280, 500, 135)];
        [self.vistaTomar setFrame:CGRectMake(0, 0, 500, 45)];
        [self.vistaUsar setFrame:CGRectMake(0, 46, 500, 45)];
        [self.viewFacebok setFrame:CGRectMake(0, 92, 500, 45)];
        [self.btnEliminar setFrame:CGRectMake(590, 440, 29, 35)];
        [self.imgBullet setFrame:CGRectMake(480, 14, 11, 18)];
        [self.imgBullet2 setFrame:CGRectMake(480, 14, 11, 18)];
        [self.imgbullet3 setFrame:CGRectMake(480, 14, 11, 18)];
        [self.labelTituloFoto setFrame:CGRectMake(134, 186 ,500, 21)];
        [self.labelTomarFoto setFrame:CGRectMake(self.labelTomarFoto.frame.origin.x, self.labelTomarFoto.frame.origin.y, self.labelTomarFoto.frame.size.width, 40)];
        [self.labelFotoExistente setFrame:CGRectMake(self.labelFotoExistente.frame.origin.x, self.labelFotoExistente.frame.origin.y, self.labelFotoExistente.frame.size.width, 40)];
        [self.btnIrAFacebook setFrame:CGRectMake(self.btnIrAFacebook.frame.origin.x, self.btnIrAFacebook.frame.origin.y, 500, 40)];
        [self.btnTomarFoto setFrame:CGRectMake(0,0,500,45)];
        [self.btnUsarFoto setFrame:CGRectMake(0, 0, 500, 45)];
        [self.scrollFoto setContentSize:CGSizeMake(768, 800)];
        [self.pieFoto setFrame:CGRectMake(134,215 , 500 ,30 )];
        
       
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.labelTituloFoto setText:NSLocalizedString(@"tituloFoto", Nil)];
    [self.labelTomarFoto setText:NSLocalizedString(@"tomarFoto", Nil)];
    [self.labelFotoExistente setText:NSLocalizedString(@"fotoExistente", Nil)];
    [self.btnIrAFacebook setTitle:NSLocalizedString(@"fotosFacebtn", Nil) forState:UIControlStateNormal];
    [self acomodarBarraNavegacionConTitulo:self.tituloPaso nombreImagen:@"barraverde.png"];
    
}

-(void) acomodarVista {
    self.datosUsuario = [DatosUsuario sharedInstance];
    switch (self.galeryType) {
        case PhotoGaleryTypeLogo:
                {
                    [self.labelTituloFoto setHidden:YES];
                    [self.pieFoto setHidden:YES];
                    [self.vistaContenedorBoton setFrame:CGRectMake(20, 186, 280, 101)];
                    [self.viewFacebok setHidden:YES];
                    NSMutableString * tipoAux = nil;
                    for(int i = 0; i < [self.datosUsuario.arregloTipoImagen count]; i++){
                        NSMutableString *arrAux = [self.datosUsuario.arregloTipoImagen objectAtIndex:i];
                        if([arrAux isEqualToString:@"LOGO"]){
                            tipoAux = arrAux;
                            self.idImagen = [self.datosUsuario.arregloIdImagen objectAtIndex:i];
                            self.urlImagen = [self.datosUsuario.arregloUrlImagenes objectAtIndex:i];
                            existeFoto = YES;
                        }
                    }
                    if([tipoAux isEqualToString:@"LOGO"]){
                        self.operacion = GaleriaImagenesEditar;
                    }else{
                        self.operacion = GaleriaImagenesAgregar;
                    }
                    
                }
            break;
        case PhotoGaleryTypeOffer:
                [self.viewFacebok setHidden:YES];
                [self.labelTituloFoto setHidden:YES];
                [self.pieFoto setHidden:YES];
                [self.vistaContenedorBoton setFrame:CGRectMake(20, 186, 280, 101)];
                self.operacion = GaleriaImagenesEditar;
                estaEditando = YES;
           
            break;
            
        default:
            break;
    }
}

-(void) cargarVista {
  
    self.datosUsuario = [DatosUsuario sharedInstance];
    
    switch (self.galeryType) {
        case PhotoGaleryTypeLogo: 
          // Ya guarde el id y la url del logo anteriormente en acomodarvista //
            break;
        case PhotoGaleryTypeImage:
            NSLog(@"EL INDEX ES: %li", (long)self.index);
            self.urlImagen = [self.datosUsuario.arregloUrlImagenesGaleria objectAtIndex:self.index];
            NSLog(@"LA URL ES: %@", self.urlImagen);
            if([self.urlImagen length] > 0){
                existeFoto = YES;
                
            }else{
                existeFoto =  NO;
            }
            self.descripcionGaleria = [self.datosUsuario.arregloDescripcionImagenGaleria objectAtIndex:self.index];
            [self.pieFoto setEnabled:YES];
            if([self.descripcionGaleria length] > 0){
                [self.pieFoto setText:self.descripcionGaleria];
            }
            break;
        case PhotoGaleryTypeOffer:
            self.urlImagen = self.datosUsuario.urlPromocion;
            if([self.urlImagen length] > 0){
                existeFoto = YES;
            }else{
                existeFoto =  NO;
            }
            break;
            
        default:
            break;
    }
 
    if ([CommonUtils hayConexion] && existeFoto) {
        [self.btnEliminar setEnabled:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlImagen]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:25.0];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if (response == nil) {
            if (requestError != nil) {
               
                [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
            }
        }else {
         
            UIImage *image = [UIImage imageWithData:response];
            [self.vistaPreviaImagen setImage:image];
        }
    }else{
        [self.btnEliminar setEnabled:NO];
        [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)irAFacebook:(id)sender {
   /* if (existeFoto) {
        AlertView *alertaFoto = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"eliminaImagenAviso", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertaFoto show];
    }
    else {
    */
    NSLog(@"RECIBIO EL CLICK A FACEBOOK ");
            if([CommonUtils hayConexion]){
                AlbumsFacebookViewController *cambiaPass = [[AlbumsFacebookViewController alloc] initWithNibName:@"AlbumsFacebookViewController" bundle:Nil];
                [cambiaPass setTextDescription:self.pieFoto.text];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cambiaPass];
                [self.navigationController presentViewController:navController animated:YES completion:Nil];
            
            }else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
    //}
    
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
    if (self.operacion == GaleriaImagenesEditar) { // si existe logo //
        estaBorrando = YES;
    }else {
        noEditando = YES;
    }
    if(self.galeryType == PhotoGaleryTypeOffer){
       
        eliminarFotoOferta = YES;
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
    noEditando = NO;
    if(self.operacion == GaleriaImagenesEditar){
		cambioPie = YES;
    }else{
        cambioPie = NO;
    }
    NSLog(@"entra aqui con el resign? ");
}

- (IBAction)openEditor:(id)sender {
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = imagenTemp;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:NO completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self.vistaPreviaImagen setImage:croppedImage];
    self.modifico = YES;
    seleccionoImagen = YES;
    [self.btnEliminar setEnabled:YES];
    self.imagenTemp = nil;
    noEditando = NO;
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
    NSLog(@"ENTRO A GUARDAR INFORMACION y la operacion es: %u", self.operacion);
    [self.pieFoto resignFirstResponder];
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.operacion == GaleriaImagenesAgregar) {
        NSLog(@"AQUI VA A AGREGAR IMAGENES DEL LOGO");
        if (self.modifico && seleccionoImagen) {
           if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(salvaImagen) withObject:nil];
           }else {
                   AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                   [alert show];
            }
        }else{
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:nil message:NSLocalizedString(@"faltaImagenActualizar", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
			
		}
    }else if(self.operacion == GaleriaImagenesEditar){
		if(cambioPie){
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
            
        }else if (self.galeryType == PhotoGaleryTypeOffer){
                self.datosUsuario = [DatosUsuario sharedInstance];
                if (self.modifico) {
                    
                    [self performSelectorInBackground:@selector(salvaImagen) withObject:Nil];
                    [self mostrarActivity];
                }
                else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
        }else{
            [self validaEditados];
			[self.navigationController popViewControllerAnimated:YES];
            NSLog(@"AQUI FUE DONDE REGRESO!!!");
		}
	}
    
}

-(IBAction)regresar:(id)sender {
    [self.view endEditing:YES];
    
    if (self.galeryType == PhotoGaleryTypeOffer) {
        if (self.modifico) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
            [alert show];
        } else { [self.navigationController popViewControllerAnimated:YES]; }
        
    }else if(self.galeryType == PhotoGaleryTypeLogo){
        if (self.modifico) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
            [alert show];
        }else { [self.navigationController popViewControllerAnimated:YES]; }
        
    }else if(self.galeryType == PhotoGaleryTypeImage){
        if (seleccionoImagen) {
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
            [alert show];
        }else if(self.modifico && self.operacion){
            AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
            [alert show];
        }else{
            [self validaEditados];
            [self.alertGaleria hide];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void) accionNo {
    if (noEditando) {
        noEditando = NO;
        
    }else{
        if (self.operacion == GaleriaImagenesAgregar) {
            [self validaEditados];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) terminaRegreso:(NSString *) path {
    [self ocultarActivity];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) salvaImagen {
    
        NSString *nombreImagen = [StringUtils randomStringWithLength:15];
        UIImage *imagenTomada = [self.vistaPreviaImagen image];
        NSData *pngData = UIImageJPEGRepresentation(imagenTomada, 1.0);
        while([pngData length] > 100000) {
            @autoreleasepool {
                CGSize newSize = CGSizeMake(imagenTomada.size.width*0.85, imagenTomada.size.height*0.85);
                imagenTomada = [ImageUtils resizeImage:imagenTomada newSize:newSize];
                pngData = UIImageJPEGRepresentation(imagenTomada, 0.9);
            }
        }
    
    if ( _delegadoGaleria != nil )
        [_delegadoGaleria imagenSeleccionada:[UIImage imageWithData:pngData]];
    
        NSString *path = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", nombreImagen]];
        [pngData writeToFile:path atomically:YES];
    
        if ( _delegadoGaleria != nil )
            [_delegadoGaleria rutaImagenGuardada:path];
    
        self.imagenActual = [[GaleriaImagenes alloc] initWithPath:path andFooter:[pieFoto text]];
    if (self.galeryType == PhotoGaleryTypeOffer) {
       
        [self performSelectorOnMainThread:@selector(terminaRegreso:) withObject:path waitUntilDone:YES];
    }
    else {
        [self performSelectorOnMainThread:@selector(terminaGuardado) withObject:Nil waitUntilDone:YES];
    }
}

-(void)accionSi {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.galeryType == PhotoGaleryTypeOffer) {
        if (self.modifico && eliminarFotoOferta == NO) {
            if ([CommonUtils hayConexion]) {
                [self performSelectorInBackground:@selector(salvaImagen) withObject:Nil];
                [self mostrarActivity];
            }else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
        }else if(eliminarFotoOferta == YES){
            if ( _delegadoGaleria != nil )
                [_delegadoGaleria imagenSeleccionada:nil];
                [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
                self.datosUsuario.urlPromocion = nil;
                [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    if ( _delegadoGaleria != nil )
        [_delegadoGaleria imagenBorrada];
    
    if (noEditando) {
        NSLog(@"No esta editando");
        [self.btnEliminar setEnabled:NO];
        [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
        self.modifico = NO;
    }else {
        NSLog(@"Esta editando");
        if (!estaBorrando && (self.operacion == GaleriaImagenesAgregar || self.operacion == GaleriaImagenesEditar) ) {
                if([CommonUtils hayConexion]){
                    [self guardarInformacion:nil];
                }else{
                    AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                    [alert show];
                    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
                }
        }else {
               if (self.galeryType == PhotoGaleryTypeOffer) { // Si es foto de promociones //
                    [self.navigationController popViewControllerAnimated:YES];
               }else {
                        if (self.galeryType == PhotoGaleryTypeImage) { // Si es galeria de imagenes //
                            self.idImagen = [self.datosUsuario.arregloIdImagenGaleria objectAtIndex:self.index];
                            [self eliminarLogoDelArreglo];
                        }else{
                            self.idImagen = [self.datosUsuario.arregloIdImagen objectAtIndex:self.index];
                        }
                      
                        [self.pieFoto setText:@" "];
                        [self.vistaPreviaImagen setImage:[UIImage imageNamed:@"previsualizador.png"]];
                        self.modifico = NO;
                       
                        if ([CommonUtils hayConexion]) {
                            [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(modificarImagen) withObject:Nil];
                        }
                        else {
                            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                            [alert show];
                        }
                   
               }
        }
    }
}

-(void) accionAceptar {
    if (estaBorrando) {
        self.urlImagen = nil;
        [self validaEditados];
        estaBorrando = NO;
        existeFoto = NO;
        self.operacion = GaleriaImagenesAgregar;
        [self.btnEliminar setEnabled:NO];
        [self eliminarLogoDelArreglo];
        
    }
    else {
        if (exitoModificar) {
            [self validaEditados];
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:1 withObject:@YES];
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
        [self validaEditados];
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
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

    if ([CommonUtils hayConexion]) {
        WS_HandlerGaleria *galeria = [[WS_HandlerGaleria alloc] init];
        [galeria setImagenInsertarAux:self.imagenActual];
        [galeria setIndiceSeleccionado:self.index];
        [galeria setTipoGaleria:self.galeryType];
        [galeria setGaleriaDelegate:self];
        if (estaBorrando) {
            [galeria eliminarImagen:[self.idImagen intValue]];
        }
        else {
                if (cambioPie) {
                   
                    [galeria actualizarGaleriaDescripcion:self.index descripcion:self.pieFoto.text];
                    
                }
                else {
                  
                    [galeria insertarImagen:self.imagenActual];
                }
        }
    }else{
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    
    }
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"] || [resultado integerValue] > 0) {
        exitoModificar = YES;
       
    }else {
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
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"noGuardoImagen", Nil) andAlertViewType:AlertViewTypeInfo] show];
 
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
        [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
    }

}

-(void) validaEditados {
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.galeryType == PhotoGaleryTypeLogo) {
                NSLog(@"Entro en valida editados PhotoGaleryTypeLogo");
            self.urlImagen = nil;
            for(int i = 0; i < [self.datosUsuario.arregloTipoImagen count]; i++){
                NSMutableString *arrAux = [self.datosUsuario.arregloTipoImagen objectAtIndex:i];
                if([arrAux isEqualToString:@"LOGO"]){
                    self.urlImagen = [self.datosUsuario.arregloUrlImagenes objectAtIndex:i];
                }
            }
            if ([self.urlImagen length] > 0 || [self.datosUsuario.imagenLogo.rutaImagen length] > 0) {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:1 withObject:@YES];
            }
            else {
                [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:1 withObject:@NO];
            }
    }else if (self.galeryType == PhotoGaleryTypeImage) {
       
        if (self.urlImagen != nil && [self.urlImagen length] > 0) {
           
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:8 withObject:@YES];
        }
        else {
            [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:8 withObject:@NO];
        }
    }
}

-(void) terminaGuardado {
    NSLog(@"LLEGO HASTA TERMINA GUARDADO ");
    if (self.galeryType == PhotoGaleryTypeImage) {
        self.arregloImagenes = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloGaleriaImagenes count]];
    
    }
        self.modifico = NO;
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

-(void)eliminarLogoDelArreglo{
  
    if(self.galeryType == PhotoGaleryTypeLogo){
        self.datosUsuario = [DatosUsuario sharedInstance];
        for(int i = 0; i < [self.datosUsuario.arregloTipoImagen count]; i++){
            NSMutableString *arrAux = [self.datosUsuario.arregloTipoImagen objectAtIndex:i];
            if([arrAux isEqualToString:@"LOGO"]){
             
                [self.datosUsuario.arregloTipoImagen removeObjectAtIndex:i];
                [self.datosUsuario.arregloIdImagen removeObjectAtIndex:i];
                [self.datosUsuario.arregloUrlImagenes removeObjectAtIndex:i];
            }
        }
    }else if(self.galeryType == PhotoGaleryTypeOffer){
        if ([CommonUtils hayConexion]) {
            WS_HandlerGaleria *galeria = [[WS_HandlerGaleria alloc] init];
            [galeria setGaleriaDelegate:self];
            if (estaBorrando) {
             
                [galeria eliminarImagen:[self.idImagen intValue]];
            }
            else {
                if (cambioPie) {
                    
                     [galeria actualizarGaleriaDescripcion:self.index descripcion:self.pieFoto.text];
                }
                else {
                 
                    [galeria insertarImagen:self.imagenActual];
                }
            }
        }else{
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            
        }
    
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"cambio desde text field");
    [self.pieFoto resignFirstResponder];
    return YES;
}


@end