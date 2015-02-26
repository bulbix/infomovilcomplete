//
//  ContactosCell.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contacto;
@protocol ContactosCellDelegate;

@interface ContactosCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagenTipo;
@property (weak, nonatomic) IBOutlet UILabel *labelTelefono;
@property (weak, nonatomic) IBOutlet UILabel *labelTipo;
@property (weak, nonatomic) IBOutlet UISwitch *switchActivo;
@property (weak, nonatomic) IBOutlet UIView *vistaContenedora;
@property (nonatomic, assign) id<ContactosCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnTipo;
@property (weak, nonatomic) IBOutlet UILabel *opacarContacto;

@property (nonatomic, strong) Contacto *contacto;

- (IBAction)cambiarEstatus:(UISwitch *)sender;

@end

@protocol ContactosCellDelegate <NSObject>

-(void)cell:(ContactosCell *)cell changeSwitchValue:(UISwitch *)aSwitch;

@end
