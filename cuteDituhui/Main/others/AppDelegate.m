//
//  AppDelegate.m
  
//
//  Created by lucifer on 16/7/21.
 
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "CDLoginRegistVc.h"
#import <Bugly/Bugly.h>
#import "UMCheckUpdate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>
@interface AppDelegate ()<UIAlertViewDelegate,JPUSHRegisterDelegate>

@end
#define kStoreAppId     @"1159608993"  //
@implementation AppDelegate

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
	NSDictionary * userInfo = notification.request.content.userInfo;
	if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		[JPUSHService handleRemoteNotification:userInfo];
	}
	completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  // Required
	NSDictionary * userInfo = response.notification.request.content.userInfo;
	if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		[JPUSHService handleRemoteNotification:userInfo];
	}
	completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	[JPUSHService handleRemoteNotification:userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[JPUSHService handleRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarStyle = UIStatusBarStyleLightContent;
    application.statusBarHidden = NO;

    _mapManager = [[BMKMapManager alloc]init];

    BOOL ret = [_mapManager start:@"1Zus7lRML7GaH7GuC9GuHPhVyOeIVL6E"  generalDelegate:nil];
    if (!ret) {
        CDLog(@"manager start failed!");
    }

	//友盟

	 [[UMSocialManager defaultManager] openLog:YES];
	[[UMSocialManager defaultManager] setUmSocialAppkey:@"5832924ac62dca22a1000cce"];

	[[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx4691ff6f0e86c3e8" appSecret:@"4c7d3149699719e1e7072da0acd5f22b" redirectURL:@"http://mobile.umeng.com/social"];


	[[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105835206"  appSecret:@"7AEkiJMz5pNiWrGI" redirectURL:@"http://mobile.umeng.com/social"];

	


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
       CDAcount *account = [CDAcount accountFromSandbox];
    
    CDLog(@"%@",account);
    if(account == nil){

        CDLoginRegistVc *loginVC = [[UIStoryboard storyboardWithName:@"CDLoginRegistVC" bundle:nil]instantiateInitialViewController];
        
        navigationController =[[CDNav alloc]initWithRootViewController:loginVC];
        
    }else{

        RootViewController *homeVC = [[UIStoryboard storyboardWithName:@"RootViewController" bundle:nil] instantiateInitialViewController];
        
        navigationController =[[CDNav alloc]initWithRootViewController:homeVC];
        
    }
    
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];

    

    [self checkAppUpdate];
    
    
    [Bugly startWithAppId:@"900056020"];



 JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
	entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

			// NSSet<UNNotificationCategory *> *categories for iOS10 or later
			// NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
	}
	[JPUSHService registerForRemoteNotificationConfig:entity delegate:self];


	[JPUSHService setupWithOption:launchOptions appKey:@"8cf79741f26ef613463fc111"
						  channel:@"App Store"
				 apsForProduction:true
			advertisingIdentifier:nil];


	if (account) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[JPUSHService setTags:nil alias:[NSString stringWithFormat:@"user_opera%@",account.user_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
				CDLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
			}];
		});
	}


	[JPUSHService setBadge:0];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    return YES;
}



-(void)checkAppUpdate
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kStoreAppId]];
    NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSRange substr = [file rangeOfString:@"\"version\":\""];
    NSRange range1 = NSMakeRange(substr.location+substr.length,10);
    NSRange substr2 =[file rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:range1];
    NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
    NSString *newVersion =[file substringWithRange:range2];
    
    
    if ([newVersion  compare:nowVersion] == NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
        [alert show];
    }
    
   
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        
        NSString *str =[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/tu-hui-qi-ye-ban-hu-lian-wang/id%@?mt=8", kStoreAppId];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
