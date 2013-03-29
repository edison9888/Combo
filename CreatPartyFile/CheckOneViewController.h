//
//  CheckOneViewController.h
//  NavaddTab
//
//  Created by ldci 尹 on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;
@class CreatPartyViewController;

@protocol ContactCtrlDelegate

//回调关闭窗口
- (void)CallBack:(NSMutableArray *)muArr; //回调传值

@end
//#import "SecondLevelViewController.h"
@interface CheckOneViewController : UITableViewController
{
    NSMutableArray* list;//好友列表
    NSMutableArray* playList;//玩伴列表
    NSMutableArray* sinaList;//新浪好友列表
    
    NSIndexPath* lastIndexPath;
    NSMutableArray *choiceFriends;
    NSMutableArray *sinaFriends;
    
    
    int temp;//记人数
    id <ContactCtrlDelegate>delegateFriend;
    int spot;//识别从哪个界面传入
    
    NSString *from_p_id;
    
    NSString *from_c_id;
    
    NSString *userUUid;
    
    int dataFlag;//标识获取提取接口
    
    CreatPartyViewController *party;
    
    NSString *check_name;
    NSString *check_time;
    NSString *check_city;
    NSString *check_local;
    
    NSString *type;
    float lat;
    float lng;
    
    NSDate *time;
    
    NSMutableDictionary *stateDictionary;
}

@property (nonatomic,retain) NSDate *time;
@property  float lat;
@property  float lng;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *check_name;
@property (nonatomic,retain) NSString *check_time;
@property (nonatomic,retain) NSString *check_city;
@property (nonatomic,retain) NSString *check_local;


@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) NSString *from_c_id;
@property (nonatomic,retain) NSString *from_p_id;
@property int spot;
@property (strong,nonatomic) NSMutableArray* list;
@property (strong,nonatomic) NSMutableArray* playList;

@property (strong,nonatomic) NSIndexPath* lastIndexPath;
@property(nonatomic,retain)id <ContactCtrlDelegate>delegateFriend;

@end
