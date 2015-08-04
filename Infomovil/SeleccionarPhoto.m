//
//  SeleccionarPhoto.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 7/23/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "SeleccionarPhoto.h"
#import "PhotosFacebookViewController.h"
#import "GaleriaImagenes.h"
#import "JFRandom.h"
#import "WS_HandlerGaleria.h"
#import "GaleriaImagenesViewController.h"

@interface SeleccionarPhoto ()
@property(nonatomic, strong) NSMutableArray *arregloImagenes;
@property(nonatomic, strong) GaleriaImagenes *imagenActual;
@property (nonatomic, strong) AlertView *alertGaleria;
@property(nonatomic, strong) UIImage *imagenTemp;
@property(nonatomic, strong) NSString *descripcionGaleria;
@property(nonatomic, strong) NSString *InicioTexto;
@property(nonatomic, strong) NSString *FinalizoTexto;
@property(nonatomic, strong) NSString *descripcionTemp;

@end

@implementation SeleccionarPhoto

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"La url de la foto es: %@" , self.urlPhoto);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlPhoto]];
    //[self.imgPhoto setImage:[UIImage imageWithData: data]];
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = [UIImage imageWithData: data];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
-(void) mostrarActivity {
    self.alertaMapa = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaMapa show];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirImagen", @" ") nombreImagen:@"barraverde.png"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"btnregresar.png"] ofType:nil]]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
   // self.navigationItem.rightBarButtonItem = nil;
    [self.vistaInferior setHidden:YES];
    

}

-(IBAction)regresar:(id)sender {
    PhotosFacebookViewController *photos = [[PhotosFacebookViewController alloc] initWithNibName:@"PhotosFacebookViewController" bundle:Nil];
    [photos setIdAlbum:self.idAlbum];
    [self.navigationController pushViewController:photos animated:NO];
    
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    NSLog(@"A A VER SI DETECTA ESTE CLICK ");
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self.imgPrevia setImage:croppedImage];
    [self.txtNombreImagen becomeFirstResponder];
  
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.imgPrevia setImage:[UIImage imageNamed:@"previsualizador.png"]];
        
    }];
    PhotosFacebookViewController *photos = [[PhotosFacebookViewController alloc] initWithNibName:@"PhotosFacebookViewController" bundle:Nil];
    [photos setIdAlbum:self.idAlbum];
    [self.navigationController pushViewController:photos animated:NO];
}


-(IBAction)guardarInformacion:(id)sender {
    if ([CommonUtils hayConexion]) {
        [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
        [self performSelectorInBackground:@selector(salvaImagen) withObject:nil];
        
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    
}

-(void) salvaImagen {
    NSLog(@"ENTRO A SALVAR IMAGEN!!!!!");
    NSString *nombreImagen = [StringUtils randomStringWithLength:15];
    UIImage *imagenTomada = [self.imgPrevia image];
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
    
    
    self.imagenActual = [[GaleriaImagenes alloc] initWithPath:path andFooter:self.txtNombreImagen.text];
    [self performSelectorOnMainThread:@selector(terminaGuardado) withObject:Nil waitUntilDone:YES];
}

-(void) terminaGuardado {
    NSLog(@"ENTRO A TERMINA GUARDADO");
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.arregloImagenes = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloGaleriaImagenes count]];
    
    if ([CommonUtils hayConexion]) {
        NSLog(@"SI HUBO CONEZION");
        WS_HandlerGaleria *galeria = [[WS_HandlerGaleria alloc] init];
        [galeria setArregloGaleria:self.arregloImagenes];
        [galeria setImagenInsertarAux:self.imagenActual];
        [galeria setIndiceSeleccionado:0];
        [galeria setTipoGaleria:2]; // PhotoGaleryTypeImage
        [galeria setGaleriaDelegate:self];
        [galeria insertarImagen:self.imagenActual];
    }
}
-(void) resultadoConsultaDominio:(NSString *)resultado {
    NSLog(@"EL VALOR DE RESULTADO ES: %@", resultado);
    self.datosUsuario = [DatosUsuario sharedInstance];
    if ([resultado isEqualToString:@"Exito"] || [resultado integerValue] > 0) {
        exitoModificar = YES;
        
    }else {
        exitoModificar = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) ocultarActivity {
    if ( self.alertaMapa )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaMapa hide];
    }
    if(exitoModificar == YES){
    AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
    [alert show];
        GaleriaImagenesViewController *imagenesVC = [[GaleriaImagenesViewController alloc] initWithNibName:@"GaleriaImagenesViewController" bundle:Nil];
        [self.navigationController pushViewController:imagenesVC animated:NO];
    }else {
        self.modifico = YES;
        AlertView *alertImagen = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"noGuardoImagen", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertImagen show];
    }
    
}

@end
