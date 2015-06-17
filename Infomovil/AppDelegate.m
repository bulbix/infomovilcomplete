//
//  AppDelegate.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "AppDelegate.h"

#import "WS_ItemsDominio.h"

#import <GooglePlus/GooglePlus.h>
//#import "GTLPlusConstants.h"
#import "AppsFlyerTracker.h"
#import "GAI.h"
#import "iVersion/iVersion.h"
#import "AppboyKit.h"
#import "RageIAPHelper.h"
#import <FacebookSDK/FacebookSDK.h>
#import "iVersion.h"
#import "SesionActivaViewController.h"
#import <HockeySDK/HockeySDK.h>
#import "MainViewController.h"
#import "ElegirPlantillaViewController.h"


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
    
    // Se limpian los datos al entrar a la aplicación //
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.datosUsuario eliminarDatos];
   
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        [self application:application didReceiveRemoteNotification:(NSDictionary*)notification];
    }else{
        NSLog(@"IRC app did not recieve notification");
    }
 
 /*
    //AppsFlyer
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"5KoF92vzAFbhSj9PRduNCn";
    [AppsFlyerTracker sharedTracker].appleAppID = @"898313250";
  
    //HOCKEYAPP  //
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"6d7f6a5334d44a52f5fb2761f6666f31"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
  */

    //-- Set Notification
    [Appboy startWithApiKey:llaveAppboy
              inApplication:[UIApplication sharedApplication]
          withLaunchOptions:launchOptions];
  
    
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
    
    NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
    if([prefSesion integerForKey:@"intSesionActiva"] == 1 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        SesionActivaViewController *inicioController = [[SesionActivaViewController alloc] initWithNibName:@"SesionActiva" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:inicioController];
    }else{
        MainViewController *inicioController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:inicioController];
       
    }
     self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    self.ultimoView = Nil;
	
	
	
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-53077061-2"];
	
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      }];
    }

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
#if DEBUG
    NSLog(@"LA APP ESTA EN applicationWillResignActive"); // cuand se va a back
#endif
}


/*  // NO UTILIZARLOS PORQUE SE EJECUTA EL APPBOY //
- (void)applicationDidEnterBackground:(UIApplication *)application
{
 
}
*/
- (void)applicationWillEnterForeground:(UIApplication *)application
{  NSLog(@"LA APP ESTA EN applicationWillEnterForeground"); // cuando regresa del back
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

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
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
           
#if DEBUG
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
       
#if DEBUG
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
#if DEBUG
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"content---%@ **************************************************************", token);
#endif

    [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if DEBUG
    NSString *strError = [NSString stringWithFormat:@"Error: %@",error];
    NSLog(@"EL ERROR DEL REGISTRO DE LA NOTIFICACION%@",strError);
#endif
}



- (void) restartDate {
    self.fechaLogin = [NSDate date];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    [[Appboy sharedInstance] registerApplication:application
                    didReceiveRemoteNotification:userInfo];
#if DEBUG
    NSLog(@"La aplicación se encuentra en : %ld",(long)application.applicationState);
#endif
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        
        NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
        if([prefSesion integerForKey:@"intSesionActiva"] == 1 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        
        if([[userInfo objectForKey:@"ab_uri"] isEqualToString:@"infomovil://Nombrar_Sitio"]){
            SesionActivaViewController *sesionActiva = [[SesionActivaViewController alloc] initWithNibName:@"SesionActiva" bundle:Nil];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:1 forKey:@"SELECCIONDEEPLINK"];
            [defaults synchronize];
            [self.navigationController pushViewController:sesionActiva animated:YES];
        
        }else if([[userInfo objectForKey:@"ab_uri"] isEqualToString:@"infomovil://CrearEditar"]){
            SesionActivaViewController *sesionActiva = [[SesionActivaViewController alloc] initWithNibName:@"SesionActiva" bundle:Nil];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:2 forKey:@"SELECCIONDEEPLINK"];
            [defaults synchronize];
            [self.navigationController pushViewController:sesionActiva animated:YES];
        
        }else if([[userInfo objectForKey:@"ab_uri"] isEqualToString:@"infomovil://Compartir"]){
            SesionActivaViewController *sesionActiva = [[SesionActivaViewController alloc] initWithNibName:@"SesionActiva" bundle:Nil];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:3 forKey:@"SELECCIONDEEPLINK"];
            [defaults synchronize];
            [self.navigationController pushViewController:sesionActiva animated:YES];
    
        }else if([[userInfo objectForKey:@"ab_uri"] isEqualToString:@"infomovil://Reportes"]){
            SesionActivaViewController *sesionActiva = [[SesionActivaViewController alloc] initWithNibName:@"SesionActiva" bundle:Nil];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:4 forKey:@"SELECCIONDEEPLINK"];
            [defaults synchronize];
            [self.navigationController pushViewController:sesionActiva animated:YES];
            
        }
            
    }
        
}
    
    
   
}
 
- (void)fbDidlogout {
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
        [StringUtils deleteFile];
        for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
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
