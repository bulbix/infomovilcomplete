//
//  KeywordDataModel.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 05/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "KeywordDataModel.h"

@implementation KeywordDataModel

//@synthesize idKeyword, keywordField, keywordValue;

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return Nil;
    }
    self.idKeyword = [aDecoder decodeIntegerForKey:@"idKeyword"];
    self.keywordField = [aDecoder decodeObjectForKey:@"keywordField"];
    self.keywordValue = [aDecoder decodeObjectForKey:@"keywordValue"];
	self.KeywordPos = [aDecoder decodeObjectForKey:@"keywordPos"];
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.keywordField forKey:@"keywordField"];
    [aCoder encodeInteger:self.idKeyword forKey:@"idKeyword"];
    [aCoder encodeObject:self.keywordValue forKey:@"keywordValue"];
	[aCoder encodeObject:self.KeywordPos forKey:@"keywordPos"];
}

- (id)copyWithZone:(NSZone *)zone {
	KeywordDataModel * newKey = [[[self class] allocWithZone:zone] init];
	
	if(newKey){
		[newKey setKeywordField:[self keywordField]];
		[newKey setKeywordValue:[self keywordValue]];
		[newKey setIdAuxKeyword:[self idAuxKeyword]];
		[newKey setKeywordPos:[self KeywordPos]];
	}
	
	return  newKey;
}

@end
