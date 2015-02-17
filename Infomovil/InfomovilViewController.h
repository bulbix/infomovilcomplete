//
//  InfomovilViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import "AppDelegate.h"

@interface InfomovilViewController : UIViewController <UINavigationBarDelegate, BSKeyboardControlsDelegate>

@property(nonatomic, strong) UILabel *tituloVista;
@property(nonatomic, strong) UIView *vistaInferior;
@property(nonatomic, strong) UIImageView *vistaCircular;
@property (nonatomic) BOOL modifico;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, strong) DatosUsuario *datosUsuario;

@property (nonatomic, strong) UIButton *botonEstadisticas;
@property (nonatomic, strong) UIButton *botonNotificaciones;
@property (nonatomic, strong) UIButton *botonCuenta;
@property (nonatomic, strong) UIButton *botonConfiguracion;

@property (nonatomic, strong) UIButton *botonFeeds;
@property (nonatomic) BOOL guardarVista;

@property (nonatomic, strong) NSString *strTituloVista;
@property (nonatomic, strong) NSString *strImagenTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;

-(IBAction)guardarInformacion:(id)sender;
-(void) acomodaSesion;
-(void) mostrarLogo;
-(void) mostrarLogoBarraNavegacion;
-(void) mostrarLogo6;
-(void) mostrarLogoBarraNavegacion6;
-(void) acomodarBarraNavegacionConTitulo:(NSString *)titulo nombreImagen:(NSString *)nombreImagen;

-(void) apareceTeclado: (UIScrollView *) scrollView withView:(UIView *) vistaRef;
-(void) apareceTeclado: (UIScrollView *) scrollView withRefFrame:(CGRect) refFrame;
-(void) desapareceElTeclado: (UIScrollView *) scrollView;

- (void)setBotonRegresar;
-(IBAction)regresar:(id)sender;
- (BOOL)shouldChangeText:(NSString *)string withLimit:(NSInteger)maxLength forFinalLenght:(NSInteger)textoLength;
- (void)muestraContadorTexto:(NSInteger)contador conLimite:(NSInteger)limite paraVista:(UIView *)view;
- (void)ocultaContadorTexto;

-(void)enviarEventoGAconCategoria:(NSString *)categoria yEtiqueta:(NSString *)etiqueta;

@end