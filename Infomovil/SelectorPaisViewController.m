//
//  SelectorPaisViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 10/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "SelectorPaisViewController.h"

@interface SelectorPaisViewController () {
    NSArray *codigoPais;
    NSLocale *local;
	
	NSMutableArray *array;
	NSMutableArray *codeArray;
	NSMutableArray *filteredArray;
	NSMutableArray *filteredCodeArray;
}

@property (nonatomic, strong) NSMutableArray *arregloPais;
//@property (nonatomic, strong) NSDictionary *ccMapping;
@property (nonatomic, strong) NSDictionary *prefijos;

@end

@implementation SelectorPaisViewController

@synthesize arregloPais;
@synthesize searchBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    codigoPais = [NSLocale ISOCountryCodes];
    local = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]];
    arregloPais = [[NSMutableArray alloc] initWithCapacity:[codigoPais count]];
    
    self.prefijos = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                pathForResource:@"CallingCodes"
                                                                ofType:@"plist"]];
	
	[self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"miconfiguracionon.png"] forState:UIControlStateNormal];
    
    if(IS_IPAD){
        [self.botonConfiguracion setFrame:CGRectMake(264, 10, 88, 80)];
    }else{
        [self.botonConfiguracion setFrame:CGRectMake(240, 0, 80, 68)];
    }
    self.navigationItem.rightBarButtonItem = Nil;
    self.tablaPais.layer.cornerRadius = 5.0f;
    
    [self fillDataSourceArray];
	array = [[NSMutableArray alloc] init];
	filteredArray = [[NSMutableArray alloc] init];
	
	for(int i=0; i<[arregloPais count] ; i++){
		[array addObject:[[arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
		[filteredArray addObject:[[arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
	}
	
	[self.tablaPais reloadData];
	
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"pais", @" ") nombreImagen:self.nombreTituloVista];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"pais", @" ") nombreImagen:@"NBverde"];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"paisCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
	if (tableView != self.searchDisplayController.searchResultsTableView){
		[array removeAllObjects];
		[filteredArray removeAllObjects];
		for(int i=0; i<[arregloPais count] ; i++) {
			[array addObject: [[arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
			[filteredArray addObject:[[arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
		}
	}
	int indice = 0;
	for(int i=0;i<[arregloPais count];i++) {
		if([[arregloPais objectAtIndex:i] objectForKey:@"countryName"] !=[filteredArray objectAtIndex:indexPath.row]){
			indice++;
		}else{
			break;
		}
	}
  

	if ( _publicarController == nil )
	{
		[cell.detailTextLabel setText:[[arregloPais objectAtIndex:indice] objectForKey:@"detailLabel"]];
		[cell.detailTextLabel setTextColor:colorFuenteVerde];
		[cell.detailTextLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
	}
	[cell.textLabel setText:[filteredArray objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:colorFuenteVerde];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
    return cell;
}

#pragma mark - UITableViewDelegate 

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.contactoController != nil) {
		int indice = 0;
		for(int i=0;i<[arregloPais count];i++){
			if([[arregloPais objectAtIndex:i] objectForKey:@"countryName"]!=[filteredArray objectAtIndex:indexPath.row]){
				indice++;
			}else{
				break;
			}
		}
		[self.contactoController.labelCodigo setText:[[arregloPais objectAtIndex:indice] objectForKey:@"detailLabel"]];
		[self.contactoController.labelPais setText:[filteredArray objectAtIndex:indexPath.row]];
        [self.contactoController.imagenSiguiente setHidden:YES];
        self.contactoController.seleccionoPais = YES;
        self.contactoController.modifico = YES;
    }
	else if(self.publicarController != nil){
		int indice = 0;
		for(int i=0;i<[arregloPais count];i++){
			if([[arregloPais objectAtIndex:i] objectForKey:@"countryName"]!=[filteredArray objectAtIndex:indexPath.row]){
				indice++;
			}else{
				break;
			}
		}
		[self.publicarController.labelPaisSeleccionado setText:[filteredArray objectAtIndex:indexPath.row]];
		if([[filteredArray objectAtIndex:indexPath.row] isEqualToString:@"Mexico"]){
			self.publicarController.nPais = @"1";
		}else{
			NSString * aux = [[arregloPais objectAtIndex:indice] objectForKey:@"detailLabel"];
			self.publicarController.nPais = [aux stringByReplacingOccurrencesOfString:@"+" withString:@""];
		}

	}
    else {

		if (tableView != self.searchDisplayController.searchResultsTableView){
			[array removeAllObjects];
			[filteredArray removeAllObjects];
			for(int i=0; i<[arregloPais count] ; i++){
				[array addObject:[[arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
				[filteredArray addObject:[[arregloPais objectAtIndex:i]objectForKey:@"countryName"]];
			}
		}
        int indice = 0;
        for(int i=0;i<[arregloPais count];i++){
			if([[arregloPais objectAtIndex:i] objectForKey:@"countryName"]!=[filteredArray objectAtIndex:indexPath.row]){
				indice++;
			}else{
				break;
			}
		}
        [self.seleccionaDelegate guardaPais:[filteredArray objectAtIndex:indexPath.row] yCodigo:[[arregloPais objectAtIndex:indice] objectForKey:@"detailLabel" ]];
	
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fillDataSourceArray {
//    // set up the final data source for the table
//    [dataSourceArray removeAllObjects];
    for (NSString *isoCC in [self.prefijos allKeys]) {
        NSUInteger idx = [codigoPais indexOfObjectPassingTest:^(NSString *cc, NSUInteger idx, BOOL *stop) {
            return [cc isEqualToString:isoCC];
        }];
        if (idx == NSNotFound)
            continue;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              isoCC, @"isoCountryCode",
                              [self.prefijos objectForKey:isoCC], @"detailLabel",
                              [StringUtils eliminarAcentos:[local displayNameForKey:NSLocaleCountryCode value:isoCC]], @"countryName",
                              nil];
        [self.arregloPais addObject:dict];
    }
    [self.arregloPais sortUsingComparator:(NSComparator)^(NSDictionary *a, NSDictionary *b) {
        NSString *aS = [a objectForKey:@"countryName"];
        NSString *bS = [b objectForKey:@"countryName"];
		if([aS isEqualToString:@"Mexico"]){
			return [bS compare:aS];
		}
		
			
        return [aS compare:bS];
    }];
    
    [self.tablaPais reloadData];
}



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[filteredArray removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    filteredArray =[NSMutableArray arrayWithArray:[array filteredArrayUsingPredicate:resultPredicate]];
	
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
							   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
									  objectAtIndex:[self.searchDisplayController.searchBar
													 selectedScopeButtonIndex]]];
    
    return YES;
}


@end
