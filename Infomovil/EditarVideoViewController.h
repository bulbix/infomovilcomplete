//
//  EditarVideoViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 04/09/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"


@interface EditarVideoViewController : InfomovilViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagenPreviaVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelDatosVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelDescripcion;
@property (weak, nonatomic) IBOutlet UITextField *txtTitulo;
@property (weak, nonatomic) IBOutlet UITextView *txtDescripcion;
@property (nonatomic, strong) VideoModel *videoSeleccionado;

- (IBAction)reproducirVideo:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UIView *viewImg;

@property (weak, nonatomic) IBOutlet UIView *viewDatos;

@property (weak, nonatomic) IBOutlet UILabel *datosVideo;

@property (weak, nonatomic) IBOutlet UILabel *titulo;

@property (weak, nonatomic) IBOutlet UILabel *descripcion;

@property (weak, nonatomic) IBOutlet UIButton *btnVideo;













@end
