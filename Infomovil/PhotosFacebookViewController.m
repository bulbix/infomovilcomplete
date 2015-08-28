//
//  PhotosFacebookViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 7/22/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "PhotosFacebookViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CollectionPhotos.h"
#import "SeleccionarPhoto.h"
#import "AlbumsFacebookViewController.h"
#import "PECropViewController.h"
#import "MenuPasosViewController.h"

@interface PhotosFacebookViewController ()

@end

@implementation PhotosFacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"anadirImagen", @" ") nombreImagen:@"barraverde.png"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionPhotos" bundle:Nil] forCellWithReuseIdentifier:@"collectPhoto"];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"EL ID DEL ALBUM ES: %@", self.idAlbum);
    
    [self cargarImagenesFacebook];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self cargarImagenesFacebook];
    [refreshControl endRefreshing];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"btnregresar.png"] ofType:nil]]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    [self.vistaInferior setHidden:YES];

}

-(IBAction)regresar:(id)sender {
    AlbumsFacebookViewController *photos = [[AlbumsFacebookViewController alloc] initWithNibName:@"AlbumsFacebookViewController" bundle:Nil];
    [photos setTextDescription:self.textDescription];
    [self.navigationController pushViewController:photos animated:YES];
    
}

#pragma mark - UICollectionViewDatosurce

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"LA CANTIDAD DE IMANGES SON %li", (long)[self.urlsAlbum count]);
    return [self.urlsAlbum count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"collectPhoto";
    CollectionPhotos *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       
                       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlsAlbum objectAtIndex:indexPath.row]]
                                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                            timeoutInterval:10.0];
                       
                       
                       
        NSError *requestError;
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                              completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                  if (response == nil) {
                                                      if (requestError != nil) {
                                                          
                                                          [cell.imgCollectPhotos setImage:[UIImage imageNamed:@"previsualizador.png"]];
                                                      }
                                                  }else {
                                                      
                                                      [cell.imgCollectPhotos setImage:[UIImage imageWithData: data]];
                                                  }
                           
                       }];
                   });
    return cell;
  
}

#pragma mark - UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([CommonUtils hayConexion]) {
        SeleccionarPhoto *photosDeAlbum = [[SeleccionarPhoto alloc]  initWithNibName:@"SeleccionarPhoto" bundle:Nil];
        [photosDeAlbum setTextDescription:self.textDescription];
        [photosDeAlbum setUrlPhoto:[self.urlsAlbumGrande objectAtIndex:indexPath.row ]];
        [photosDeAlbum setIdAlbum:self.idAlbum];
        [self.navigationController pushViewController:photosDeAlbum animated:YES];
        
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
    
}

-(void)cargarImagenesFacebook{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/photos?fields=images&limit=50", self.idAlbum] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error){
            NSArray *imageFeed = [result objectForKey:@"data"];
            if([result count] > 0){
                self.urlsAlbum = [[NSMutableArray alloc]init];
                self.urlsAlbumGrande = [[NSMutableArray alloc]init];
            }
            for (NSDictionary *dict in imageFeed){
                NSInteger cuantos = [[dict objectForKey:@"images"] count];
                NSString *sourceURL = [[[dict objectForKey:@"images"]objectAtIndex:cuantos-1]objectForKey:@"source"];
                [self.urlsAlbum addObject:sourceURL];
                sourceURL = [[[dict objectForKey:@"images"]objectAtIndex:0]objectForKey:@"source"];
                [self.urlsAlbumGrande addObject:sourceURL];
            }
            NSLog(@"LAS URLS SON : %@", [self.urlsAlbum description]);
            NSLog(@"LAS URLS Grandes SON : %@", [self.urlsAlbumGrande description]);
            [self.tableView reloadData];
        }
    }];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        return CGSizeMake(110, 110);
    }else if(IS_IPAD){
        return CGSizeMake(95, 95);
    }
    return CGSizeMake(95, 95);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        return UIEdgeInsetsMake(15, 25, 20, 10);
    }else if(IS_IPAD){
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
