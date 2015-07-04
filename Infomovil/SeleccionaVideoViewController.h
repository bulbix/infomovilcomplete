//
//  SeleccionaVideoViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 16/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface SeleccionaVideoViewController : InfomovilViewController <UITextFieldDelegate, AlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *videoCollection;
@property (nonatomic, strong) NSMutableArray *arregloVideos;

@end
