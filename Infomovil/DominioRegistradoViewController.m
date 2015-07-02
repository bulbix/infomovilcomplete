//
//  DominioRegistradoViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 21/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "DominioRegistradoViewController.h"

@interface DominioRegistradoViewController ()

@end

@implementation DominioRegistradoViewController

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
	
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.labelDominio setText:[NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio]];

	
    self.navigationItem.rightBarButtonItem = Nil;
	self.btnComprar.hidden = YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"roja.png"];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
