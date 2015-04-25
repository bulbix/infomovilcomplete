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
 
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"roja.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"plecaroja.png"];
	}
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.labelDominio setText:[NSString stringWithFormat:@"www.%@.tel", self.datosUsuario.dominio]];
#if DEBUG
   // [self.labelDominio setText:[NSString stringWithFormat:@"http://infomovil.com/%@", self.datosUsuario.dominio]];
#endif
	
    self.navigationItem.rightBarButtonItem = Nil;
	self.btnComprar.hidden = YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"roja.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"nombrar", @" ") nombreImagen:@"NBbermellon.png"];
	}
    self.datosUsuario = [DatosUsuario sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
