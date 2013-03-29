//
//  PartyViewController.h
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//4641541

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
@class ASIHTTPRequest;
#import "SRRefreshView.h"
#import "ASIFormDataRequest.h"
#import "CreatPartyViewController.h"
#import "PartyDetialViewController.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
#import "SimpleSwitch.h"

@interface PartyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,CLLocationManagerDelegate>
{
    
    float PreY;
    BOOL isLoading;
    UIButton* Allparty;
    UIButton* ReliableParty;
    UIButton* MyParty;
    int ChoseNum;
    UIBarButtonItem *segmentBar;
    UITableView *tableViewParty;
    NSMutableArray* sumArray;
    SRRefreshView *_slimeView;//下拉刷新
    NSString *userUUid;
    int flag;
    CLLocationManager *locationMamager;
    CGFloat lat;//纬度
    CGFloat lng;//经度
    int segmentNum;//标志位，表示当前选择的按钮是附近还是所有，附近=0
    int total;//本次接口返回的数量
    PartyDetialViewController *partyDetialViewController;
    CreatPartyViewController *creatPartyViewController;
    MapViewController *mapControl;
    UIButton *buttonNew;
    UIButton *buttonNear;
    
    UIImageView *logoimage;
    
}
@property float lat,lng;
@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) UITableView *tableViewParty;
@property (nonatomic,retain) NSMutableArray *sumArray;
@property (nonatomic) int count;
@end
