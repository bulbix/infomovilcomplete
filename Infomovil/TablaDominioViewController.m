//
//  TablaDominioViewController.m
//  Infomovil
//
//  Created by Infomovil on 10/23/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "TablaDominioViewController.h"
#import "DominiosUsuario.h"
#import "CNPPopupController.h"
#import "DatosUsuario.h"
#import "CommonUtils.h"
@interface TablaDominioViewController () <CNPPopupControllerDelegate>

@property (nonatomic, strong) NSMutableArray *arregloDominios;
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation TablaDominioViewController

-(void) loadView {
    DatosUsuario *datosUsuario = [DatosUsuario sharedInstance];
    self.arregloDominios = datosUsuario.dominiosUsuario;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arregloDominios count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfoDominio"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellInfoDominio"];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
    //}
    DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:indexPath.row];
   
    /*
    if ([usuarioDom.statusDominio isEqualToString:@"Tramite"]) {
        if ([CommonUtils validaMail:usuarioDom.domainName]) {
            [cell.textLabel setText:[NSString stringWithFormat:@".%@", [usuarioDom domainType]]];
            [cell.detailTextLabel setText:NSLocalizedString(@"txtDominioDisponible", nil)];
        }
        else {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@.%@", usuarioDom.domainName, usuarioDom.domainType]];
        }
    }
    else {
       if ([usuarioDom.domainType isEqualToString:@"recurso"]) {
            [cell.textLabel setText:[NSString stringWithFormat:@"info-movil.com/%@", usuarioDom.domainName]];
        }
        else {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@.%@", usuarioDom.domainName, usuarioDom.domainType]];
        }
    }
    */
    
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
       if([prefs stringForKey:@"dominioPublicado"]){
            [cell.textLabel setText:[NSString stringWithFormat:@"%@.tel",[prefs stringForKey:@"dominioPublicado"]]];
            
       }else  if ([usuarioDom.domainType isEqualToString:@"recurso"]) {
           [cell.textLabel setText:[NSString stringWithFormat:@"info-movil.com/%@", usuarioDom.domainName]];
       }
       else if([usuarioDom.domainType isEqualToString:@"tel"]){
           [cell.textLabel setText:[NSString stringWithFormat:@"%@.%@", usuarioDom.domainName, usuarioDom.domainType]];
       }
    
    
    
    
    
    
    
    
    
    
    
    [cell.textLabel setTextColor:colorFuenteAzul];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    [cell.detailTextLabel setTextColor:colorFuenteVerde];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
}

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTag:(NSInteger)tag {
    
}

@end
