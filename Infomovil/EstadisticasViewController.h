//
//  EstadisticasViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"
#import "CRProductTour.h"

@interface EstadisticasViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol, UINavigationBarDelegate, UINavigationControllerDelegate> {
    CRProductTour *productTourView;
}

@property (weak, nonatomic) IBOutlet UIView *vistaEstadisticas;
@property (weak, nonatomic) IBOutlet UISegmentedControl *botonCambioEstadisticas;
@property (weak, nonatomic) IBOutlet UISegmentedControl *botonTotales;

- (IBAction)cambiarEstadisticas:(UISegmentedControl *)sender;
- (IBAction)cambiarVisitas:(UISegmentedControl *)sender;
@end
