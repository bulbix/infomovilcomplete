//
//  TipsViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 23/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import <MessageUI/MessageUI.h>

@interface TipsViewController : InfomovilViewController <UIScrollViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollVistaTips;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;

@property (weak, nonatomic) IBOutlet UIView *vistaTip1;
@property (weak, nonatomic) IBOutlet UIView *vistaTip2;
@property (weak, nonatomic) IBOutlet UIView *vistaTip3;
@property (weak, nonatomic) IBOutlet UIView *vistaTip4;

@property (weak, nonatomic) IBOutlet UILabel *seccionUnoTItulo;
@property (weak, nonatomic) IBOutlet UILabel *seccionUnoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *seccionUnoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *seccionUnoLabel3;
@property (weak, nonatomic) IBOutlet UILabel *seccionUnoLabel4;

@property (weak, nonatomic) IBOutlet UILabel *seccionDosTitulo;
@property (weak, nonatomic) IBOutlet UILabel *seccionDosLabel1;
@property (weak, nonatomic) IBOutlet UILabel *seccionDosLabel2;
@property (weak, nonatomic) IBOutlet UILabel *seccionDosLabel3;
@property (weak, nonatomic) IBOutlet UILabel *seccionDosLabel4;

@property (weak, nonatomic) IBOutlet UILabel *seccionTresTitulo;
@property (weak, nonatomic) IBOutlet UILabel *seccionTresLabel1;
@property (weak, nonatomic) IBOutlet UILabel *seccionTresLabel2;
@property (weak, nonatomic) IBOutlet UILabel *seccionTresLabel3;

@property (weak, nonatomic) IBOutlet UILabel *seccionCuatroTitulo;
@property (weak, nonatomic) IBOutlet UILabel *seccionCuatroLabel1;

@property (weak, nonatomic) IBOutlet UILabel *vineta32;

@property (nonatomic, retain) UIAlertView *dialogoFacebook;
@property (nonatomic, retain) UIAlertView *dialogoTwitter;

@property (weak, nonatomic) IBOutlet UIButton *btnFace;
@property (weak, nonatomic) IBOutlet UIButton *btnTwit;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSms;
@property (weak, nonatomic) IBOutlet UIButton *btnWhats;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogle;

@property (weak, nonatomic) IBOutlet UILabel *b1;
@property (weak, nonatomic) IBOutlet UILabel *b2;
@property (weak, nonatomic) IBOutlet UILabel *b3;
@property (weak, nonatomic) IBOutlet UILabel *b4;
@property (weak, nonatomic) IBOutlet UILabel *b5;
@property (weak, nonatomic) IBOutlet UILabel *b6;

@property (weak, nonatomic) IBOutlet UIButton *irMiSitio;
- (IBAction)irMiSitioAct:(id)sender;


- (IBAction)cambiarPagina:(UIPageControl *)sender;
- (IBAction)compartirFacebook:(UIButton *)sender;
- (IBAction)compartirTwitter:(UIButton *)sender;
- (IBAction)compartirEmail:(UIButton *)sender;
- (IBAction)compartirSMS:(UIButton *)sender;
- (IBAction)compartirWhatsapp:(UIButton *)sender;
- (IBAction)compartirGooglePlus:(id)sender;

@end
