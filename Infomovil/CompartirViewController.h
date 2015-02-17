//
//  CompartirViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 20/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import <GooglePlus/GooglePlus.h>

@interface CompartirViewController : InfomovilViewController<GPPSignInDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelNombreDominio;
@property (weak, nonatomic) IBOutlet UIView *vistaContenidoCompartir;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;

@property BOOL flujoregistro;

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;


- (IBAction)compartirFacebook:(UIButton *)sender;
- (IBAction)compartirTwitter:(UIButton *)sender;
- (IBAction)compartirEmail:(UIButton *)sender;
- (IBAction)compartirSMS:(UIButton *)sender;
- (IBAction)compartirWhatsapp:(UIButton *)sender;
- (IBAction)compartirGooglePlus:(id)sender;







@end
