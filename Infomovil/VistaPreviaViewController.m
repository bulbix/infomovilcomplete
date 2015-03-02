//
//  VistaPreviaViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 21/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "VistaPreviaViewController.h"
#import "Contacto.h"
#import "Base64.h"
#import "GaleriaImagenes.h"
#import "KeywordDataModel.h"
#import "ListaHorarios.h"
#import "OffertRecord.h"
#import "NSStringUtiles.h"

@interface VistaPreviaViewController ()
@property(nonatomic, strong) AlertView *alert;
@property (nonatomic,retain) NSFileManager *fileMgr;
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic,retain) NSString *title;

@end

@implementation VistaPreviaViewController

@synthesize fileMgr;
@synthesize homeDir;
@synthesize title;

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
    self.alert = [AlertView initWithDelegate:self message:NSLocalizedString(@"cargando", @" ") andAlertViewType:AlertViewTypeActivity];
    [self.alert show];
    self.navigationItem.rightBarButtonItem = Nil;
    
    if (self.tipoVista == PreviewTypePrevia) {
        
            
        NSURL *baseURL = nil;//[NSURL fileURLWithPath:[StringUtils pathForDocumentsDirectory]];
        
        
            [self.vistaCircular setHidden:YES];
            [self.vistaInferior setHidden:YES];
		
		NSFileManager *filemanager=[NSFileManager defaultManager];
		NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"myStyle.css"];
		//Verificar si la base de datos existe
		BOOL success = [filemanager fileExistsAtPath:path];
		if(!success){
			//Copia la base de datos si no existe
			[self CopyToDocumentsFolder:@"myStyle.css"];
		}
		path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"sprite2.css"];
		//Verificar si la base de datos existe
		success = [filemanager fileExistsAtPath:path];
		if(!success){
			//Copia la base de datos si no existe
			[self CopyToDocumentsFolder:@"sprite2.css"];
		}
		path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"functions.js"];
		//Verificar si la base de datos existe
		success = [filemanager fileExistsAtPath:path];
		if(!success){
			//Copia la base de datos si no existe
			[self CopyToDocumentsFolder:@"functions.js"];
		}
		
		NSData *dataWeb = [[self getStringHTML] dataUsingEncoding:NSUTF8StringEncoding];
		baseURL = [NSURL fileURLWithPath:[StringUtils pathForDocumentsDirectory]];
		[self.webView loadData:dataWeb MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
        [self.webView setMediaPlaybackRequiresUserAction:NO];
        
        
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"indexInfo" ofType:@"html"]isDirectory:NO]]];
    }
    
    [self.vistaInferior setHidden:YES];
	
	

}

-(void)viewWillAppear:(BOOL)animated{
	self.vistaInferior.hidden = YES;
}

-(void)CopyToDocumentsFolder:(NSString *)nombre{
    NSError *err=nil;
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:nombre];
    
//    NSLog([NSString stringWithFormat:@"dbpath: %@",dbpath]);
    
    
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:nombre];
//    NSLog([NSString stringWithFormat:@"copydbpath: %@",copydbpath]);
    [fileMgr removeItemAtPath:copydbpath error:&err];
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
    {
        NSLog(@"Error description-%@ \n", [err localizedDescription]);
        NSLog(@"Error reason-%@", [err localizedFailureReason]);
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to copy." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
        
    }
    
}

-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",homeDir]);
    
    return homeDir;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.alert)
    {
        [NSThread sleepForTimeInterval:1];
        [self.alert hide];
    }
}

-(NSString *) getStringHTML {
	self.datosUsuario = [DatosUsuario sharedInstance];
    NSMutableArray *arregloEstatusEdicion = self.datosUsuario.arregloEstatusEdicion;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *filePath = [[NSString alloc]initWithString:[documentsPath stringByAppendingPathComponent:@"myStyle.css"]];
	[[NSBundle mainBundle]pathForResource:@"myStyle"ofType:@"css"];
	NSLog(@"myStile: %s",[filePath UTF8String]);
	
//	NSString *filePath2 = [[NSString alloc]initWithString:[documentsPath stringByAppendingPathComponent:@"sprite2.css"]];
	[[NSBundle mainBundle]pathForResource:@"sprite2"ofType:@"css"];
	
//	NSString *filePath3 = [[NSString alloc]initWithString:[documentsPath stringByAppendingPathComponent:@"functions.js"]];
	[[NSBundle mainBundle]pathForResource:@"functions"ofType:@"js"];
    
//    DatosUsuario *datos = [DatosUsuario sharedInstance];
    NSMutableString *htmlString = [[NSMutableString alloc] init];// [[NSBundle mainBundle] pathForResource:@"CatalogoInformacion" ofType:@"plist"]
	
	
	[htmlString appendFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">"
     "<html>"
     "<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" />"
     "<meta http-equiv=\"Cache-Control\" content=\"max-age=3600\"/>"
     "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\" />"
     "<link href=\"http://info-movil.net/images/favicon.ico\" rel=\"icon\" type=\"image/x-icon\" />"
	"<link href=\"myStyle.css\"  rel=\"stylesheet\" type=\"text/css\"/>"
	"<link href=\"sprite2.css\"  rel=\"stylesheet\" type=\"text/css\"/> "
	"<head>"
     "<style type=\"text/css\" > .hide { display:none; } </style>"
     "<script type=\"text/javascript\" src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js\"></script>"
     "<script type=\"text/javascript\" src=\"https://maps.google.com/maps/api/js?sensor=false\"></script>"
     "<script type=\"text/javascript\" src=\"https://raw.github.com/HPNeo/gmaps/master/gmaps.js\"></script>"
     "<script type=\"text/javascript\">"
     "function main(){init();} function init() {$('#mapa').toggle('fast');"
     "}"
	 "</script>"
	"<script type=\"text/javascript\" async src=\"functions.js\"></script>"
    "<title>pruebadominio</title>"];
    
    [htmlString appendFormat:@"<meta name=\"name\" content=\"%@\">"
     "<meta name=\"descripcion\" content=\"%@\">"
     "<meta property=\"og:title\" content=\"%@\" />"
     "<meta name=\"og:description\" content=\"%@\">"
     "<meta property=\"og:image\"  content=\"http://info-movil.net/garbage/infomovil.png\" /></head>", self.datosUsuario.dominio, self.datosUsuario.descripcion, self.datosUsuario.dominio, self.datosUsuario.descripcion];
	
    
    UIColor *colorAux;
    
    if (self.datosUsuario.colorSeleccionado == Nil) {
        colorAux = [UIColor whiteColor];
    }
    else {
        colorAux = self.datosUsuario.colorSeleccionado;
    }
    NSString *nombreEmpresa;
    if (self.datosUsuario.nombreEmpresa == Nil) {
        nombreEmpresa = @"Título";
    }
    else {
        nombreEmpresa = self.datosUsuario.nombreEmpresa;
    }
    NSString *descripcion;
    if (self.datosUsuario.descripcion == Nil) {
        descripcion = @"Descripción";
    }
    else {
        descripcion = [self.datosUsuario.descripcion stringByReplacingOccurrencesOfString:@"\n" withString:@"<Br />"];
    }
    
    NSString *imagenLogo;
    if (self.datosUsuario.imagenLogo.rutaImagen != Nil) {
        imagenLogo = self.datosUsuario.imagenLogo.rutaImagen;
    }
    else {
        imagenLogo = [NSString stringWithFormat:@"data:image/png;base64,%@", [Base64 encode:UIImagePNGRepresentation([UIImage imageNamed:@"no-avatar.png"])]];
    }
    [htmlString appendFormat:@"<body bgcolor = %@><div id=\"container\">"
     "<div id=\"ContenedorGeneral\">"
     "<table id=\"Logo\" width=\"100%%\"   >"
     "<td >"
     "<div id=\"header-left\" >"
     "<div style=\"width:auto;\"><img id=\"photo\" src=\"%@\" width=90px;/></div>"
     "</div>				</td><td width=\"70%%\">"
     "<div class=\"info\">"
     "<h1 id=\"title-domain\">%@</h1>"
     "</div> <!-- End Titulo Domain -->"
     "</td>"
     "</table>"
     "<div id=\"content\">"
     "<div id=\"content-left\" class=\"left-column\">"
     "<div id=\"descCorta\">"
     "<h2 id=\"shortDesc\" style=\"word-wrap: break-word;\">%@<br>"
     "</h2>"
     "</div> <!-- End short desc -->"
     "</div>"
     "<div class=\"division\" style=\" width: 95%%; border-top-width: 1px; border-top-style: solid; border-top-color: rgb(111, 111, 111) !important; margin: 0 auto;\"  ></div>", [StringUtils hexFromUIColor:colorAux], imagenLogo, nombreEmpresa, descripcion];
    //contactos principal
    
    [htmlString appendString:@"<div id=\"contenedor-Contacto\"><table width=\"100%;\" border=\"0\" ><td>"];
    
    NSString *noTelefonico;
//	NSString *idPais;
    NSString *emailPrincipal;
    if ([self.datosUsuario.arregloContacto count] >= 1) {
        for (int i=0; i < [self.datosUsuario.arregloContacto count]; i++) {
            Contacto *contactoAux = [self.datosUsuario.arregloContacto objectAtIndex:i];
            if (contactoAux.indice == 0 || contactoAux.indice == 1) {
                noTelefonico = [contactoAux.idPais stringByAppendingString: contactoAux.noContacto];
//				idPais = contactoAux.idPais;
                break;
            }
        }
        
        for (int i=0; i < [self.datosUsuario.arregloContacto count]; i++) {
            Contacto *contactoAux = [self.datosUsuario.arregloContacto objectAtIndex:i];
            if (contactoAux.indice == 3) {
                emailPrincipal = contactoAux.noContacto;
                break;
            }
        }
    }
    //
    if ([noTelefonico length] == 0) {
        [htmlString appendFormat:@"<a href=\"javascript:void(0);\" onclick=\"noDisponible()\"><div id=\"article\" class=\"llamanos\"></div></a>"
         "<p id=\"text_icono\"> %@</p>"
         "</td>", NSLocalizedString(@"llamanos", Nil)];
    }
    else {
        [htmlString appendFormat:@"<a href=\"tel:%@\"><div id=\"article\" class=\"llamanos\"></div> </a>"
         "<p id=\"text_icono\"> %@</p>"
         "</td>", noTelefonico, NSLocalizedString(@"llamanos", Nil)];
    }
    
   if(self.datosUsuario.localizacion == nil && (self.datosUsuario.localizacion.coordinate.latitude == 0.0 && self.datosUsuario.localizacion.coordinate.longitude == 0.0)){
		[htmlString appendFormat:@"<td>"
		 "<a id=\"verMapa\" href=\"javascript:void(0);\" onclick=\"isNull()\" >"
		 "<div id=\"article\" class=\"ubicanos\"></div>"
		 "</a>"
		 "<p id=\"text_icono\" >%@</p>"
		 "<td>", NSLocalizedString(@"ubicacionVista2", Nil)];
	}else{
		[htmlString appendFormat:@"<td><a id=\"verMapa\" href=\"javascript:void(0);\" onclick=\"creariMapa(%f,%f)\">"
		 "<div id=\"article\" class=\"ubicanos\"></div></a>"
		 "<p id=\"text_icono\" > %@</p></td>", self.datosUsuario.localizacion.coordinate.latitude, self.datosUsuario.localizacion.coordinate.longitude, NSLocalizedString(@"ubicacionVista2", Nil)];
	}
    
    if ([emailPrincipal length] == 0) {
        [htmlString appendFormat:@"<td><a id=\"link \"href=\"javascript:void(0);\" onclick=\"noDisponible()\"><div id=\"article\" class=\"contactanos\"></div> </a></h2>"
         "<p id=\"text_icono\"> %@</p></td></table>"
         "</div></div></div>", NSLocalizedString(@"contactoVista", Nil)];
    }
    else {
//        NSLog(@"El correo es %@", )
        [htmlString appendFormat:@"<td><a id=\"link \"href=\"mailto:%@?:&subject=Informacion&body=Hola:%%20www.%@.tel\"><div id=\"article\" class=\"contactanos\"></div> </a></h2>"
         "<p id=\"text_icono\"> %@</p></td></table>"
         "</div></div></div>",emailPrincipal,self.datosUsuario.dominio, NSLocalizedString(@"contactoVista", Nil)];
    }
    
    
    
    //Agregando el mapa
    if (self.datosUsuario.localizacion != Nil && self.datosUsuario.localizacion.coordinate.latitude != 0.0 && self.datosUsuario.localizacion.coordinate.longitude != 0.0) {
        [htmlString appendFormat:@"<div id=\"mapa\" class=\"hide\" ><br>"
         "<table id=\"head-mapa\" border=0 width=\"100%%\"><td  width=\"20%%\">"
         "<div id=\"iconos\" class=\"ubicacion\"></div>"
         "<td> <div id=\"text_icono_contenedor\"> %@ </div><td width=\"40%%\"> <div id=\"boton-contenedor\" >"
         "<a  href=\"javascript:void(0);\"  ><div id=\"ocultar-mapa\" class=\"hideP\" ></div></a>  </div></table>"
         "<div>&nbsp;</div><div id=\"contenedorMapa\"></div></div>", NSLocalizedString(@"ubicacionVista", Nil)];
        NSLog(@"Sacando el video");
    }
    //Video de youtube
    if (self.datosUsuario.urlVideo != Nil) {
        [htmlString appendFormat:@"<div id=\"contenedor\"><br><table id=\"head-video\" border=0 width=\"100%%\">"
         "<td  width=\"20%%\"><div id=\"iconos\" class=\"video\"><div>"
         "<td> <div id=\"text_icono_contenedor\"> Video </div>"
         "<td width=\"40%%\"> <div id=\"boton-contenedor\" ><a  href=\"javascript:void(0);\" onclick=\"verVideo()\" ><div  id=\"ocultar-video\" class=\"showP\" ></div></a> </div>"
         "</table><div>&nbsp;</div><div id=\"movie-panel\"  style=\"text-align:center;\" class=\"hide\">"
         "<iframe id=\"Mapa\" src=\"http:%@\"></iframe></div></div>", self.datosUsuario.urlVideo];
    }
    
    //Añadiendo oferta
    OffertRecord *oferta = self.datosUsuario.promocionActual;
    if (oferta != Nil && [[arregloEstatusEdicion objectAtIndex:7] isEqual:@YES]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/YYYY"];
        NSString *stringFecha = [formatter stringFromDate:[oferta endDateAux]];
        if ( [NSString isEmptyString:stringFecha] || [stringFecha isEqualToString:@"01/01/1970"]) {
            stringFecha = @" ";
        } else {
            stringFecha = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"vigencia", Nil), stringFecha];
        }
        NSString *imagenOferta;
        if ([oferta pathImageOffer] != Nil && [[oferta pathImageOffer] length] > 0) {
            imagenOferta = oferta.pathImageOffer;//self.datosUsuario.rutaImagenPromocion;
        }
        else {
            imagenOferta = [NSString stringWithFormat:@"data:image/png;base64,%@", [Base64 encode:UIImagePNGRepresentation([UIImage imageNamed:@"promocionesdefault.png"])]];
        }
        NSString *infoAdicional = ( ![NSString isEmptyString:oferta.termsOffer] ) ? NSLocalizedString(@"informacionAdicional", Nil) : @"";
        
        [htmlString appendFormat:@"<div id=\"contenedor\"><br>"
         "<table id=\"head-promociones\" border=0 width=\"100%%\">"
         "<td  width=\"20%%\"> <div id=\"iconos\" class=\"promociones\">"
//         "</div>"//checra como se ve
         "<td> <div id=\"text_icono_contenedor\"> %@ </div>"
         "<td width=\"40%%\"> <div id=\"boton-contenedor\" >"
         "<a  href=\"javascript:void(0);\" onclick=\"verOferta()\" ><div id=\"ocultarOffer\" class=\"showP\" ></div></a>"
         "</table>"
         "<div id=\"offer-panel\" class=\"hide\">"
         "<div class=\"wrapper\">"
         "<div id=\"text_icono_Offer\">%@</div><div>&nbsp;</div>"
         "<div float:left;>"
         "<img title=\"Imagen Offer\" id=\"photoOffer\" style=\"max-width:100px; border: 3px solid rgb(255, 255, 255); -moz-border: 3px solid rgb(255, 255, 255);  -webkit-border: 3px solid rgb(255, 255, 255); box-shadow: 1px 1px 3px rgb(136, 136, 136); float: left; margin: 1px 10px 0px 15px;\" src=\"%@\"></img>"
         "</div><div>"
         "<div id=\"Descripcion\" class=\"text_desc\"> %@</div>"
         "<div id=\"Caducidad\" class=\"text_desc\"> %@ </div>"
         "<div id=\"Reddem\" class=\"text_desc\"> %@ </div>"
         "<div id=\"verTerms\" class=\"text_desc\" href=\"\"> %@ </div>"
         "<div id=\"Terminos\" class=\"text_desc_terminos\">%@</div></div>"
         "</div>"
         "</div> <br>"
         "</div>", NSLocalizedString(@"promociones", nil),
         [oferta titleOffer] != Nil?[oferta titleOffer]:@" ", imagenOferta,
         [oferta descOffer]!=Nil?[[oferta descOffer] stringByReplacingOccurrencesOfString:@"\n" withString:@"<Br />"]:@" ",
         stringFecha, [oferta redeemAux]!=Nil?[oferta redeemAux]:@" ",
         infoAdicional,[oferta termsOffer]!=Nil?[[oferta termsOffer] stringByReplacingOccurrencesOfString:@"\n" withString:@"<Br />"]:@" " ];
    }
    
    //La galeria de imagen
    if ([self.datosUsuario.arregloGaleriaImagenes count] > 0 && [[arregloEstatusEdicion objectAtIndex:8] isEqual:@YES]) {
        [htmlString appendFormat:@"<div id=\"contenedor\"><br>"
         "<table id=\"head-galeria\" border=0 width=\"100%%\">"
         "<td  width=\"20%%\"> <div id=\"iconos\" class=\"imagenes\">"
         "</div>"
         "<td> <div id=\"text_icono_contenedor\"> %@ </div>"
         "<td width=\"40%%\"> <div id=\"boton-contenedor\">"
         "<a  href=\"javascript:void(0);\" onclick=\"verGaleria()\" ><div  id=\"ocultar-galeria\" class=\"showP\" ></div></a></div>"
         "</table><div>&nbsp;</div><div id=\"div-galeria\"class=\"division hide\" ></div>"
         "<div id=\"galeria\" class=\"hide\">", NSLocalizedString(@"galeriaVista", Nil)];
        NSMutableArray *arrayGaleria = self.datosUsuario.arregloGaleriaImagenes;
        for (GaleriaImagenes *galeria in arrayGaleria) {
            [htmlString appendFormat:@"<div class=\"title_galery\" >"
             "<span class=\"align_title_galery\">%@<span style=\"color:#3D393A\">.</span></span>"
             "<img src=\"%@\" class=\"imagen-galery\">"
             "</div>"
             "<div>&nbsp;</div>", galeria.pieFoto, galeria.rutaImagen];
        }
        [htmlString appendString:@"</div></div>"];
    }
    
    
    //colocar aqui el perfil *****************************************************************
    
    if ([self.datosUsuario.arregloDatosPerfil count] > 0 &&
        ([[arregloEstatusEdicion objectAtIndex:2] isEqual:@YES] || [[arregloEstatusEdicion objectAtIndex:9] isEqual:@YES] )) {
        NSMutableArray *arregloPerfil = self.datosUsuario.arregloDatosPerfil;
        [htmlString appendFormat:@"<div id=\"contenedor\"><br><table id=\"head-perfil\" border=0 width=\"100%%\">"
         "<td  width=\"20%%\"> <div id=\"iconos\" class=\"perfil\">"
         "<td> <div id=\"text_icono_contenedor\"> %@ </div>"
         "<td width=\"40%%\"> <div id=\"boton-contenedor\" ><a  href=\"javascript:void(0);\" onclick=\"verPerfil()\" ><div id=\"ocultar-perfil\" class=\"showP\" ></div></a></div>"
         "</table><div id=\"perfil-panel\" class=\"hide\">", NSLocalizedString(@"perfil", Nil)];
        NSArray *titulosTabla = @[NSLocalizedString(@"productoServicio", @" "), NSLocalizedString(@"areaServicio", @" "), NSLocalizedString(@"horario", @" "), NSLocalizedString(@"metodosPago", @" "), NSLocalizedString(@"asociaciones", @" "), NSLocalizedString(@"biografia", @" "), NSLocalizedString(@"perfinNegocioProfesion", Nil)];
        for (int i = 0; i < [arregloPerfil count]; i++) {
            KeywordDataModel *dataModel = [arregloPerfil objectAtIndex:i];
            if (i == 2) {
                NSArray *arrayDias = @[NSLocalizedString(@"lunes", @" "),
                                       NSLocalizedString(@"martes", @" "),
                                       NSLocalizedString(@"miercoles", @" "),
                                       NSLocalizedString(@"jueves", @" "),
                                       NSLocalizedString(@"viernes", @" "),
                                       NSLocalizedString(@"sabado", @" "),
                                       NSLocalizedString(@"domingo", @" ")];
                NSMutableArray *arrayDataContent = [[NSMutableArray alloc] init];
                KeywordDataModel *keyAux = [self.datosUsuario.arregloDatosPerfil objectAtIndex:2];
                if (keyAux.keywordValue != nil && keyAux.keywordValue.length > 0) {
                    NSInteger k = 0;
                    NSArray *arrayHorarioAux = [keyAux.keywordValue componentsSeparatedByString:@"|"];
                    for (int j = 0; j < [arrayHorarioAux count]; j++) {
                        if (j % 2 == 0 && j > 0) {
                            NSArray *arrayDiaAux = [[arrayHorarioAux objectAtIndex:j] componentsSeparatedByString:@" - "];
                            ListaHorarios *lista = [[ListaHorarios alloc] init];
                            [lista setDia:[arrayDias objectAtIndex:k]];
                            [lista setInicio:[arrayDiaAux objectAtIndex:0]];
                            [lista setCierre:[arrayDiaAux objectAtIndex:1]];
                            if (![[arrayDiaAux objectAtIndex:0] isEqualToString:@"00:00"] || ![[arrayDiaAux objectAtIndex:1] isEqualToString:@"00:00"]) {
                                [lista setEditado:YES];
                            }
                            else {
                                [lista setEditado:NO];
                            }
                            [arrayDataContent addObject:lista];
                            k++;
                        }
                    }
                }
                if ([[self.datosUsuario.arregloEstatusPerfil objectAtIndex:2] isEqual:@YES]) {
                    if ([arrayDataContent count] > 0) {
                        [htmlString appendFormat:@"<div id=\"contenedor-data\" >"
                         "<span id=\"align_desc_cont\">%@</span><br>"
                         "<div id=\"constenedor-horario\">"
                         "<table id=\"CSSTableGenerator\" class=\"align_desc_cont_sub\" style=\"margin-left:10%%;\">", [titulosTabla objectAtIndex:i]];
                        
                        for (ListaHorarios *horario in arrayDataContent) {
                            if (![horario.inicio isEqualToString:@"00:00"] || ![horario.cierre isEqualToString:@"00:00"]) {
                                [htmlString appendFormat:@"<td class=\"horarios\">%@</td><td class=\"horarios\">%@ - %@</td><tr>", horario.dia, horario.inicio, horario.cierre];
                            }
                        }
                        [htmlString appendString:@"</table><br><div class=\"divisionContacto\" style=\" border-top-width: 1px; border-top-style: solid; border-top-color: rgb(111, 111, 111) !important; margin: 0 auto 10px; \"></div></div></div><div class=\"clr\"></div>"];
                    }
                }
                
            }
            else {
                if (dataModel.keywordValue != Nil) {
                    [htmlString appendFormat:@"<div id=\"contenedor-data\"><span id=\"align_desc_cont\">%@</span><br><div class=\"clr\"></div>"
                     "<span class=\"align_desc_cont_sub\">%@<br></span><div class=\"clr\"></div><div class=\"divisionContacto\" style=\" border-top-width: 1px; border-top-style: solid; border-top-color: rgb(111, 111, 111) !important; margin: 0 auto 10px; \" ></div></div><div class=\"clr\"></div>", [titulosTabla objectAtIndex:i], [dataModel.keywordValue stringByReplacingOccurrencesOfString:@"\n" withString:@"<Br />"]];
                }
            }
        }
        [htmlString appendString:@"</div><div>&nbsp;</div></div>"];
    }
    
    //Contactos
    
    if ([self.datosUsuario.arregloContacto count] > 0 && [[arregloEstatusEdicion objectAtIndex:4] isEqual:@YES])
    {
        NSArray *arrayDatos = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tipoContacto" ofType:@"plist"]];
        NSMutableArray *arregloContactos = self.datosUsuario.arregloContacto;
        NSMutableString *htmlContactos = [[NSMutableString alloc] init];
        for (Contacto *contacto in arregloContactos)
        {
            NSString *regExp;
            if (contacto.idPais.length > 0) {
                regExp = [NSString stringWithFormat:@"%@%@", contacto.idPais, contacto.noContacto];
            }
            else {
                regExp = contacto.noContacto;
            }
            
            if (contacto.habilitado)
            {
                if (contacto.indice == 0) { //tefono fijo
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-telefono.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a> <div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div id=\"contenedor-data-boton\">"
                     "<a href=\"tel:%@\" ><input  value=\"Llamar\" type=\"button\"  class=\"btncontact\" > </input></a></div><div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], regExp, contacto.descripcion, regExp];
                }
                else if (contacto.indice == 1) { //tefono movil
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-cel.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a> <div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div id=\"contenedor-data-boton\">"
                     "<a href=\"tel:%@\" ><input  value=\"Llamar\" type=\"button\"  class=\"btncontact\" > </input></a></div><div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], regExp, contacto.descripcion, regExp];
                }
                else if (contacto.indice == 2) { //sms
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-sms.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], regExp, contacto.descripcion];
                }
                else if (contacto.indice == 3) { //email
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-email.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a> <div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div id=\"contenedor-data-boton\">"
                     "<a href=\"mailto:%@\" ><input  value=\"Contactar\" type=\"button\"  class=\"btncontact\" > </input></a></div><div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], contacto.noContacto, contacto.descripcion, regExp];
                }
                else if (contacto.indice == 4) { //fax
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-fax.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], regExp,contacto.descripcion];
                }
                else if (contacto.indice == 5) { //facebook
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-facebook.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], contacto.noContacto,contacto.descripcion];
                }
                else if (contacto.indice == 6) { //twitter
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-twitter.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], contacto.noContacto,contacto.descripcion];
                }
                else if (contacto.indice == 7) { //google +
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-google.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], contacto.noContacto,contacto.descripcion];
                }
                else if (contacto.indice == 8) { //skype
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-skype.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], contacto.noContacto,contacto.descripcion];
                }
                else if (contacto.indice == 9) { //linkedin
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-linkedin.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], contacto.noContacto,contacto.descripcion];
                }
                else if (contacto.indice == 10) { //secure web
                    [htmlContactos appendFormat:@"<div id=\"contenedor-data\"><br>"
                     "<img src=\"http://info-movil.net/garbage/320/c-secure web.png\" class=\"align_desc_cont\">"
                     "<a id=\"tilte-contact\">%@</a> </img><br>"
                     "<a class=\"align_desc_cont_sub\">%@</a><div class=\"clr\"></div>"
                     "<a id=\"desc-contact\">%@</a><br/>"
                     "<div class=\"clr\"></div> <br><div class=\"divisionContacto\" ></div></div>", [[arrayDatos objectAtIndex:contacto.indice] objectForKey:@"text"], contacto.noContacto,contacto.descripcion];
                }
                
            }
            
        }
        
        if ( ![NSString isEmptyString:htmlContactos] )
        {
            [htmlString appendFormat:@"<div id=\"contenedor\"><br>"
             "<table id=\"head-contacto\" border=0 width=\"100%%\">"
             "<td  width=\"20%%\"> <div id=\"iconos\" class=\"contacto\">"
             "</div></td>"
             "<td> <div id=\"text_icono_contenedor\"> %@ </div></td>"
             "<td width=\"40%%\"> <div id=\"boton-contenedor\"  >"
             "<a  href=\"javascript:void(0);\" onclick=\"verContacto()\"><div  id=\"ocultar-contacto\" class=\"showP\" ></div></a>"
             "</div></td></table><div id=\"body-contacto\" class=\"hide\">", NSLocalizedString(@"contacto", Nil)];
            [htmlString appendString:htmlContactos];
            [htmlString appendString:@"</div><div>&nbsp;</div> </div> "];
        }
    }
    
    
    //La direccion
    if (self.datosUsuario.direccion != Nil && [[arregloEstatusEdicion objectAtIndex:10] isEqual:@YES]) {
        [htmlString appendFormat:@"<div id=\"contenedor\"><br><table id=\"head-direccion\" border=0 width=\"100%%\">"
         "<td  width=\"20%%\"> <div id=\"iconos\"class=\"direccion\">"
         "</div>"
         "<td> <div id=\"text_icono_contenedor\"> %@ </div><td width=\"40%%\"> <div id=\"boton-contenedor\" ><a  href=\"javascript:void(0);\" onclick=\"verDireccion()\"><div  id=\"ocultar-direccion\" class=\"showP\" ></div></a>"
         "</div></table><div id=\"direccion-panel\" class=\"hide\">", NSLocalizedString(@"direccion", Nil)];
        
        NSMutableArray *arregloDireccion = self.datosUsuario.direccion;
        
        for (KeywordDataModel *dataModel in arregloDireccion) {
            [htmlString appendFormat:@"<div id=\"contenedor-data\"><span class=\"align_desc_cont_sub\">%@</span></div>", dataModel.keywordValue];
        }
        [htmlString appendString:@"</div><div>&nbsp;</div></div>"];
    }
    
    // Aqui va Otra informacion ****************************************
    
    if ([self.datosUsuario.arregloInformacionAdicional count] > 0 && [[arregloEstatusEdicion objectAtIndex:11] isEqual:@YES]) {
        [htmlString appendFormat:@"<div id=\"contenedor\"><br><table id=\"head-otherInfo\" border=0 width=\"100%%\"><td width=\"20%%\"> <div id=\"iconos\" class=\"infoAd\">"
         "</div></td><td > <div id=\"text_icono_contenedor\"> %@ </div></td><td width=\"40%%\"> <div id=\"boton-contenedor\" >"
         "<a  href=\"javascript:void(0);\" onclick=\"verOtherInfo()\"><div  id=\"ocultar-otherInfo\" class=\"showP\" ></div></a>"
         "</div></td></table><div id=\"info-panel\" class=\"hide\">", NSLocalizedString(@"informacionAdicional", Nil)];
        for (KeywordDataModel *dataModel in self.datosUsuario.arregloInformacionAdicional) {
            [htmlString appendFormat:@"<div id=\"contenedor-data\"><span id=\"align_desc_cont\">%@</span></div><div class=\"clr\"></div>"
             "<div id=\"contenedor-data\"><span class=\"align_desc_cont_sub\">%@</span></div>", dataModel.keywordField, [dataModel.keywordValue stringByReplacingOccurrencesOfString:@"\n" withString:@"<Br />"]];
        }
        [htmlString appendString:@"</div><div>&nbsp;</div></div>"];
    }
    
    //compartir
    
//    [htmlString appendFormat:@"<div id=\"contenedor\" >"
//     "<div id=\"compartir\"><div class=\"clr\"></div>"
//     "<div id=\"compartirText\">Compartir</div>"
//     "<table id=\"links-Compartir\" width=\"100%%\">"
//     "<td width=\"16.6%%\"><a href=\"http://www.facebook.com/sharer.php?u=www.%@.tel\"\" target=\"blank\"><div id=\"iconos\" class=\"facebook\" ></div></a><td>"
//	 "<td width=\"16.6%%\"><a href=\"https://plus.google.com/share?url=www.%@.tel\" target=\"blank\"><div id=\"iconos\" class=\"google\">  </div></a><td>"
//     "<td width=\"16.6%%\"><a href=\"http://www.twitter.com/intent/tweet?text=www.%@.tel%%0AMuy%%20buen%%20sitio%%20web%20movil%%0Awww.%@.tel\" target=\"blank\"><div id=\"iconos\" class=\"twitter\"></div></a></td>"
//     "<td width=\"16.6%%\"><a href=\"mailto:?subject=www.%@.tel%%20Checa%%20este%%20sitio!&body=Checa%%20este%%20sitio%%20web%%20movil:%%0Awww.%@.tel%%0ACreado%%20con%%20www.infomovil.com\"><div id=\"iconos\" class=\"email\"></div></a></td>"
//     "<td width=\"16.6%%\"><a href=\"sms:?body=Checa%%20este%%20sitio%%20web%%20movil:%%20www.%@.tel\"><div id=\"iconos\" class=\"sms\"></div></a></td>"
//     "<td width=\"16.6%%\"><a  href=\"whatsapp://send?text=Checa%%20este%%20sitio%%20web%%20movil:%%20www.%@.tel\" target=\"blank\"><div id=\"iconos\" class=\"whatsapp\">  </div></a></td></table>"
//          "<div class=\"clr\"></div></div></div>", self.datosUsuario.dominio, self.datosUsuario.dominio, self.datosUsuario.dominio, self.datosUsuario.dominio, self.datosUsuario.dominio, self.datosUsuario.dominio,self.datosUsuario.dominio,self.datosUsuario.dominio];
//    
//    [htmlString appendString:@"<div id=\"footer\" ><br>Sitio creado con la app Infomovil. <br>Descargala y crea tu sitio web m&oacute;vil hoy. &iexcl;Es gratis!<br>"
//     "<A name=\"descargar\"></A><br> <a href=\"https://itunes.apple.com/mx/app/whatsapp-messenger/id310633997?mt=8&uo=4\"  target=\"itunes_store\" style=\"display:inline-block;overflow:hidden;background:url(https://linkmaker.itunes.apple.com/htmlResources/assets/es_mx//images/web/linkmaker/badge_appstore-lrg.png) no-repeat;width:135px;height:40px;@media only screen{background-image:url(https://linkmaker.itunes.apple.com/htmlResources/assets/es_mx//images/web/linkmaker/badge_appstore-lrg.svg);}\"></a> <a href=\"https://play.google.com/store/search?q=pub:infomovil\"><img style=\"width:135px;height:40px;\" alt=\"Android app on Google Play\" src=\"https://developer.android.com/images/brand/es_app_rgb_wo_45.png\"/></a> </div>"
//     "</body>"
//     "</html>" ];
    
//    "<script type=\"text/javascript\">"
//    "window.analytics||(window.analytics=[]),window.analytics.methods=[\"identify\",\"track\",\"trackLink\",\"trackForm\",\"trackClick\",\"trackSubmit\",\"page\",\"pageview\",\"ab\",\"alias\",\"ready\",\"group\",\"on\",\"once\",\"off\"],window.analytics.factory=function(t){return function(){var a=Array.prototype.slice.call(arguments);return a.unshift(t),window.analytics.push(a),window.analytics}};for(var i=0;window.analytics.methods.length>i;i++){var method=window.analytics.methods[i];window.analytics[method]=window.analytics.factory(method)}window.analytics.load=function(t){var a=document.createElement(\"script\");a.type=\"text/javascript\",a.async=!0,a.src=(\"https:\"===document.location.protocol?\"https://\":\"http://\")+\"d2dq2ahtl5zl1z.cloudfront.net/analytics.js/v1/\"+t+\"/analytics.min.js\";var n=document.getElementsByTagName(\"script\")[0];n.parentNode.insertBefore(a,n)},window.analytics.SNIPPET_VERSION=\"2.0.8\","
//    "window.analytics.load(\"3oqmf9m20h\");"
//    "</script>"
    [htmlString appendString:@"</body></html>"];
    return htmlString;
}

//-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
//    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
//        [[UIApplication sharedApplication] openURL:[inRequest URL]];
//        return NO;
//    }
//    
//    return YES;
//}

@end
