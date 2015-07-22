//
//  GaleriaCell.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaleriaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagenPrevia;
@property (weak, nonatomic) IBOutlet UILabel *pieFoto;
@property (strong, nonatomic) IBOutlet UIView *vistaGaleria;
@property (weak, nonatomic) IBOutlet UILabel *sombrearCelda;

@end
