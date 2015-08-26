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
#import "CrearPaso1ViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface GaleriaImagenesViewController () {
    BOOL exito;
    BOOL movio;
    NSInteger maxNumeroImagenes;
	
	AlertView * alertaImagenes;
}
@property (nonatomic, strong) NSMutableArray *arregloImagenes;
@property (nonatomic, strong) NSMutableArray *arregloDescripcion;
@property (nonatomic, strong) NSMutableArray *arregloIdImagenes;
@property (nonatomic, strong) AlertView *alertaGaleria;

@end

@implementation GaleriaImagenesViewController

@synthesize urlImagen;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{ NSLog(@"ENTRO A VIEWDIDLOAD DE GALERIAIMAGENESVIEWCONTROLLER");
    [super viewDidLoad];
    
    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"btnregresar.png"] ofType:nil]]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    [self mostrarBotones];
    
}

-(void) viewWillAppear:(BOOL)animated {
    NSLog(@"ENTRO AL VIEWWILLAPPEAR");
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
    self.arregloImagenes = self.datosUsuario.arregloUrlImagenesGaleria;
    self.arregloDescripcion = self.datosUsuario.arregloDescripcionImagenGaleria;
    self.arregloIdImagenes = self.datosUsuario.arregloIdImagenGaleria;
    self.vistaInfo.layer.cornerRadius = 5.0f;
    [self.labelImagenesMensaje setText:NSLocalizedString(@"galeriaVertical", Nil)];
    [self.labelImagenesMensaje2 setText:NSLocalizedString(@"redimensionaImagen", Nil)];
    [self.labelNumeroImagenes setText:NSLocalizedString(@"5Imagenes", Nil)];
    [self acomodarBarraNavegacionConTitulo:NSLocalizedString(@"imagenes", @" ") nombreImagen:@"barraverde.png"];
    
    if ([self.arregloImagenes count] > 0) {
        [self.tablaGaleria setHidden:NO];
        [self.vistaInfo setHidden:YES];
        [self.tablaGaleria reloadData];
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:8 withObject:@YES];
    }
    else {
        [self.tablaGaleria setHidden:YES];
        [self.vistaInfo setHidden:NO];
        [self.datosUsuario.arregloEstatusEdicion replaceObjectAtIndex:8 withObject:@NO];
    }
	
 if(IS_IPAD){
        [self.vistaInfo setFrame:CGRectMake(84, 40, 600, 500)];
        [self.labelNumeroImagenes setFrame: CGRectMake(40, 60, 550, 60)];
        [self.labelImagenesMensaje setFrame:CGRectMake(40, 150, 550, 30)];
        [self.labelImagenesMensaje2 setFrame:CGRectMake(40, 210,550, 30)];
        
        [self.vineta3 setFrame:CGRectMake(20,75, 14, 21)];
        [self.vineta1 setFrame:CGRectMake(20,150, 14, 21)];
        [self.vineta2 setFrame:CGRectMake(20,210, 14, 21)];
     
        
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        [self.vistaInfo setFrame:CGRectMake(20, 40, 335, 350)];
        self.labelNumeroImagenes.frame = CGRectMake(34, 35, 256, 100);
        self.labelImagenesMensaje.frame = CGRectMake(34, 90, 256, 47);
        self.labelImagenesMensaje2.frame = CGRectMake(34, 156, 256, 47);
        self.vineta3.frame = CGRectMake(10, 39, 14, 21);
        self.vineta1.frame = CGRectMake(10, 92, 14, 21);
        self.vineta2.frame = CGRectMake(10, 155, 14, 21);
    
    }else {
        if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
         
            self.labelNumeroImagenes.frame = CGRectMake(34, 35, 256, 100);
            self.labelImagenesMensaje.frame = CGRectMake(34, 90, 256, 47);
            self.labelImagenesMensaje2.frame = CGRectMake(34, 156, 256, 47);
            self.vineta3.frame = CGRectMake(10, 39, 14, 21);
            self.vineta1.frame = CGRectMake(10, 92, 14, 21);
            self.vineta2.frame = CGRectMake(10, 155, 14, 21);
        }else{
           
            self.vineta1.frame = CGRectMake(10, 120, 14, 21);
            self.vineta2.frame = CGRectMake(10, 177, 14, 21);
        }
    
    }
    
    [self mostrarBotones];
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    CrearPaso1ViewController *CrearPaso1 = [[CrearPaso1ViewController alloc] initWithNibName:@"CrearPaso1ViewController" bundle:Nil];
    [self.navigationController pushViewController:CrearPaso1 animated:YES];
    
}

-(void) mostrarBotones {
    
    if([self.arregloImagenes count] > 0){
    
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
                self.navigationItem.rightBarButtonItems = @[botonEdit, botonAdd];
                
            }
    }else{
        self.navigationItem.rightBarButtonItem = Nil;
        UIImage *imageAdd = [UIImage imageNamed:@"btnagregar.png"];
        UIButton *btAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btAdd setFrame:CGRectMake(0, 0, imageAdd.size.width, imageAdd.size.height)];
        [btAdd setImage:imageAdd forState:UIControlStateNormal];
        [btAdd addTarget:self action:@selector(agregarImagen:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *botonAdd = [[UIBarButtonItem alloc] initWithCustomView:btAdd];
        self.navigationItem.rightBarButtonItems = @[botonAdd];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)agregarImagen:(id)sender {

    if ([self.arregloImagenes count] < 5) {
        GaleriaPaso2ViewController *galeriaPaso2 = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeriaPaso2 setOperacion:GaleriaImagenesAgregar];
        [galeriaPaso2 setGaleryType:PhotoGaleryTypeImage];
        [galeriaPaso2 setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [self.navigationController pushViewController:galeriaPaso2 animated:YES];
        
    }else if([self.arregloImagenes count] >= 5 && [self.arregloImagenes count] < 12 && [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        GaleriaPaso2ViewController *galeriaPaso2 = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeriaPaso2 setOperacion:GaleriaImagenesAgregar];
        [galeriaPaso2 setGaleryType:PhotoGaleryTypeImage];
        [galeriaPaso2 setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [self.navigationController pushViewController:galeriaPaso2 animated:YES];
    
    }else if([self.arregloImagenes count] >= 5 && [self.arregloImagenes count] < 12 && [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && [self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        AlertView *alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"mensajeImagenesPrueba", Nil) andAlertViewType:AlertViewTypeQuestion];
        [alert show];
    }else if([self.arregloImagenes count] >= 5 && [self.arregloImagenes count] < 12 && ![((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] ){
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
  
    self.urlImagen = [self.arregloImagenes objectAtIndex:indexPath.row];
    
    static NSString *identificador = @"GaleriaCell";
    GaleriaCell *cell = [tableView dequeueReusableCellWithIdentifier:identificador];
    if (cell == Nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GaleriaCell" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
    }
    cell.vistaGaleria.layer.cornerRadius = 5.0f;
    cell.pieFoto.frame = CGRectMake(69, 11, 450, 50);
     @try {
        [cell.pieFoto setText:[self.arregloDescripcion objectAtIndex:indexPath.row]];
    }
    @catch (NSException *exception) {
        [cell.pieFoto setText:@""];
    }
    
    
    if ([CommonUtils hayConexion]) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:  self.urlImagen ]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:10.0];
        NSError *requestError;
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (response == nil) {
                                       if (requestError != nil) {
                                           
                                           [cell.imagenPrevia setImage:[UIImage imageNamed:@"previsualizador.png"]];
                                       }
                                   }else {
                                       
                                       UIImage *image = [UIImage imageWithData:data];
                                       [cell.imagenPrevia setImage:image];
                                   }
                                   
                                    }];
        
        
    }else{
        [cell.imagenPrevia setImage:[UIImage imageNamed:@"previsualizador.png"]];
    }
    
    if( [((AppDelegate*)[[UIApplication sharedApplication] delegate]).statusDominio isEqualToString:@"Pago"] && [self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"] && indexPath.row > 4){
        cell.sombrearCelda.hidden = NO;
    }else{
        cell.sombrearCelda.hidden = YES;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row <= 4 ){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GaleriaPaso2ViewController *galeriaPaso2 = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeriaPaso2 setOperacion:GaleriaImagenesEditar];
        [galeriaPaso2 setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [galeriaPaso2 setGaleryType:PhotoGaleryTypeImage];
        [galeriaPaso2 setIndex:indexPath.row];
        [self.navigationController pushViewController:galeriaPaso2 animated:YES];
    }else if(indexPath.row > 4 && ![self.datosUsuario.descripcionDominio isEqualToString:@"DOWNGRADE"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GaleriaPaso2ViewController *galeriaPaso2 = [[GaleriaPaso2ViewController alloc] initWithNibName:@"GaleriaPaso2ViewController" bundle:nil];
        [galeriaPaso2 setOperacion:GaleriaImagenesEditar];
        [galeriaPaso2 setTituloPaso:NSLocalizedString(@"anadirImagen", @" ")];
        [galeriaPaso2 setGaleryType:PhotoGaleryTypeImage];
        [galeriaPaso2 setIndex:indexPath.row];
        [self.navigationController pushViewController:galeriaPaso2 animated:YES];
    
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if(fromIndexPath.row != toIndexPath.row){
        NSString * imgAux = [self.arregloImagenes objectAtIndex:fromIndexPath.row];
        [self.arregloImagenes removeObjectAtIndex:fromIndexPath.row];
        [self.arregloImagenes insertObject:imgAux atIndex:toIndexPath.row];
        
        NSString * descAux = [self.arregloDescripcion objectAtIndex:fromIndexPath.row];
        [self.arregloDescripcion removeObjectAtIndex:fromIndexPath.row];
        [self.arregloDescripcion insertObject:descAux atIndex:toIndexPath.row];
        
        NSString * idImgAux = [self.arregloIdImagenes objectAtIndex:fromIndexPath.row];
        [self.arregloIdImagenes removeObjectAtIndex:fromIndexPath.row];
        [self.arregloIdImagenes insertObject:idImgAux atIndex:toIndexPath.row];
        movio = YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(IBAction)editarTabla:(id)sender {
   
    if (self.editing) {
        NSLog(@"LE DIO EN EDITAR TABLA!!!!!!!");
        [self.tablaGaleria setEditing:NO animated:YES];
        [self setEditing:NO animated:YES];
       
        
        if (movio ) {
            NSLog(@"ENTRO A SI MOVIO LA TABLA !!!!!!!");
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
        NSLog(@"NOOOOOO LE DIO EN EDITAR TABLA!!!!!!!");
        [self.tablaGaleria setEditing:YES animated:YES];
        [self setEditing:YES animated:YES];
    }
    [self mostrarBotones];
}



-(void)accionAceptar {
    if (exito) {
        NSLog(@"ENTRO EN ACCION ACEPTAR!!!");
       // [self.navigationController popViewControllerAnimated:YES];
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
        WS_HandlerGaleria *handlerGaleria = [[WS_HandlerGaleria alloc] init];
        [handlerGaleria setGaleriaDelegate:self];
        [handlerGaleria actualizarGaleria:self.arregloImagenes idImages:self.arregloDescripcion descImages:self.arregloIdImagenes];
    
}

-(void) resultadoConsultaDominio:(NSString *)resultado {
    NSLog(@"QUE ME REGRESO??? %@", resultado);
    if ([resultado isEqualToString:@"Exito"]) {
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
    
    MainViewController *inicio = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:Nil];
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
}
@end
