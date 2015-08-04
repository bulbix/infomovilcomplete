//
//  PhotosFacebookViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 7/22/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "PECropViewController.h"


@interface PhotosFacebookViewController : InfomovilViewController

@property (nonatomic,strong) NSString* idAlbum;
@property (nonatomic,strong) NSMutableArray* urlsAlbum;
@property (nonatomic,strong) NSMutableArray* urlsAlbumGrande;
@property (weak, nonatomic) IBOutlet UICollectionView *tableView;

@end
