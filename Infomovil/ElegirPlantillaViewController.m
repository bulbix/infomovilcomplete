//
//  ElegirPlantillaViewController.m
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/11/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "ElegirPlantillaViewController.h"
#import "PlantillaViewController.h"


@interface ElegirPlantillaViewController ()

@end

@implementation ElegirPlantillaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.scrollTemplate setShowsHorizontalScrollIndicator:NO];
    [self.scrollTemplate setShowsVerticalScrollIndicator:NO];
    [self.scrollTemplate setPagingEnabled:YES];
    
    
    [self setupScrollView];
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 450, 320, 20)];
    [pgCtr setTag:5];
    pgCtr.numberOfPages=5;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:pgCtr];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"elegirEstilo", @" ") nombreImagen:@"barramorada.png"];
    }else{
        [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"elegirEstilo", @" ") nombreImagen:@"NBlila.png"];
    }
    
    
    self.navigationItem.rightBarButtonItem = nil;
    
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.vistaInferior.hidden==NO){
        self.vistaInferior.hidden = YES;
    }

}

- (void)setupScrollView {
    nombrePlantilla = @[@"Estilo Divertido", @"Estilo Clásico", @"Estilo Creativo",
                        @"Estilo Moderno", @"Estilo Estándar"];
    descripcionPlantilla = @[@"Estilo popular para Restaurantes, Pizzerias, Taquerías, Antros, Bares, etc.", @"Estilo popular para eventos formales, bodas, quinceaños, abogados, despachos, profesionistas, etc.", @"Estilo popular para creativos, músicos, estudiantes, fotógrafos, agencias, diseñadores, artistas,etc.",
                             @"Estilo popular para empresas de tecnología, freelancers, distribuidoras de productos electrónicos, etc.", @"Estilo popular para todo tipo de productos y servicios."];
    self.scrollTemplate.tag = 1;
    self.scrollTemplate.autoresizingMask=UIViewAutoresizingNone;
  
    for (int i=0; i<5; i++) {
       PlantillaViewController *pController = [[PlantillaViewController alloc] initWithNibName:@"Plantilla" bundle:[NSBundle mainBundle]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"t%i.png",i+1]];
        
        //pController.imgTemplate.contentMode=UIViewContentModeScaleToFill;
        pController.view.frame = CGRectMake(320*i, 0, 320, 420);
        [pController.imgTemplate setImage:image];
        pController.nombrePlantilla.text = [nombrePlantilla objectAtIndex:i];
        pController.descripcionPlantilla.text = [descripcionPlantilla objectAtIndex:i];
        [self.scrollTemplate addSubview:pController.view];
    }
   
     [self.scrollTemplate setContentSize:CGSizeMake(self.scrollTemplate.frame.size.width*5, self.scrollTemplate.frame.size.height)];
  //  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
    self.scrollTemplate.tag = 1;
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:5];
    CGFloat contentOffset = self.scrollTemplate.contentOffset.x;
    int nextPage = (int)(contentOffset/self.scrollTemplate.frame.size.width) + 1 ;
    if( nextPage!=5 )  {
        [self.scrollTemplate scrollRectToVisible:CGRectMake(nextPage*self.scrollTemplate.frame.size.width, 0, self.scrollTemplate.frame.size.width, self.scrollTemplate.frame.size.height) animated:YES];
        pgCtr.currentPage=nextPage;
    } else {
        [self.scrollTemplate scrollRectToVisible:CGRectMake(0, 0, self.scrollTemplate.frame.size.width, self.scrollTemplate.frame.size.height) animated:YES];
        pgCtr.currentPage=0;
    }
}


@end
