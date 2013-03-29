//
//  SettingViewController.h
//  Combo1111122
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "CheckOneViewController.h"
#import "MyDetailViewController.h"
#import "IDViewController.h"
#import "AboutViewController.h"
#import "WeiboAccounts.h"
#import "WeiboSignIn.h"
#import "UserQuery.h"
#import "RESwitch.h"
@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,WeiboSignInDelegate>{
    CheckOneViewController *friend;
    MyDetailViewController *person;
    IDViewController *idViewController;
    AboutViewController *aboutVC;
    UITableView *tableV;
    NSDictionary *words;
    NSArray *keys;
    UIButton *button;
    
    NSString *name;//获取用户名
    BOOL Sina;//新浪绑定
    BOOL renren;//人人绑定
    BOOL bean;//豆瓣绑定
    WeiboSignIn *_weiboSignIn;
    
    NSString *userUUid;
    
    NSDictionary *dictory;
    int sinaFlag;
    int temp;
    RESwitch *switchView;
}

@property (nonatomic,retain) NSDictionary *dictory;
@property (nonatomic,retain) NSString *userUUid;
@property(nonatomic,retain)UITableView *tableV;
@property(nonatomic,retain)NSDictionary *words;
@property(nonatomic,retain)NSArray *keys;


@end
