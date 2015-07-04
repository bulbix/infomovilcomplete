//
//  VerEjemploPlantillaViewController.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 3/11/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"


@interface VerEjemploPlantillaViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol, UIWebViewDelegate,UIApplicationDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,assign) NSInteger index;
@end
