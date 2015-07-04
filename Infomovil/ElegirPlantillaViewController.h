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

   
  
   
    
   
}


@property (nonatomic, strong) NSArray * nombrePlantilla;
@property (nonatomic, strong) NSArray * nombrePlantillaEn;
@property (nonatomic, strong) NSArray * nombreWebServiceTemplate;
@property (nonatomic, strong) NSArray * descripcionPlantilla;
@property (nonatomic, strong) NSArray * descripcionPlantillaEn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollTemplate;
@property(nonatomic, strong) NSString * plantillaSeccionada;
@property(nonatomic, assign) NSInteger plantillaAPublicar;

@property (weak, nonatomic) IBOutlet UIView *viewExtra;







@end
