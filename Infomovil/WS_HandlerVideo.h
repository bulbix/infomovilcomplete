//
//  WS_HandlerVideo.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"

@interface WS_HandlerVideo : WS_Handler <WS_HandlerProtocol>

@property (nonatomic, strong) id<WS_HandlerProtocol> videoDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *resultado;
@property (nonatomic, strong) NSString *token;

-(void) eliminarVideo;
-(void) insertarVideo;

//-(void) insertarVideo:(VideoModel *) videoSeleccionado;

@end
