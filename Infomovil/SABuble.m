//
//  SABuble.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 16/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "SABuble.h"

@implementation SABuble

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame withTitle:(NSString *)title andPosition:(SABublePosition)position {
    self = [super initWithFrame:frame];
    if (self) {
        self.positionBubble = position;
        self.backgroundColor = [UIColor clearColor];
        if (position == SABublePositionBottom) {
            self.vistaContenedora = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-10)];
        }
        else {
            self.vistaContenedora = [[UIView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-10)];
        }
       
        [self.vistaContenedora setBackgroundColor:[UIColor whiteColor]];
        self.vistaContenedora.layer.cornerRadius = 3.0f;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-20)];
        [self.titleLabel setText:title];
        [self.titleLabel setTextColor:colorFuenteAzul];
        [self.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:10]];
        [self.titleLabel setNumberOfLines:2];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.vistaContenedora addSubview:self.titleLabel];
        [self addSubview:self.vistaContenedora];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.positionBubble == SABublePositionBottom) {
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, 15.0, 20.0);
        CGContextAddLineToPoint(context, 25.0, 30.0);
        CGContextAddLineToPoint(context, 35.0, 20.0);
        CGContextAddLineToPoint(context, 15.0, 20.0);
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, 25.0, 0.0);
        CGContextAddLineToPoint(context, 15.0, 10.0);
        CGContextAddLineToPoint(context, 35.0, 10.0);
        CGContextAddLineToPoint(context, 25.0, 0.0);
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}


@end
