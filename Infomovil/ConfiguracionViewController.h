//
//  ConfiguracionViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 20/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "InfomovilViewController.h"

@interface ConfiguracionViewController : InfomovilViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, AlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablaConfiguracion;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
