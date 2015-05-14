//
//  PopupController.m
//  Infomovil
//
//  Created by Sergio Sanchez on 10/29/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "PopupController.h"

@interface PopupController ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSArray *buttonItems;
@property (nonatomic, strong) NSString *popupTitle;
@property (nonatomic, strong) UIButton *destructiveButton;
@property (nonatomic, assign) PopupControllerType popupType;
@property (nonatomic, strong) UITextField *inputText;

@end

@implementation PopupController

- (instancetype)initWithTitle:(NSString *)popupTitle
                     contents:(NSArray *)contents
                  buttonItems:(NSArray *)buttonItems
                withPopupType:(PopupControllerType)popupType {
    self = [super init];
    if (self) {
        _popupTitle = popupTitle;
        _contents = contents;
        _buttonItems = buttonItems;
        _popupType = popupType;
    }
    return self;
}

-(void) setupPopup {
    self.maskView = [[UIView alloc] init];
    self.maskView.alpha = 0.0;
    
    self.contentView = [[UIView alloc] init];
    
    if (self.popupTitle != nil) {
        CGSize sizeLabel = [self labelSizeForText:self.popupTitle andFontSize:17];
        UILabel *labelTitulo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeLabel.width, sizeLabel.height)];
        [labelTitulo setText:self.popupTitle];
        [labelTitulo setFont:[UIFont fontWithName:@"Avenir-Book" size:17]];
        [labelTitulo setTextColor:[UIColor whiteColor]];
    }
    switch (_popupType) {
        case PopupControllerTypeNormal:
            break;
        case PopupControllerTypeText:
            [self configurePopupText];
            break;
            
        default:
            break;
    }
}

-(void) configurePopupNormal {
    
}

-(void) configurePopupText {
    
}

-(CGSize) labelSizeForText:(NSString *)text andFontSize:(CGFloat)fontSize {
    CGFloat width = 100;
    CGFloat height = 100;
    bool sizeFound = false;
    while (!sizeFound) {
        NSLog(@"Begin loop");
        CGFloat previousSize = 0.0;
        CGFloat currSize = 0.0;
        for (float fSize = fontSize; fSize < fontSize+6; fSize++) {
            CGRect r = [text boundingRectWithSize:CGSizeMake(width, height)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:fSize]}
                                          context:nil];
            currSize =r.size.width*r.size.height;
            if (previousSize >= currSize) {
                width = width*11/10;
                height = height*11/10;
                fSize = fontSize+10;
            }
            else {
                previousSize = currSize;
            }
            NSLog(@"fontSize = %f\tbounds = (%f x %f) = %f",
                  fSize,
                  r.size.width,
                  r.size.height,r.size.width*r.size.height);
        }
        if (previousSize == currSize) {
            sizeFound = true;
        }
        
    }
    NSLog(@"Size found with width %f and height %f", width, height);
    
    return CGSizeMake(width, height);
}

- (void)presentPopupControllerAnimated:(BOOL)flag {
    
}
- (void)dismissPopupControllerAnimated:(BOOL)flag {
    
}


@end
