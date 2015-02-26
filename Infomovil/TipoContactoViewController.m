//
//  TipoContactoViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 02/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "TipoContactoViewController.h"
#import "ContactoPaso2ViewController.h"
#import "TipoContactoCell.h"
#import "AppsFlyerTracker.h"
#import "AppDelegate.h"

@interface TipoContactoViewController ()

@property(nonatomic, strong) NSArray *arregloTipoContacto;

@end

@implementation TipoContactoViewController

@synthesize arregloTipoContacto;

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
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tipoContacto", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tipoContacto", @" ") nombreImagen:@"NBverde.png"];
	}
    
    arregloTipoContacto = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
    
    self.tablaContacto.layer.cornerRadius = 5;
	
	if(!IS_IPHONE_5 && ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion ){
		self.tablaContacto.frame = CGRectMake(20, 33, 280, 480);
	}
	else if(IS_IPHONE_5 && ((AppDelegate *)[[UIApplication sharedApplication] delegate]).existeSesion ){
		self.tablaContacto.frame = CGRectMake(20, 33, 280, 480);
	}
    
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tipoContacto", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"tipoContacto", @" ") nombreImagen:@"NBverde.png"];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arregloTipoContacto count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictDatos = [arregloTipoContacto objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"cellTipo";
    TipoContactoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == Nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TipoContactoCell" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
    }
    [cell.textLabel setText:[dictDatos objectForKey:@"text"]];
    UIImage *imagenTipo = [UIImage imageNamed:[dictDatos objectForKey:@"image"]];
    CGSize tamImagen = imagenTipo.size;
    float ratio=cell.imageView.frame.size.width/tamImagen.width;
    float scaledHeight=tamImagen.height*ratio;
    if(scaledHeight < cell.imageView.frame.size.height)
    {
        [cell.imageView setFrame:CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, cell.imageView.frame.size.width, scaledHeight)];
    }
    [cell.imageView setImage:imagenTipo];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
//    [cell.textLabel setTextColor:colorFuenteAzul];
    
//    [cell.textLabel setFrame:CGRectMake(250, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height)];
    return cell;
}

#pragma - mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactoPaso2ViewController *contacto = [[ContactoPaso2ViewController alloc] initWithNibName:@"ContactoPaso2ViewController" bundle:Nil];
    [contacto setTipoContacto:[arregloTipoContacto objectAtIndex:indexPath.row]];
    [contacto setOpcionSeleccionada:indexPath.row];
    [contacto setContactosOperacion:ContactosOperacionAgregar];
    [self.navigationController pushViewController:contacto animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(IBAction)guardarInformacion:(id)sender {
    //
}



@end
