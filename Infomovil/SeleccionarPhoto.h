//
//  SeleccionarPhoto.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 7/23/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "PECropViewController.h"
#import "GaleriaImagenesViewController.h"
#import "WS_HandlerProtocol.h"
#import "GaleriaPaso2ViewController.h"
/*
@protocol GaleriaPaso3Delegate <NSObject>

- (void)imagenSeleccionada:(UIImage *)imagen;
- (void)rutaImagenGuardada:(NSString *)rutaImagen;
@end
*/



@interface SeleccionarPhoto : InfomovilViewController<AlertViewDelegate , PECropViewControllerDelegate, UINavigationControllerDelegate,WS_HandlerProtocol>
{
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
    
}



@property (weak, nonatomic) IBOutlet UILabel *etiquetaImg;
@property (weak, nonatomic) IBOutlet UILabel *etiquetaSelecciona;
@property (weak, nonatomic) IBOutlet UITextField *txtNombreImagen;

@property (nonatomic,strong) NSString* urlPhoto;
@property (nonatomic,strong) NSString* idAlbum;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) AlertView *alertaPhoto;
@property (nonatomic,assign) BOOL pagCargada;
@property (weak, nonatomic) id<GaleriaPaso2Delegate>delegadoGaleria;
@property (weak, nonatomic) IBOutlet UIImageView *imgPrevia;

@end
