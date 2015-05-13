//
//  SeleccionaVideoViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 16/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "SeleccionaVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VistaVideoViewController.h"
#import "EditarVideoViewController.h"
#import "VideoModel.h"
#import "VideoCell.h"

@interface SeleccionaVideoViewController ()

@property (nonatomic, strong) AlertView *alerta;
@property (nonatomic, strong) NSData *datosObtenidos;


@end

@implementation SeleccionaVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscarVideo", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscarVideo", @" ") nombreImagen:@"NBverde.png"];
	}
    [self.videoCollection registerNib:[UINib nibWithNibName:@"VideoCell" bundle:Nil] forCellWithReuseIdentifier:@"videoCell"];
    self.videoCollection.layer.cornerRadius = 5.0f;
    self.navigationItem.rightBarButtonItem = Nil;
  
}

-(void)viewWillAppear:(BOOL)animated{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscarVideo", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscarVideo", @" ") nombreImagen:@"NBverde.png"];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self performSelectorOnMainThread:@selector(mostrarAlerta) withObject:Nil waitUntilDone:YES];
    [self buscarVideo];
    return YES;
}

-(void) buscarVideo {
    
}
-(void) mostrarAlerta {
    self.alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", @" ") andAlertViewType:AlertViewTypeActivity];
    [self.alerta show];
}

-(void) ocultarAlerta {
    if ([self.arregloVideos count] > 0) {
        [self.videoCollection setHidden:NO];
        [self.videoCollection reloadData];
        if (self.alerta)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alerta hide];
        }
    }
    else {
        if (self.alerta)
        {
            [NSThread sleepForTimeInterval:1];
            [self.alerta hide];
        }
        AlertView *alertInfo = [AlertView initWithDelegate:self message:NSLocalizedString(@"noVideo", Nil) andAlertViewType:AlertViewTypeInfo];
        [alertInfo show];
    }
    
    
}

-(void) realizaConsultaconURL:(NSString *) urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [self iniciarParseo:urlData];
}

-(void) iniciarParseo:(NSData *)dataWeb {
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataWeb options:kNilOptions error:&error];
    self.arregloVideos = [[NSMutableArray alloc] init];
    if (error != nil) {
        //        <#statements#>
    }
    else {
        NSDictionary *dictFeed = [jsonDict objectForKey:@"feed"];
        NSArray *arreglo = [dictFeed objectForKey:@"entry"];
        for (int i = 0; i < [arreglo count]; i++) {
            NSDictionary *dictAux = [arreglo objectAtIndex:i];
            VideoModel *video = [[VideoModel alloc] init];
            video.link = [dictAux objectForKey:@"link"];
            video.linkSolo = [[[dictAux objectForKey:@"link"] objectAtIndex:0] objectForKey:@"href"];
            video.autor = [[[[dictAux objectForKey:@"author"] objectAtIndex:0] objectForKey:@"name"] objectForKey:@"$t"];
            video.titulo = [[dictAux objectForKey:@"title"] objectForKey:@"$t"];
            video.descripcionVideo = [[dictAux objectForKey:@"content"] objectForKey:@"$t"];
            video.thumbnail = [[dictAux objectForKey:@"media$group"] objectForKey:@"media$thumbnail"];
            video.categoria = [[[dictAux objectForKey:@"category"] objectAtIndex:1] objectForKey:@"label"];
            NSData *img = [NSData dataWithContentsOfURL:[NSURL URLWithString:video.thumbnail]];
            video.imagenPrevia = [UIImage imageWithData:img];
            [self.arregloVideos addObject:video];
        }
    }
    [self performSelectorOnMainThread:@selector(ocultarAlerta) withObject:Nil waitUntilDone:YES];
}

#pragma mark - UICollectionViewDatosurce

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arregloVideos count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"videoCell";
    VideoModel *video = [self.arregloVideos objectAtIndex:indexPath.row];
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.labelTitulo setText:video.titulo];
    [cell.imagenPreview setImage:video.imagenPrevia];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.datosUsuario.videoSeleccionado = [self.arregloVideos objectAtIndex:indexPath.row];
    VistaVideoViewController *vistaVideo = [[VistaVideoViewController alloc] initWithNibName:@"VistaVideoViewController" bundle:Nil];
    vistaVideo.videoSeleccionado = [self.arregloVideos objectAtIndex:indexPath.row];
    vistaVideo.modifico = YES;
    [self.navigationController pushViewController:vistaVideo animated:YES];
//    EditarVideoViewController *editarVideo = [[EditarVideoViewController alloc] initWithNibName:@"EditarVideoViewController" bundle:Nil];
//    [editarVideo setVideoSeleccionado:[self.arregloVideos objectAtIndex:indexPath.row]];
//    [self.navigationController pushViewController:editarVideo animated:YES];
}

@end
