//
//  AppDelegate.m
//  NewsFourApp
//
//  Created by chen on 14/8/8.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "SDWebImageManager.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <Parse/Parse.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <SMS_SDK/SMS_SDK.h>
#import "XXYNavigationController.h"
#import "WBNavigationController.h"
#import "MyPublishRequireController.h"
#import "MLNavigationController.h"
#import "MainViewController.h"

#import "BPush.h"
#import "XGPush.h"
#import "XGSetting.h"

#import "PlistDB.h"
#define _IPHONE80_ 80000

@interface AppDelegate ()<UIAlertViewDelegate>

@property(nonatomic,copy)NSString *pushKey;
@end


@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;



- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    [SMS_SDK registerApp:@"5494418e9c50" withSecret:@"946e19132b5e39c7661c17e1ee17f4e9"];
    
    [ShareSDK registerApp:@"4f67beb7760c"];
    
    
    [ShareSDK connectWeChatWithAppId:@"wxdf195844e1c87953"   //微信APPID
                           appSecret:@"8cbb5b8f6f0878ef2a4bed8a1a7fe5b2"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"541149561"
                               appSecret:@"ac1a355a7e28f80c5235d3212ba2d781"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    
    
    //QQ
    [ShareSDK connectQZoneWithAppKey:@"1103549999"
                           appSecret:@"o4LB4iqW3LlVmepR"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    [Parse setApplicationId:@"vnm0muL0lWG63jMVZD7UMKZ6bCFrdZdwgMRryFv7"
                  clientKey:@"OBSHxOhmgQ9IwJcq6NDT68CZ6goFPMArKkwzAMS9"];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
  
    
    MainViewController *main = [[MainViewController alloc] init];
    self.window.rootViewController = main;
    
    
    [self.window makeKeyAndVisible];
    
    //设置帐号（别名）
    [XGPush setAccount:@"123456"];
    
    [XGPush startApp:2200112061 appKey:@"ITG1N3I615JN"];
    //[XGPush startApp:2290000353 appKey:@"key1"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    //本地推送示例
    /*
     NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
     
     NSMutableDictionary *dicUserInfo = [[NSMutableDictionary alloc] init];
     [dicUserInfo setValue:@"myid" forKey:@"clockID"];
     NSDictionary *userInfo = dicUserInfo;
     
     [XGPush localNotification:fireDate alertBody:@"测试本地推送" badge:2 alertAction:@"确定" userInfo:userInfo];
     */
    
    // Override point for customization after application launch.
    return YES;

}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock");
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:deviceTokenStr];
    [plist setDataFilePathXgTokenPlist:array];
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    
    
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    NSLog(@"%@",userInfo);
    

    
    //回调版本示例
     void (^successBlock)(void) = ^(void){
     //成功之后的处理
     NSLog(@"[XGPush]handleReceiveNotification successBlock");
         NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
         NSString *key1 = [userInfo objectForKey:@"key1"];
         self.pushKey = key1;
         if (application.applicationState == UIApplicationStateActive) {
             // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收到一条推送"
                                                                 message:[NSString stringWithFormat:@"推送的内容:\n%@", alert]
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                       otherButtonTitles:@"查看",nil];
             [alertView show];
         }
         else if (application.applicationState == UIApplicationStateInactive)
         {
             NSLog(@"________inactive__________");
             UIViewController *controller = self.window.rootViewController.childViewControllers[0];
             UIViewController *controller1 = controller.childViewControllers[0];
             if ([@"1"isEqualToString:key1]) {
                 MyPublishRequireController *publishReuqire=[[MyPublishRequireController alloc] init];
                 
                 [controller1.navigationController pushViewController:publishReuqire animated:YES];
             }
             else
             {
                 NSLog(@"我收到的需求列表");
             }
         }
         else if (application.applicationState == UIApplicationStateBackground)
         {
             NSLog(@"________background__________");
             UIViewController *controller = self.window.rootViewController.childViewControllers[0];
             UIViewController *controller1 = controller.childViewControllers[0];
             if ([@"1"isEqualToString:key1]) {
                     MyPublishRequireController *publishReuqire=[[MyPublishRequireController alloc] init];
                     
                     [controller1.navigationController pushViewController:publishReuqire animated:YES];
             }
             else
             {
                 NSLog(@"我收到的需求列表");
             }
         }
         
         
         
         [application setApplicationIconBadgeNumber:0];

         
     };
     
     void (^errorBlock)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[XGPush]handleReceiveNotification errorBlock");
     };
     
     void (^completion)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[xg push completion]userInfo is %@",userInfo);
     };
     
     [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
//        NSMutableArray *arr =[NSMutableArray array];
//        for (UIViewController *controller in self.window.rootViewController.childViewControllers) {
//            [arr addObject:controller.childViewControllers[0]];
//        }
//        NSLog(@"%@",arr);
//        
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushInfoNotification" object:self userInfo:@{@"key1":@"1"}];
        
        
        UIViewController *controller = self.window.rootViewController.childViewControllers[0];
        UIViewController *controller1 = controller.childViewControllers[0];
        
        if ([self.pushKey isEqualToString:@"1"]) {
            
            MyPublishRequireController *publishReuqire=[[MyPublishRequireController alloc] init];
            
            [controller1.navigationController pushViewController:publishReuqire animated:YES];
        }
        else
        {
            NSLog(@"我收到的需求列表");
        }
        
       

    }
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





#pragma mark 检测第三方应用程序是否安装
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];

}






- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                            wxDelegate:self];


}


@end
