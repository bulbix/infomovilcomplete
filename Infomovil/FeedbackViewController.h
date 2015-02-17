//
//  FeedbackViewController.h
//  Infomovil
//
//  Created by Sergio Sanchez on 11/10/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"

@interface FeedbackViewController : InfomovilViewController

@property (weak, nonatomic) IBOutlet UITextView *txtMensaje;
@property (weak, nonatomic) IBOutlet UILabel *labelPregunta;
@property (weak, nonatomic) IBOutlet UISwitch *switchFeedback;
@property (weak, nonatomic) IBOutlet UILabel *labelMensaje;

- (IBAction)enviarError:(UISwitch *)sender;
@end
