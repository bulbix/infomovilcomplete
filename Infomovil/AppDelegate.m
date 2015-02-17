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
    
    [Appboy startWithApiKey:@"773948d3-24b7-422e-8a53-f3b1be2834d0"
              inApplication:application
          withLaunchOptions:launchOptions];
    //[RageIAPHelper sharedInstance];
#if !TARGET_IPHONE_SIMULATOR
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
#endif
	
	
	[GPPSignIn sharedInstance].clientID = kClientId;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    InicioViewController *inicioController = [[InicioViewController alloc] initWithNibName:@"InicioViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:inicioController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    self.ultimoView = Nil;
	
	
	//AppsFlyer
	[AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"5KoF92vzAFbhSj9PRduNCn";
	[AppsFlyerTracker sharedTracker].appleAppID = @"898313250";
    
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
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
 
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
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
    
    [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#ifdef _DEBUG
    NSString *strError = [NSString stringWithFormat:@"Error: %@",error];

    NSLog(@"%@",strError);
#endif
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	return [GPPURLHandler handleURL:url
				  sourceApplication:sourceApplication
						 annotation:annotation];
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[Appboy sharedInstance] registerApplication:application
                    didReceiveRemoteNotification:userInfo];
}
- (void)fbDidlogout {
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
}

@end
