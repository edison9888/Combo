//
//  MessageViewController.m
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import "MessageViewController.h"
#import "infoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "ASIHTTPRequest.h"
#import "PartyDetialViewController.h"
#import "AddrDetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "MakefriendViewController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
int MessFlag=0;
@interface MessageViewController ()

@end

@implementation MessageViewController
@synthesize creaters;
@synthesize P_time;
@synthesize partyId;
@synthesize uuid;
@synthesize message;

@synthesize senderDic;
@synthesize user;
@synthesize imgView;
@synthesize tbView,dic;
@synthesize systemArray;
@synthesize friendlist;
@synthesize userUUid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title=@"消息";
        choiceNumber=0;
        [self getUUidForthis];
        //************************添加三个button
        friendbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        friendbutton.frame=CGRectMake(0, 0, 107, 32);
        friendbutton.titleLabel.text=@"好友";
        friendbutton.tag=101;
        [friendbutton setSelected:YES];
        [friendbutton setBackgroundImage:[UIImage imageNamed:@"lable3"] forState:UIControlStateNormal];
        [friendbutton setBackgroundImage:[UIImage imageNamed:@"lable33"] forState:UIControlStateSelected];
        [friendbutton addTarget:self action:@selector(mesAction:) forControlEvents:UIControlEventTouchUpInside];
        
        partybutton=[UIButton buttonWithType:UIButtonTypeCustom];
        partybutton.frame=CGRectMake(107, 0, 106, 32);
        partybutton.titleLabel.text=@"派对";
        partybutton.tag=102;
        [partybutton setBackgroundImage:[UIImage imageNamed:@"lable2"] forState:UIControlStateNormal];
        [partybutton setBackgroundImage:[UIImage imageNamed:@"lable22"] forState:UIControlStateSelected];
        [partybutton addTarget:self action:@selector(mesAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        systembutton=[UIButton buttonWithType:UIButtonTypeCustom];
        systembutton.frame=CGRectMake(213, 0, 107, 32);
        systembutton.titleLabel.text=@"系统";
        systembutton.tag=103;
        [systembutton setBackgroundImage:[UIImage imageNamed:@"lable1"] forState:UIControlStateNormal];
        [systembutton setBackgroundImage:[UIImage imageNamed:@"lable11"] forState:UIControlStateSelected];
        [systembutton addTarget:self action:@selector(mesAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:friendbutton];
        [self.view addSubview:partybutton];
        [self.view addSubview:systembutton];
        
        [friendbutton addTarget:self action:@selector(buttonFriend) forControlEvents:UIControlEventTouchDown];
        [partybutton addTarget:self action:@selector(buttonParty) forControlEvents:UIControlEventTouchDown];
        [systembutton addTarget:self action:@selector(buttonSystem) forControlEvents:UIControlEventTouchDown];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

-(void)timerFired
{
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       NSString* str=[NSString stringWithFormat:@"mac/msg/IF00060?uuid=%@",userUUid];
                       NSString *stringUrl=globalURL(str);
                       NSURL* url=[NSURL URLWithString:stringUrl];
                       ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                       request.shouldAttemptPersistentConnection = NO;
                       [request setValidatesSecureCertificate:NO];
                       [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                       [request setDidFailSelector:@selector(requestDidFailed:)];
                       [request startSynchronous];
                       //[friBtn removeFromSuperview];
                       //[sysBtn removeFromSuperview];
                       //[mesBtn removeFromSuperview];
                       
                       
                       
                       //更新界面时用到
                       dispatch_async(dispatch_get_main_queue(), ^{
                           NSData* response=[request responseData];
                           //NSLog(@"%@",response);
                           NSError* error;
                           
                           
                           if (response!=nil) {
                               
                               NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                               //NSLog(@"%@",bizDic);
                              // NSLog(@"wo de nei rong ding shi qi huo de shu ju");
                               friend_count=[[bizDic objectForKey:@"friend_count"]intValue];
                               if(friend_count){
                                   if (friBtn==nil) {
                                       friBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                                       friBtn.frame=CGRectMake(71, 7, 6, 5);
                                       [friBtn setBackgroundImage:[UIImage imageNamed:@"DIAN"] forState:UIControlStateNormal];
                                       [self.view addSubview:friBtn];
                                   }
                                   
                               }
                               party_count=[[bizDic objectForKey:@"party_count"]intValue];
                               if (party_count) {
                                   if (mesBtn==nil) {
                                       mesBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                                       mesBtn.frame=CGRectMake(179, 7, 6, 5);
                                       [mesBtn setBackgroundImage:[UIImage imageNamed:@"DIAN"] forState:UIControlStateNormal];
                                       [self.view addSubview:mesBtn];
                                   }
                                   
                               }
                               system_count=[[bizDic objectForKey:@"system_count"]intValue];
                               if(system_count){
                                   if (sysBtn==nil) {
                                       sysBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                                       sysBtn.frame=CGRectMake(280, 7, 6, 5);
                                       [sysBtn setBackgroundImage:[UIImage imageNamed:@"DIAN"] forState:UIControlStateNormal];
                                       [self.view addSubview:sysBtn];
                                   }
                                   
                               }
                           }
                           
                           UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:0];
                           
                           int badgeValue = friend_count+party_count+system_count;
                           //NSLog(@"新消息的数量:%d",badgeValue);
                           if (badgeValue>0) {
                               tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",badgeValue];
                           }
                           else
                           {
                               tController.tabBarItem.badgeValue=nil;
                           }
                       });
                   });
    
}
#pragma mark-
#pragma mark Table Data Source Methods

-(void)viewWillAppear:(BOOL)animated
{
   
    [self getUUidForthis];
    if (MessFlag==0) {
        //重新加载消息
        NSLog(@"重新加载消息");
        [friendlist removeAllObjects];
        [tbView reloadData];
        [friendbutton setSelected:NO];
        [partybutton setSelected:YES];
        [systembutton setSelected:NO];
        choiceNumber=1;
        total=0;
        flag=0;
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00050?uuid=%@&&m_type=party",userUUid];
        NSString *stringUrl=globalURL(str);
        NSURL* url=[NSURL URLWithString:stringUrl];
        //NSLog(@"派对消息：%@",url);
        //NSLog(@"%@",stringUrl);
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    MessFlag=0;
    
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self getUUidForthis];
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad
{
    self.title=@"消息";
    
    [super viewDidLoad];
    [self getUUidForthis];
    //UITableView
    tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 32, 320, mainscreenhight-44-44-32) style:UITableViewStylePlain];
    self.tbView.dataSource=self;
    self.tbView.delegate=self;
    [self.view addSubview:self.tbView];
    self.tbView.backgroundView=nil;
    self.tbView.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:219.0/255 alpha:1]; [self.tbView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    lableTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    //=============system数据========================================================
    NSMutableArray* party=[[NSMutableArray alloc]init];
    self.message=party;
    NSMutableArray* system=[[NSMutableArray alloc]init];
    self.systemArray=system;

    
    mutablePid  =[[NSMutableArray alloc]init];
    mutableCid  =[[NSMutableArray alloc]init];
    mutableCtype  =[[NSMutableArray alloc]init];
    
    //****************friend的数据
    NSMutableArray* list=[[NSMutableArray alloc]init];
    self.friendlist=list;
    
}

-(void)mesAction:(UIButton *)btn
{
    if (btn.tag == 101)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self.view viewWithTag:102];
        UIButton * otherButton1 = (UIButton *)[self.view viewWithTag:103];
        otherButton.selected = NO;
        otherButton1.selected=NO;
    }
    if (btn.tag == 102)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self.view viewWithTag:101];
        UIButton * otherButton1 = (UIButton *)[self.view viewWithTag:103];
        otherButton.selected = NO;
        otherButton1.selected=NO;
    }
    if (btn.tag == 103)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self.view viewWithTag:101];
        UIButton * otherButton1 = (UIButton *)[self.view viewWithTag:102];
        otherButton.selected = NO;
        otherButton1.selected=NO;
    }
    
}

-(void)getUUidForthis
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"myFile.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *stringUUID=[stringmutable objectAtIndex:0];
    NSLog(@"wwwwwwwwwwwwwwwwwwww%@",stringUUID);
    self.uuid=[NSNumber numberWithInt:[stringUUID intValue]];
    //self.userUUid=@"10001";
    self.userUUid=stringUUID;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    isLoading=NO;
    //尹林林
    if (choiceNumber==0) {
        NSLog(@"接口16:好友消息");
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",bizDic);
        NSArray* messarr=[bizDic objectForKey:@"Messages"];
        total=[messarr count];
        NSLog(@"好友消息当前返回的数量%d",total);
        if (flag==0) {
            [self.friendlist removeAllObjects];
        }
        [self.friendlist addObjectsFromArray:messarr];
    }
    
    //郭江伟
    if (choiceNumber==1) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",bizDic);
        self.dic=bizDic;
        NSLog(@"派对消息。。。。。self.dic===%@",self.dic);
        NSArray* array=[self.dic objectForKey:@"Message"];
        total=array.count;
        if (flag==0) {
            [self.message removeAllObjects];
        }
        [self.message addObjectsFromArray:array];
        
        //[tbView reloadData];
    }
    
    //李萌萌
    if (choiceNumber==2) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"输出字典里面的所有数据%@",bizDic);
        NSArray* array=[bizDic objectForKey:@"Messages"];
        total=array.count;
        if (flag==0) {
            [self.systemArray removeAllObjects];
        }
        [self.systemArray addObjectsFromArray:array];
        NSLog(@"输出数组里面的所有数据%@",mutablePid);
    }
    
    int sum=self.message.count+systemArray.count+self.friendlist.count;
    if (sum) {
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",sum];
    }
    //所有的消息界面更新完之后都需要重新加载
    [tbView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //尹林林
    if (choiceNumber==0) {
        NSDictionary* dict=[self.friendlist objectAtIndex:indexPath.row];
        NSLog(@"%d:%@",indexPath.row, dict);
        NSDictionary* sender=[dict objectForKey:@"sender"];
        NSLog(@"sender:%@",sender);
        NSString* type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"p_id"]];
        NSLog(@"type:%@",type);
        //添加好友的请求，点击进入好友资料
        if ([type isEqualToString:@"0"])
        {
            MakefriendViewController* makefriend=[[MakefriendViewController alloc]init];
            makefriend.user_id=[sender objectForKey:@"SENDER_ID"];
            makefriend.delegate=self;
            makefriend.hidesBottomBarWhenPushed=YES;
            friendselect=[indexPath row];
            NSLog(@"makefriend:user_id::::%@",makefriend.user_id);
            MessFlag=1;
            [self.navigationController pushViewController:makefriend animated:YES];
            
        }
        
        //邀请加入派对，点击进入派对主页
        else
        {
            MessFlag=1;
            PartyDetialViewController* party=[[PartyDetialViewController alloc]init];
            party.title=[dict objectForKey:@"p_title"];
            party.hidesBottomBarWhenPushed=YES;
            NSLog(@"%@",party.title);
            
            party.p_id=[dict objectForKey:@"p_id"];
            [self.navigationController pushViewController:party animated:YES];
            
        }
        
    }
    
    
    //郭江伟
    if (choiceNumber==1) {
        //***********************************比较发送者以及接受者数据**********************************
        self.senderDic=[[self.message objectAtIndex:indexPath.row] objectForKey:@"sender"];
        self.user=[[self.message objectAtIndex:indexPath.row] objectForKey:@"user"];
        self.partyId=[[self.message objectAtIndex:indexPath.row]objectForKey:@"p_id"];
        self.creaters=[[self.message objectAtIndex:indexPath.row] objectForKey:@"creats"];
        
        //***********************************比较发送者以及接受者数据 end**********************************
        
        if([[self.partyId objectForKey:@"P_UUID"] isEqualToNumber:self.uuid]){//如果派对的创建者的id等于uuid
            if([[self.user objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]){//如果信息接收者的id等于uuid 别人申请加入我的派对
                
                infoViewController* makefriend=[[infoViewController alloc]init];
                makefriend.hidesBottomBarWhenPushed=YES;
                makefriend.flag=10;
                makefriend.user_id=[self.senderDic objectForKey:@"SENDER_ID"];
                NSLog(@"makefriend:user_id::::%@",makefriend.user_id);
                
                MessFlag=1;
                [self.navigationController pushViewController:makefriend animated:YES];
                
            }
            else{//我邀请别人联合创建
                PartyDetialViewController *party=[[PartyDetialViewController alloc]init];
                party.hidesBottomBarWhenPushed=YES;
                //[self.navigationController pushViewController:party animated:YES];
                party.p_id=[self.partyId objectForKey:@"P_ID"];
                party.title=[self.partyId objectForKey:@"P_TITLE"];
                MessFlag=1;
                [self.navigationController pushViewController:party animated:YES];
            }
        }
        else if ([[self.senderDic objectForKey:@"SENDER_ID"] isEqualToNumber:self.uuid]){//我申请加入别人的派对
            PartyDetialViewController *party=[[PartyDetialViewController alloc]init];
            //[self.navigationController pushViewController:party animated:YES];
            party.p_id=[self.partyId objectForKey:@"P_ID"];
            party.title=[self.partyId objectForKey:@"P_TITLE"];
            MessFlag=1;
            party.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:party animated:YES];
        }
        else{//如果联合创建人的id等于uuid  别人邀请你联合创建
            BOOL isdone=NO;
            if (self.creaters.count==0) {
                isdone=NO;
            }
            for (int i=0; i<[self.creaters count]; i++) {
                if ([[[self.creaters objectAtIndex:i] objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]) {
                    isdone=YES;
                }
            }
            if(isdone){
                PartyDetialViewController *party=[[PartyDetialViewController alloc]init];
                party.hidesBottomBarWhenPushed=YES;
                //[self.navigationController pushViewController:party animated:YES];
                party.p_id=[self.partyId objectForKey:@"P_ID"];
                party.title=[self.partyId objectForKey:@"P_TITLE"];
                MessFlag=1;
                [self.navigationController pushViewController:party animated:YES];
            }
        }
    }
    
    //李萌萌
    if (choiceNumber==2) {
        NSDictionary *dict =[systemArray objectAtIndex:indexPath.row];
        NSString *stringPid=[dict objectForKey:@"p_id"];
        if ([stringPid intValue]!=0) {
            
            NSLog(@"sssssssssssssssssssssssssssssss%@",stringPid);
            PartyDetialViewController *party=[[PartyDetialViewController alloc]init];
            party.hidesBottomBarWhenPushed=YES;
            //[self.navigationController pushViewController:party animated:YES];
            party.p_id=[dict objectForKey:@"p_id"];
            party.title=[dict objectForKey:@"p_title"];
            MessFlag=1;
            [self.navigationController pushViewController:party animated:YES];
        }
        else
        {
            NSDictionary*dictC=[systemArray objectAtIndex:indexPath.row];
            NSString *stringCtype=[dictC objectForKey:@"c_type"];
            if ([stringCtype intValue]==1) {
                DetailViewController *placeView=[[DetailViewController alloc]init];
                placeView.C_id=[dict objectForKey:@"C_ID"];
                NSLog(@"ssssssssssssssssssssssssssss%@",placeView.C_id);
                MessFlag=1;
                placeView.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:placeView animated:YES];
            }
            else if([stringCtype intValue]==2)
            {
                AddrDetailViewController *addrView=[[AddrDetailViewController alloc]init];
                addrView.hidesBottomBarWhenPushed=YES;
                addrView.C_id=[dict objectForKey:@"C_ID"];
                NSLog(@"ssssssssssssssssssssssssssss%@",addrView.C_id);
                MessFlag=1;
                [self.navigationController pushViewController:addrView animated:YES];
            }
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (choiceNumber==2) {
        return [systemArray count];
    }
    if (choiceNumber==1) {
        return [self.message count];
    }
    if (choiceNumber==0) {
        return self.friendlist.count;
    }
    return 0;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //尹林林
    if (choiceNumber==0) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        NSDictionary* dict=[self.friendlist objectAtIndex:indexPath.row];
        NSLog(@"%d:%@",indexPath.row, dict);
        NSDictionary* sender=[dict objectForKey:@"sender"];
        NSLog(@"sender:%@",sender);
        NSString* type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"p_id"]];
        NSLog(@"type:%@",type);
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MSGFIRkuang"]];
        UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(9, 12, 52, 52)];
        
        imageview.layer.cornerRadius=5;
        imageview.clipsToBounds=YES;
        imageview.layer.masksToBounds=YES;
        [imageview setImageWithURL:[NSURL URLWithString:[sender objectForKey:@"SENDER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [cell.contentView addSubview:imageview];
        UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(87, 16, 11, 13)];
        if ([[[sender objectForKey:@"SENDER_SEX"]substringToIndex:1] isEqualToString:@"M"]) {
            NSLog(@"男");
            seximage.image=[UIImage imageNamed:@"nan"];
        }
        else
        {
            seximage.image=[UIImage imageNamed:@"nv"];
        }
        
        [cell.contentView addSubview:seximage];
        UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(104, 10, 100, 25)];
        namelabel.text=[sender objectForKey:@"SENDER_NICK"];
        namelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
        namelabel.textColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
        namelabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:namelabel];
        UILabel* timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 50, 100, 15)];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        timeLabel.font=[UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:timeLabel];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
        //HH与hh的区别是24小时制和12小时制
        NSInteger time=[[dict objectForKey:@"M_STIME"]integerValue];
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timeLabel.text=confromTimespStr;
        
        
        //申请添加好友的消息
        if ([type isEqualToString:@"0"])
        {
            //NSLog(@"申请添加好友");
            
            
            UILabel* messinfo=[[UILabel alloc]initWithFrame:CGRectMake(100, 27, 170, 25)];
            messinfo.backgroundColor=[UIColor clearColor];
            messinfo.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
            messinfo.text=@"想加你为好友";
            messinfo.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
            [cell.contentView addSubview:messinfo];
            if (![[[sender objectForKey:@"SENDER_STATUS"] substringToIndex:1] isEqualToString:@"Y"]) {
                //对方还不是好友
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(260, 10, 50 , 17)];
                imageview.image=[UIImage imageNamed:@"MSGFIRADD"];
                [cell.contentView addSubview:imageview];
            }
            else
            {
                //已经是好友
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(260, 10, 50 , 17)];
                imageview.image=[UIImage imageNamed:@"MSGFIRADDED"];
                [cell.contentView addSubview:imageview];
                
            }
            
        }
        
        //邀请参加派对的消息
        else
        {
            NSLog(@"邀请加入派对");
            UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 27, 100, 25)];
            wantlabel.text=@"想和你一起去";
            wantlabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
            wantlabel.backgroundColor=[UIColor clearColor];
            wantlabel.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
            [cell.contentView addSubview:wantlabel];
            UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 27, 120, 25)];
            infolabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
            infolabel.backgroundColor=[UIColor clearColor];
            infolabel.textColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
            infolabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"p_title"]];
            
            [cell.contentView addSubview:infolabel];
            
            //已经加入派对
            if ([[[dict objectForKey:@"p_status"]substringToIndex:1]isEqualToString:@"Y"])
            {
                //NSLog(@"已加入派对");
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(260, 10, 50 , 17)];
                imageview.image=[UIImage imageNamed:@"MSGSEEMORE"];
                [cell.contentView addSubview:imageview];
                
            }
            //还没有加入派对
            else
            {
                //还未加入派对
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(260, 10, 50 , 17)];
                imageview.image=[UIImage imageNamed:@"MSGSEEMORE"];
                [cell.contentView addSubview:imageview];
                
            }
            
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
    }

    //郭江伟
    if (choiceNumber==1) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MSSBG"]];
        
        //***************************************显示头像*********************************************
        
        //***********************************比较发送者以及接受者数据**********************************
        self.senderDic=[[self.message objectAtIndex:indexPath.row] objectForKey:@"sender"];
        self.user=[[self.message objectAtIndex:indexPath.row] objectForKey:@"user"];
        self.partyId=[[self.message objectAtIndex:indexPath.row]objectForKey:@"p_id"];
        self.creaters=[[self.message objectAtIndex:indexPath.row] objectForKey:@"creats"];
        //***********************************比较发送者以及接受者数据 end**********************************
        
        //************************************派对创建时间******************************************
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
        
        NSInteger time1=[[self.partyId objectForKey:@"P_STIME"]integerValue];
        NSDate* date1=[NSDate dateWithTimeIntervalSince1970:time1];
        self.P_time = [formatter stringFromDate:date1];
        NSLog(@"self.P_time======%@",self.P_time);
        
        //消息发送时间
        NSInteger time2=[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_STIME"]integerValue];
        NSDate* date2=[NSDate dateWithTimeIntervalSince1970:time2];
        M_stime = [formatter stringFromDate:date2];
        NSLog(@"self.P_time======%@",M_stime);
        
        
        //消息倒计时
        NSInteger time3=[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_DTIME"]integerValue];
        if (time3>10||time3==10) {
            M_dtime=[NSString stringWithFormat:@"00:%d",time3];
        }
        else if(time3>0||time3==0)
            M_dtime=[NSString stringWithFormat:@"00:0%d",time3];
        NSLog(@"self.P_time======%@",M_dtime);
        
        
        //派对倒计时
        NSInteger time4=[[self.partyId objectForKey:@"P_DTIME"]integerValue];
        if(time4>0||time4==0){
            int i=time4/60;
            NSString *hour;
            if (i>10||i==10) {
                hour=[NSString stringWithFormat:@"%d",i];
            }
            else
                hour=[NSString stringWithFormat:@"0%d",i];
            
            int j=time4%60;
            NSString *mins;
            if (j>10||j==10) {
                mins=[NSString stringWithFormat:@"%d",j];
            }
            else
                mins=[NSString stringWithFormat:@"0%d",j];
            
            P_dtime = [NSString stringWithFormat:@"%@:%@",hour,mins];
        }
        NSLog(@"self.P_time======%@",P_dtime);
        
        //************************************派对创建时间 end*****************************************
        
        UILabel *timeLabel1=[[UILabel alloc]initWithFrame:CGRectMake(207, 108, 100, 12)];
        timeLabel1.text=M_stime;//@"2013,3,12  17:35";
        timeLabel1.backgroundColor=[UIColor clearColor];
        timeLabel1.tag=105;
        timeLabel1.textColor=[UIColor lightGrayColor];
        timeLabel1.font=[UIFont systemFontOfSize:11];
        [cell.contentView addSubview:timeLabel1];
        
        if (indexPath.row==18) {
            NSLog(@"%@",[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_CONTENT"]);
        }
        
        if([[self.partyId objectForKey:@"P_UUID"] isEqualToNumber:self.uuid]){//如果派对的创建者的id等于uuid
            if([[self.user objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]){//如果信息接收者的id等于uuid
                //XX申请加入我的派对
                UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 16, 42, 42)];
                NSURL* imageurl=[NSURL URLWithString:[self.senderDic objectForKey:@"SENDER_PIC"]];
                [imgView2 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                imgView2.layer.borderColor=[[UIColor whiteColor] CGColor];
                imgView2.layer.borderWidth=1;
                //圆角设置
                imgView2.layer.cornerRadius = 6;
                imgView2.layer.masksToBounds = YES;
                [cell.contentView addSubview:imgView2];
                //***************************************信息显示*********************************************
                UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 16, 138, 15)];
                mylabel.text=[self.senderDic objectForKey:@"SENDER_NICK"];
                mylabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                mylabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                mylabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:mylabel];
                
                UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 16, 11, 13)];
                NSString* sexstr=[self.senderDic objectForKey:@"SENDER_SEX"];
                if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
                    seximage.image=[UIImage imageNamed:@"nan"];
                }
                else
                {
                    seximage.image=[UIImage imageNamed:@"nv"];
                }
                [cell.contentView addSubview:seximage];
                
                UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 40, 232, 15)];
                infolabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                //infolabel.font=[UIFont systemFontOfSize:11];
                infolabel.backgroundColor=[UIColor clearColor];
                infolabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
                [cell.contentView addSubview:infolabel];
                
                UITextView *introView=[[UITextView alloc]initWithFrame:CGRectMake(68, 57, 240, 100)];
                introView.userInteractionEnabled=NO;
                introView.multipleTouchEnabled=NO;
                introView.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                introView.backgroundColor=[UIColor clearColor];
                introView.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                if ([[self.message objectAtIndex:indexPath.row] objectForKey:@"M_CONTENT"]) {
                    introView.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_CONTENT"]];
                }
                else{
                    introView.text=@"";
                }
                [cell.contentView addSubview:introView];
                //        //***************************************信息显示 end*********************************************
                
                UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
                button1.frame= CGRectMake(268, 8, 40, 42);
                button1.backgroundColor=[UIColor clearColor];
                button1.tag=104;
                [button1 setImage:[UIImage imageNamed:@"shengqin"] forState:UIControlStateNormal];
                [cell.contentView addSubview:button1];
                
                
                //***************************************决定时间*********************************************
                
                
                if ([[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                    
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame= CGRectMake(20, 67, 43, 25);
                    button.backgroundColor=[UIColor clearColor];
                    button.tag=104;
                    [button setImage:[UIImage imageNamed:@"gougougoug"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(requestButton:event:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button];
                    
                    
                    //***************************************决定时间*********************************************
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                    timeLabel.text=@"决定时间";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                    [cell.contentView addSubview:timeLabel];
                    //倒计时
                    auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(119, 104, 60, 14)];
                    auctionTime.backgroundColor=[UIColor clearColor];
                    auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    auctionTime.userInteractionEnabled=NO;
                    auctionTime.tag=106;
                    auctionTime.textColor=[UIColor redColor];
                    auctionTime.text=M_dtime;
                    auctionTime.font=[UIFont fontWithName:@"Helvetica-Oblique" size:18];
                    [cell.contentView addSubview:auctionTime];
                    
                    UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(167, 107, 40, 14)];
                    minLabel.backgroundColor=[UIColor clearColor];
                    minLabel.text=@"mins";
                    minLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    minLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                    [cell.contentView addSubview:minLabel];
                    
                }
                else if([[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                    timeLabel.text=@"已过期";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                    [cell.contentView addSubview:timeLabel];
                    
                }
                else if([[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                    timeLabel.text=@"已加入";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                    [cell.contentView addSubview:timeLabel];
                }
                //***************************************决定时间 end*********************************************
            }
            
            else{//如果信息的接收者的id不等于uuid  //我邀请XX联合创建
                //*********************************
                UIImageView* imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 16, 42, 42)];
                NSURL* imageurl=[NSURL URLWithString:[[self.partyId objectForKey:@"p_user_id"] objectForKey:@"USER_PIC"]];
                [imgView1 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                imgView1.layer.borderColor=[[UIColor whiteColor] CGColor];
                imgView1.layer.borderWidth=1;
                //圆角设置
                imgView1.layer.cornerRadius = 6;
                imgView1.layer.masksToBounds = YES;
                //***************************************信息显示*******************************************
                UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 67, 138, 15)];
                mylabel.text=@"我";
                mylabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                mylabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                mylabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:mylabel];
                
                UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 16, 138, 15)];
                NSMutableString *mutableSyting=[[NSMutableString alloc]init];
                [mutableSyting appendString:@"邀请"];
                
                for (int i=0; i<[creaters count]; i++) {
                    if (i==0) {
                        [mutableSyting appendFormat:@"%@",[[creaters objectAtIndex:i] objectForKey:@"CREAT_NICK"]];
                    }
                    else
                        [mutableSyting appendFormat:@",%@",[[creaters objectAtIndex:i] objectForKey:@"CREAT_NICK"]];
                    NSLog(@"mutableSyting=========%@",mutableSyting);
                }
                wantlabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                //wantlabel.font=[UIFont systemFontOfSize:11];
                wantlabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                wantlabel.backgroundColor=[UIColor clearColor];
                wantlabel.text=mutableSyting;
                
                [cell.contentView addSubview:wantlabel];
                
                UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 40, 232, 15)];
                infolabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                //infolabel.font=[UIFont systemFontOfSize:11];
                infolabel.backgroundColor=[UIColor clearColor];
                infolabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
                [cell.contentView addSubview:infolabel];
                
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 57, 200, 15)];
                timeLabel.text=[NSString stringWithFormat:@"时间：%@",self.P_time];//[self.partyId objectForKey:@"P_STIME"]];
                timeLabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                timeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:timeLabel];
                UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 74, 223, 15)];
                if ([self.partyId objectForKey:@"P_LOCAL"]) {
                    placeLabel.text=[NSString stringWithFormat:@"地点：%@",[self.partyId objectForKey:@"P_LOCAL"]];
                }else
                    placeLabel.text=@"";
                placeLabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                placeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                placeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:placeLabel];
                //***************************************信息显示 end*********************************************
                
                UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
                button1.frame= CGRectMake(268, 8, 40, 42);
                button1.backgroundColor=[UIColor clearColor];
                button1.tag=104;
                [button1 setImage:[UIImage imageNamed:@"chuangjian"] forState:UIControlStateNormal];
                [cell.contentView addSubview:button1];
                
                if ([[[self.partyId objectForKey:@"P_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                    timeLabel.text=@"等待决定";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                    [cell.contentView addSubview:timeLabel];
                    //倒计时
                    auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(119, 104, 60, 14)];
                    auctionTime.backgroundColor=[UIColor clearColor];
                    auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    auctionTime.userInteractionEnabled=NO;
                    auctionTime.tag=106;
                    auctionTime.textColor=[UIColor redColor];
                    auctionTime.text=P_dtime;//[NSString stringWithFormat:@"%@",[self.partyId objectForKey:@"P_DTIME"]];
                    //[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_DTIME"];
                    auctionTime.font=[UIFont fontWithName:@"Helvetica-Oblique" size:18];
                    [cell.contentView addSubview:auctionTime];
                    
                    UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(167, 107, 40, 14)];
                    minLabel.backgroundColor=[UIColor clearColor];
                    minLabel.text=@"hrs";
                    minLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    minLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                    [cell.contentView addSubview:minLabel];
                }
                else if([[[self.partyId objectForKey:@"P_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 100, 14)];
                    timeLabel.text=@"人数不足已删除";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                    [cell.contentView addSubview:timeLabel];
                }
                else if([[[self.partyId objectForKey:@"P_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                    timeLabel.text=@"已创建";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                    [cell.contentView addSubview:timeLabel];
                }
                //***************************************决定时间 end*********************************************
                
                [cell.contentView addSubview:imgView1];
            }
        }
        else if ([[self.senderDic objectForKey:@"SENDER_ID"] isEqualToNumber:self.uuid]) {//如果信息接收者的id等于uuid
            
            //我申请加入XX的派对
            
            UIImageView* imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 16, 42, 42)];
            
            NSURL* imageurl=[NSURL URLWithString:[self.senderDic objectForKey:@"SENDER_PIC"]];
            [imgView1 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            imgView1.layer.borderColor=[[UIColor whiteColor] CGColor];
            imgView1.layer.borderWidth=1;
            //圆角设置
            imgView1.layer.cornerRadius = 6;
            imgView1.layer.masksToBounds = YES;
            
            UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 67, 138, 15)];
            mylabel.text=@"我";//[self.senderDic objectForKey:@"SENDER_NICK"];
            mylabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            mylabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
            mylabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:mylabel];
            
            UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 16, 138, 15)];
            NSMutableString *mutableSyting=[[NSMutableString alloc]init];
            [mutableSyting appendString:@"加入"];
            [mutableSyting appendFormat:@"%@的:",[self.user objectForKey:@"USER_NICK"]];
            wantlabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            //wantlabel.font=[UIFont systemFontOfSize:11];
            wantlabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
            wantlabel.backgroundColor=[UIColor clearColor];
            wantlabel.text=mutableSyting;
            
            [cell.contentView addSubview:wantlabel];
            
            UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 40, 232, 15)];
            infolabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            //infolabel.font=[UIFont systemFontOfSize:11];
            infolabel.backgroundColor=[UIColor clearColor];
            infolabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
            infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
            [cell.contentView addSubview:infolabel];
            
            UITextView *introView=[[UITextView alloc]initWithFrame:CGRectMake(68, 57, 240, 100)];
            introView.userInteractionEnabled=NO;
            introView.multipleTouchEnabled=NO;
            introView.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
            //introView.font=[UIFont systemFontOfSize:12];
            introView.backgroundColor=[UIColor clearColor];
            introView.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
            if ([[self.message objectAtIndex:indexPath.row] objectForKey:@"M_CONTENT"]) {
                introView.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_CONTENT"]];
            }
            else{
                introView.text=@"";
            }
            
            [cell.contentView addSubview:introView];
            //***************************************信息显示 end*********************************************
            
            [cell.contentView addSubview:imgView1];
            
            UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame= CGRectMake(268, 8, 40, 42);
            button1.backgroundColor=[UIColor clearColor];
            button1.tag=104;
            [button1 setImage:[UIImage imageNamed:@"shengqin"] forState:UIControlStateNormal];
            [cell.contentView addSubview:button1];
            
            //***************************************决定时间*********************************************
            
            if ([[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                timeLabel.text=@"等待决定";
                timeLabel.backgroundColor=[UIColor clearColor];
                timeLabel.tag=105;
                timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                [cell.contentView addSubview:timeLabel];
                
                //倒计时
                auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(119, 104, 60, 14)];
                auctionTime.backgroundColor=[UIColor clearColor];
                auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                auctionTime.userInteractionEnabled=NO;
                auctionTime.tag=106;
                auctionTime.textColor=[UIColor redColor];
                auctionTime.text=M_dtime;
                auctionTime.font=[UIFont fontWithName:@"Helvetica-Oblique" size:18];
                [cell.contentView addSubview:auctionTime];
                
                UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(167, 107, 40, 14)];
                minLabel.backgroundColor=[UIColor clearColor];
                minLabel.text=@"mins";
                minLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                minLabel.font=[UIFont systemFontOfSize:14];
                [cell.contentView addSubview:minLabel];
                
            }
            else if([[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                timeLabel.text=@"已过期";
                timeLabel.backgroundColor=[UIColor clearColor];
                timeLabel.tag=105;
                timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                [cell.contentView addSubview:timeLabel];
            }
            else if([[[[self.message objectAtIndex:indexPath.row] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                timeLabel.text=@"已加入";
                timeLabel.backgroundColor=[UIColor clearColor];
                timeLabel.tag=105;
                timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                [cell.contentView addSubview:timeLabel];
            }
            //***************************************决定时间 end*********************************************
        }
        else{//如果联合创建人的id等于uuid
            BOOL isdone=NO;
            if (self.creaters.count==0) {
                isdone=NO;
            }
            for (int i=0; i<[self.creaters count]; i++) {
                if ([[[self.creaters objectAtIndex:i] objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]) {
                    isdone=YES;
                }
            }
            if(isdone){
                
                UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 16, 42, 42)];
                NSURL* imageurl=[NSURL URLWithString:[[self.partyId objectForKey:@"p_user_id"] objectForKey:@"USER_PIC"]];
                [imgView2 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                imgView2.layer.borderColor=[[UIColor whiteColor] CGColor];
                imgView2.layer.borderWidth=1;
                //圆角设置
                imgView2.layer.cornerRadius = 6;
                imgView2.layer.masksToBounds = YES;
                //***************************************信息显示*********************************************
                
                UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 16, 11, 13)];
                NSString* sexstr=[self.senderDic objectForKey:@"SENDER_SEX"];
                if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
                    seximage.image=[UIImage imageNamed:@"nan"];
                }
                else
                {
                    seximage.image=[UIImage imageNamed:@"nv"];
                }
                [cell.contentView addSubview:seximage];
                
                UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 16, 138, 15)];
                mylabel.text=[[self.partyId objectForKey:@"p_user_id"] objectForKey:@"USER_NICK"];
                mylabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                mylabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                mylabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:mylabel];
                
                UILabel* infolabel=infolabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 40, 232, 15)];
                infolabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                //infolabel.font=[UIFont systemFontOfSize:11];
                infolabel.backgroundColor=[UIColor clearColor];
                infolabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
                [cell.contentView addSubview:infolabel];
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 57, 200, 15)];
                timeLabel.text=[NSString stringWithFormat:@"时间：%@",self.P_time];//[self.partyId objectForKey:@"P_STIME"]];
                timeLabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                timeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:timeLabel];
                
                UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 74, 223, 15)];
                if ([self.partyId objectForKey:@"P_LOCAL"]) {
                    placeLabel.text=[NSString stringWithFormat:@"地点：%@",[self.partyId objectForKey:@"P_LOCAL"]];
                }else
                    placeLabel.text=@"";
                placeLabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                placeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
                placeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:placeLabel];
                //***************************************信息显示 end*********************************************
                [cell.contentView addSubview:imgView2];
                
                UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
                button1.frame= CGRectMake(268, 8, 40, 42);
                button1.backgroundColor=[UIColor clearColor];
                button1.tag=104;
                [button1 setImage:[UIImage imageNamed:@"yaoqing"] forState:UIControlStateNormal];
                [cell.contentView addSubview:button1];
                
                //***************************************决定时间*********************************************
                if ([[[self.partyId objectForKey:@"P_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                    
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame= CGRectMake(20, 67, 43, 25);
                    button.backgroundColor=[UIColor clearColor];
                    button.tag=104;
                    [button setImage:[UIImage imageNamed:@"gougougoug"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(ButtonClick:event:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button];
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                    timeLabel.text=@"决定时间";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                    
                    [cell.contentView addSubview:timeLabel];
                    //倒计时
                    auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(119, 104, 60, 14)];
                    auctionTime.backgroundColor=[UIColor clearColor];
                    auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    auctionTime.userInteractionEnabled=NO;
                    auctionTime.tag=106;
                    auctionTime.textColor=[UIColor redColor];
                    auctionTime.text=P_dtime;
                    auctionTime.font=[UIFont fontWithName:@"Helvetica-Oblique" size:18];
                    [cell.contentView addSubview:auctionTime];
                    
                    UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(167, 107, 40, 14)];
                    minLabel.backgroundColor=[UIColor clearColor];
                    minLabel.text=@"hrs";
                    minLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    minLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                    [cell.contentView addSubview:minLabel];
                    
                }
                else if([[[self.partyId objectForKey:@"P_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 100, 14)];
                    timeLabel.text=@"人数不足已删除";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                    [cell.contentView addSubview:timeLabel];
                }
                else if([[[self.partyId objectForKey:@"P_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 107, 60, 14)];
                    timeLabel.text=@"已创建";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                    timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                    [cell.contentView addSubview:timeLabel];
                }
                //***************************************决定时间 end*********************************************
                isdone=NO;
            }
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
    }
    //李萌萌
    if (choiceNumber==2) {
        static NSString *cellSystem=@"systemCell";
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellSystem];
        if (!cell) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSystem];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        
        NSDictionary* dict=[self.systemArray objectAtIndex:indexPath.row];
        NSString *stringP_ID=[dict objectForKey:@"p_id"];
        
        UILabel* timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(190, 90, 100, 15)];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        timeLabel.font=[UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:timeLabel];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
        //HH与hh的区别是24小时制和12小时制
        NSInteger time=[[dict objectForKey:@"M_STIME"]integerValue];
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timeLabel.text=confromTimespStr;
        if ([stringP_ID intValue] !=0) {
            //排队入场券
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ticketPRT"]];
            UILabel* titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 32, 180, 20)];
            titlelabel.backgroundColor=[UIColor clearColor];
            titlelabel.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
            titlelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
            titlelabel.text=[dict objectForKey:@"p_title"];
            [cell.contentView addSubview:titlelabel];
            UITextView* addrView=[[UITextView alloc]initWithFrame:CGRectMake(113, 47, 160, 50)];
            addrView.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
            addrView.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
            addrView.backgroundColor=[UIColor clearColor];
            addrView.text=[dict objectForKey:@"p_local"];
            addrView.userInteractionEnabled=NO;
            addrView.multipleTouchEnabled=NO;
            [cell.contentView addSubview:addrView];
            UILabel* phone=[[UILabel alloc]initWithFrame:CGRectMake(215, 106, 100, 20)];
            phone.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"p_phone"]];
            phone.textColor=[UIColor whiteColor];
            phone.font=[UIFont systemFontOfSize:11];
            phone.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:phone];
            
        }
        else//活动入场券
        {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ticketACT"]];
            UILabel* titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 40, 160, 20)];
            titlelabel.backgroundColor=[UIColor clearColor];
            titlelabel.textColor=[UIColor colorWithRed:93.0/255 green:93.0/255 blue:93.0/255 alpha:1];
            titlelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
            titlelabel.text=[dict objectForKey:@"c_title"];
            [cell.contentView addSubview:titlelabel];
            UILabel* messinfo=[[UILabel alloc]initWithFrame:CGRectMake(120, 55, 170, 25)];
            messinfo.backgroundColor=[UIColor clearColor];
            messinfo.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
            messinfo.text=@"有新的派对邀请你参加";
            messinfo.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
            [cell.contentView addSubview:messinfo];
            
        }
        
        return cell;
    }
    return nil;
    
}

-(void)showFriendPic
{
    NSLog(@"xianshi hao you");
    
}

-(void)requestButton:(id)sender event:(id)event{
    sendDate=1;
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbView];
    NSIndexPath *indexPath = [tbView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath != nil)
    {
        [self tableView:tbView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}
- (void)ButtonClick:(id)sender event:(id)event
{
    sendDate=2;
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbView];
    NSIndexPath *indexPath = [tbView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"selectRow==============%@",indexPath);
    
    if(indexPath != nil)
    {
        [self tableView:tbView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    
}

//yes按钮的快捷键
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    selectRow=indexPath.row;
    NSLog(@"selectRow==============%d",selectRow);
    
    
    [self sendDate];
}

-(void)sendDate
{
    NSLog(@"确认");
    NSDictionary* dict=[self.message objectAtIndex:selectRow];
    NSString* party_id=[dict objectForKey:@"P_ID"];
    NSString *senderTo=[dict objectForKey:@"SENDER_ID"];
    
    if (sendDate==1) {
        
        [SVProgressHUD show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showFriend) userInfo:nil repeats:NO];
        
        NSString* str=@"mac/party/IF00054";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
        [request setPostValue:senderTo forKey: @"user_id"];
        
        NSLog(@"self.senderTo======%@",senderTo);
        
        [request setPostValue:party_id forKey:@"p_id"];            //[request setDelegate:self];
        [request startSynchronous];
    }
    else if(sendDate==2){
        
        [SVProgressHUD show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showParty) userInfo:nil repeats:NO];
        
        
        NSString* str=@"mac/party/IF00053";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
        [request setPostValue:self.userUUid forKey: @"uuid"];
        [request setPostValue:party_id forKey:@"p_id"];
        //[request setDelegate:self];
        [request startSynchronous];
    }
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00050?uuid=%@&&m_type=party&&from=%d&&to=%d",userUUid,1,[self.message count]];
    NSString *stringUrl=globalURL(str);
    flag=0;
    NSURL* url=[NSURL URLWithString:stringUrl];
    NSLog(@"获取已经修改的派对消息：%@",url);
    NSLog(@"%@",stringUrl);
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
-(void)showParty{
    [SVProgressHUD dismissWithSuccess:@"派对创建成功！"];
}
-(void)showFriend{
    [SVProgressHUD dismissWithSuccess:@"发送成功！"];
}

//改变行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (choiceNumber==0) {
        return 70;
    }
    else if(choiceNumber==1)
        return 136;
    return 129;
}



//************************点击按钮触发事件*********************


//尹林林
-(IBAction)buttonFriend
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    choiceNumber=0;
    flag=0;
    self.tbView.contentOffset=CGPointMake(0.0, 0.0);
    [self.tbView reloadData];
    if (friBtn!=nil)
    {
        [friBtn removeFromSuperview];
        friBtn=nil;
        NSString* str=[NSString stringWithFormat:@"mac/msg/IF00061?uuid=%@&m_type=1",userUUid];
        NSString *cleanUrlStr=globalURL(str);
        NSLog(@"清空friend消息:%@",cleanUrlStr);
        NSURL* cleanurl=[NSURL URLWithString:cleanUrlStr];
        
        ASIHTTPRequest* cleanrequest=[ASIHTTPRequest requestWithURL:cleanurl];
        [cleanrequest startSynchronous];
    }
    
    
    NSString* str=[NSString stringWithFormat:@"mac/user/IF00016?uuid=%@&&type=friend",userUUid];
    NSString *stringUrl=globalURL(str);
    NSURL* url=[NSURL URLWithString:stringUrl];
    NSLog(@"好友消息：%@",url);
    NSLog(@"%@",stringUrl);
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


//郭江伟
-(IBAction)buttonParty
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    flag=0;
    self.tbView.contentOffset=CGPointMake(0.0, 0.0);
    choiceNumber=1;
    [self.tbView reloadData];
    if (mesBtn!=nil) {
        [mesBtn removeFromSuperview];
        mesBtn=nil;
        NSString* str=[NSString stringWithFormat:@"mac/msg/IF00061?uuid=%@&m_type=2",userUUid];
        NSString *cleanUrlStr=globalURL(str);
        NSLog(@"清空party消息:%@",cleanUrlStr);
        NSURL* cleanurl=[NSURL URLWithString:cleanUrlStr];
        
        ASIHTTPRequest* cleanrequest=[ASIHTTPRequest requestWithURL:cleanurl];
        [cleanrequest startSynchronous];
    }
    
    //测试from有问题,已经解决
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00050?uuid=%@&&m_type=party",userUUid];
    NSString *stringUrl=globalURL(str);
    NSLog(@"派对消息：：：%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}


//李萌萌
-(IBAction)buttonSystem
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    choiceNumber=2;
    flag=0;
    self.tbView.contentOffset=CGPointMake(0.0, 0.0);
    [self.tbView reloadData];
    if (sysBtn!=nil) {
        [sysBtn removeFromSuperview];
        sysBtn=nil;
        NSString* str=[NSString stringWithFormat:@"mac/msg/IF00061?uuid=%@&m_type=3",userUUid];
        NSString *cleanUrlStr=globalURL(str);
        NSLog(@"清空system消息:%@",cleanUrlStr);
        NSURL* cleanurl=[NSURL URLWithString:cleanUrlStr];
        
        ASIHTTPRequest* cleanrequest=[ASIHTTPRequest requestWithURL:cleanurl];
        [cleanrequest startSynchronous];
    }
    //from有问题，已经解决
    
    
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00018?uuid=%@&&m_type=system",userUUid];
    NSString *stringUrl=globalURL(str);
    NSLog(@"系统消息:::%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    
}

//好友消息加载更多
-(void)friendMessageclickmore
{
    flag=1;
    NSLog(@"好友消息当前返回的数量%d",total);
    if (total<mytotal) {
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"已经返回所有消息" message:@"已经返回所有消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
    }
    else
    {
        NSString* str=[NSString stringWithFormat:@"mac/user/IF00016?uuid=%@&&type=friend&&from=%d",userUUid,[self.friendlist count]+1];
        NSString *stringUrl=globalURL(str);
        NSURL* url=[NSURL URLWithString:stringUrl];
        NSLog(@"加载更多:::好友消息：%@",url);
        NSLog(@"%@",stringUrl);
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}
//派对消息加载更多
-(void)partyMessageclickmore
{
    flag=1;
    if (total<mytotal) {
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"已经返回所有消息" message:@"已经返回所有消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
    }
    else{
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00050?uuid=%@&&m_type=party&&from=%d",userUUid,[self.message count]+1];
        NSString *stringUrl=globalURL(str);
        NSLog(@"派对消息加载更多:::%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    
}

//系统消息加载更多
-(void)systemMessageclickmore
{
    flag=1;
    if (total<mytotal) {
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"已经返回所有消息" message:@"已经返回所有消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
    }
    else{
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00018?uuid=%@&&m_type=system&&from=%d",userUUid,[self.systemArray count]+1];
        NSString *stringUrl=globalURL(str);
        NSLog(@"系统加载更多：：：%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    
}


-(void)Frichangedatasource
{
    NSString* str=[NSString stringWithFormat:@"mac/user/IF00016?uuid=%@&&type=friend&&from=%d&&to=%d",userUUid,1,[self.friendlist count]];
    NSString *stringUrl=globalURL(str);
    choiceNumber=0;
    flag=0;
    NSURL* url=[NSURL URLWithString:stringUrl];
    NSLog(@"获取已经修改的好友消息：%@",url);
    NSLog(@"%@",stringUrl);
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];//    NSData* response=[request responseData];
    //    //NSLog(@"%@",response);
    //    NSError* error;
    //    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    NSLog(@"%@",bizDic);
    //    NSArray* messarr=[bizDic objectForKey:@"Messages"];
    //    NSLog(@"%@",[self.friendlist objectAtIndex:friendselect]);
    //    [self.friendlist replaceObjectAtIndex:friendselect withObject:[messarr objectAtIndex:0]];
    //    [self.tbView reloadData];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((self.tbView.contentOffset.y+mainscreenhight-self.tbView.contentSize.height>0)&&(self.tbView.contentSize.height>0))
    {
        if (choiceNumber==0) {
            if (isLoading==NO) {
                isLoading=YES;
                [self friendMessageclickmore];
            }
            isLoading=YES;
            return;
        }
        if (choiceNumber==1) {
            if (isLoading==NO) {
                isLoading=YES;
                [self partyMessageclickmore];
            }
            isLoading=YES;
            return;
        }

        if (choiceNumber==2) {
            if (isLoading==NO) {
                isLoading=YES;
                [self systemMessageclickmore];
            }
            isLoading=YES;
            return;
        }

    }
}
@end
