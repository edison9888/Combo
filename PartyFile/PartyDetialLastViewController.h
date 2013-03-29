//
//  PartyDetialLastViewController.h
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MyMapViewController.h"
#import "friendinfoViewController.h"
#import "CheckOneViewController.h"
#import "InvitViewController.h"
#import "SDImageView+SDWebCache.h"
@interface PartyDetialLastViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,PagedFlowViewDataSource,PagedFlowViewDelegate>
{
    MyMapViewController *mapViewController;
    friendinfoViewController *friendsViewController;
    CheckOneViewController *friend;
    UITableView* tableview;
    
    //==============
    CGPoint oldPoint;
    BOOL leftOrRight;
    int OldPage;
    UILabel * label;
    
    NSDictionary *party;//单个派对
    int mark;
    UIImage *imagePIC;
    NSString *p_id;
    NSMutableArray *creId;
    NSMutableArray *jioId;
    NSString *userUUid;
    NSMutableArray *creatUser;//创建者信息
    NSMutableArray *joinUser;//参与者信息
    UIButton *back;
    UIButton *join;
    NSNumber *numberUUID;
    int numFlogLogout;//退出派对的标志
    int numFlogJoin;//申请加入标志位
    int partyTemp;//从创建派对进入
}
@property int partyTemp;
@property(nonatomic,strong)PagedFlowView * FlowView;//滑动效果
@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) NSString *p_id;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, retain) NSMutableArray *items;
@property(strong,nonatomic) UITableView* tableview;
@property (nonatomic,retain) NSDictionary *party;
@property (nonatomic,retain) NSString *partyStr;
@property (nonatomic,retain) NSMutableArray *joinUser,*creatUser;
@property (nonatomic,retain) NSNumber *numberUUID;

@end
