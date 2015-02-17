//
//  VideoViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
//#import "InfomovilVideoDelegate.h"
#import "WS_HandlerProtocol.h"

@interface VideoViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollVideo;
@property (nonatomic, strong) NSString *urlVideo;
@property (weak, nonatomic) IBOutlet UIView *vistaSeleccionaVideo;
@property (weak, nonatomic) IBOutlet UIView *vistaVisualizaVideo;
@property (weak, nonatomic) IBOutlet UIImageView *imagenVistaPrevia;
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelAutor;
@property (weak, nonatomic) IBOutlet UILabel *labelCategoria;
@property (weak, nonatomic) IBOutlet UIView *vistaDatosVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelBuscaYoutube;
@property (weak, nonatomic) IBOutlet UILabel *labelTituloVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelAutorVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelCategoriaVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelDatosVideo;
@property (weak, nonatomic) IBOutlet UITextField *txtUrlVideo;
@property (nonatomic, strong) NSMutableArray *arregloVideos;
@property (weak, nonatomic) IBOutlet UILabel *labelUrlVideo;

@property (nonatomic) NSInteger tipoBusqueda;

- (IBAction)seleccionarProveedor:(UIButton *)sender;
- (IBAction)verVideo:(UIButton *)sender;
- (IBAction)eliminarVideo:(UIButton *)sender;
- (IBAction)buscarVideoConURL:(id)sender;

@end