//
//  PerfilViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "PerfilViewController.h"
#import "PerfilPaso2ViewController.h"

@interface PerfilViewController ()

@property (nonatomic, strong) NSArray *titulosTabla;

@end

@implementation PerfilViewController

@synthesize titulosTabla;

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

    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"perfil", @" ") nombreImagen:@"barraverde.png"];
	
    titulosTabla = @[NSLocalizedString(@"productoServicio", @" "), NSLocalizedString(@"areaServicio", @" "), NSLocalizedString(@"horario", @" "), NSLocalizedString(@"metodosPago", @" "), NSLocalizedString(@"asociaciones", @" "), NSLocalizedString(@"biografia", @" "), NSLocalizedString(@"perfinNegocioProfesion", @"")];
    self.tablaPerfil.layer.cornerRadius = 5;
    self.datosUsuario = [DatosUsuario sharedInstance];
    if (self.datosUsuario.arregloEstatusPerfil.count == 0) {
        NSArray *arrayEstatus = @[@NO, @NO, @NO, @NO, @NO, @NO, @NO];
        NSMutableArray *arregloEstatus = [[NSMutableArray alloc] init];
        [arregloEstatus addObjectsFromArray:arrayEstatus];
        self.datosUsuario.arregloEstatusPerfil = arregloEstatus;
    }
	
	self.navigationItem.rightBarButtonItem = Nil;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.tablaPerfil reloadData];
	
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"perfil", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"perfil", @" ") nombreImagen:@"NBverde.png"];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titulosTabla count] -1;
//    return 6;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"perfilCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"perfilCell"];
        UIImageView *imagenAccesory = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"btnsiguiente.png"] ofType:nil]]]];
        [cell setAccessoryView:imagenAccesory];
    }
    [cell.textLabel setText:[titulosTabla objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    if ([[self.datosUsuario.arregloEstatusPerfil objectAtIndex:indexPath.row]  isEqual: @NO]) {
        [cell.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"noeditado.png"] ofType:nil]]]];
        [cell.textLabel setTextColor:colorFuenteVerde];
    }
    else {
        [cell.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"editado.png"] ofType:nil]]]];
        [cell.textLabel setTextColor:colorFuenteAzul];
    }
    return cell;
}

#pragma mark - UITableViewDataSource

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PerfilPaso2ViewController *perfil2 = [[PerfilPaso2ViewController alloc] initWithNibName:@"PerfilPaso2ViewController" bundle:Nil];
    [perfil2 setIndex:indexPath.row];
    [perfil2 setTituloPerfil:[titulosTabla objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:perfil2 animated:YES];
}

@end
