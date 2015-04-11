//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "SABuble.h"


//------------------------------------------------------------------------------------------------
// private interface declaration
//------------------------------------------------------------------------------------------------
@interface PNLineChart () {
    BOOL isBubleVisible;
}

@property (nonatomic,strong) NSMutableArray *chartLineArray; // Array[CAShapeLayer]

@property (strong, nonatomic) NSMutableArray *chartPath; //Array of line path, one for each line.
@property (nonatomic, strong) SABuble *bubleInfo;

- (void)setDefaultValues;

@end


//------------------------------------------------------------------------------------------------
// public interface implementation
//------------------------------------------------------------------------------------------------
@implementation PNLineChart

#pragma mark initialization

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

#pragma mark instance methods

-(void)setYLabels:(NSArray *)yLabels
{
    
    CGFloat yStep = (_yValueMax-_yValueMin) / _yLabelNum;
	CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
    
    
    NSInteger index = 0;
	NSInteger num = _yLabelNum+1;
	while (num > 0) {
		PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (_chartCavanHeight - index * yStepHeight), _chartMargin, _yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f",_yValueMin + (yStep * index)];
		[self addSubview:label];
        index +=1 ;
		num -= 1;
	}
    
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    NSString* labelText;
    if(_showLabel){
        _xLabelWidth = _chartCavanWidth/[xLabels count];
        
        for(int index = 0; index < xLabels.count; index++)
        {
            labelText = xLabels[index];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(2*_chartMargin +  (index * _xLabelWidth) - (_xLabelWidth / 2), (_chartMargin + _chartCavanHeight)-5, _xLabelWidth, 21)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self addSubview:label];
        }
        
    }else{
        _xLabelWidth = (self.frame.size.width)/[xLabels count];
    }
    UILabel *labelPeriodo;
	NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
	if([language rangeOfString:@"es"].location != NSNotFound){
		labelPeriodo = [[UILabel alloc] initWithFrame:CGRectMake(110, _chartMargin + _chartCavanHeight+12, 150, 21)];
		[labelPeriodo setText:@"Período de tiempo"];
	}else if([language rangeOfString:@"en"].location != NSNotFound){
		labelPeriodo = [[UILabel alloc] initWithFrame:CGRectMake(140, _chartMargin + _chartCavanHeight+12, 150, 21)];
		[labelPeriodo setText:@"Period"];
	}
    else {
        labelPeriodo = [[UILabel alloc] initWithFrame:CGRectMake(110, _chartMargin + _chartCavanHeight+12, 150, 21)];
		[labelPeriodo setText:@"Período de tiempo"];
    }
    [labelPeriodo setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
    [labelPeriodo setTextColor:[UIColor lightGrayColor]];
    [self addSubview:labelPeriodo];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
}

-(void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    for (UIBezierPath *path in _chartPath) {
        CGPathRef originalPath = path.CGPath;
        CGPathRef strokedPath = CGPathCreateCopyByStrokingPath(originalPath, NULL, 3.0, kCGLineCapRound, kCGLineJoinRound, 3.0);
        // !!!: revisar
        if ( !strokedPath )
            continue;
        
        BOOL pathContainsPoint = CGPathContainsPoint(strokedPath, NULL, touchPoint, NO);
        if (pathContainsPoint)
        {
            [_delegate userClickedOnLinePoint:touchPoint lineIndex:[_chartPath indexOfObject:path]];
            for (NSArray *linePointsArray in _pathPoints) {
                for (NSValue *val in linePointsArray) {
                    CGPoint p = [val CGPointValue];
                    if (p.x + 3.0 > touchPoint.x && p.x - 3.0 < touchPoint.x && p.y + 3.0 > touchPoint.y && p.y - 3.0 < touchPoint.y ) {
                        //Call the delegate and pass the point and index of the point
                        [self hideBuble];
                        if (touchPoint.y-30 > self.frame.origin.y) {
                            self.bubleInfo = [[SABuble alloc] initWithFrame:CGRectMake(touchPoint.x-25, touchPoint.y-30, 50, 30) withTitle:[self.arregloValores objectAtIndex:[linePointsArray indexOfObject:val]] andPosition:SABublePositionBottom];
                        }
                        else {
                            self.bubleInfo = [[SABuble alloc] initWithFrame:CGRectMake(touchPoint.x-25, touchPoint.y, 50, 30) withTitle:[self.arregloValores objectAtIndex:[linePointsArray indexOfObject:val]] andPosition:SABublePositionTop];
                        }
                        
                        [self showBuble];
                        
//                        [self showBuble];
                        [_delegate userClickedOnLineKeyPoint:touchPoint lineIndex:[_pathPoints indexOfObject:linePointsArray] andPointIndex:[linePointsArray indexOfObject:val]];
                    }
                }
            }
            
        }
        // !!!:revisar
        CGPathRelease(strokedPath);
    }
    
}

-(void)strokeChart
{
    _chartPath = [[NSMutableArray alloc] init];
    
    
    //Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        CAShapeLayer *chartLine = (CAShapeLayer *) self.chartLineArray[lineIndex];
        CGFloat yValue;
        CGFloat innerGrade;
        CGPoint point;
        
        UIGraphicsBeginImageContext(self.frame.size);
        UIBezierPath * progressline = [UIBezierPath bezierPath];
        [_chartPath addObject:progressline];
        

        
        if(!_showLabel){
            _chartCavanHeight = self.frame.size.height - 2*_yLabelHeight;
            _chartCavanWidth = self.frame.size.width;
            _chartMargin = 0.0;
            _xLabelWidth = (_chartCavanWidth / ([_xLabels count] -1));
        }
        
        NSMutableArray * linePointsArray = [[NSMutableArray alloc] init];
        [progressline setLineWidth:4.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        
        
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {

            yValue = chartData.getData(i).y;
            
            innerGrade = (yValue - _yValueMin) / ( _yValueMax - _yValueMin);
            
            point = CGPointMake(2*_chartMargin +  (i * _xLabelWidth), _chartCavanHeight - (innerGrade * _chartCavanHeight) + ( _yLabelHeight /2 ));
            
            if (i != 0) {
                [progressline addLineToPoint:point];
            }
            
            [progressline moveToPoint:point];
            [linePointsArray addObject:[NSValue valueWithCGPoint:point]];
        }
        [_pathPoints addObject:[linePointsArray copy]];
        // setup the color of the chart line
        if (chartData.color) {
            chartLine.strokeColor = [chartData.color CGColor];
        }else{
            chartLine.strokeColor = [PNGreen CGColor];
        }
        
        [progressline stroke];
        
        chartLine.path = progressline.CGPath;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        chartLine.strokeEnd = 1.0;
        
        
        UIGraphicsEndImageContext();
    }
}

- (void)setChartData:(NSArray *)data {
    if (data != _chartData) {
        
        NSMutableArray *yLabelsArray = [NSMutableArray arrayWithCapacity:data.count];
        CGFloat yMax = 0.0f;
        CGFloat yMin = MAXFLOAT;
        CGFloat yValue;
        // remove all shape layers before adding new ones
        for (CALayer *layer in self.chartLineArray) {
            [layer removeFromSuperlayer];
        }
        self.chartLineArray = [NSMutableArray arrayWithCapacity:data.count];
        
        
        for (PNLineChartData *chartData in data) {
            
            // create as many chart line layers as there are data-lines
            CAShapeLayer *chartLine = [CAShapeLayer layer];
            chartLine.lineCap   = kCALineCapRound;
            chartLine.lineJoin  = kCALineJoinBevel;
            chartLine.fillColor = [[UIColor whiteColor] CGColor];
            chartLine.lineWidth = 3.0;
            chartLine.strokeEnd = 0.0;
            [self.layer addSublayer:chartLine];
            [self.chartLineArray addObject:chartLine];
            
            for (NSUInteger i = 0; i < chartData.itemCount; i++) {
                yValue = chartData.getData(i).y;
                [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
                yMax = fmaxf(yMax, yValue);
                yMin = fminf(yMin, yValue);
            }
        }
        if ([yLabelsArray count] == 1) {
            yMin = 0;
        }
        
        // Min value for Y label
        if (yMax < 5) {
            yMax = 5.0f;
        }
        if (yMin < 0){
            yMin = 0.0f;
        }
        
        _yValueMin = yMin;
        _yValueMax = yMax;
        
        
        _chartData = data;
//        if ([self.chartLineArray count] == 1) {
//            CAShapeLayer *chartLine = [CAShapeLayer layer];
//            chartLine.lineCap   = kCALineCapRound;
//            chartLine.lineJoin  = kCALineJoinBevel;
//            chartLine.fillColor = [[UIColor whiteColor] CGColor];
//            chartLine.lineWidth = 3.0;
//            chartLine.strokeEnd = 0.0;
//            [self.layer addSublayer:chartLine];
//            [self.chartLineArray insertObject:chartLine atIndex:0];
//        }
        
        if (_showLabel) {
//            if ([yLabelsArray count] == 1) {
//                [yLabelsArray insertObject:@"0" atIndex:0];
//            }
            [self setYLabels:yLabelsArray];
        }
        
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 40.0, 0.0);
    CGContextAddLineToPoint(context, 40.0, self.frame.size.height);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context,  10.0, self.frame.size.height - 35);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height -35);
    CGContextDrawPath(context, kCGPathStroke);
}


#pragma mark private methods

- (void)setDefaultValues {
    // Initialization code
    isBubleVisible = NO;
    self.backgroundColor = [UIColor colorWithRed:(237/255.0f) green:(229/255.0f) blue:(226/255.0f) alpha:1.0];
    self.clipsToBounds   = YES;
    self.chartLineArray  = [NSMutableArray new];
    _showLabel           = YES;
    _pathPoints = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;
    
    _yLabelNum = 5.0;
    _yLabelHeight = [[[[PNChartLabel alloc] init] font] pointSize];
    
    _chartMargin = 30;

    _chartCavanWidth = self.frame.size.width - _chartMargin *2;
    _chartCavanHeight = self.frame.size.height - _chartMargin * 2;
}

#pragma -mark

-(void) hideBuble {
    if (isBubleVisible) {
        isBubleVisible = NO;
//        [UIView animateWithDuration:0.3f animations:^{
//            [self.bubleInfo setAlpha:0];
//        } completion:^(BOOL finished) {
            [self.bubleInfo removeFromSuperview];
//            [self showBuble];
//        }];
    }
//    else {
//        [self showBuble];
//    }
}
-(void) showBuble {
    [self.bubleInfo setAlpha:0];
    isBubleVisible = YES;
    [self addSubview:self.bubleInfo];
    [UIView animateWithDuration:0.3f animations:^{
        [self.bubleInfo setAlpha:1];
    }];
}

@end
