//
//  KeywordDataModel.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 05/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeywordDataModel : NSObject <NSCoding>

@property (nonatomic) NSInteger idKeyword;
@property (nonatomic, strong) NSString *keywordField;
@property (nonatomic, strong) NSString *keywordValue;
@property (nonatomic, strong) NSString *idAuxKeyword;
@property (nonatomic, strong) NSString *KeywordPos;

@end
