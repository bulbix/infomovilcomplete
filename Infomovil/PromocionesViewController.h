//
//  PromocionesViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 08/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"
#import "PECropViewController.h"
#import "GaleriaPaso2ViewController.h"

//@class GaleriaPaso2ViewController;

@interface PromocionesViewController : InfomovilViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate ,UITableViewDataSource, UITableViewDelegate, AlertViewDelegate, WS_HandlerProtocol, /*PECropViewControllerDelegate,*/GaleriaPaso2Delegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPromocion;
@property (weak, nonatomic) IBOutlet UITextField *txtTituloPromocion;
@property (weak, nonatomic) IBOutlet UITextView *textDescripcion;
@property (weak, nonatomic) IBOutlet UITextView *textInformacion;
@property (weak, nonatomic) IBOutlet UIDatePicker *fechaPicker;
@property (weak, nonatomic) IBOutlet UIView *vistaPicker;
@property (weak, nonatomic) IBOutlet UIView *vistaVigencia;
@property (weak, nonatomic) IBOutlet UITableView *tablaPromociones;
@property (weak, nonatomic) IBOutlet UILabel *labelVigencia;
@property (weak, nonatomic) IBOutlet UILabel *labelNombrePromocion;
@property (weak, nonatomic) IBOutlet UILabel *labelDescripcionPromocion;
@property (weak, nonatomic) IBOutlet UILabel *labelVigenciaAl;
@property (weak, nonatomic) IBOutlet UILabel *labelInformacionAdicional;
@property (weak, nonatomic) IBOutlet UIButton *btnBorrar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fixed;

- (IBAction)mostrarFecha:(id)sender;
- (IBAction)seleccionarFecha:(UIBarButtonItem *)sender;
- (IBAction)borrarPromocion:(id)sender;


@end
