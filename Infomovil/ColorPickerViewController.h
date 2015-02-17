//
//  ColorPickerViewController.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "InfomovilViewController.h"
#import "ILSaturationBrightnessPickerView.h"
#import "ILHuePickerView.h"
#import "WS_HandlerProtocol.h"

@interface ColorPickerViewController : InfomovilViewController <ILSaturationBrightnessPickerViewDelegate, AlertViewDelegate, WS_HandlerProtocol> {
    IBOutlet UIView *colorChip;
    IBOutlet ILSaturationBrightnessPickerView *colorPicker;
    IBOutlet ILHuePickerView *huePicker;
}
@property (weak, nonatomic) IBOutlet UIScrollView *viewContenido;

@end
