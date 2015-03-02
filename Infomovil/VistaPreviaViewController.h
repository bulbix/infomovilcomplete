//
//  VistaPreviaViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 21/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

typedef enum {
    PreviewTypeEjemplo,
    PreviewTypePrevia
}PreviewType;

@interface VistaPreviaViewController : InfomovilViewController <AlertViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) PreviewType tipoVista;

@end
