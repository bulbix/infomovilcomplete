//
//  PopupController.h
//  Infomovil
//
//  Created by Sergio Sanchez on 10/29/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PopupControllerDelegate;

typedef enum {
    PopupControllerTypeNormal,
    PopupControllerTypeText
}PopupControllerType;

@interface PopupController : NSObject

- (instancetype)initWithTitle:(NSAttributedString *)popupTitle
                     contents:(NSArray *)contents
                  buttonItems:(NSArray *)buttonItems
                withPopupType:(PopupControllerType)popupType;

- (void)presentPopupControllerAnimated:(BOOL)flag;
- (void)dismissPopupControllerAnimated:(BOOL)flag;


@end

@protocol PopupControllerDelegate <NSObject>

- (void)popupController:(PopupController *)controller didDismissWithButtonTag:(NSInteger)tag andText:(NSString *)strText;

@end
