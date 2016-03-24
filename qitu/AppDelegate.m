//
//  AppDelegate.m
//  qitu
//
//  Created by 上海企图 on 16/3/15.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import "HomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    HomeViewController *mainView = [[HomeViewController alloc] init];
    self.window.rootViewController = mainView;
    [self changeNavigationBarStyle];
    
    [self.window makeKeyAndVisible];
    return YES;
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

#pragma mark - 配置UI
- (void)changeNavigationBarStyle
{
    //设置导航栏背景色
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:GLOBAL_NAVIGATIONBAR_BG_COLOR];  //设置导航栏背景色
    [[UINavigationBar appearance] setTintColor:GLOBAL_NAVIGATIONBAR_TITLE_TEXT_COLOR];  //设置标题文本颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: GLOBAL_NAVIGATIONBAR_TITLE_FONT, NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    UIImage *image = [UIImage imageNamed:@"maka_navbar_return"];
//    [UINavigationBar appearance].backIndicatorImage = image;
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 私有方法
#pragma mark 网络状态变化提示
-(void)alert:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"System Info" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark 网络状态监测
-(void)checkNetworkStatus{
    //创建一个用于测试的url
    NSURL *url=[NSURL URLWithString:@"http://www.apple.com"];
    AFHTTPSessionManager *operationManager = [[AFHTTPSessionManager alloc]initWithBaseURL:url];
    
    //根据不同的网络状态改变去做相应处理
    [operationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self alert:@"2G/3G/4G Connection."];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //[self alert:@"WiFi Connection."];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self alert:@"Network not found."];
                break;
                
            default:
                [self alert:@"Unknown."];
                break;
        }
    }];
    
    //开始监控
    [operationManager.reachabilityManager startMonitoring];
}


@end
