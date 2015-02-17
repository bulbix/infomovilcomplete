//
//  CompartirPublicacionViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 19/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "CuentaViewProtocol.h"

@interface CompartirPublicacionViewController : InfomovilViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelDominio;

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *labelPublicaTiempo;
@property NSInteger tipoVista;
@property (nonatomic, strong) id<CuentaViewProtocol> delegado;

- (IBAction)enviarSMS:(UIButton *)sender;
- (IBAction)enviarEmail:(UIButton *)sender;
- (IBAction)compartirFacebook:(UIButton *)sender;
- (IBAction)compartirTwitter:(UIButton *)sender;
- (IBAction)compartirWhatsapp:(UIButton *)sender;
- (IBAction)compartirGooglePlus:(id)sender;


@end
