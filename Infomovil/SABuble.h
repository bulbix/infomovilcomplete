//
//  SABuble.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 16/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    SABublePositionTop,
    SABublePositionBottom
}SABublePosition;

@interface SABuble : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *vistaContenedora;
@property (nonatomic) SABublePosition positionBubble;

-(id) initWithFrame:(CGRect)frame withTitle:(NSString *)title andPosition:(SABublePosition)position;

@end
