//
//  CambiarPasswordViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"

@interface CambiarPasswordViewController : InfomovilViewController <AlertViewDelegate,WS_HandlerProtocol>

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end
