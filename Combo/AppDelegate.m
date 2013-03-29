//
//  AppDelegate.m
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate
@synthesize partyViewController;
@synthesize messageViewController;
@synthesize settingViewController;
@synthesize activeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    //或者UIStatusBarStyleDefault
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReach startNotifier];
    
    NSMutableArray *controllers=[NSMutableArray array];
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //messageViewController
    messageViewController=[[MessageViewController alloc]initWithNibName:nil bundle:nil];
    
    UINavigationController *navMessage=[[UINavigationController alloc]initWithRootViewController:self.messageViewController];
    [navMessage.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:navMessage];
    
    
    //partyViewController
    partyViewController=[[PartyViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navParty=[[UINavigationController alloc]initWithRootViewController:self.partyViewController];
    [navParty.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:navParty];
    
    
    //activeViewController
    activeViewController = [[ActiveViewController alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController *navActive=[[UINavigationController alloc]initWithRootViewController:self.activeViewController];
    [navActive.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:navActive];
    
    
    //forthController
    settingViewController=[[SettingViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *navSetting=[[UINavigationController alloc]initWithRootViewController:self.settingViewController];
    [navSetting.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    
    
    [controllers addObject:navSetting];
    
    
    tbarController=[[UITabBarController alloc]init];
    tbarController.delegate=self;
    tbarController.viewControllers=controllers;
    tbarController.customizableViewControllers=controllers;
    [[tbarController tabBar] setSelectedImageTintColor:[UIColor whiteColor]];
    [[tbarController tabBar] setBackgroundColor:[UIColor whiteColor]];
    [[tbarController tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbarbackimage.png"]];
    [[tbarController tabBar] selectionIndicatorImage];
    [self.window addSubview:tbarController.view];
    [[tbarController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"zhezao"]];
    [tbarController setSelectedIndex:1];
    //=============设置照片=================
    UIImage *selectedImage0 = [UIImage imageNamed:@"messagebalck.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"messagee.png"];
    
    UITabBar *tabBar0 = tbarController.tabBar;
    UITabBarItem *item0 = [tabBar0.items objectAtIndex:0];
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    //=============设置照片=================
    UIImage *selectedImage1 = [UIImage imageNamed:@"partyimage.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"partyun.png"];
    UITabBar *tabBar1 = tbarController.tabBar;
    UITabBarItem *item1 = [tabBar1.items objectAtIndex:1];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    //=============设置照片=================
    UIImage *selectedImage2 = [UIImage imageNamed:@"activeimage.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"activeimageun.png"];
    UITabBar *tabBar2 = tbarController.tabBar;
    UITabBarItem *item2 = [tabBar2.items objectAtIndex:2];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    //
    //=============设置照片=================
    UIImage *selectedImage3 = [UIImage imageNamed:@"settingsblack.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"settingun.png"];
    [settingViewController.tabBarItem setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    UITabBar *tabBar3 = tbarController.tabBar;
    UITabBarItem *item3 = [tabBar3.items objectAtIndex:3];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"Guo.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSLog(@"ffffffffffffffffffffff%@",stringmutable);
    if (stringmutable==nil)
    {
        LogInViewController *login=[[LogInViewController alloc]init];
        [self.window addSubview:login.view];
    }
    [self.window makeKeyAndVisible];
    
    //    /** 注册推送通知功能, */
    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    //
    //    //判断程序是不是由推送服务完成的
    //    if (launchOptions) {
    //        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //        if (pushNotificationKey) {
    //            [self alertNotice:@"" withMSG:@"这是通过推送窗口启动的程序，你可以在这里处理推送内容" cancleButtonTitle:@"知道了" otherButtonTitle:nil];
    //        }
    //    }
    
    return YES;
}
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
    }
}
#pragma mark - 实现远程推送需要实现的监听接口
/** 接收从苹果服务器返回的唯一的设备token，该token需要发送回推送服务器*/
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
	NSLog(@"apns -> 生成的devToken:%@", token);
    //    [self alertNotice:@"" withMSG:[NSString stringWithFormat:@"从苹果推送服务器返回的设备标识:%@",deviceToken] cancleButtonTitle:@"Ok" otherButtonTitle:@""];
    DeviceSender* sender = [[DeviceSender alloc]initWithDelegate:self ];
    [sender sendDeviceToPushServer:token ];
}


/** 接收注册推送通知功能时出现的错误，并做相关处理*/
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"apns -> 注册推送功能时发生错误， 错误信息:\n %@", err);
    //    [self alertNotice:@"注册推送功能时发生错误" withMSG:[err localizedDescription] cancleButtonTitle:@"Ok" otherButtonTitle:@""];
}

//程序处于启动状态，或者在后台运行时，会接收到推送消息，解析处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    //把icon上的标记数字设置为0,
    application.applicationIconBadgeNumber = 0;
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"**推送消息**"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"处理推送内容",nil];
        alert.tag = alert_tag_push;
        [alert show];
     
    }
}

#pragma mark - 处理推送服务器push过来的数据
-(void) pushAlertButtonClicked:(NSInteger)buttonIndex
{
    NSLog(@"响应推送对话框");
    if (buttonIndex == 0) {
        NSLog(@"--->点了第一个按钮");
    } else {
        NSLog(@"--->点了第二个按钮");
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case alert_tag_push:
        {
            [self pushAlertButtonClicked:buttonIndex];
        }
            break;
        default:
            break;
    }
}

-(void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle
{
    UIAlertView *alert;
    if(!otherTitle || [otherTitle isEqualToString:@""])
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
    [alert show];
}

#pragma mark - 实现代理接口：DeviceSenderDelegate
- (void)didSendDeviceFailed:(DeviceSender *)sender withError:(NSError *)error
{
    NSLog(@"apns -> 发送设备标识到服务器失败:%@", error);
    //    [self alertNotice:@"错误" withMSG:@"发送设备标识到服务器失败" cancleButtonTitle:@"确定" otherButtonTitle:nil ];
    
}

- (void)didSendDeviceSuccess:(DeviceSender *)sender
{
    NSLog(@"apns -> 设备标识已发送到服务器");
    //    [self alertNotice:@"" withMSG:@"设备标识已发送到服务器" cancleButtonTitle:@"确定" otherButtonTitle:nil ];
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //进入后台时要进行的处理
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //进入前台时要进行的处理
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
