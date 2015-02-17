//
//  AppDelegate.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//
#import <StoreKit/StoreKit.h>

#define kSessionTime 18

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) DatosUsuario *datosUsuario;

@property (nonatomic) BOOL existeSesion;
@property (nonatomic) DomainType tipoDominio;
@property (nonatomic,strong) NSString * statusDominio;
@property (nonatomic) BOOL logueado;

@property (nonatomic, strong) UIViewController *ultimoView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSDate *fechaLogin;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL) itIsInTime;
- (void) restartDate;
- (void)fbDidlogout;
@end
