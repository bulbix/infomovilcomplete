//
//  ContactosCell.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "ContactosCell.h"
#import "Contacto.h"

@implementation ContactosCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) init {
    self = [super init];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.switchActivo.hidden = self.editing;
    //[self.labelTelefono setText:[self.contacto noContacto]];
	if([self.contacto.idPais isEqualToString:@"+52"] && [[self.contacto.noContacto substringToIndex:1] isEqualToString:@"1"] && self.contacto.indice == 1){
		[self.labelTelefono setText:[[self.contacto noContacto] substringFromIndex:1]];
	}else{
		[self.labelTelefono setText:[self.contacto noContacto]];
	}
    [self.labelTipo setText:[self.contacto descripcion]];
    [self.switchActivo setOn:self.contacto.habilitado];
    if ([self.contacto habilitado]) {
        [self.labelTelefono setTextColor:colorFuenteAzul];
        [self.labelTipo setTextColor:colorFuenteVerde];
        [self.btnTipo setEnabled:YES];
    }
    else {
        [self.labelTelefono setTextColor:[UIColor lightGrayColor]];
        [self.labelTipo setTextColor:[UIColor lightGrayColor]];
        [self.btnTipo setEnabled:NO];
    }
}

- (IBAction)cambiarEstatus:(UISwitch *)sender {
    [self.delegate cell:self changeSwitchValue:self.switchActivo];
}
@end
