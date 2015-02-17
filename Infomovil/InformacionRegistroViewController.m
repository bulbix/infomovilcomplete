//
//  InformacionRegistroViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 24/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InformacionRegistroViewController.h"
#import "SelectorPaisViewController.h"
#import "InformacionRegistro.h"
#import "WS_HandlerInformacionRegistro.h"

@interface InformacionRegistroViewController (){
	
	NSArray *arregloEmpresa;
	NSArray *arregloIndividual;
	
	NSMutableArray *checaEmpresa;
	NSMutableArray *checaIndividual;

	
	NSMutableArray *infoEmpresa;
	NSMutableArray *infoIndividual;
	
	BOOL tipo; //NO = EMPRESA
			   //YES = INDIVIDUAL
	
	NSString * paisText;
	NSIndexPath * editingIndexPath;
	
	NSString * nombre;
	NSString * servicio;
	NSString * numero;
	NSString * mail;
	NSString * calleNum;
	NSString * pob;
	NSString * cd;
	NSString * edo;
	NSString * cP;
	NSString * Pais;
	NSString * codPais;
	
	NSString * campo;
	
	//Banderas
	BOOL bNombre;
	BOOL bServicios;
	BOOL bNumero;
	BOOL bMail;
	BOOL bCalle;
	BOOL bPob;
	BOOL bCd;
	BOOL bEdo;
	BOOL bCp;
	BOOL bPais;
	
	BOOL actualizoCorrecto;
	
	
}

@property (nonatomic, strong) NSArray *arregloConfiguracion;
@property (nonatomic, strong) AlertView *alertaContacto;

@end

@implementation InformacionRegistroViewController

@synthesize seleccionoPais;

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
    self.guardarVista = YES;
	
	self.datosUsuario = [DatosUsuario sharedInstance];
	NSLog(@"servicio: %@",self.datosUsuario.servicioCliente);
	if(!(self.datosUsuario.servicioCliente == nil) && !([self.datosUsuario.servicioCliente isEqualToString:@""])){
		NSLog(@"no vacia");
		infoEmpresa = [NSMutableArray arrayWithObjects:
					   self.datosUsuario.nombreOrganizacion == nil ? @"" : self.datosUsuario.nombreOrganizacion,
					   self.datosUsuario.servicioCliente == nil ? @"" : self.datosUsuario.servicioCliente,
					   self.datosUsuario.numeroMovil == nil ? @"" : self.datosUsuario.numeroMovil,
					   self.datosUsuario.email == nil ? @"" : self.datosUsuario.email,
					   self.datosUsuario.calleNumero == nil ? @"" : self.datosUsuario.calleNumero,
					   self.datosUsuario.poblacion == nil ? @"" : self.datosUsuario.poblacion,
					   self.datosUsuario.ciudad == nil ? @"" : self.datosUsuario.ciudad,
					   self.datosUsuario.estado == nil ? @"" : self.datosUsuario.estado,
					   self.datosUsuario.cp == nil ? @"" : self.datosUsuario.cp,
					   self.datosUsuario.pais == nil ? @"" : self.datosUsuario.pais,
					   nil];
		infoIndividual = [NSMutableArray arrayWithObjects:
						  self.datosUsuario.servicioCliente == nil ? @"" : self.datosUsuario.servicioCliente,
						  self.datosUsuario.numeroMovil == nil ? @"" : self.datosUsuario.numeroMovil,
						  self.datosUsuario.email == nil ? @"" : self.datosUsuario.email,
						  self.datosUsuario.calleNumero == nil ? @"" : self.datosUsuario.calleNumero,
						  self.datosUsuario.poblacion == nil ? @"" : self.datosUsuario.poblacion,
						  self.datosUsuario.ciudad == nil ? @"" : self.datosUsuario.ciudad,
						  self.datosUsuario.estado == nil ? @"" : self.datosUsuario.estado,
						  self.datosUsuario.cp == nil ? @"" : self.datosUsuario.cp,
						  self.datosUsuario.pais == nil ? @"" : self.datosUsuario.pais,
						  nil];
		
		nombre = self.datosUsuario.nombreOrganizacion;
		servicio = self.datosUsuario.servicioCliente;
		numero = self.datosUsuario.numeroMovil;
		mail = self.datosUsuario.email;
		calleNum = self.datosUsuario.calleNumero;
		pob = self.datosUsuario.poblacion;
		cd = self.datosUsuario.ciudad;
		edo = self.datosUsuario.estado;
		cP = self.datosUsuario.cp;
		Pais = self.datosUsuario.pais;
		codPais = self.datosUsuario.pais;
		
	}else{
		infoEmpresa = [NSMutableArray arrayWithObjects:@"",
					   @"",
					   @"",
					   @"",
					   @"",
					   @"",
					   @"",
					   @"",
					   @"",
					   @"",nil];
		infoIndividual = [NSMutableArray arrayWithObjects:@"",
						  @"",
						  @"",
						  @"",
						  @"",
						  @"",
						  @"",
						  @"",
						  @"",nil];
	}
	
	checaEmpresa = [NSMutableArray arrayWithObjects:NSLocalizedString(@"nombreOrganizacionCheck", @" "),
					NSLocalizedString(@"servicioClienteCheck", @" "),
					NSLocalizedString(@"numeroMovilCheck", @" "),
					NSLocalizedString(@"emailCheck", @" "),
					NSLocalizedString(@"calleNumeroCheck", @" "),
					NSLocalizedString(@"poblacionCheck", @" "),
					NSLocalizedString(@"ciudadCheck", @" "),
					NSLocalizedString(@"estadoCheck", @" "),
					NSLocalizedString(@"cpCheck", @" "),
					NSLocalizedString(@"paisCheck", @" "),nil];
	
	checaIndividual = [NSMutableArray arrayWithObjects:NSLocalizedString(@"servicioClienteCheck", @" "),
					   NSLocalizedString(@"numeroMovilCheck", @" "),
					   NSLocalizedString(@"emailCheck", @" "),
					   NSLocalizedString(@"calleNumeroCheck", @" "),
					   NSLocalizedString(@"poblacionCheck", @" "),
					   NSLocalizedString(@"ciudadCheck", @" "),
					   NSLocalizedString(@"estadoCheck", @" "),
					   NSLocalizedString(@"cpCheck", @" "),
					   NSLocalizedString(@"paisCheck", @" "),nil];
	
	[self.vistaCircular setImage:[UIImage imageNamed:@"plecamorada.png"]];
//    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView == Nil) {
//        NSArray *arrayControllers = [self.navigationController viewControllers];
//        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView = [arrayControllers objectAtIndex:arrayControllers.count-2];
//        NSLog(@"la clase es %@", [arrayControllers objectAtIndex:arrayControllers.count-2]);
//    }
    arregloEmpresa = @[NSLocalizedString(@"nombreOrganizacion", @" "),
					   NSLocalizedString(@"servicioCliente", @" "),
					   NSLocalizedString(@"numeroMovil", @" "),
					   NSLocalizedString(@"email", @" "),
					   NSLocalizedString(@"calleNumero", @" "),
					   NSLocalizedString(@"poblacion", @" "),
					   NSLocalizedString(@"ciudad", @" "),
					   NSLocalizedString(@"estado", @" "),
					   NSLocalizedString(@"cp", @" "),
					   NSLocalizedString(@"pais", @" ")];
	
    arregloIndividual = @[NSLocalizedString(@"servicioCliente", @" "),
						  NSLocalizedString(@"numeroMovil", @" "),
						  NSLocalizedString(@"email", @" "),
						  NSLocalizedString(@"calleNumero", @" "),
						  NSLocalizedString(@"poblacion", @" "),
						  NSLocalizedString(@"ciudad", @" "),
						  NSLocalizedString(@"estado", @" "),
						  NSLocalizedString(@"cp", @" "),
						  NSLocalizedString(@"pais", @" ")];
	
	bNombre = YES;
	bServicios = YES;
	bNumero = YES;
	bMail = YES;
	bCalle = YES;
	bPob = YES;
	bCd = YES;
	bEdo = YES;
	bCp = YES;
	bPais = YES;
	
	NSLog(@"nombre: %@", self.datosUsuario.nombreOrganizacion);
	
	if(self.datosUsuario.nombreOrganizacion == nil && [self.datosUsuario.nombreOrganizacion isEqualToString:@""]){
		self.datosUsuario.tipoRegistro = YES;
		tipo = YES;
	}else{
		self.datosUsuario.tipoRegistro = NO;
		tipo = NO;
	}
	

	if(self.datosUsuario.tipoRegistro){
		self.arregloConfiguracion = @[arregloIndividual];
		//CGRect frame = [self.tabla frame];
		//frame.size.height-=30;
		//self.tabla.frame = frame;
		CGRect frame =  CGRectMake(20, 109, 280, 238-30);
		self.tabla.frame = frame;
		[self.botonEmpresa setBackgroundImage:[UIImage imageNamed:@"checkInactivo.png"] forState:UIControlStateNormal];
		[self.botonIndividual setBackgroundImage:[UIImage imageNamed:@"checkActivo.png"] forState:UIControlStateNormal];
		NSLog(@"individual");
	}else{
		self.arregloConfiguracion = @[arregloEmpresa];
		[self.botonEmpresa setBackgroundImage:[UIImage imageNamed:@"checkActivo.png"] forState:UIControlStateNormal];
		[self.botonIndividual setBackgroundImage:[UIImage imageNamed:@"checkInactivo.png"] forState:UIControlStateNormal];
		CGRect frame =  CGRectMake(20, 109, 280, 238);
		self.tabla.frame = frame;
	}
	
	tipo = self.datosUsuario.tipoRegistro;
	
	
    paisText = self.datosUsuario.pais;
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
//    [self.vistaCircular setImage:[UIImage imageNamed:@"plecamorada.png"]];
//    [self.tituloVista setText:NSLocalizedString(@"infoDeRegistro", @" ")];
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"infoDeRegistro", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"infoDeRegistro", @" ") nombreImagen:@"NBlila.png"];
	}
    
    self.tabla.layer.cornerRadius = 5.0f;
	if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
		[self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"settingsEn.png"] forState:UIControlStateNormal];
	}else{
		[self.botonConfiguracion setBackgroundImage:[UIImage imageNamed:@"miconfiguracionon.png"] forState:UIControlStateNormal];
	}
    
    [self.botonConfiguracion setFrame:CGRectMake(240, 0, 80, 68)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
	self.modifico = NO;
	seleccionoPais = NO;
	
	if(codPais != nil && ![codPais isEqualToString: @""]){
		NSDictionary *diccCodes = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CallingCodes" ofType:@"plist"]];
		NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]];
		for (NSString *isoCC in diccCodes) {
			NSString *shortestCC = [@"+" stringByAppendingString:codPais];
			NSString *ccValue = [diccCodes objectForKey:isoCC];
			if ([ccValue isEqualToString:shortestCC]) {
						paisText = [local displayNameForKey:NSLocaleCountryCode value:isoCC];
						Pais = [local displayNameForKey:NSLocaleCountryCode value:isoCC];
						break; //goto ccMatched;
			}
		}
	}
    self.navigationItem.rightBarButtonItem = Nil;


}

-(void)viewWillAppear:(BOOL)animated{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"infoDeRegistro", @" ") nombreImagen:@"barramorada.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"infoDeRegistro", @" ") nombreImagen:@"NBlila.png"];
	}
	[super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regresar:(id)sender {
	NSLog(@"Regresar");
    /*UIViewController *controllerAux = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView;
    [self.navigationController popToViewController:controllerAux animated:YES];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).ultimoView = Nil;*/
	[[self view] endEditing:YES];
	AlertView *alertView;
    if (self.modifico) {
		alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
		[alertView show];
    }
    else {
		[self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) configuraVista {
}

-(IBAction)guardarInformacion:(id)sender {
	[[self view] endEditing:YES];
	
	bNombre = NO;
	bServicios = NO;
	bNumero = NO;
	bMail = NO;
	bCalle = NO;
	bPob = NO;
	bCd = NO;
	bEdo = NO;
	bCp = NO;
	bPais = NO;
	
	bNombre = [CommonUtils validaNombreEmpresa:nombre];
	bServicios = [CommonUtils validaServicios:servicio];
	bNumero = [CommonUtils validaNumeroMovil:numero];
	bMail = [CommonUtils validaMail:mail];
	bCalle = [CommonUtils validaCalleNumero:calleNum];
	bPob = [CommonUtils validaPoblacion:pob];
	bCd = [CommonUtils validaCiudad:cd];
	bEdo = [CommonUtils validaEstado:edo];
	bCp = [CommonUtils validaCP:cP];
	bPais = [CommonUtils validaPais:Pais];
	
//	NSLog(bNombre ? @"nombre YES" : @"nombre NO");
//	NSLog(bServicios ? @"servicios YES" : @"servicios NO");
//	NSLog(bNumero ? @"numero YES" : @"numero NO");
//	NSLog(bMail ? @"mail YES" : @"mail NO");
//	NSLog(bCalle ? @"calle YES" : @"calle NO");
//	NSLog(bPob ? @"poblacion YES" : @"poblacion NO");
//	NSLog(bCd ? @"cd YES" : @"cd NO");
//	NSLog(bEdo ? @"edo YES" : @"edo NO");
//	NSLog(bCp ? @"cp YES" : @"cp NO");
//	NSLog(bPais ? @"pais YES" : @"pais NO");
	
	if(!tipo && bNombre && bServicios && bNumero && bMail && bCalle && bPob && bCd && bEdo && bCp && bPais){
		
		self.datosUsuario.nombreOrganizacion = nombre;
		self.datosUsuario.servicioCliente = servicio;
		self.datosUsuario.numeroMovil = numero;
		self.datosUsuario.email = mail;
		self.datosUsuario.calleNumero = calleNum;
		self.datosUsuario.poblacion = pob;
		self.datosUsuario.ciudad = cd;
		self.datosUsuario.estado = edo;
		self.datosUsuario.cp = cP;
		self.datosUsuario.pais = Pais;
		self.datosUsuario.codigoPais = codPais;
		
		if ([CommonUtils hayConexion]) {
			[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
			[self performSelectorInBackground:@selector(actualizarDatos) withObject:Nil];
			[self.navigationController popViewControllerAnimated:YES];
		}
		else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
		
		
		
		
	}else if (tipo && bServicios && bNumero && bMail && bCalle && bPob && bCd && bEdo && bCp && bPais) {
		
		self.datosUsuario.nombreOrganizacion = @"";
		self.datosUsuario.servicioCliente = servicio;
		self.datosUsuario.numeroMovil = numero;
		self.datosUsuario.email = mail;
		self.datosUsuario.calleNumero = calleNum;
		self.datosUsuario.poblacion = pob;
		self.datosUsuario.ciudad = cd;
		self.datosUsuario.estado = edo;
		self.datosUsuario.cp = cP;
		self.datosUsuario.pais = Pais;
		self.datosUsuario.codigoPais = codPais;
		
		if ([CommonUtils hayConexion]) {
			[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
			[self performSelectorInBackground:@selector(actualizarDatos) withObject:Nil];
			[self.navigationController popViewControllerAnimated:YES];
		}
		else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
		
	}else{
		NSLog(@"Alertaaa");
		AlertView * alertView;
		alertView = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"datosInvalidos", @" ") message:NSLocalizedString(@"mensajeVerifica", @" ") dominio:nil andAlertViewType:AlertViewTypeInfo];
		
		[alertView show];
		
		[self.tabla reloadData];
	}
	
/*	if(self.datosUsuario.tipoRegistro){
		self.datosUsuario.nombreOrganizacion = @"";
		self.datosUsuario.servicioCliente = servicio;
		self.datosUsuario.numeroMovil = numero;
		self.datosUsuario.email = mail;
		self.datosUsuario.calleNumero = calleNum;
		self.datosUsuario.poblacion = pob;
		self.datosUsuario.ciudad = cd;
		self.datosUsuario.estado = edo;
		self.datosUsuario.cp = cP;
		self.datosUsuario.pais = Pais;
		self.datosUsuario.codigoPais = codPais;
	}else{
		self.datosUsuario.nombreOrganizacion = nombre;
		self.datosUsuario.servicioCliente = servicio;
		self.datosUsuario.numeroMovil = numero;
		self.datosUsuario.email = mail;
		self.datosUsuario.calleNumero = calleNum;
		self.datosUsuario.poblacion = pob;
		self.datosUsuario.ciudad = cd;
		self.datosUsuario.estado = edo;
		self.datosUsuario.cp = cP;
		self.datosUsuario.pais = Pais;
		self.datosUsuario.codigoPais = codPais;
	}*/
	
}

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(tipo){
		return 7;
	}
	else{
		return 8;
	}
    //return [[self.arregloConfiguracion objectAtIndex:section] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellDefault"];
    [cell setBackgroundColor:[UIColor whiteColor]];
	[cell.textLabel setTextColor:colorFuenteAzul];
	[cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
	
	NSArray * info;
	NSArray * check;
	
	if(self.datosUsuario.tipoRegistro){
		info = infoIndividual;
		check = checaIndividual;
		
	}else{
		info = infoEmpresa;
		check = checaEmpresa;
		//NSLog(@"empresa: %@", [info objectAtIndex:0]);
	}
	
	
	if(indexPath.row == [[self.arregloConfiguracion objectAtIndex:0] count] - 5){
		UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 130, 30)];
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		
		if(bPob){
			textField.text = [info objectAtIndex:indexPath.row];
			textField.textColor = colorFuenteAzul;
		}else{
			textField.text = [check objectAtIndex:indexPath.row];
			textField.textColor = [UIColor redColor];
		}
		textField.placeholder = [[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		//[textField setValue:colorFuenteAzul forKeyPath:@"_placeholderLabel.textColor"];
		textField.delegate = self;
		[cell.contentView addSubview:textField];
		
		UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(150, 0, 125, 30)];
		textField2.autocorrectionType = UITextAutocorrectionTypeNo;
		textField2.autocapitalizationType = UITextAutocapitalizationTypeNone;
		if(bCd){
			textField2.text = [info objectAtIndex:indexPath.row+1];
			textField2.textColor = colorFuenteAzul;
		}else{
			textField2.text = [check objectAtIndex:indexPath.row+1];
			textField2.textColor = [UIColor redColor];
		}
		textField2.placeholder = [[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
		//[textField2 setValue:colorFuenteAzul forKeyPath:@"_placeholderLabel.textColor"];
		textField2.delegate = self;
		[cell.contentView addSubview:textField2];
		
	}else if(indexPath.row == [[self.arregloConfiguracion objectAtIndex:0] count] - 4){
		UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 275, 30)];
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		
		if(bEdo){
			textField.text = [info objectAtIndex:indexPath.row+1];
			textField.textColor = colorFuenteAzul;
		}else{
			textField.text = [check objectAtIndex:indexPath.row+1];
			textField.textColor = [UIColor redColor];
		}
		textField.placeholder = [[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
		//[textField setValue:colorFuenteAzul forKeyPath:@"_placeholderLabel.textColor"];
		textField.delegate = self;
		[cell.contentView addSubview:textField];
		
		UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(170, 0, 105, 30)];
		textField2.autocorrectionType = UITextAutocorrectionTypeNo;
		textField2.autocapitalizationType = UITextAutocapitalizationTypeNone;;
		
		if(bCp){
			textField2.text = [info objectAtIndex:indexPath.row+2];
			textField2.textColor = colorFuenteAzul;
		}else{
			textField2.text = [check objectAtIndex:indexPath.row+2];
			textField2.textColor = [UIColor redColor];
		}
		textField2.placeholder = [[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+2];
		//[textField2 setValue:colorFuenteAzul forKeyPath:@"_placeholderLabel.textColor"];
		textField2.delegate = self;
		[cell.contentView addSubview:textField2];
		
	}else{
		UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 275, 30)];
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		
		if([[self.arregloConfiguracion objectAtIndex:0] count] - 3 == indexPath.row){
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellDefault"];
			
			[cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:16]];
			
			//textField.placeholder = [[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+2];
			UIImageView *imagenAccesory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnsiguiente.png"]];
			[cell setAccessoryView:imagenAccesory];
			if(bPais){
				[cell.textLabel setText:[[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+2]];
				[cell.textLabel setTextColor:colorFuenteAzul];
				[cell.detailTextLabel setText:paisText];
				cell.detailTextLabel.textColor = colorFuenteAzul;
			}else{
				[cell.textLabel setText:[check objectAtIndex:indexPath.row+2]];
				[cell.detailTextLabel setText:@""];
				[cell.textLabel setTextColor:[UIColor redColor]];
				cell.detailTextLabel.textColor = [UIColor redColor];
			}

		}else{
			
				
			if(bNombre && indexPath.row == 0){
				textField.text = [info objectAtIndex:indexPath.row];
				textField.textColor = colorFuenteAzul;
			}else if(!bNombre && indexPath.row == 0){
				textField.text = [check objectAtIndex:indexPath.row];
				textField.textColor = [UIColor redColor];
			}else if(bServicios && indexPath.row == 1){
				textField.text = [info objectAtIndex:indexPath.row];
				textField.textColor = colorFuenteAzul;
			}else if(!bServicios && indexPath.row == 1){
				textField.text = [check objectAtIndex:indexPath.row];
				textField.textColor = [UIColor redColor];
			}else if(bNumero && indexPath.row == 2){
				textField.text = [info objectAtIndex:indexPath.row];
				textField.textColor = colorFuenteAzul;
			}else if(!bNumero && indexPath.row == 2){
				textField.text = [check objectAtIndex:indexPath.row];
				textField.textColor = [UIColor redColor];
			}else if(bMail && indexPath.row == 3){
				textField.text = [info objectAtIndex:indexPath.row];
				textField.textColor = colorFuenteAzul;
			}else if(!bMail && indexPath.row == 3){
				textField.text = [check objectAtIndex:indexPath.row];
				textField.textColor = [UIColor redColor];
			}else if(bCalle && indexPath.row == 4){
				textField.text = [info objectAtIndex:indexPath.row];
				textField.textColor = colorFuenteAzul;
			}else if(!bCalle && indexPath.row == 4){
				textField.text = [check objectAtIndex:indexPath.row];
				textField.textColor = [UIColor redColor];
			}
			
			textField.placeholder = [[self.arregloConfiguracion objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
			
			//[textField setValue:colorFuenteAzul forKeyPath:@"_placeholderLabel.textColor"];
			textField.delegate = self;
			[cell.contentView addSubview:textField];
		}
		
		
	}
	
    return cell;
}

#pragma mark - TableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([[self.arregloConfiguracion objectAtIndex:0] count] - 3 == indexPath.row){
		bPais = YES;
		//[tableView cellForRowAtIndexPath:indexPath].textColor = colorFuenteAzul;
		SelectorPaisViewController *selector = [[SelectorPaisViewController alloc] initWithNibName:@"SelectorPaisViewController" bundle:Nil];
		selector.seleccionaDelegate = self;
        selector.nombreTituloVista = @"barramorada.png";
		[self.navigationController pushViewController:selector animated:YES];
	}
	
	editingIndexPath = indexPath;
    
    
}

- (IBAction)esEmpresa:(id)sender {
	
    self.arregloConfiguracion = @[arregloEmpresa];
	[self.botonEmpresa setBackgroundImage:[UIImage imageNamed:@"checkActivo.png"] forState:UIControlStateNormal];
	[self.botonIndividual setBackgroundImage:[UIImage imageNamed:@"checkInactivo.png"] forState:UIControlStateNormal];
	tipo = NO;
	self.datosUsuario.tipoRegistro = tipo;
	[self.tabla reloadData];
	CGRect frame =  CGRectMake(20, 109, 280, 238-30);
	frame.size.height+=30;
	self.tabla.frame = frame;
	
	self.modifico = YES;
}


- (IBAction)esIndividual:(id)sender {
	
	self.arregloConfiguracion = @[arregloIndividual];
	[self.botonEmpresa setBackgroundImage:[UIImage imageNamed:@"checkInactivo.png"] forState:UIControlStateNormal];
	[self.botonIndividual setBackgroundImage:[UIImage imageNamed:@"checkActivo.png"] forState:UIControlStateNormal];
	tipo = YES;
	self.datosUsuario.tipoRegistro = tipo;
	[self.tabla reloadData];
	CGRect frame =  CGRectMake(20, 109, 280, 238-30);//[self.tabla frame];
	NSLog(@"Size: %f,%f",frame.size.width,frame.size.height);
	//frame.size.height-=30;
	self.tabla.frame = frame;
	
	self.modifico = YES;
}

#pragma mark - Selector País Delegate

-(void) guardaPais:(NSString *)pais yCodigo:(NSString *)codigoPais{
	NSLog(@"GuardaPais");
	paisText = pais;
	Pais = pais;
	codPais = codigoPais;
	[self.tabla reloadData];
}

#pragma mark - Alert view delegate

-(void) accionSi{
	
	bServicios = NO;
	bNumero = NO;
	bMail = NO;
	bCalle = NO;
	bPob = NO;
	bCd = NO;
	bEdo = NO;
	bCp = NO;
	bPais = NO;
	
	bNombre = [CommonUtils validaNombreEmpresa:nombre];
	bServicios = [CommonUtils validaServicios:servicio];
	bNumero = [CommonUtils validaNumeroMovil:numero];
	bMail = [CommonUtils validaMail:mail];
	bCalle = [CommonUtils validaCalleNumero:calleNum];
	bPob = [CommonUtils validaPoblacion:pob];
	bCd = [CommonUtils validaCiudad:cd];
	bEdo = [CommonUtils validaEstado:edo];
	bCp = [CommonUtils validaCP:cP];
	bPais = [CommonUtils validaPais:Pais];
	
	if(!tipo && bNombre && bServicios && bNumero && bMail && bCalle && bPob && bCd && bEdo && bCp && bPais){
		
		self.datosUsuario.nombreOrganizacion = nombre;
		self.datosUsuario.servicioCliente = servicio;
		self.datosUsuario.numeroMovil = numero;
		self.datosUsuario.email = mail;
		self.datosUsuario.calleNumero = calleNum;
		self.datosUsuario.poblacion = pob;
		self.datosUsuario.ciudad = cd;
		self.datosUsuario.estado = edo;
		self.datosUsuario.cp = cP;
		self.datosUsuario.pais = Pais;
		self.datosUsuario.codigoPais = codPais;
		
		if ([CommonUtils hayConexion]) {
			[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
			[self performSelectorInBackground:@selector(actualizarDatos) withObject:Nil];
			[self.navigationController popViewControllerAnimated:YES];
		}
		else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
		
	}else if (tipo && bServicios && bNumero && bMail && bCalle && bPob && bCd && bEdo && bCp && bPais) {
		
		self.datosUsuario.nombreOrganizacion = @"";
		self.datosUsuario.servicioCliente = servicio;
		self.datosUsuario.numeroMovil = numero;
		self.datosUsuario.email = mail;
		self.datosUsuario.calleNumero = calleNum;
		self.datosUsuario.poblacion = pob;
		self.datosUsuario.ciudad = cd;
		self.datosUsuario.estado = edo;
		self.datosUsuario.cp = cP;
		self.datosUsuario.pais = Pais;
		self.datosUsuario.codigoPais = codPais;
		
		if ([CommonUtils hayConexion]) {
			[self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
			[self performSelectorInBackground:@selector(actualizarDatos) withObject:Nil];
			[self.navigationController popViewControllerAnimated:YES];
		}
		else {
			AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
			[alert show];
		}
		
	}else{
		NSLog(@"Alertaaa");
		AlertView * alertView;
		alertView = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"datosInvalidos", @" ") message:NSLocalizedString(@"mensajeVerifica", @" ") dominio:nil andAlertViewType:AlertViewTypeInfo];
		
		[alertView show];
		
		[self.tabla reloadData];
	}
	
}

-(void) accionNo{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Métodos del teclado

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height-60), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
	
    self.tabla.contentInset = contentInsets;
    self.tabla.scrollIndicatorInsets = contentInsets;
    [self.tabla scrollToRowAtIndexPath:editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tabla.contentInset = UIEdgeInsetsZero;
    self.tabla.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - TextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
	campo = textField.placeholder;
	NSLog(@"campo: %@",campo);
	
	if(([campo isEqualToString:NSLocalizedString(@"nombreOrganizacion", @" ")] || [campo isEqualToString:NSLocalizedString(@"nombreOrganizacionCheck", @" ")]) && !bNombre){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"servicioCliente", @" ")] || [campo isEqualToString:NSLocalizedString(@"servicioClienteCheck", @" ")]) && !bServicios){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"numeroMovil", @" ")] || [campo isEqualToString:NSLocalizedString(@"numeroMovilCheck", @" ")]) && !bNumero){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"email", @" ")] || [campo isEqualToString:NSLocalizedString(@"emailCheck", @" ")]) && !bMail){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"calleNumero", @" ")] || [campo isEqualToString:NSLocalizedString(@"calleNumeroCheck", @" ")]) && !bCalle){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"poblacion", @" ")] || [campo isEqualToString:NSLocalizedString(@"poblacionCheck", @" ")]) && !bPob){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"ciudad", @" ")] || [campo isEqualToString:NSLocalizedString(@"ciudadCheck", @" ")]) && !bCd){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"estado", @" ")] || [campo isEqualToString:NSLocalizedString(@"estadoCheck", @" ")]) && !bEdo){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}
	else if(([campo isEqualToString:NSLocalizedString(@"cp", @" ")] || [campo isEqualToString:NSLocalizedString(@"cpCheck", @" ")]) && !bCp){
		textField.text = @"";
		textField.textColor = colorFuenteAzul;
	}

}
-(void)textFieldDidEndEditing:(UITextField *)textField {
	
	if([campo isEqualToString:NSLocalizedString(@"nombreOrganizacion", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"nombreOrganizacion", @" ")]){
		nombre = textField.text;
		self.modifico = YES;
		
		NSLog(@"index0: %@",[infoEmpresa objectAtIndex:0]);
		[infoEmpresa replaceObjectAtIndex:0 withObject:nombre];
		NSLog(@"edito %@", [infoEmpresa objectAtIndex:0]);
		textField.textColor = colorFuenteAzul;
		bNombre = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"servicioCliente", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"servicioCliente", @" ")]){
		servicio = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:1 withObject:servicio];
		[infoIndividual replaceObjectAtIndex:0 withObject:servicio];
		textField.textColor = colorFuenteAzul;
		bServicios = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"numeroMovil", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"numeroMovil", @" ")]){
		numero = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:2 withObject:numero];
		[infoIndividual replaceObjectAtIndex:1 withObject:numero];
		textField.textColor = colorFuenteAzul;
		bNumero = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"email", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"email", @" ")]){
		mail = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:3 withObject:mail];
		[infoIndividual replaceObjectAtIndex:2 withObject:mail];
		textField.textColor = colorFuenteAzul;
		bMail = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"calleNumero", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"calleNumero", @" ")]){
		calleNum = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:4 withObject:calleNum];
		[infoIndividual replaceObjectAtIndex:3 withObject:calleNum];
		textField.textColor = colorFuenteAzul;
		bCalle = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"poblacion", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"poblacion", @" ")]){
		pob = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:5 withObject:pob];
		[infoIndividual replaceObjectAtIndex:4 withObject:pob];
		textField.textColor = colorFuenteAzul;
		bPob = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"ciudad", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"ciudad", @" ")]){
		cd = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:6 withObject:cd];
		[infoIndividual replaceObjectAtIndex:5 withObject:cd];
		textField.textColor = colorFuenteAzul;
		bCd = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"estado", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"estado", @" ")]){
		edo = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:7 withObject:edo];
		[infoIndividual replaceObjectAtIndex:6 withObject:edo];
		textField.textColor = colorFuenteAzul;
		bEdo = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"cp", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"cp", @" ")]){
		cP = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:8 withObject:cP];
		[infoIndividual replaceObjectAtIndex:7 withObject:cP];
		textField.textColor = colorFuenteAzul;
		bCp = YES;
	}
	else if([campo isEqualToString:NSLocalizedString(@"pais", @" ")] && ![textField.text isEqualToString:NSLocalizedString(@"pais", @" ")]){
		Pais = textField.text;
		self.modifico = YES;
		
		[infoEmpresa replaceObjectAtIndex:9 withObject:Pais];
		[infoIndividual replaceObjectAtIndex:8 withObject:Pais];
		textField.textColor = colorFuenteAzul;
		bPais = YES;
	}
}

#pragma mark - WS

-(void) mostrarActivity {
    self.alertaContacto = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaContacto show];
}
-(void) ocultarActivity {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    if (actualizoCorrecto) {
		AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
            [alert show];
    }
    else {
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"errorActualizacion", Nil) andAlertViewType:AlertViewTypeInfo];
        [alert show];
    }
}
-(void) actualizarDatos {
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).itIsInTime) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) restartDate];
        WS_HandlerInformacionRegistro *handlerinfo = [[WS_HandlerInformacionRegistro alloc] init];
        [handlerinfo setInformacionRegistroDelegate:self];
	
        [handlerinfo actualizaInformacionRegistro];
    }
    else {
        if ( self.alertaContacto )
        {
            [NSThread sleepForTimeInterval:1];
            [self.alertaContacto hide];
        }
        self.alertaContacto = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionCaduco", Nil) andAlertViewType:AlertViewTypeInfo];
        [self.alertaContacto show];
        [StringUtils terminarSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) resultadoInformacionRegistro:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        actualizoCorrecto = YES;
    }
    else {
        actualizoCorrecto = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}

-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorContacto) withObject:Nil waitUntilDone:YES];
}

-(void) errorContacto {
    if ( self.alertaContacto )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaContacto hide];
    }
    [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"errorSimple",nil) andAlertViewType:AlertViewTypeInfo] show];
}


@end
