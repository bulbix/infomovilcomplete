//
//  TextAndGraphAlertView.m
//  Infomovil
//
//  Created by German Azahel Velazquez Garcia on 8/25/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "TextAndGraphAlertView.h"

@implementation TextAndGraphAlertView

- (id)initWithFrame:(CGRect)frame
{
   
    if ((self = [super initWithFrame:frame]))
    {
     
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        
    }
    return self;
}

+(id)initInstruccionesContacto
{
    
    
    NSArray *objetos = [[NSBundle mainBundle] loadNibNamed:@"InstruccionesContacto"
                                                     owner:self
                                                   options:Nil];
    
    TextAndGraphAlertView *alerta = (TextAndGraphAlertView *)[objetos objectAtIndex:0];
    
    if(IS_IPAD){
        alerta.frame = CGRectMake(0, 0, 768, 1024);
        alerta.viewContenido.frame = CGRectMake(236,250,295,381);
    }else if(IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS){
        alerta.frame = CGRectMake(0, 0, 375,667);
        alerta.viewContenido.frame = CGRectMake(40,100,295,381);
    }
    /*else if(IS_STANDARD_IPHONE_6_PLUS){
        alerta.frame = CGRectMake(0, 0, 414, 736);
        alerta.viewContenido.frame = CGRectMake(59,100,295,381);
       
    }
    */
    
    [alerta setUpContacto];
    [alerta setAlpha:0];
    
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	[mainWindow addSubview:alerta];
    
    return alerta;
}

- (void)show
{
    
    
    
    [UIView animateWithDuration:0.3f animations:^{
        [self setAlpha:1];
        
    } completion:nil];
    
}

- (void)hide
{
    [self setAlpha:0];
    [self removeFromSuperview];
}

-(IBAction)presionarAceptar:(id)sender
{
    [self hide];
}

#pragma mark -
- (void)setUpContacto
{
   
    _lblTitulo.text = NSLocalizedString(@"instrucciones", nil);
    _lblTexto1.text = NSLocalizedString(@"pulsaContacto", nil);
    _lblTexto2.text = NSLocalizedString(@"mostrarContacto", nil);
    _lblTexto3.text = NSLocalizedString(@"moverContacto", nil);
    [self.btnAceptar setTitle:NSLocalizedString(@"aceptarPop", nil) forState: UIControlStateNormal];
}

@end
