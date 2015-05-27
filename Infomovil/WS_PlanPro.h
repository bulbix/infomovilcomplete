//
//  WS_PlanPro.h
//  Infomovil
//
//  Created by Isaac Rosas Camarillo on 10/02/15.
//  Copyright (c) 2015 Sergio Sánchez Flores. All rights reserved.
//
#import "WS_Handler.h"
#import "WS_HandlerProtocol.h"
#import <StoreKit/StoreKit.h>
#import "WS_Handler.h"

@interface WS_PlanPro : WS_Handler <WS_HandlerProtocol, NSXMLParserDelegate>
@property (nonatomic, strong) id<WS_HandlerProtocol> compraDominioDelegate;
@property (nonatomic, strong) NSString *currentElementString;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *resultado;




@end


