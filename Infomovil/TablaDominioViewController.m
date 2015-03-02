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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSLog(@"El numero de filas es: %i",[self.arregloDominios count]);
    if([self.arregloDominios count] == 0 )
        return 1;
    else
    return [self.arregloDominios count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Ahora si entro");
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSLog(@"MenuPasosViewController - Dominio en TablaDominioViewController: %@ ",self.datosUsuario.dominio);
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfoDominio"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellInfoDominio"];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
   
    if(![self.datosUsuario.dominio isEqualToString:@"(null)"] && ![self.datosUsuario.dominio isEqualToString:@""] && ![self.datosUsuario.dominio isEqual:[NSNull null]] && !(self.datosUsuario.dominio == nil)){
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@.tel", self.datosUsuario.dominio]];
#if DEBUG
    [cell.textLabel setText:[NSString stringWithFormat:@"info-movil.com/%@", self.datosUsuario.dominio]];
#endif
    
    }
    
    /* PARA LA VERSION DE DOMINIOS */
    /*
     DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:indexPath.row];
     
     if ([usuarioDom.statusDominio isEqualToString:@"Tramite"]) {
        if ([CommonUtils validaMail:usuarioDom.domainName]) {
            [cell.textLabel setText:[NSString stringWithFormat:@".%@", [usuarioDom domainType]]];
            [cell.detailTextLabel setText:NSLocalizedString(@"txtDominioDisponible", nil)];
        }
        else {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@.tel", self.datosUsuario.dominio]];
        }
    }
    else {
        if ([usuarioDom.domainType isEqualToString:@"recurso"]) {
            [cell.textLabel setText:[NSString stringWithFormat:@"infomovil.com/%@", usuarioDom.domainName]];
        }
        else {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@.tel", self.datosUsuario.dominio]];
        }
    }
     */
    [cell.textLabel setTextColor:colorFuenteAzul];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    [cell.detailTextLabel setTextColor:colorFuenteVerde];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
}
/*
 -(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:indexPath.row];
 if (indexPath.row == 0 && [usuarioDom.domainType isEqualToString:@"recurso"]) {
 NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
 paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
 paragraphStyle.alignment = NSTextAlignmentCenter;
 
 NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Plan Pro" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Book" size:17], NSParagraphStyleAttributeName : paragraphStyle}];
 NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"www.infomovil.com/%@", usuarioDom.domainName] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Book" size:17], NSParagraphStyleAttributeName : paragraphStyle}];
 
 NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Actualizar" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Book" size:17], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
 
 CNPPopupButtonItem *buttonItem = [CNPPopupButtonItem defaultButtonItemWithTitle:buttonTitle backgroundColor:[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0]];
 buttonItem.tag = 10;
 buttonItem.selectionHandler = ^(CNPPopupButtonItem *item){
 NSLog(@"Block for button: %@", item.buttonTitle.string);
 };
 
 self.popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[lineOne] buttonItems:@[buttonItem]];
 self.popupController.theme = [CNPPopupTheme defaultTheme];
 self.popupController.theme.popupStyle = CNPPopupStyleCentered;
 self.popupController.delegate = self;
 self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
 [self.popupController presentPopupControllerAnimated:YES];
 }
 else {
 }
 }
 */
- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTag:(NSInteger)tag {
    
}

@end
