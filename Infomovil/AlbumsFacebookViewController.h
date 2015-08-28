//
//  AlbumsFacebookViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 7/22/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface AlbumsFacebookViewController : InfomovilViewController<AlertViewDelegate>

@property (nonatomic, strong) AlertView *alertaContacto;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger vacio;
@property (nonatomic,strong) NSMutableArray* albumes;
@property (nonatomic,strong) NSMutableArray* idAlbumes;
@property (nonatomic,strong) NSMutableArray *cuantasFotos;
@property (nonatomic,strong) NSMutableArray *urlPicture;
@property (weak, nonatomic) IBOutlet UIButton *btnReintentar;
@property (weak, nonatomic) IBOutlet UIView *viewReintentar;
@property (weak, nonatomic) IBOutlet UILabel *labelReconectar;
@property (strong, nonatomic) NSString * textDescription;
- (IBAction)btnReintentarAct:(id)sender;




@end
