//
//  BuscaDireccionViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 05/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "BuscaDireccionViewController.h"

@interface BuscaDireccionViewController ()
@property (nonatomic, strong) AlertView *alert;
@end

@implementation BuscaDireccionViewController

@synthesize cajaBusqueda, geocoder;
@synthesize delegate;

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
//    [self.tituloVista setText:NSLocalizedString(@"buscar", @" ")];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecaverde.png"]];
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecacreasitio.png"]];
    
    //MBC
    if(IS_STANDARD_IPHONE_6){
        [self.cajaBusqueda setFrame:CGRectMake(50, 83, 280, 30)];
    }
    else if(IS_STANDARD_IPHONE_6_PLUS){
        [self.cajaBusqueda setFrame:CGRectMake(70, 83, 280, 30)];
    }
    else{
        [self.cajaBusqueda setFrame:CGRectMake(20, 83, 280, 30)];
    }
    
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscar", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscar", @" ") nombreImagen:@"NBverde.png"];

	}
    
    
    [self.labelBuscaDireccion setText:NSLocalizedString(@"buscaDireccion", Nil)];
    
    cajaBusqueda.layer.cornerRadius = 5;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    geocoder = [[CLGeocoder alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscar", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"buscar", @" ") nombreImagen:@"NBverde.png"];
		
	}
	[super viewWillAppear:YES];
    [self.vistaInferior setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField.text length] == 0) {
        return NO;
    }
    [textField resignFirstResponder];
    [self procesarDireccion];
    return YES;
}

-(void)procesarDireccion {
    self.alert = [AlertView initWithDelegate:nil message:NSLocalizedString(@"cargandoUbicacion", @" ") andAlertViewType:AlertViewTypeActivity];
    [self.alert show];
    [geocoder geocodeAddressString:cajaBusqueda.text completionHandler:^(NSArray *placemarks, NSError *error) {
        [self.alert hide];
        if ((error == nil) && (placemarks.count > 0)) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
#ifdef _DEBUG
            NSLog(@"la ubicacion es %@ ********************", placemark.location);
#endif
            [delegate buscaDireccionViewController:self conLocalizacion:placemark.location yDireccion:cajaBusqueda.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            AlertView *alerta = [AlertView initWithDelegate:nil message:NSLocalizedString(@"noDireccion", Nil) andAlertViewType:AlertViewTypeInfo];
            [alerta show];
#ifdef _DEBUG
            NSLog(@"No se encontro nada********************");
#endif
        }
    }];
}

@end
