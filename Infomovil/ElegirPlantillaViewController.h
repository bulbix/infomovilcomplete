//
//  ElegirPlantillaViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/11/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface ElegirPlantillaViewController : InfomovilViewController
{

    NSArray * nombrePlantilla;
    NSArray * descripcionPlantilla;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollTemplate;


@end
