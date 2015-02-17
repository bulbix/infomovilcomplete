//
//  GaleriaPaso2ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "GaleriaImagenesViewController.h"
#import "PECropViewController.h"
#import "WS_HandlerProtocol.h"


@protocol GaleriaPaso2Delegate <NSObject>

- (void)imagenSeleccionada:(UIImage *)imagen;
- (void)rutaImagenGuardada:(NSString *)rutaImagen;
- (void)seleccionCancelada;
- (void)operacionConError:(NSString *)strError;
- (void)imagenBorrada;

@end

typedef enum {
    PhotoGaleryTypeLogo,
    PhotoGaleryTypeOffer,
    PhotoGaleryTypeImage
}PhotoGaleryType;

@interface GaleriaPaso2ViewController : InfomovilViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, AlertViewDelegate, PECropViewControllerDelegate, WS_HandlerProtocol>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollFoto;
@property (weak, nonatomic) IBOutlet UITextField *pieFoto;
@property (weak, nonatomic) IBOutlet UIView *vistaTomar;
@property (weak, nonatomic) IBOutlet UIView *vistaUsar;
@property (weak, nonatomic) IBOutlet UIImageView *vistaPreviaImagen;
@property GaleriaImagenesOperacion operacion;
@property (nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *btnEliminar;
@property (weak, nonatomic) IBOutlet UIButton *btnTomarFoto;
@property (weak, nonatomic) IBOutlet UIButton *btnUsarFoto;
@property (weak, nonatomic) IBOutlet UILabel *labelTituloFoto;
@property (weak, nonatomic) IBOutlet UILabel *labelFotoExistente;
@property (weak, nonatomic) IBOutlet UILabel *labelTomarFoto;
@property (nonatomic, assign) PhotoGaleryType galeryType;
@property (nonatomic, strong) NSString *tituloPaso;
@property (weak, nonatomic) IBOutlet UIView *vistaContenedorBoton;

@property (weak, nonatomic) id<GaleriaPaso2Delegate>delegadoGaleria;
@property (strong, nonatomic) NSString *strImagenPath;


- (IBAction)tomarFoto:(UIButton *)sender;
- (IBAction)usarFoto:(UIButton *)sender;
- (IBAction)eliminarFoto:(UIButton *)sender;
@end
