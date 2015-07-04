//
//  NombrarViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "WS_HandlerProtocol.h"



typedef enum {
    RespuestaStatusExito2,
    RespuestaStatusPendiente2,
    RespuestaStatusExistente2,
    RespuestaStatusError2
}RespuestaEstatus2;

@interface NombrarViewController : InfomovilViewController <AlertViewDelegate, UITextFieldDelegate, WS_HandlerProtocol,UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *labelW;
@property (weak, nonatomic) IBOutlet UITextField *nombreDominio;
@property (weak, nonatomic) IBOutlet UILabel *labelTel;
@property (weak, nonatomic) IBOutlet UILabel *labelEstatusDominio;
@property (weak, nonatomic) IBOutlet UILabel *labelDominio;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *boton;
@property (weak, nonatomic) IBOutlet UIView *popUpCenter;
@property (weak, nonatomic) IBOutlet UIButton *btnPublicar;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UILabel *estaDisponibleBtn;


// propiedades del ipad //
@property (weak, nonatomic) IBOutlet UILabel *etiquetaEstatica;
@property (weak, nonatomic) IBOutlet UILabel *nombreDelDominio;
@property (weak, nonatomic) IBOutlet UILabel *MensajeDisponible;
@property (weak, nonatomic) IBOutlet UIButton *publicarBtn;
@property (weak, nonatomic) IBOutlet UIButton *cerrarBtn;

//////////// POPUPDOMINIOS //////////
@property (weak, nonatomic) IBOutlet UIView *viewContenidoDominios;
@property (weak, nonatomic) IBOutlet UITableView *tableDominios;
@property (weak, nonatomic) IBOutlet UIView *viewDominiosTable;
@property (weak, nonatomic) IBOutlet UILabel *dominioCompleto;

@property (nonatomic, strong) NSString *idDominio;


@property (weak, nonatomic) IBOutlet UIButton *btnAceptarDom;
@property (weak, nonatomic) IBOutlet UIButton *SalirSelectDomain;
- (IBAction)SalirSelectDomainAct:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *cerrarPopUp;
- (IBAction)cerrarPopUpAction:(id)sender;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (IBAction)verificarDominio:(UIButton *)sender;
- (IBAction)publicarAction:(id)sender;
@end
