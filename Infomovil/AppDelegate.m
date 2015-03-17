//
//  AppDelegate.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "AppDelegate.h"
#import "InicioViewController.h"
#import "WS_ItemsDominio.h"

#import <GooglePlus/GooglePlus.h>
#import "GTLPlusConstants.h"
#import "AppsFlyerTracker.h"
#import "GAI.h"
#import "iVersion/iVersion.h"
#import "AppboyKit.h"
#import "RageIAPHelper.h"
#import <FacebookSDK/FacebookSDK.h>
#import "iVersion.h"
#import <HockeySDK/HockeySDK.h>


@implementation AppDelegate

@synthesize datosUsuario;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static NSString * const kClientId = @"585514192998.apps.googleusercontent.com";

+ (void)initialize {
    [iVersion sharedInstance].appStoreID = 898313250;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // APPBOY // IRC //
    // PREPRODUCCION
    // ce1afa14-800b-4b45-8e8b-3a7696c3ef26
    // PRODUCCION
    // 773948d3-24b7-422e-8a53-f3b1be2834d0
    // ios_app_qa
    // 418813e5-5c95-4710-8ce1-d23d55fb4d5d
  
 /*
    [Appboy startWithApiKey:@"418813e5-5c95-4710-8ce1-d23d55fb4d5d"
              inApplication:application
          withLaunchOptions:launchOptions];
   */
    
    //save
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:launchOptions forKey:@"launchingWithOptions"];
    [defaults synchronize];
   
    
    
    //AppsFlyer
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"5KoF92vzAFbhSj9PRduNCn";
    [AppsFlyerTracker sharedTracker].appleAppID = @"898313250";
    
    
    
    
    //HOCKEYAPP  //
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"6d7f6a5334d44a52f5fb2761f6666f31"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];
    
   
    
    //-- Set Notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) {
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
	
	
	[GPPSignIn sharedInstance].clientID = kClientId;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    InicioViewController *inicioController = [[InicioViewController alloc] initWithNibName:@"InicioViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:inicioController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    self.ultimoView = Nil;
	
	
	
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-53077061-2"];
	
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          
                                          NSLog(@"Entrando a sesion activa");
                                      }];
    }
	
    // For save an Login (User y password) //
    NSUserDefaults *prefsLogin = [NSUserDefaults standardUserDefaults];
    if(![prefsLogin integerForKey:@"intRecordar"] || [prefsLogin integerForKey:@"intRecordar"] == 0){
        [prefsLogin setObject:@"" forKey:@"strRecordarUser"];
        [prefsLogin setObject:@"" forKey:@"strRecordarPass"];
        [prefsLogin setInteger:0 forKey:@"intRecordar"];
        [prefsLogin synchronize];
    }
    
    //[self fbDidlogout];
   // Se limpian los datos al entrar a la aplicación //
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.datosUsuario eliminarDatos];
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   
}
/*  // NO UTILIZARLOS PORQUE SE EJECUTA EL APPBOY //
- (void)applicationDidEnterBackground:(UIApplication *)application
{
 
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
 
}
*/
- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];

    [self fbDidlogout];
    
    // Se limpian los datos al salir de la aplicación //
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.datosUsuario eliminarDatos];
}

-(void) realizaConsultaItems {
    WS_ItemsDominio *itemsDominio = [[WS_ItemsDominio alloc] init];
    [itemsDominio actualizarItemsDominio];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
           
#ifdef _DEBUG
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Infomovil" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Infomovil.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
       
#ifdef _DEBUG
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#ifdef _DEBUG
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"content---%@ **************************************************************", token);
#endif
    
    //[[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#ifdef _DEBUG
    NSString *strError = [NSString stringWithFormat:@"Error: %@",error];

    NSLog(@"%@",strError);
#endif
}

- (BOOL) itIsInTime {
    BOOL enTiempo = YES;
#ifdef _CON_SESION
    NSDate *newDate = [NSDate date];
    int duracion = kSessionTime * 60;
    NSDate *fechaLoginPlus = [self.fechaLogin dateByAddingTimeInterval:duracion];
    
    if ([fechaLoginPlus compare:newDate] == NSOrderedAscending) {
        enTiempo = NO;
    }
#endif
    return enTiempo;
}

- (void) restartDate {
    self.fechaLogin = [NSDate date];
}
/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[Appboy sharedInstance] registerApplication:application
                    didReceiveRemoteNotification:userInfo];
}
 */
- (void)fbDidlogout {
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url
                             sourceApplication:sourceApplication];
    
    // add app-specific handling code here
    return wasHandled;
}

@end
