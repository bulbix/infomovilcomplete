//
//  EditarVideoViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 04/09/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "EditarVideoViewController.h"
#import "VistaVideoViewController.h"

@interface EditarVideoViewController ()

@end

@implementation EditarVideoViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.txtDescripcion setBackgroundColor:[UIColor whiteColor]];
    [self.txtTitulo setBackgroundColor:[UIColor whiteColor]];
    self.txtDescripcion.layer.cornerRadius = 5.0f;
    self.txtTitulo.layer.cornerRadius = 5.0f;
    [self.txtTitulo setText:[self.videoSeleccionado titulo]];
    [self.txtDescripcion setText:[self.videoSeleccionado descripcionVideo]];
    [self.imagenPreviaVideo setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.ytimg.com/vi/%@/0.jpg", self.videoSeleccionado.idVideo]]]]];
    
    
    if(IS_IPAD){
    
    
    }else if(IS_STANDARD_IPHONE_6_PLUS){
    
    
    }else if(IS_STANDARD_IPHONE_6){
    
    
    
    }
    
    
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reproducirVideo:(UIButton *)sender {
    VistaVideoViewController *vistaVideo = [[VistaVideoViewController alloc] initWithNibName:@"VistaVideoViewController" bundle:Nil];
    [vistaVideo setVideoSeleccionado:self.videoSeleccionado];
    [vistaVideo setModifico:YES];
    [self.navigationController pushViewController:vistaVideo animated:YES];
}
@end
