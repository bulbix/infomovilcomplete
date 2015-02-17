//
//  TerminosCondicionesViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 24/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"


@interface TerminosCondicionesViewController : InfomovilViewController <AlertViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NSInteger index;

@end