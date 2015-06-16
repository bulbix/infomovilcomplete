//
//  JsonParserVideo.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 04/09/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WS_HandlerProtocol.h"

@interface JsonParserVideo : NSObject

@property(nonatomic, strong) NSString *criterioBusqueda;
@property(nonatomic) NSInteger tipoBusqueda;
@property(nonatomic, strong) NSMutableArray *arregloVideos;
@property (nonatomic, weak) id<WS_HandlerProtocol> delegate;

-(void)buscarVideo:(NSString *)criterioBusqueda conTipo:(NSInteger) tipoBusqueda;

@end
