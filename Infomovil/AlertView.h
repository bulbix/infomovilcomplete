//
//  AlertView.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 22/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate;

@class ETActivityIndicatorView;

typedef enum {
    AlertViewTypeQuestion,
    AlertViewTypeQuestionWithTitle,
    AlertViewTypeInfo,
    AlertViewTypeInfo2,
    AlertViewTypeActivity,
	AlertViewTypeInfo3,
    AlertViewInfoMapa
}AlertViewType;

@interface AlertView : UIView

@property (nonatomic,assign) id<AlertViewDelegate> delegado;
@property (nonatomic) AlertViewType type;

@property (nonatomic, strong) UIView *vistaAlert;

@property (nonatomic, strong) UIImageView *imagenEncabezado;

@property (nonatomic, strong) UIButton *botonSi;
@property (nonatomic, strong) UIButton *botonNo;
@property (nonatomic, strong) UIButton *botonAceptar;

@property (nonatomic, strong) UILabel *labelTitulo;
@property (nonatomic, strong) UILabel *labelPregunta;

@property (nonatomic, strong) UILabel *labelMensaje;
@property (nonatomic, strong) UILabel *labelDominio;
@property (nonatomic, strong) UILabel *labelMensaje2;
@property (nonatomic, strong) UIImageView *imagenLogo;

@property (nonatomic, strong) ETActivityIndicatorView *activityIndicator;

+(id)initWithDelegate:(id<AlertViewDelegate>)delegate message:(NSString*)mensaje andAlertViewType:(AlertViewType)type;
+(id)initWithDelegate:(id<AlertViewDelegate>)delegate titulo:(NSString *)titulo message:(NSString*)mensaje dominio:(NSString*)dominio andAlertViewType:(AlertViewType)type;

-(void) show;
-(void) hide;

-(IBAction)presionarSi:(id)sender;
-(IBAction)presionarNo:(id)sender;
-(IBAction)presionarAceptar:(id)sender;
-(IBAction)presionarAceptar2:(id)sender;
-(IBAction)presionarCancelar:(id)sender;

@end

@protocol AlertViewDelegate <NSObject>

@optional
-(void) accionSi;
-(void) accionNo;
-(void) accionAceptar;
-(void) accionAceptar2;
-(void) accionCancelar;

@end
