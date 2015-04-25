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

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.datosUsuario = [DatosUsuario sharedInstance];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfoDominio"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellInfoDominio"];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15]];
    
   
    

    for(int i= 0; i< [self.arregloDominios count]; i++){
        DominiosUsuario *usuarioDom = [self.arregloDominios objectAtIndex:i];
/*
#if DEBUG
        if(![self.datosUsuario.dominio isEqualToString:@"(null)"] && ![self.datosUsuario.dominio isEqualToString:@""] && ![self.datosUsuario.dominio isEqual:[NSNull null]] && !(self.datosUsuario.dominio == nil) && [usuarioDom.domainType isEqualToString:@"recurso"]){
            [cell.textLabel setText:[NSString stringWithFormat:@"http://infomovil.com/%@", self.datosUsuario.dominio]];
        }
#else
*/
 if(![self.datosUsuario.dominio isEqualToString:@"(null)"] && ![self.datosUsuario.dominio isEqualToString:@""] && ![self.datosUsuario.dominio isEqual:[NSNull null]] && !(self.datosUsuario.dominio == nil) && [usuarioDom.domainType isEqualToString:@"tel"]){
            [cell.textLabel setText:[NSString stringWithFormat:@"%@.tel", self.datosUsuario.dominio]];
        }
/*#endif*/
        
        [cell.textLabel setTextColor:colorFuenteAzul];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        [cell.detailTextLabel setTextColor:colorFuenteVerde];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }

    return cell;
}

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTag:(NSInteger)tag {
    
}

@end
