//
//  InicioRapidoViewController.m
//  Infomovil
//
//  Created by Sergio Sanchez on 11/18/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InicioRapidoViewController.h"
#import "CrearPaso2ViewController.h"
#import "ListaTelefonosViewController.h"
#import "PerfilPaso2ViewController.h"
#import "MapaUbicacionViewController.h"
#import "NombrarViewController.h"
#import "VistaPreviaWebViewController.h"

@interface InicioRapidoViewController ()

@property (nonatomic, strong) NSArray *arregloDatos;
@property (nonatomic, strong) NSMutableArray *arregloStatusInicio;

@end

@implementation InicioRapidoViewController

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
    self.tablaInicio.layer.cornerRadius = 5;
    self.arregloStatusInicio = [[NSMutableArray alloc] initWithObjects:@NO, @NO, @NO, @NO, @NO, @NO, nil];
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.labelTitulo setText:NSLocalizedString(@"labelInicioRapidoTexto", Nil)];
    if ([self.datosUsuario.arregloEstatusEdicion count] == 0) {
        NSArray *arregloAux = @[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO];
        NSMutableArray *arregloEstatus = [[NSMutableArray alloc] init];
        [arregloEstatus addObjectsFromArray:arregloAux];
        self.datosUsuario.arregloEstatusEdicion = arregloEstatus;
    }
    if (self.datosUsuario.arregloEstatusPerfil.count == 0) {
        NSArray *arrayEstatus = @[@NO, @NO, @NO, @NO, @NO, @NO, @NO];
        NSMutableArray *arregloEstatus = [[NSMutableArray alloc] init];
        [arregloEstatus addObjectsFromArray:arrayEstatus];
        self.datosUsuario.arregloEstatusPerfil = arregloEstatus;
    }
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"labelInicioRapido", Nil) nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"labelInicioRapido", Nil) nombreImagen:@"NBverde.png"];
	}
    [self.vistaInferior setHidden:YES];
    self.arregloDatos = [[NSArray alloc] initWithObjects:NSLocalizedString(@"nombreEmpresa", Nil),
                         NSLocalizedString(@"descripcionCorta", @" "),
                         NSLocalizedString(@"contacto", @" "),
                         [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"perfil", @" "), NSLocalizedString(@"productoServicio", Nil)],
                         NSLocalizedString(@"mapa", @" "),
                         NSLocalizedString(@"txtPublicar", Nil), Nil];
    if (self.datosUsuario.arregloEstatusEdicion != nil) {
        [self.arregloStatusInicio replaceObjectAtIndex:0 withObject:[self.datosUsuario.arregloEstatusEdicion objectAtIndex:0]];
        [self.arregloStatusInicio replaceObjectAtIndex:1 withObject:[self.datosUsuario.arregloEstatusEdicion objectAtIndex:3]];
        [self.arregloStatusInicio replaceObjectAtIndex:2 withObject:[self.datosUsuario.arregloEstatusEdicion objectAtIndex:4]];
        [self.arregloStatusInicio replaceObjectAtIndex:4 withObject:[self.datosUsuario.arregloEstatusEdicion objectAtIndex:5]];
    }
    UIImage *imagenBoton = [UIImage imageNamed:@"btnprevisualizar.png"];
    UIButton *botonPrevisualizar = [UIButton buttonWithType:UIButtonTypeCustom];
    [botonPrevisualizar setFrame:CGRectMake(0, 0, imagenBoton.size.width, imagenBoton.size.height)];
    [botonPrevisualizar setImage:imagenBoton forState:UIControlStateNormal];
    [botonPrevisualizar addTarget:self action:@selector(mostrarWeb:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *botonDerecha = [[UIBarButtonItem alloc] initWithCustomView:botonPrevisualizar];
    self.navigationItem.rightBarButtonItem = botonDerecha;
    
    if (self.datosUsuario.arregloEstatusPerfil != nil) {
        [self.arregloStatusInicio replaceObjectAtIndex:3 withObject:[self.datosUsuario.arregloEstatusPerfil objectAtIndex:0]];
    }
    
    [self.tablaInicio reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfo"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellInfo"];
    }
    UIImageView *imagenAccesory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnsiguiente.png"]];
    [cell setAccessoryView:imagenAccesory];
    
    if ([[self.arregloStatusInicio objectAtIndex:indexPath.row] isEqual:@NO]) {
        [cell.imageView setImage:[UIImage imageNamed:@"noeditado.png"]];
        [cell.textLabel setTextColor:colorFuenteVerde];
    }
    else {
        [cell.imageView setImage:[UIImage imageNamed:@"editado.png"]];
        [cell.textLabel setTextColor:colorFuenteAzul];
    }
    
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    [cell.textLabel setText:[self.arregloDatos objectAtIndex:indexPath.row]];
    if (indexPath.row == 3) {
        cell.textLabel.numberOfLines = 2;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            CrearPaso2ViewController *paso2 = [[CrearPaso2ViewController alloc] initWithNibName:@"CrearPaso2ViewController" bundle:nil];
            [paso2 setIndex:indexPath.row];
            [paso2 setTituloPaso:NSLocalizedString(@"nombreEmpresa", nil)];
            [self.navigationController pushViewController:paso2 animated:YES];
        }
            break;
            
        case 1: {
            CrearPaso2ViewController *paso2 = [[CrearPaso2ViewController alloc] initWithNibName:@"CrearPaso2ViewController" bundle:nil];
            [paso2 setIndex:3];
            [paso2 setTituloPaso:NSLocalizedString(@"descripcionCorta", nil)];
            [self.navigationController pushViewController:paso2 animated:YES];
        }
            break;
            
        case 2: {
            ListaTelefonosViewController *listaTelefono = [[ListaTelefonosViewController alloc] initWithNibName:@"ListaTelefonosViewController" bundle:Nil];
            [listaTelefono setIndiceSeleccionado:4];
            [self.navigationController pushViewController:listaTelefono animated:YES];
        }
            break;
            
        case 3: {
            PerfilPaso2ViewController *perfil2 = [[PerfilPaso2ViewController alloc] initWithNibName:@"PerfilPaso2ViewController" bundle:Nil];
            [perfil2 setIndex:0];
            [perfil2 setTituloPerfil:NSLocalizedString(@"productoServicio", Nil)];
            [self.navigationController pushViewController:perfil2 animated:YES];
        }
            break;
            
        case 4: {
            if([CLLocationManager locationServicesEnabled] &&
               [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                MapaUbicacionViewController *mapaUbicacion  = [[MapaUbicacionViewController alloc] initWithNibName:@"MapaUbicacionViewController" bundle:Nil];
                [self.navigationController pushViewController:mapaUbicacion animated:YES];
            } else {
                [[AlertView initWithDelegate:nil message:NSLocalizedString(@"noGeolocalizacion", @"") andAlertViewType:AlertViewTypeInfo] show];
            }
        }
            break;
            
        default: {
            if ([self seccionesEditadas]) {
                NombrarViewController *nombrarView = [[NombrarViewController alloc] initWithNibName:@"NombrarViewController" bundle:Nil];
                self.datosUsuario.vistaOrigen = 12;
                [self.navigationController pushViewController:nombrarView animated:YES];
            }
            else {
                [[AlertView initWithDelegate:nil message:NSLocalizedString(@"mensajeInicioRapido", Nil) andAlertViewType:AlertViewTypeInfo] show];
            }
            
        }
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL) seccionesEditadas {
    BOOL editadas = YES;
    for (NSInteger i = 0; i < [self.arregloStatusInicio count]-2; i++) {
        if ([[self.arregloStatusInicio objectAtIndex:i] isEqual:@NO]) {
            editadas = NO;
        }
    }
    return editadas;
}

-(IBAction)mostrarWeb:(id)sender {
    VistaPreviaWebViewController *vistaPrevia = [[VistaPreviaWebViewController alloc] initWithNibName:@"VistaPreviaViewController" bundle:Nil];
    //[vistaPrevia setTipoVista:PreviewTypePrevia];
    [self.navigationController pushViewController:vistaPrevia animated:YES];
}

@end
