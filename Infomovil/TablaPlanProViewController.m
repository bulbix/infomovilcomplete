//
//  TablaPlanProViewController.m
//  Infomovil
//
//  Created by Infomovil on 10/23/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "TablaPlanProViewController.h"

@interface TablaPlanProViewController () {
    NSMutableArray * arreglo;
}

@end

@implementation TablaPlanProViewController

-(void) loadView {
    arreglo = [NSMutableArray arrayWithObjects:
               NSLocalizedString(@"numeroImagenes", @" "),
               NSLocalizedString(@"datosBasicos", @" "),
               //NSLocalizedString(@"videoLigado", @" "),
               NSLocalizedString(@"numeroContactos", @" "),
               //NSLocalizedString(@"brand", @" "),
               NSLocalizedString(@"ads", @" "),
               //NSLocalizedString(@"templates", @" "),
               nil];
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

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arreglo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfo"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellInfo"];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    //}
    [cell.textLabel setText:[arreglo objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:colorFuenteAzul];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

@end
