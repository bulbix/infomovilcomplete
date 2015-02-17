//
//  VideoModel.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return Nil;
    }
    self.autor = [aDecoder decodeObjectForKey:@"autorVideo"];
    self.link = [aDecoder decodeObjectForKey:@"linkVideo"];
    self.thumbnail = [aDecoder decodeObjectForKey:@"imagenVideo"];
    self.titulo = [aDecoder decodeObjectForKey:@"tituloVideo"];
    
    self.categoria = [aDecoder decodeObjectForKey:@"categoriaVideo"];
    self.imagenPrevia = [aDecoder decodeObjectForKey:@"previaVideo"];
    self.linkSolo = [aDecoder decodeObjectForKey:@"linkSolo"];
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.autor forKey:@"autorVideo"];
    [aCoder encodeObject:self.link forKey:@"linkVideo"];
    [aCoder encodeObject:self.thumbnail forKey:@"imagenVideo"];
    [aCoder encodeObject:self.titulo forKey:@"tituloVideo"];
    
    [aCoder encodeObject:self.categoria forKey:@"categoriaVideo"];
    [aCoder encodeObject:self.imagenPrevia forKey:@"previaVideo"];
    
    [aCoder encodeObject:self.linkSolo forKey:@"linkSolo"];
}

- (id)copyWithZone:(NSZone *)zone {
	VideoModel * newVideo = [[[self class] allocWithZone:zone] init];
	
	if(newVideo){
		[newVideo setAutor:[self autor]];
		[newVideo setTitulo:[self titulo]];
		[newVideo setLink:[self link]];
		[newVideo setThumbnail:[self thumbnail]];
		[newVideo setImagenPrevia:[self imagenPrevia]];
		[newVideo setLinkSolo:[self linkSolo]];
		[newVideo setCategoria:[self categoria]];
	}
	
	return  newVideo;
}

@end
