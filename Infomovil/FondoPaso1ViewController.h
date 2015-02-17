//
//  FondoPaso1ViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "PECropViewController.h"

@interface FondoPaso1ViewController : InfomovilViewController <UINavigationControllerDelegate ,UIImagePickerControllerDelegate, PECropViewControllerDelegate, AlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imagenFondo;

- (IBAction)tomarFoto:(UIButton *)sender;
- (IBAction)usarFoto:(UIButton *)sender;
- (IBAction)seleccionarColor:(UIButton *)sender;


@end
