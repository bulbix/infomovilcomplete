//
//  NombraCompraDominio.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 6/4/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"


@interface NombraCompraDominio : InfomovilViewController<AlertViewDelegate, UITextFieldDelegate, WS_HandlerProtocol>
{
    BOOL existeDominio;
    SKProduct *productoElegido;
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}
@property (weak, nonatomic) IBOutlet UILabel *etiquetaNombraSitio;
@property (weak, nonatomic) IBOutlet UILabel *etiqutawww;
@property (weak, nonatomic) IBOutlet UITextField *txtNombreSitio;
@property (weak, nonatomic) IBOutlet UILabel *etiquetatel;
@property (weak, nonatomic) IBOutlet UIButton *btnBuscar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollNombrar;
@property (nonatomic, strong) AlertView *alertActivity;
@property (nonatomic, nonatomic) int operacionWS;









- (IBAction)buscar:(id)sender;












@end
