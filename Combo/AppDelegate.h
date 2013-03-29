//
//  AppDelegate.h
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewController.h"
#import "PartyViewController.h"
#import "ActiveViewController.h"
#import "SettingViewController.h"
#import "DeviceSender.h"
#import "Reachability.h"
#import "LogInViewController.h"
@class ViewController;
#define alert_tag_push 10

@interface AppDelegate : UIResponder <UIApplicationDelegate,DeviceSenderDelegate,UITabBarControllerDelegate>
{
    Reachability  *hostReach;
    UITabBarController *tbarController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MessageViewController *messageViewController;
@property (strong, nonatomic) PartyViewController *partyViewController;
@property (strong, nonatomic) ActiveViewController *activeViewController;
@property (strong, nonatomic) SettingViewController *settingViewController;
@property (strong, nonatomic) ViewController *viewController;

@end
