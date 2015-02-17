//
//  VistaVideoViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "VideoModel.h"
#import "WS_HandlerProtocol.h"

@interface VistaVideoViewController : InfomovilViewController <AlertViewDelegate, WS_HandlerProtocol, UIWebViewDelegate>

//@property BOOL modifico;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) VideoModel *videoSeleccionado;
@end
