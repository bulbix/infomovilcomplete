//
//  AlertView.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 22/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "AlertView.h"
#import "ETActivityIndicatorView.h"

@interface AlertView () {
    NSInteger tipo;
}

@end

@implementation AlertView

- (id)initWithFrame:(CGRect)frame andAlertViewType:(AlertViewType) type andTypeInit:(NSInteger) typeInit;
{
    self = [super initWithFrame:frame];
    if (self) {
        tipo = typeInit;
        self.type = type;
        [self baseInit];
        
    }
    return self;
}

+(id)initWithDelegate:(id<AlertViewDelegate>)delegate message:(NSString*)mensaje andAlertViewType:(AlertViewType)type {
    CGRect frameAlert = [[UIScreen mainScreen] bounds];
    AlertView *alerta = [[AlertView alloc] initWithFrame:frameAlert andAlertViewType:type andTypeInit:1];
    [alerta guardarTituloLabel:mensaje];
    [alerta asignarDelegado:delegate];
    [alerta setAlpha:0];
    
    
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	[mainWindow addSubview:alerta];
    
    return alerta;
}
+(id)initWithDelegate:(id<AlertViewDelegate>)delegate titulo:(NSString *)titulo message:(NSString *)mensaje dominio:(NSString *)dominio andAlertViewType:(AlertViewType)type {
    CGRect frameAlert = [[UIScreen mainScreen] bounds];
    
    AlertView *alerta = [[AlertView alloc] initWithFrame:frameAlert andAlertViewType:type andTypeInit:2];
    [alerta guardarTituloLabel:titulo];
    [alerta guardarMensaje:mensaje];
    [alerta guardarDominio:dominio];
    [alerta asignarDelegado:delegate];
    [alerta setAlpha:0];
    
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	[mainWindow addSubview:alerta];
    
    return alerta;
}

-(void)baseInit {
    [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.6]];
    self.vistaAlert = [[UIView alloc] initWithFrame:CGRectMake(21, 150, 278, 200)];
    [self.vistaAlert setBackgroundColor:colorBackground];
    
    self.labelTitulo = [[UILabel alloc] initWithFrame:CGRectMake(5, 33, 268, 100)];
    [self.labelTitulo setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
    [self.labelTitulo setTextColor:[UIColor blackColor]];
    [self.labelTitulo setTextAlignment:NSTextAlignmentCenter];
    [self.labelTitulo setBackgroundColor:[UIColor clearColor]];
    [self.labelTitulo setNumberOfLines:4];
    [self.vistaAlert addSubview:self.labelTitulo];
    switch (self.type) {
        case AlertViewTypeQuestion:
            self.botonSi = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.botonSi setFrame:CGRectMake(30, 150, 108, 41)];
			if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
				[self.botonSi setTitle:@"Yes" forState:UIControlStateNormal];
			}else{
				[self.botonSi setTitle:@"Si" forState:UIControlStateNormal];
			}
            
            [self.botonSi setTitleColor:colorFuenteAzul forState:UIControlStateNormal];
            [self.botonSi setBackgroundImage:[UIImage imageNamed:@"btnsino.png"] forState:UIControlStateNormal];
            [self.botonSi.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.botonSi addTarget:self action:@selector(presionarSi:) forControlEvents:UIControlEventTouchUpInside];
            [self.vistaAlert addSubview:self.botonSi];
            
            self.botonNo = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.botonNo setFrame:CGRectMake(145, 150, 108, 41)];
            [self.botonNo setTitle:@"No" forState:UIControlStateNormal];
            [self.botonNo setTitleColor:colorFuenteAzul forState:UIControlStateNormal];
            [self.botonNo setBackgroundImage:[UIImage imageNamed:@"btnsino"] forState:UIControlStateNormal];
            [self.botonNo.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.botonNo addTarget:self action:@selector(presionarNo:) forControlEvents:UIControlEventTouchUpInside];
            [self.vistaAlert addSubview:self.botonNo];
            if (tipo == 1) {
                //MBC
                if(IS_STANDARD_IPHONE_6){
                    [self.vistaAlert setFrame:CGRectMake(50, 150, 278, 182)];
                }
                else if(IS_STANDARD_IPHONE_6_PLUS){
                    [self.vistaAlert setFrame:CGRectMake(68, 150, 278, 182)];
                }else if(IS_IPAD){
                    [self.vistaAlert setFrame:CGRectMake(245, 400, 300, 182)];
                }else{
                    [self.vistaAlert setFrame:CGRectMake(21, 150, 278, 182)];
                }
                if(IS_IPAD){
                    [self.botonNo setFrame:CGRectMake(150, 128, 149, 54)];
                    [self.botonSi setFrame:CGRectMake(0, 128, 149, 54)];
                }else{
                    [self.botonNo setFrame:CGRectMake(139, 128, 139, 54)];
                    [self.botonSi setFrame:CGRectMake(0, 128, 139, 54)];
                    }
            }
            break;
			
			
		case AlertViewTypeInfo3:
            self.botonSi = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.botonSi setFrame:CGRectMake(30, 150, 108, 41)];
			if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
				[self.botonSi setTitle:@"Accept" forState:UIControlStateNormal];
			}else{
				[self.botonSi setTitle:@"Aceptar" forState:UIControlStateNormal];
			}
            
            [self.botonSi setTitleColor:colorFuenteAzul forState:UIControlStateNormal];
            [self.botonSi setBackgroundImage:[UIImage imageNamed:@"btnsino.png"] forState:UIControlStateNormal];
            [self.botonSi.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.botonSi addTarget:self action:@selector(presionarAceptar2:) forControlEvents:UIControlEventTouchUpInside];
            [self.vistaAlert addSubview:self.botonSi];
            
            self.botonNo = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.botonNo setFrame:CGRectMake(145, 150, 108, 41)];
			if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
				[self.botonNo setTitle:@"Cancel" forState:UIControlStateNormal];
			}else{
				[self.botonNo setTitle:@"Cancelar" forState:UIControlStateNormal];
			}
            
            [self.botonNo setTitleColor:colorFuenteAzul forState:UIControlStateNormal];
            [self.botonNo setBackgroundImage:[UIImage imageNamed:@"btnsino"] forState:UIControlStateNormal];
            [self.botonNo.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.botonNo addTarget:self action:@selector(presionarCancelar:) forControlEvents:UIControlEventTouchUpInside];
            [self.vistaAlert addSubview:self.botonNo];
            if (tipo == 1) {
                //MBC
                if(IS_STANDARD_IPHONE_6){
                    [self.vistaAlert setFrame:CGRectMake(50, 150, 278, 182)];
                }
                else if(IS_STANDARD_IPHONE_6_PLUS){
                    [self.vistaAlert setFrame:CGRectMake(65, 150, 278, 182)];
                }else if(IS_IPAD){
                    [self.vistaAlert setFrame:CGRectMake(245, 400, 300, 182)];
                   
                
                }else{
                    [self.vistaAlert setFrame:CGRectMake(21, 150, 278, 182)];
                }
                [self.botonNo setFrame:CGRectMake(139, 128, 139, 54)];
                [self.botonSi setFrame:CGRectMake(0, 128, 139, 54)];
            }
            break;
        
        case AlertViewTypeActivity:
            //MBC
            if(IS_STANDARD_IPHONE_6){
                [self.vistaAlert setFrame:CGRectMake(50, 150, 278, 182)];
            }
            else if(IS_STANDARD_IPHONE_6_PLUS){
                [self.vistaAlert setFrame:CGRectMake(80, 150, 278, 182)];
            }else if(IS_IPAD){
                [self.vistaAlert setFrame:CGRectMake(245, 400, 300, 182)];
            }else{
                [self.vistaAlert setFrame:CGRectMake(21, 150, 278, 182)];
            }
            
            self.activityIndicator = [[ETActivityIndicatorView alloc] initWithFrame:CGRectMake(109, 40, 60, 60) andColor:colorMorado];
            [self.activityIndicator startAnimating];
            [self.vistaAlert addSubview:self.activityIndicator];
            [self.labelTitulo setFrame:CGRectMake(10, 110, 258, 30)];
            break;
            
        case AlertViewTypeInfo:
            //MBC
            if(IS_STANDARD_IPHONE_6){
                [self.vistaAlert setFrame:CGRectMake(50, 150, 278, 200)];
            }
            else if(IS_STANDARD_IPHONE_6_PLUS){
                [self.vistaAlert setFrame:CGRectMake(80, 150, 278, 200)];
            }else if(IS_IPAD){
                [self.vistaAlert setFrame:CGRectMake(234, 400, 300, 182)];
            }else{
                [self.vistaAlert setFrame:CGRectMake(21, 150, 278, 200)];
            }
            
            self.labelMensaje = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 263, 75)];
            [self.labelMensaje setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelMensaje setTextColor:[UIColor blackColor]];
            [self.labelMensaje setNumberOfLines:10];
            [self.labelMensaje setTextAlignment:NSTextAlignmentCenter];
            [self.vistaAlert addSubview:self.labelMensaje];
            
            self.labelDominio = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 263, 30)];
            [self.labelDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelDominio setTextColor:[UIColor blackColor]];
            [self.labelDominio setNumberOfLines:3];
            [self.labelDominio setTextAlignment:NSTextAlignmentCenter];
            [self.vistaAlert addSubview:self.labelDominio];
            
            self.botonAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
            if(IS_IPAD){
                [self.botonAceptar setFrame:CGRectMake(0, 150, 300, 62)];
            }else{
                [self.botonAceptar setFrame:CGRectMake(0, 170, 278, 54)];
            
            }
            [self.botonAceptar setBackgroundImage:[UIImage imageNamed:@"btnaceptarmensajes.png"] forState:UIControlStateNormal];
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
				[self.botonAceptar setTitle:@"Accept" forState:UIControlStateNormal];
			}else{
				[self.botonAceptar setTitle:@"Aceptar" forState:UIControlStateNormal];
			}
            [self.botonAceptar setTitleColor:colorFuenteAzul forState:UIControlStateNormal];
            [self.botonAceptar addTarget:self action:@selector(presionarAceptar:) forControlEvents:UIControlEventTouchUpInside];
            [self.vistaAlert addSubview:self.botonAceptar];
			
            if (tipo == 1) {
                
                if(IS_STANDARD_IPHONE_6){
                    [self.vistaAlert setFrame:CGRectMake(50, 150, 278, 240)];
                }
                else if(IS_STANDARD_IPHONE_6_PLUS){
                    [self.vistaAlert setFrame:CGRectMake(80, 150, 278, 200)];
                }else if(IS_IPAD){
                    [self.vistaAlert setFrame:CGRectMake(234, 400, 300, 182)];
                   
                }else{
                    [self.vistaAlert setFrame:CGRectMake(21, 150, 278, 182)];
                }
                self.labelDominio.hidden = YES;
                
                if(IS_STANDARD_IPHONE_6){
                    [self.botonAceptar setFrame:CGRectMake(0, 140, 278, 54)];
                }
                else if(IS_STANDARD_IPHONE_6_PLUS){
                    [self.botonAceptar setFrame:CGRectMake(0, 170, 278, 54)];
                }else if(IS_IPAD){
                    [self.botonAceptar setFrame:CGRectMake(0, 145, 300, 62)];
                }else{
                    [self.botonAceptar setFrame:CGRectMake(0, 128, 278, 54)];
                }
                [self.labelTitulo setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
                [self.labelTitulo setFrame:CGRectMake(10, 50, 258, 70)];
            }
            else {
                [self.labelTitulo setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
                [self.labelTitulo setFrame:CGRectMake(10, 45, 258, 21)];
                //[self.labelMensaje setFrame:CGRectMake(10, 70, 263, 40)];
                [self.labelDominio setFrame:CGRectMake(10, 110, 263, 21)];
            }
            break;
            
        case AlertViewTypeInfo2:
            [self.vistaAlert setFrame:CGRectMake(18, 150, 283, 220)];
            self.labelMensaje = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 263, 45)];
            [self.labelMensaje setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelMensaje setTextColor:colorFuenteAzul];
            [self.labelMensaje setNumberOfLines:5];
            [self.labelMensaje setTextAlignment:NSTextAlignmentCenter];
            [self.vistaAlert addSubview:self.labelMensaje];
            
            [self.labelTitulo setFrame:CGRectMake(5, 33, 268, 120)];
            [self.labelTitulo setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelTitulo setNumberOfLines:6];
            [self.labelTitulo setTextAlignment:NSTextAlignmentCenter];

            
            self.labelDominio = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 263, 21)];
            [self.labelDominio setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelDominio setTextColor:colorFuenteVerde];
            [self.labelDominio setTextAlignment:NSTextAlignmentCenter];
            [self.vistaAlert addSubview:self.labelDominio];
            
            self.labelMensaje2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 263, 45)];
            [self.labelMensaje2 setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelMensaje2 setTextColor:colorFuenteAzul];
            [self.labelMensaje2 setTextAlignment:NSTextAlignmentCenter];
            [self.labelMensaje2 setNumberOfLines:3];
            [self.vistaAlert addSubview:self.labelMensaje2];
            
            self.botonAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.botonAceptar setFrame:CGRectMake(0, 166, 278, 54)];
            [self.botonAceptar setBackgroundImage:[UIImage imageNamed:@"btnaceptarmensajes.png"] forState:UIControlStateNormal];
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
				[self.botonAceptar setTitle:@"Accept" forState:UIControlStateNormal];
			}else{
				[self.botonAceptar setTitle:@"Aceptar" forState:UIControlStateNormal];
			}
            [self.botonAceptar setTitleColor:colorFuenteAzul forState:UIControlStateNormal];
            [self.botonAceptar addTarget:self action:@selector(presionarAceptar:) forControlEvents:UIControlEventTouchUpInside];
            [self.vistaAlert addSubview:self.botonAceptar];
            
            break;
        case AlertViewInfoMapa:
            //MBC
            if(IS_STANDARD_IPHONE_6){
                [self.vistaAlert setFrame:CGRectMake(50, 150, 278, 200)];
            }else if(IS_IPAD){
                [self.vistaAlert setFrame:CGRectMake(234, 400, 300, 182)];
                
            }else if(IS_STANDARD_IPHONE_6_PLUS){
                [self.vistaAlert setFrame:CGRectMake(80, 150, 278, 200)];
            }
            else{
                [self.vistaAlert setFrame:CGRectMake(21, 150, 278, 182)];
            }
            [self.labelTitulo setHidden:YES];
            self.labelMensaje = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 263, 25)];
            [self.labelMensaje setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelMensaje setTextColor:colorFuenteAzul];
            [self.labelMensaje setNumberOfLines:5];
            [self.labelMensaje setTextAlignment:NSTextAlignmentCenter];
            [self.labelMensaje setText:NSLocalizedString(@"txtInfoMapa", Nil)];
            [self.vistaAlert addSubview:self.labelMensaje];
            
            self.labelMensaje2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 99, 263, 25)];
            [self.labelMensaje2 setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
            [self.labelMensaje2 setTextColor:colorFuenteAzul];
            [self.labelMensaje2 setNumberOfLines:5];
            [self.labelMensaje2 setTextAlignment:NSTextAlignmentCenter];
            [self.labelMensaje2 setText:NSLocalizedString(@"txtInfoMapa2", Nil)];
            [self.vistaAlert addSubview:self.labelMensaje2];
            
            self.imagenLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milocalizar.png"]];
            [self.imagenLogo setFrame:CGRectMake(100, 45, 78, 52)];
            [self.vistaAlert addSubview:self.imagenLogo];
            
            self.botonAceptar = [UIButton buttonWithType:UIButtonTypeCustom];
            if(IS_IPAD){
                [self.botonAceptar setFrame:CGRectMake(0, 145, 300, 62)];
            }else{
                [self.botonAceptar setFrame:CGRectMake(0, 140, 278, 54)];
            }
            [self.botonAceptar setBackgroundImage:[UIImage imageNamed:@"btnaceptarmensajes.png"] forState:UIControlStateNormal];
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
				[self.botonAceptar setTitle:@"Accept" forState:UIControlStateNormal];
			}else{
				[self.botonAceptar setTitle:@"Aceptar" forState:UIControlStateNormal];
			}
            [self.botonAceptar setTitleColor:colorFuenteAzul forState:UIControlStateNormal];
            [self.botonAceptar addTarget:self action:@selector(presionarAceptar:) forControlEvents:UIControlEventTouchUpInside];
            [self.vistaAlert addSubview:self.botonAceptar];
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.vistaAlert];
}

-(void) guardarTituloLabel:(NSString *)titulo {
    [self.labelTitulo setText:titulo];
}

-(void) guardarMensaje:(NSString *)mensaje {
    if (AlertViewTypeInfo2 == self.type) {
        NSArray *arregloTextos = [mensaje componentsSeparatedByString:@"+"];
        [self.labelMensaje setText:[arregloTextos objectAtIndex:0]];
        [self.labelMensaje2 setText:[arregloTextos objectAtIndex:1]];
    }
    else {
        [self.labelMensaje setText:mensaje];
    }
}

-(void) guardarDominio:(NSString *) dominio {
    [self.labelDominio setText:dominio];
}

-(void) asignarDelegado:(id<AlertViewDelegate>)delegado{
    [self setDelegado:delegado];
}



-(void) show {
    [UIView animateWithDuration:0.3f animations:^{
        [self setAlpha:1];
    } completion:nil];
}

-(void) hide {
        [self setAlpha:0];
        [self removeFromSuperview];
}

-(IBAction)presionarSi:(id)sender {

	[self performSelectorInBackground:@selector(ejecutaSelector) withObject:NULL];
	[self hide];
    
}
-(IBAction)presionarNo:(id)sender {
    if ([self.delegado respondsToSelector:@selector(accionNo)]) {
        [self.delegado accionNo];
    }
    [self hide];
}
-(IBAction)presionarAceptar2:(id)sender {
    if ([self.delegado respondsToSelector:@selector(accionAceptar2)]) {
        [self.delegado accionAceptar2];
    }
    [self hide];
}
-(IBAction)presionarCancelar:(id)sender {
    if ([self.delegado respondsToSelector:@selector(accionCancelar)]) {
        [self.delegado accionCancelar];
    }
    [self hide];
}
-(IBAction)presionarAceptar:(id)sender {
    if ([self.delegado respondsToSelector:@selector(accionAceptar)]) {
        [self.delegado accionAceptar];
    }
    
    [self hide];
}

-(void)ejecutaSelector{
	
	@autoreleasepool {
        if([_delegado respondsToSelector:@selector(accionSi)]){
			[_delegado performSelector:@selector(accionSi)];
		}
    }
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
