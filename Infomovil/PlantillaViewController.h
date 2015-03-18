//
//  PlantillaViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/11/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlantillaViewController :  UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgTemplate;
@property (weak, nonatomic) IBOutlet UILabel *nombrePlantilla;
@property (weak, nonatomic) IBOutlet UILabel *descripcionPlantilla;
@property (weak, nonatomic) IBOutlet UIButton *btnVerEjemploPlantilla;
@property (weak, nonatomic) IBOutlet UIButton *btnTemplateSeleccionado;
@property (weak, nonatomic) IBOutlet UILabel *etiquetaEstatica;
@property (weak, nonatomic) IBOutlet UIImageView *imgBullets;


@end
