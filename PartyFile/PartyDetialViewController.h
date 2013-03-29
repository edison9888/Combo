//
//  PartyDetialViewController.h
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"
#import "MyMapViewController.h"
#import "friendinfoViewController.h"
#import "DetailViewController.h"
#import "AddrDetailViewController.h"
#import "CheckOneViewController.h"
#import "InvitViewController.h"
#import "ASIHTTPRequest.h"

#import "ASIFormDataRequest.h"
#import "SDImageView+SDWebCache.h"
@interface PartyDetialViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,PagedFlowViewDataSource,PagedFlowViewDelegate,UIApplicationDelegate>
{
    MyMapViewController *mapViewController;
    friendinfoViewController *friendsViewController;
    DetailViewController* acdetail;
    AddrDetailViewController* addrdetail;
    CheckOneViewController *friend;
    InvitViewController *invit;
    UITableView* tableview;
    //==============
    CGPoint oldPoint;
    BOOL leftOrRight;
    int OldPage;
    UILabel * label;
    
    UIButton *back;
    UIButton *join;
    NSString *stringB;
    NSMutableString *stringA;
    NSString *p_id;//传值传的是p_id
    NSDictionary *party;//单个派对
    
    NSMutableArray *creatUser;//创建者信息
    NSMutableArray *joinUser;//参与者信息
    
    int mark;
    NSString *userUUid;
    NSNumber *numberUUID;
    int numFlogLogout;//退出派对的标志
    int numFlogJoin;//申请加入标志位
}
@property(nonatomic,strong)PagedFlowView * FlowView;//滑动效果

@property (nonatomic,retain) NSNumber *numberUUID;
@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic, retain) NSMutableArray *items;
@property(strong,nonatomic) UITableView* tableview;
@property (nonatomic,retain) NSString *p_id;
@property (nonatomic,retain) NSDictionary *party;
@property (nonatomic,retain) NSMutableArray* creatUser,*joinUser;

@end
