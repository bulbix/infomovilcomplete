//
//  ElegirPlantillaViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/11/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface ElegirPlantillaViewController : InfomovilViewController<UIScrollViewDelegate, AlertViewDelegate, WS_HandlerProtocol>
{

    NSArray * nombrePlantilla;
    NSArray * nombrePlantillaEn;
    NSArray * nombreWebServiceTemplate;
    NSArray * descripcionPlantilla;
    NSArray * descripcionPlantillaEn;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollTemplate;
@property(weak, weak) NSString * plantillaSeccionada;
@property(nonatomic) NSInteger plantillaAPublicar;
@end
