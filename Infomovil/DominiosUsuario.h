//
//  DominiosUsuario.h
//  Infomovil
//
//  Created by Infomovil on 10/24/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DominiosUsuario : NSObject

@property (nonatomic, strong) NSString *domainName;
@property (nonatomic, strong) NSString *domainType;
@property (nonatomic, strong) NSString *fechaFin;
@property (nonatomic, strong) NSString *fechaIni;
@property (nonatomic, strong) NSString *vigente;
@property (nonatomic, assign) NSInteger idCtrlDomain;
@property (nonatomic, assign) NSInteger idDomain;
@property (nonatomic, strong) NSString *statusDominio;
@property (nonatomic, assign) NSInteger statusVisible;

@end
