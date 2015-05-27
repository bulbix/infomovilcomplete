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
    AlertViewInfoMapa,
    AlertViewTypeInfoPassword
}AlertViewType;

@interface AlertView : UIView

@property (nonatomic,retain) id<AlertViewDelegate> delegado;
@property (nonatomic) AlertViewType type;

@property (nonatomic, retain) UIView *vistaAlert;

@property (nonatomic, retain) UIImageView *imagenEncabezado;

@property (nonatomic, retain) UIButton *botonSi;
@property (nonatomic, retain) UIButton *botonNo;
@property (nonatomic, retain) UIButton *botonAceptar;

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
