//
//  AlbumsFacebookViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 7/22/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "AlbumsFacebookViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CellAlbum.h"
#import "PhotosFacebookViewController.h"
#import "GaleriaImagenesViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define kSITIO_WEB "www.facebook.com"

@interface AlbumsFacebookViewController ()

@end

@implementation AlbumsFacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.albumes = [[NSMutableArray alloc]init];
    self.idAlbumes = [[NSMutableArray alloc]init];
    self.cuantasFotos = [[NSMutableArray alloc]init];
    self.urlPicture = [[NSMutableArray alloc]init];
    
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
    if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.tableView setFrame:CGRectMake(0, 0, 375, 667)];
        [self.viewReintentar setFrame:CGRectMake(0, 100, 375, 200)];
    }else if(IS_IPAD){
        [self.tableView setFrame:CGRectMake(0, 0, 768, 1024)];
        [self.viewReintentar setFrame:CGRectMake(0, 300, 768, 200)];
    }else if(IS_IPHONE_4){
        [self.tableView setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    
    
    self.btnReintentar.layer.cornerRadius = 5.0f;
    self.navigationItem.rightBarButtonItem = nil;
    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"albumsFace" , Nil) nombreImagen:@"barraverde.png"];
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
    GaleriaImagenesViewController *galeria = [[GaleriaImagenesViewController alloc] initWithNibName:@"GaleriaImagenesViewController" bundle:Nil];
    [self.navigationController pushViewController:galeria animated:YES];
   
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    [super viewWillDisappear:animated];
}
#pragma mark - TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albumes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellAlbum *cell = [tableView dequeueReusableCellWithIdentifier:@"celAlbum"];
   
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CellAlbum" bundle:nil]  forCellReuseIdentifier:@"celAlbum"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"celAlbum"];
    }
    cell.labelCelName.text = [self.albumes objectAtIndex:indexPath.row];
    cell.labelCelCuantos.text = [self.cuantasFotos objectAtIndex:indexPath.row];
  
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
    {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:  [self.urlPicture objectAtIndex:indexPath.row] ]
                                                 cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval:10.0];
        NSError *requestError;
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (response == nil) {
                                       if (requestError != nil) {
                                           
                                           [cell.imgCel setImage:[UIImage imageNamed:@"previsualizador.png"]];
                                       }
                                   }else {
                                       
                                       UIImage *image = [UIImage imageWithData:data];
                                       [ cell.imgCel setImage:image];
                                   }
                                   
                               }];
        
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotosFacebookViewController *photosDeAlbum = [[PhotosFacebookViewController alloc]  initWithNibName:@"PhotosFacebookViewController" bundle:Nil];
    [photosDeAlbum setTextDescription:self.textDescription];
    [photosDeAlbum setIdAlbum:[self.idAlbumes objectAtIndex:indexPath.row ]];
    [self.navigationController pushViewController:photosDeAlbum animated:YES];
    
}
-(BOOL) estaConectado {
    
    SCNetworkReachabilityRef referencia = SCNetworkReachabilityCreateWithName (kCFAllocatorDefault, kSITIO_WEB);
    SCNetworkReachabilityFlags resultado;
    SCNetworkReachabilityGetFlags ( referencia, &resultado );
    CFRelease(referencia);
    if (resultado & kSCNetworkReachabilityFlagsReachable) {
        return TRUE;
    }
    return FALSE;
}


-(void)cargarImagenesFacebook{
    if([CommonUtils hayConexion] && [self estaConectado]){
        
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_photos",@"publish_actions"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          if (session.isOpen) {
                                           
                                              [FBRequestConnection startWithGraphPath:@"/me/albums?fields=count,name,id,picture"
                                                                           parameters:nil
                                                                           HTTPMethod:@"GET"
                                                                    completionHandler:^(
                                                                                        FBRequestConnection *connection,
                                                                                        id result,
                                                                                        NSError *error
                                                                                        ) {
                                                                        NSArray *album = [result objectForKey:@"data"];
                                                                        NSLog(@"LOS  VALORES DE ALBUM SON: %@", [album description]);
                                                                        if([album count] > 0){
                                                                            self.albumes = [[NSMutableArray alloc]init];
                                                                            self.idAlbumes = [[NSMutableArray alloc]init];
                                                                            self.cuantasFotos = [[NSMutableArray alloc]init];
                                                                            self.urlPicture = [[NSMutableArray alloc]init];
                                                                        
                                                                        }
                                                                        self.vacio = -1;
                                                                        for (NSDictionary *dict in album){
                                                                            self.vacio++;
                                                                            [self.albumes addObject:[dict objectForKey:@"name"] ];
                                                                            [self.idAlbumes  addObject:[dict objectForKey:@"id"]];
                                                                            [self.cuantasFotos addObject:[NSString stringWithFormat:@"%@ imágenes",[dict objectForKey:@"count"] ]];
                                                                            
                                                                            [self.urlPicture addObject:[[[dict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                                                            
                                                                        }
                                                                        if(self.vacio == -1){
                                                                            self.labelReconectar.text = NSLocalizedString(@"cuentaVaciaFace", Nil);
                                                                        }else if(self.vacio >= 0){
                                                                            self.labelReconectar.text = NSLocalizedString(@"NoConexionFace", Nil);
                                                                        }
                                                                        
                                                                        if([self.albumes count] <= 0){
                                                                            [self.viewReintentar setHidden:NO];
                                                                            [self.tableView setHidden:YES];
                                                                          
                                                                        }else{
                                                                            [self.viewReintentar setHidden:YES];
                                                                            [self.tableView setHidden:NO];
                                                                            [self.tableView reloadData];
                                                                        }
                                                                        
                                                                    }];
                                          }else{
                                              NSLog(@"NO hay una sesion activa");
                                          }
                                          NSLog(@"EL CODIGO DE PERIMERO ERROR ES: %@  -  %li", error.description,(long)error.code);
                                          
                                      }];
    }else{
        self.labelReconectar.text = NSLocalizedString(@"NoConexionFace", Nil);
        [self.viewReintentar setHidden:NO];
        [self.tableView setHidden:YES];
        
    }
}

- (IBAction)btnReintentarAct:(id)sender {
    
    if ([CommonUtils hayConexion]) {
        [self cargarImagenesFacebook];
    }
    else {
        self.labelReconectar.text = NSLocalizedString(@"NoConexionFace", Nil);
        AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}








@end
