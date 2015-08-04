//
//  CellAlbum.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 7/23/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellAlbum : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelCelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCelCuantos;
@property (weak, nonatomic) IBOutlet UIImageView *imgCel;

@end
