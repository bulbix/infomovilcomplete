//
//  GaleriaImagenesViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "GaleriaImagenesViewController.h"
#import "GaleriaPaso2ViewController.h"
#import "GaleriaCell.h"
#import "GaleriaImagenes.h"
#import "WS_HandlerGaleria.h"
#import "ItemsDominio.h"
#import "CuentaViewController.h"
#import "AppsFlyerTracker.h"
#import "AppDelegate.h"
#import "InicioViewController.h"

@interface GaleriaImagenesViewController () {
    BOOL exito;
    BOOL movio;
    NSInteger maxNumeroImagenes;
	
	AlertView * alertaImagenes;
}
@property (nonatomic, strong) NSMutableArray *arregloImagenes;
@property (nonatomic, strong) AlertView *alertaGaleria;

@end

@implementation GaleriaImagenesViewController

@synthesize urlImagen;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.datosUsuario = [DatosUsuario sharedInstance];

    UIImage *imagenAgregar = [UIImage imageNamed:@"btnagregar.png"];
    UIButton *botonAgregar = [UIButton buttonWithType:UIButtonTypeCustom];
    [botonAgregar setFrame:CGRectMake(0, 0, imagenAgregar.size.width, imagenAgregar.size.height)];
    [botonAgregar setBackgroundImage:imagenAgregar forState:UIControlStateNormal];
    [botonAgregar addTarget:self action:@selector(agregarImagen:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithCustomView:botonAgregar];
    self.navigationItem.rightBarButtonItem = buttonAdd;

	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"imagenes", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"imagenes", @" ") nombreImagen:@"NBverde.png"];
	}
    
    [self.labelImagenesMensaje setText:NSLocalizedString(@"galeriaVertical", Nil)];
    [self.labelImagenesMensaje2 setText:NSLocalizedString(@"redimensionaImagen", Nil)];
    
    self.vistaInfo.layer.cornerRadius = 5.0f;
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"imagenes", @" ") nombreImagen:@"barraverde.png"];
	}else{
		[self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"imagenes", @" ") nombreImagen:@"NBverde.png"];
	}
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSLog(@"LA CANTIDAD DE IMAGENES EN GALERIA SON : %i ",[self.datosUsuario.arregloUrlImagenesGaleria count]);
    self.arregloImagenes = self.datosUsuario.arregloUrlImagenesGaleria;
    if ([self.arregloImagenes count] > 0) {
        [self.tablaGaleria setHidden:NO];
        [self.vistaInfo setHidden:YES];
        [self.tablaGaleria reloadData];
        [self mostrarBotones];
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:8 withObject:@YES];
    }
    else {
        [self.tablaGaleria setHidden:YES];
        [self.vistaInfo setHidden:NO];
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:8 withObject:@NO];
        
        self.navigationItem.rightBarButtonItems = Nil;
        UIImage *imageAceptar = [UIImage imageNamed:@"btnagregar.png"];
        UIButton *btAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
        [btAceptar setFrame:CGRectMake(0, 0, imageAceptar.size.width, imageAceptar.size.height)];
        [btAceptar setImage:imageAceptar forState:UIControlStateNormal];
        [btAceptar addTarget:self action:@selector(agregarImagen:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonAceptar = [[UIBarButtonItem alloc] initWithCustomView:btAceptar];
        self.navigationItem.rightBarButtonItem = botonAceptar;
    }
	[self mostrarBotones];
    
    if(IS_STANDARD_IPHONE_6_PLUS){
        [self.vistaInfo setFrame:CGRectMake(50, 40, 314, 350)];
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            [self.labelNumeroImagenes setText:[NSString stringWithFormat:NSLocalizedString(@"5Imagenes", Nil),maxNumeroImagenes]];
            self.labelNumeroImagenes.frame = CGRectMake(34, 35, 256, 100);
            self.labelImagenesMensaje.frame = CGRectMake(34, 90, 256, 47);
            self.labelImagenesMensaje2.frame = CGRectMake(34, 156, 256, 47);
            self.vineta3.frame = CGRectMake(10, 39, 14, 21);
            self.vineta1.frame = CGRectMake(10, 92, 14, 21);
            self.vineta2.frame = CGRectMake(10, 155, 14, 21);
        }else{
            [self.labelNumeroImagenes setText:NSLocalizedString(@"5Imagenes", Nil)];
            self.vineta1.frame = CGRectMake(10, 120, 14, 21);
            self.vineta2.frame = CGRectMake(10, 177, 14, 21);
        }
    
    
    }else if(IS_IPAD){
        [self.vistaInfo setFrame:CGRectMake(84, 40, 600, 500)];
        [self.labelNumeroImagenes setFrame: CGRectMake(40, 60, 550, 60)];
        [self.labelImagenesMensaje setFrame:CGRectMake(40, 150, 550, 30)];
        [self.labelImagenesMensaje2 setFrame:CGRectMake(40, 210,550, 30)];
        
        [self.vineta3 setFrame:CGRectMake(20,75, 14, 21)];
        [self.vineta1 setFrame:CGRectMake(20,150, 14, 21)];
        [self.vineta2 setFrame:CGRectMake(20,210, 14, 21)];
        
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            [self.labelNumeroImagenes setText:[NSString stringWithFormat:NSLocalizedString(@"5Imagenes", Nil),maxNumeroImagenes]];
        }else{
            [self.labelNumeroImagenes setText:NSLocalizedString(@"5Imagenes", Nil)];
        }
    }else if(IS_STANDARD_IPHONE_6){
        [self.vistaInfo setFrame:CGRectMake(20, 40, 335, 350)];
    
    }else {
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
            [self.labelNumeroImagenes setText:[NSString stringWithFormat:NSLocalizedString(@"5Imagenes", Nil),maxNumeroImagenes]];
            self.labelNumeroImagenes.frame = CGRectMake(34, 35, 256, 100);
            self.labelImagenesMensaje.frame = CGRectMake(34, 90, 256, 47);
            self.labelImagenesMensaje2.frame = CGRectMake(34, 156, 256, 47);
            self.vineta3.frame = CGRectMake(10, 39, 14, 21);
            self.vineta1.frame = CGRectMake(10, 92, 14, 21);
            self.vineta2.frame = CGRectMake(10, 155, 14, 21);
        }else{
            [self.labelNumeroImagenes setText:NSLocalizedString(@"5Imagenes", Nil)];
            self.vineta1.frame = CGRectMake(10, 120, 14, 21);
            self.vineta2.frame = CGRectMake(10, 177, 14, 21);
        }
    
    }
    
    
}

-(void) mostrarBotones {
    
    if (self.editing) {
        self.navigationItem.rightBarButtonItems = Nil;
        UIImage *imageAceptar = [UIImage imageNamed:@"btnaceptar.png"];
        UIButton *btAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
        [btAceptar setFrame:CGRectMake(0, 0, imageAceptar.size.width, imageAceptar.size.height)];
        [btAceptar setImage:imageAceptar forState:UIControlStateNormal];
        [btAceptar addTarget:self action:@selector(editarTabla:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonAceptar = [[UIBarButtonItem alloc] initWithCustomView:btAceptar];
        self.navigationItem.rightBarButtonItem = botonAceptar;
    }
    else {
        self.navigationItem.rightBarButtonItem = Nil;
        UIImage *imageAdd = [UIImage imageNamed:@"btnagregar.png"];
        UIButton *btAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btAdd setFrame:CGRectMake(0, 0, imageAdd.size.width, imageAdd.size.height)];
        [btAdd setImage:imageAdd forState:UIControlStateNormal];
        [btAdd addTarget:self action:@selector(agregarImagen:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonAdd = [[UIBarButtonItem alloc] initWithCustomView:btAdd];
        UIImage *imagenEdit = [UIImage imageNamed:@"btnorganizar.png"];
        UIButton *btEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btEdit setFrame:CGRectMake(0, 0, imagenEdit.size.width, imagenEdit.size.height)];
        [btEdit setImage:imagenEdit forState:UIControlStateNormal];
        [btEdit addTarget:self action:@selector(editarTabla:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonEdit = [[UIBarButtonItem alloc] initWithCustomView:btEdit];
        
	
        if([self.arregloImagenes count]>1){
			self.navigationItem.rightBarButtonItems = @[botonEdit, botonAdd];
		}else{
			self.navigationItem.rightBarButtonItems = @[botonAdd];
		}
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)agregarImagen:(id)sender {
NSLog(@"AQUI ESTA EN AGREGAR IMAGEN ");
    if ([self.arregloImagenes count] < 2) {
        GaleriaPaso2ViewController *galeria = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeria setOperacion:GaleriaImagenesAgregar];
        [galeria setGaleryType:PhotoGaleryTypeImage];
        [galeria setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [self.navigationController pushViewController:galeria animated:YES];
        
    }else if([self.arregloImagenes count] >= 2 && [self.arregloImagenes count] < 12 && [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        GaleriaPaso2ViewController *galeria = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeria setOperacion:GaleriaImagenesAgregar];
        [galeria setGaleryType:PhotoGaleryTypeImage];
        [galeria setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [self.navigationController pushViewController:galeria animated:YES];
    
    }else if([self.arregloImagenes count] >= 2 && [self.arregloImagenes count] < 12 && [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && [self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeImagenesPrueba", Nil) andAlertViewType:AlertViewTypeQuestion];
        [alert show];
    }else if([self.arregloImagenes count] >= 2 && [self.arregloImagenes count] < 12 && ![((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] ){
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeImagenesPrueba", Nil) andAlertViewType:AlertViewTypeQuestion];
        [alert show];
        
    }else if([self.arregloImagenes count] >= 12){
        alertaImagenes = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeImagenesPro", nil) andAlertViewType:AlertViewTypeInfo];
        [alertaImagenes show];
    }
    
    
}

-(void) accionSi{
	[alertaImagenes hide];
    CuentaViewController *cuenta = [[CuentaViewController alloc] initWithNibName:@"CuentaViewController" bundle:Nil];
    [self.navigationController pushViewController:cuenta animated:YES];
}

-(void) accionNo{
	[alertaImagenes hide];
}

#pragma mark - UITableViewDatasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arregloImagenes count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.urlImagen = [self.datosUsuario.arregloUrlImagenesGaleria objectAtIndex:indexPath.row];
    
    static NSString *identificador = @"GaleriaCell";
    GaleriaCell *cell = [tableView dequeueReusableCellWithIdentifier:identificador];
    if (cell == Nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GaleriaCell" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
    }
    cell.vistaGaleria.layer.cornerRadius = 5.0f;
    [cell.pieFoto setText:[self.datosUsuario.arregloDescripcionImagenGaleria objectAtIndex:indexPath.row]];
    
    if ([CommonUtils hayConexion]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:  self.urlImagen ]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if (response == nil) {
            if (requestError != nil) {
                NSLog(@"GaleriaPaso2ViewController Error Code imagen: %ld", (long)requestError.code);
                NSLog(@"GaleriaPaso2ViewController Description error: %@", [requestError localizedDescription]);
                [cell.imagenPrevia setImage:[UIImage imageNamed:@"previsualizador.png"]];
            }
        }else {
            NSLog(@"ENTRO A TRATAR DE CARGAR LA IMAGEN ");
            UIImage *image = [UIImage imageWithData:response];
            [cell.imagenPrevia setImage:image];
        }
    }else{
        [cell.imagenPrevia setImage:[UIImage imageNamed:@"previsualizador.png"]];
    }
    
    if( [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && [self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"] && indexPath.row > 1){
        cell.sombrearCelda.hidden = NO;
    }else{
        cell.sombrearCelda.hidden = YES;
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row <= 1 ){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GaleriaPaso2ViewController *galeria = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeria setOperacion:GaleriaImagenesEditar];
        [galeria setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [galeria setGaleryType:PhotoGaleryTypeImage];
        [galeria setIndex:indexPath.row];
        [self.navigationController pushViewController:galeria animated:YES];
    }else if(indexPath.row > 1 && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GaleriaPaso2ViewController *galeria = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeria setOperacion:GaleriaImagenesEditar];
        [galeria setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [galeria setGaleryType:PhotoGaleryTypeImage];
        [galeria setIndex:indexPath.row];
        [self.navigationController pushViewController:galeria animated:YES];
    
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    GaleriaImagenes *imagen = [self.arregloImagenes objectAtIndex:fromIndexPath.row];
    [self.arregloImagenes removeObject:imagen];
    [self.arregloImagenes insertObject:imagen atIndex:toIndexPath.row];
    movio = YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(IBAction)editarTabla:(id)sender {
    NSLog(@"AQUI ESTA EDITANDO LA TABLA");
    if (self.editing) {
        [self.tablaGaleria setEditing:NO animated:YES];
        [self setEditing:NO animated:YES];
        self.arregloImagenes = [[NSMutableArray alloc] initWithCapacity:[self.datosUsuario.arregloGaleriaImagenes count]];
        for (GaleriaImagenes *galeria in self.datosUsuario.arregloGaleriaImagenes) {
            GaleriaImagenes *galeriaAux = [[GaleriaImagenes alloc] init];
            [galeriaAux setIdImagen:[galeria idImagen]];
            [galeriaAux setPieFoto:[galeria pieFoto]];
            [galeriaAux setRutaImagen:[galeria rutaImagen]];
            [galeriaAux setImagenIdAux:[galeria imagenIdAux]];
            [galeriaAux setAlto:[galeria alto]];
            [galeriaAux setAncho:[galeria ancho]];
            [self.arregloImagenes addObject:galeriaAux];
        }
        if (movio ) {
            if ([CommonUtils hayConexion]) {
                [self performSelectorOnMainThread:@selector(mostrarActivity) withObject:Nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(actualizarGaleria) withObject:Nil];
            }
            else {
                AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
                [alert show];
            }
            
        }
    }
    else {
        [self.tablaGaleria setEditing:YES animated:YES];
        [self setEditing:YES animated:YES];
    }
    [self mostrarBotones];
}



-(void)accionAceptar {
    if (exito) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) mostrarActivity {
    self.alertaGaleria = [AlertView initWithDelegate:self message:NSLocalizedString(@"msgGuardarImagen", Nil) andAlertViewType:AlertViewTypeActivity];
    [self.alertaGaleria show];
    
}

-(void) ocultarActivity {
    if ( self.alertaGaleria )
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaGaleria hide];
    }
    if (exito) {
        AlertView *alerta = [AlertView initWithDelegate:self message:NSLocalizedString(@"actualizacionCorrecta", Nil) andAlertViewType:AlertViewTypeInfo];
        [alerta show];
    }
}

-(void) actualizarGaleria {
  NSLog(@"AQUI ESTA ACTUALIZANDO LA GALERIA");
        WS_HandlerGaleria *handlerGaleria = [[WS_HandlerGaleria alloc] init];
        [handlerGaleria setArregloGaleria:self.arregloImagenes];
        [handlerGaleria setGaleriaDelegate:self];
        [handlerGaleria actualizarGaleria];
   }

-(void) resultadoConsultaDominio:(NSString *)resultado {
    if ([resultado isEqualToString:@"Exito"]) {
        [self enviarEventoGAconCategoria:@"Edito" yEtiqueta:@"Imagenes"];
        exito = YES;
    }
    else {
        exito = NO;
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
}
-(void) errorToken {
    if (self.alertaGaleria)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaGaleria hide];
    }
    AlertView *alertAct = [AlertView initWithDelegate:Nil message:NSLocalizedString(@"sessionUsada", Nil) andAlertViewType:AlertViewTypeInfo];
    [alertAct show];
    [StringUtils terminarSession];
    
    InicioViewController *inicio = [[InicioViewController alloc] initWithNibName:@"InicioViewController" bundle:Nil];
    [self.navigationController pushViewController:inicio animated:YES];
}


-(void) errorConsultaWS {
    [self performSelectorOnMainThread:@selector(errorActualizar) withObject:Nil waitUntilDone:YES];
}

-(void) errorActualizar {
    if (self.alertaGaleria)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alertaGaleria hide];
    }
    [self performSelectorOnMainThread:@selector(ocultarActivity) withObject:Nil waitUntilDone:YES];
   // [[AlertView initWithDelegate:Nil message:NSLocalizedString(@"ocurrioError", Nil) andAlertViewType:AlertViewTypeInfo] show];
}
@end
