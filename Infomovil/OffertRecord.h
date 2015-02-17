//
//  OffertRecord.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 20/07/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OffertRecord : NSObject

@property (nonatomic, strong) NSString *titleOffer;
@property (nonatomic, strong) NSString *descOffer;
@property (nonatomic, strong) NSString *termsOffer;
@property (nonatomic, strong) NSString *imageClobOffer;
@property (nonatomic, strong) NSString *linkOffer;
@property (nonatomic, strong) NSString *endDateOffer;
@property (nonatomic, strong) NSString *promoCodeOffer;
@property (nonatomic) NSInteger discountOffer;
@property (nonatomic, strong) NSString *redeemOffer;
@property (nonatomic) NSInteger idOffer;
@property (nonatomic, strong) NSString *pathImageOffer;
@property (nonatomic, strong) NSDate *endDateAux;
@property (nonatomic, strong) NSString *redeemAux;

@end
