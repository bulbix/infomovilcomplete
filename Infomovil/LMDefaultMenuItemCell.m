//
//  LMItemViewCell.m
//  LMDropdownView
//
//  Created by LMinh on 16/07/2014.
//  Copyright (c) Năm 2014 LMinh. All rights reserved.
//

#import "LMDefaultMenuItemCell.h"

@implementation LMDefaultMenuItemCell

- (void)awakeFromNib
{
  /*  self.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = colorFuenteVerde;
    self.selectedBackgroundView = selectedBackgroundView;
    self.menuItemLabel.textColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryCheckmark;
   */
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
  
}

@end
