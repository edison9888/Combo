//
//  PartyDetialViewController.m
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import "PartyDetialViewController.h"

@interface PartyDetialViewController ()

@end

@implementation PartyDetialViewController
@synthesize tableview;
@synthesize items;
@synthesize p_id;
@synthesize party;
@synthesize userUUid;
@synthesize numberUUID;
@synthesize creatUser,joinUser;
@synthesize FlowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        numFlogJoin=0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    numFlogLogout=0;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"partynavigation"] forBarMetrics:UIBarMetricsDefault];
    // NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1] forKey:UITextAttributeTextColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:239.0/255.0 green:105.0/255.0 blue:87.0/255.0 alpha:1.0],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,[UIFont systemFontOfSize:18],
                          UITextAttributeFont,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 40, 35);
    [backbutton setImage:[UIImage imageNamed:@"partyback"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    [self getUUidForthis];
    //==================请求数据========================================
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00105?p_id=%@&&uuid=%@",p_id,userUUid];
    NSString *stringP=globalURL(str);
    NSLog(@"shuchuwangzhi::::::::::::::::%@",stringP);
    NSURL* url=[NSURL URLWithString:stringP];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    [tableview reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    mark=0;
    //[UIApplication sharedApplication].delegate=self;
    //self.view.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableview=table;
    [self.view addSubview:self.tableview];
    self.tableview.backgroundView=nil;
    self.tableview.backgroundColor=[UIColor colorWithRed:241.0/255 green:241.0/255 blue:236.0/255 alpha:1];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    //======================================
    stringA=[[NSMutableString alloc]initWithCapacity:100];
    
    //==============================
    label = [[UILabel alloc] initWithFrame:CGRectMake(70,100,180,100)];
    label.numberOfLines =0;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:110.0/255 green:109.0/255 blue:109.0/255 alpha:1];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    //=======================================
    
    
    self.navigationItem.hidesBackButton=YES;
    
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
    self.userUUid=stringUUID;
    if (userUUid==nil) {
        userUUid=@"10002";
    }
    self.numberUUID=[NSNumber numberWithInt:[stringUUID intValue]];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (numFlogLogout==0) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"rrrrrrrrrrrrrrr%@",bizDic);
        self.party =[bizDic objectForKey:@"partys"];
        NSLog(@"hhhhhhhhhhhhhhhhhhhhhh%@",party);
        self.creatUser=[party objectForKey:@"creaters"];
        self.joinUser=[party objectForKey:@"participants"];
        self.title=[party objectForKey:@"P_TITLE"];
        NSDictionary* userdict=[self.creatUser objectAtIndex:0];
        label.text=[userdict objectForKey:@"USER_NICK"];
        NSString *stringPartyStatues=[party objectForKey:@"P_STATUS"];
        NSString *userStringStatues=[bizDic objectForKey:@"userStatus"];
        UIButton *buttonJoin=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[stringPartyStatues substringToIndex:1]isEqualToString:@"Y"]||[[stringPartyStatues substringToIndex:1]isEqualToString:@"W"])//只有派对没有结束的时候派对下边栏才能加进去
        {
            if ([[userStringStatues substringToIndex:1]isEqualToString:@"N"])//未加入活动只有游客可能
            {
                [buttonJoin setImage:[UIImage imageNamed:@"Pjoin"] forState:UIControlStateNormal];
                [buttonJoin addTarget:self action:@selector(supplyParty) forControlEvents:UIControlEventTouchUpInside];//申请加入派对
            }
            if ([[userStringStatues substringToIndex:1]isEqualToString:@"Y"])//已经加入活动，游客和联合创建者都可以进入
            {
                //如果是游客则进行操作,显示我不去了按钮,这个时候游客变为参与者可以选择不去参加派对了
                for ( NSDictionary *dicParty in [party objectForKey:@"participants"])
                {
                    NSLog(@"wwwwwwwwwwwwwwwwwww%@",self.userUUid);
                    NSString *stringInStatues=[dicParty objectForKey:@"IN_STATUS"];
                    NSString *stringTakeStatues=[dicParty objectForKey:@"USER_STATUS"];
                    if ([[dicParty objectForKey:@"USER_ID"] isEqualToNumber:self.numberUUID])
                    {
                        if ([[stringInStatues substringToIndex:1]isEqualToString:@"N"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"Y"]) {
                            [buttonJoin setImage:[UIImage imageNamed:@"Pout"] forState:UIControlStateNormal];
                            [buttonJoin addTarget:self action:@selector(outParty) forControlEvents:UIControlEventTouchUpInside];//可以退出派对不去
                            numFlogJoin=1;
                        }
                    }
                    
                }
                //参与者结束
                //如果自己是联合创建者
                for (NSDictionary *dicJion in [party objectForKey:@"creaters"])
                {
                    NSString *stringInStatues=[dicJion objectForKey:@"IN_STATUS"];
                    NSString *stringTakeStatues=[dicJion objectForKey:@"take_status"];
                    if ([[dicJion objectForKey:@"USER_ID"] isEqualToNumber:self.numberUUID] ) {
                        
                        if ([[stringInStatues substringToIndex:1]isEqualToString:@"Y"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"Y"]) {
                            [buttonJoin setImage:[UIImage imageNamed:@"Pout"] forState:UIControlStateNormal];
                            [buttonJoin addTarget:self action:@selector(noOutParty) forControlEvents:UIControlEventTouchUpInside];//是联合创建人不能推出派对
                            numFlogJoin=1;
                        }
                        
                        if ([[stringInStatues substringToIndex:1]isEqualToString:@"Y"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"N"]) {
                            [buttonJoin setImage:[UIImage imageNamed:@"Pjoin"] forState:UIControlStateNormal];
                            [buttonJoin addTarget:self action:@selector(agreeJoinParty) forControlEvents:UIControlEventTouchUpInside];//同意联合创建
                            numFlogJoin=1;
                        }
                        if ([[stringInStatues substringToIndex:1]isEqualToString:@"Y"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"W"]) {
                            [buttonJoin setImage:[UIImage imageNamed:@"Pjoin"] forState:UIControlStateNormal];
                            [buttonJoin addTarget:self action:@selector(agreeJoinParty) forControlEvents:UIControlEventTouchUpInside];//同意联合创建
                            numFlogJoin=1;
                        }
                    }
                }
                //====自己是创建者结束=============================
                
            }
            if ([[userStringStatues substringToIndex:1]isEqualToString:@"W"])//等待加入派对，游客和联合创建者都可以进入
            {
                //如果是游客==============
                [buttonJoin setImage:[UIImage imageNamed:@"Pjoin"] forState:UIControlStateNormal];
                [buttonJoin addTarget:self action:@selector(weaitJoinParty) forControlEvents:UIControlEventTouchUpInside];//等待同意
                //游客结束
                //===============
                for (NSDictionary *dicJion in [party objectForKey:@"creaters"])
                {
                    NSString *stringInStatues=[dicJion objectForKey:@"IN_STATUS"];
                    NSString *stringTakeStatues=[dicJion objectForKey:@"take_status"];
                    if ([[dicJion objectForKey:@"USER_ID"] isEqualToNumber:self.numberUUID] ) {
                        
                        if ([[stringInStatues substringToIndex:1]isEqualToString:@"Y"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"Y"]) {
                            [buttonJoin setImage:[UIImage imageNamed:@"Pout"] forState:UIControlStateNormal];
                            [buttonJoin addTarget:self action:@selector(noOutParty) forControlEvents:UIControlEventTouchUpInside];//是联合创建人不能推出派对
                            numFlogJoin=1;
                        }
                        NSLog(@"eeeeeeeeeeeeeeeeeee%@,,,%@",stringInStatues,stringTakeStatues);
                        if ([[stringInStatues substringToIndex:1]isEqualToString:@"Y"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"N"]) {
                            [buttonJoin setImage:[UIImage imageNamed:@"Pjoin"] forState:UIControlStateNormal];
                            [buttonJoin addTarget:self action:@selector(agreeJoinParty) forControlEvents:UIControlEventTouchUpInside];//同意联合创建
                            numFlogJoin=1;
                        }
                        if ([[stringInStatues substringToIndex:1]isEqualToString:@"Y"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"W"]) {
                            [buttonJoin setImage:[UIImage imageNamed:@"Pjoin"] forState:UIControlStateNormal];
                            [buttonJoin addTarget:self action:@selector(agreeJoinParty) forControlEvents:UIControlEventTouchUpInside];//同意联合创建
                            numFlogJoin=1;
                        }
                    }
                }
                //===============
            }
            //只有派对没有结束的时候派对下边栏才能加进去
            buttonJoin.frame=CGRectMake(0,mainscreenhight-107, 160, 44);
            [self.view addSubview:buttonJoin];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(158, mainscreenhight-100, 2, 30)];
            imageView.image=[UIImage imageNamed:@"CutOffRule.png"];
            
            [self.view addSubview:imageView];
            //==========邀请按钮===============================
            UIButton *inviteButton =[UIButton buttonWithType:UIButtonTypeCustom];
            [inviteButton setImage:[UIImage imageNamed:@"Pinvite"] forState:UIControlStateNormal];
            [inviteButton addTarget:self action:@selector(showFriendView:) forControlEvents:UIControlEventTouchUpInside];
            [inviteButton setFrame:CGRectMake(160,mainscreenhight-107, 160, 44)];
            [self.view addSubview:inviteButton];
            
        }
        
        FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
        FlowView.delegate = self;
        FlowView.dataSource = self;
        FlowView.minimumPageAlpha = 0.7;
        FlowView.minimumPageScale = 0.6;
        [tableview reloadData];
    }
}
-(void)supplyParty
{
    NSLog(@"申请加入派对");
    if (numFlogJoin==0) {
        invit=[[InvitViewController alloc]init];
        invit.temp=2;
        invit.from_p_id=self.p_id;
        NSLog(@"输出pid%@",invit.from_p_id);
        [self.navigationController pushViewController:invit animated:YES];
    }
}
-(void)agreeJoinParty
{
    NSLog(@"同意创建派对");
    //numFlogLogout=1;
    NSString* str=@"mac/party/IF00053";
    NSString* strURL=globalURL(str);
    NSURL* url=[NSURL URLWithString:strURL];
    ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
    [request setPostValue:self.userUUid forKey: @"uuid"];
    [request setPostValue:self.p_id forKey:@"p_id"];
    [request startSynchronous];
    
    NSString* strr=[NSString stringWithFormat:@"mac/party/IF00105?p_id=%@&&uuid=%@",p_id,userUUid];
    NSString *stringPr=globalURL(strr);
    NSLog(@"shuchuwangzhi::::::::::::::::%@",stringPr);
    NSURL* urlr=[NSURL URLWithString:stringPr];
    ASIHTTPRequest* requestr=[ASIHTTPRequest requestWithURL:urlr];
    [requestr setDelegate:self];
    requestr.shouldAttemptPersistentConnection = NO;
    [requestr setValidatesSecureCertificate:NO];
    [requestr setDefaultResponseEncoding:NSUTF8StringEncoding];
    [requestr setDidFailSelector:@selector(requestDidFailed:)];
    [requestr startAsynchronous];
}
-(void)noOutParty
{
    NSLog(@"联合创建人不能退出派对");
    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你是联合创建人，不能退出活动" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [soundAlert show];
}
-(void)outParty
{
    NSLog(@"非联合创建人退出派对");
    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认退出派对？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [soundAlert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        numFlogLogout=1;
        NSString* str=@"mac/party/IF00041";
        NSString* strURL=globalURL(str);
        NSURL *url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.p_id forKey: @"p_id"];
        [rrequest setDelegate:self];
        [rrequest startAsynchronous];
    }
}
-(void)weaitJoinParty
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在等待创建者同意" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)showFriendView:(UIButton *)btF
{
    btF.selected=!btF.selected;
    NSLog(@"join");
    if ([[party objectForKey:@"P_TYPE"]intValue]==1) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=4;
        friend.from_p_id=self.p_id;
        [self.navigationController pushViewController:friend animated:YES];
        
    }
    else if ([[party objectForKey:@"P_TYPE"]intValue]==2) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=2;
        friend.from_p_id=self.p_id;
        friend.from_c_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:friend animated:YES];
    }
    else if([[party objectForKey:@"P_TYPE"]intValue]==3){
        friend=[[CheckOneViewController alloc]init];
        friend.spot=2;
        friend.from_p_id=self.p_id;
        friend.from_c_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:friend animated:YES];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,[UIFont systemFontOfSize:20],
                          UITextAttributeFont,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
//========================== 分组个数============================================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 266;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 120;
}
//=====================行的间距======================================================
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row=[indexPath row];
    if (row==0) {
        return 22;
    }
    if (row==1) {
        return 33;
    }
    if (row==2) {
        return 47;
    }
    if (row==3) {
        return 36;
    }
    if (row==4) {
        UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 16;
}
//==================cell的内容=====================================================
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellAccessoryNone;
    if (indexPath.row==0) {
        
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party0"]];
        //不属于任何活动
        if ([[party objectForKey:@"P_TYPE"]intValue]==1)
        {
            UIImageView* NCImage=[[UIImageView alloc]initWithFrame:CGRectMake(199, 0, 101, 22)];
            NCImage.image=[UIImage imageNamed:@"NCButton"];
            [cell.contentView addSubview:NCImage];
        }
        else{
            UIButton* Cbutton=[UIButton buttonWithType:UIButtonTypeCustom];
            Cbutton.frame=CGRectMake(199, 0, 101, 22);
            [Cbutton setImage:[UIImage imageNamed:@"CButton"] forState:UIControlStateNormal];
            [Cbutton addTarget:self action:@selector(JumpCollection) forControlEvents:UIControlEventTouchDown];
            UILabel* CLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 101, 22)];
            CLabel.text=[party objectForKey:@"C_TITLE"];
            CLabel.textColor=[UIColor whiteColor];
            CLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
            NSLog(@"CLabel.text:%@",[party objectForKey:@"C_TITLE"]);
            CLabel.backgroundColor=[UIColor clearColor];
            CLabel.textAlignment=NSTextAlignmentCenter;
            [Cbutton addSubview:CLabel];
            [cell.contentView addSubview:Cbutton];
        }
        return cell;
    }
    
    
    if (indexPath.row==1) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party1"]];
        UILabel* timelabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 33)];
        timelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        timelabel.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
        NSInteger time=[[party objectForKey:@"P_STIME"]integerValue];
        NSLog(@"%d",time);
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timelabel.text=confromTimespStr;
        [cell.contentView addSubview:timelabel];
        return cell;
    }
    if (indexPath.row==2) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party2"]];
        UILabel* addrlabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 33)];
        addrlabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        addrlabel.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        addrlabel.text=[party objectForKey:@"P_LOCAL"];
        [cell.contentView addSubview:addrlabel];
        return cell;
    }
    if (indexPath.row==3) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party3"]];
        return cell;
        
    }
    if (indexPath.row==4) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party4"]];
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectZero];
        labelName.numberOfLines = 0;
        labelName.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        labelName.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        labelName.backgroundColor=[UIColor clearColor];
        labelName.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        [cell.contentView addSubview:labelName];
        
        
        CGRect cellFrame = CGRectMake(30, 15.0, 265, 60);
        labelName.text=[party objectForKey:@"P_INFO"];
        CGRect rect = cellFrame;
        labelName.frame = rect;
        [labelName sizeToFit];
        cellFrame.size.height = labelName.frame.size.height+75;
        [cell setFrame:cellFrame];
        return cell;
    }
    if (indexPath.row==5) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party5"]];
        return cell;
    }
    
    
    return cell;
}
//=========================界面跳转=======================================
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        mapViewController=[[MyMapViewController alloc] init];
        //[mapViewController initData:self.party];
        //转换出现问题，待解决
        mapViewController.hidesBottomBarWhenPushed=YES;
        float lat=[[self.party objectForKey:@"LAT"]floatValue];
        float lng=[[self.party objectForKey:@"LNG"]floatValue];
        NSLog(@"2++++++%f %f",lat,lng);
        [mapViewController initData:lat and:lng];
        [mapViewController initTitle:[self.party objectForKey:@"P_TITLE"]];
        [self.navigationController pushViewController:mapViewController animated:YES];
        
    }
}
//==================头部放置动画效果===============================================
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageviewMidal=[[UIImageView alloc]initWithFrame:CGRectMake(159, 216, 2.5, 44)];
    UIImageView *PStatusImage=[[UIImageView alloc]initWithFrame:CGRectMake(7, 170, 307, 23)];
    if ([[[party objectForKey:@"P_STATUS"]substringToIndex:1]isEqualToString:@"Y"]) {
        PStatusImage.image=[UIImage imageNamed:@"PY"];
    }
    else
    {
        if ([[[party objectForKey:@"P_STATUS"]substringToIndex:1]isEqualToString:@"W"]) {
            PStatusImage.image=[UIImage imageNamed:@"PW"];
        }
        else
        {
            
            PStatusImage.image=[UIImage imageNamed:@"PN"];
            
        }
    }
    imageviewMidal.image=[UIImage imageNamed:@"fangzhongjian"];
    UIButton* personButton=[UIButton buttonWithType:UIButtonTypeCustom];
    personButton.frame=CGRectMake(0, 216, 159, 44);
    
    NSString *stringPerson=[NSString stringWithFormat:@"%d 创建者",self.creatUser.count];
    personButton.titleLabel.text=stringPerson;
    personButton.tag=501;
    UIButton* personButtonUnin=[UIButton buttonWithType:UIButtonTypeCustom];
    personButtonUnin.frame=CGRectMake(161.5, 216, 160, 44);
    NSString *stringPersonUnin=[NSString stringWithFormat:@"%d创建者",self.joinUser.count];
    personButtonUnin.titleLabel.text=stringPersonUnin;
    personButtonUnin.tag=502;
    if (mark==0) {
        [personButton setBackgroundImage:[UIImage imageNamed:@"CreatersSelect"] forState:UIControlStateNormal];
        personButton.userInteractionEnabled=NO;
        [personButtonUnin setBackgroundImage:[UIImage imageNamed:@"Parters"] forState:UIControlStateNormal];
        [personButtonUnin addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lableNumc=[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 50, 50)];
        lableNumc.textColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumc.backgroundColor=[UIColor clearColor];
        lableNumc.shadowColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumc.font=[UIFont systemFontOfSize:25];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumc.text=[NSString stringWithFormat:@"%d",self.creatUser.count];
        //lableNumc.layer.shadowOpacity=0.5;
        [personButton addSubview:lableNumc];
        UILabel *lableNumJ=[[UILabel alloc]initWithFrame:CGRectMake(-5, -2, 50, 50)];
        lableNumJ.textColor=[UIColor colorWithRed:123/255.0f green:140/255.0f blue:155/255.0f alpha:1];
        lableNumJ.backgroundColor=[UIColor clearColor];
        lableNumJ.font=[UIFont systemFontOfSize:25];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumJ.text=[NSString stringWithFormat:@"%d",self.joinUser.count];
        lableNumJ.shadowColor=[UIColor darkGrayColor];
        lableNumJ.textAlignment = NSTextAlignmentRight;
        [personButtonUnin addSubview:lableNumJ];
    }
    if (mark==1) {
        [personButton setBackgroundImage:[UIImage imageNamed:@"Creaters"] forState:UIControlStateNormal];
        [personButton addTarget:self action:@selector(segmentClickJion:) forControlEvents:UIControlEventTouchUpInside];
        [personButtonUnin setBackgroundImage:[UIImage imageNamed:@"PartersSelect"] forState:UIControlStateNormal];
        personButtonUnin.userInteractionEnabled=NO;
        UILabel *lableNumc=[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 50, 50)];
        lableNumc.textColor=[UIColor colorWithRed:123/255.0f green:140/255.0f blue:155/255.0f alpha:1];
        lableNumc.backgroundColor=[UIColor clearColor];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumc.shadowColor=[UIColor darkGrayColor];
        lableNumc.font=[UIFont systemFontOfSize:25];
        lableNumc.text=[NSString stringWithFormat:@"%d",self.creatUser.count];
        [personButton addSubview:lableNumc];
        UILabel *lableNumJ=[[UILabel alloc]initWithFrame:CGRectMake(-5, -2, 50, 50)];
        lableNumJ.textColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumJ.backgroundColor=[UIColor clearColor];
        lableNumJ.shadowColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumJ.font=[UIFont systemFontOfSize:25];
        lableNumJ.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumJ.text=[NSString stringWithFormat:@"%d",self.joinUser.count];
        lableNumJ.textAlignment = NSTextAlignmentRight;
        [personButtonUnin addSubview:lableNumJ];
        
    }
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0,100, 320, 266)];
    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"touxiangbeijing"]];
    [view addSubview:FlowView];
    [view addSubview:label];
    [view addSubview:PStatusImage];
    [view addSubview:personButton];
    [view addSubview:personButtonUnin];
    [view addSubview:imageviewMidal];
    return view;
    
}



//=================选择哪个Segment改变图片的位置======================================
- (void)segmentClick:(UIButton *)btn
{
    
    mark=1;
    if ([self.joinUser count]!=0) {
        NSDictionary* userdict=[self.joinUser objectAtIndex:0];
        label.text=[userdict objectForKey:@"USER_NICK"];
        [FlowView removeFromSuperview];
        FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
        FlowView.delegate = self;
        FlowView.dataSource = self;
        FlowView.minimumPageAlpha = 0.7;
        FlowView.minimumPageScale = 0.6;
        [tableview reloadData];
        
    }
}
-(void)segmentClickJion:(UIButton *)btn
{
    mark=0;
    NSDictionary* userdict=[self.creatUser objectAtIndex:0];
    label.text=[userdict objectForKey:@"USER_NICK"];
    [FlowView removeFromSuperview];
    FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
	FlowView.delegate = self;
    FlowView.dataSource = self;
    FlowView.minimumPageAlpha = 0.7;
    FlowView.minimumPageScale = 0.6;
    [tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(120,120);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView
{
    NSLog(@"Scrolled to page # %d", pageNumber);
    
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:pageNumber];
        label.text=[userdict objectForKey:@"USER_NICK"];
        
        
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:pageNumber];
            label.text=[userdict objectForKey:@"USER_NICK"];
            
        }
    }
    
    
    if (OldPage < pageNumber)
    {
        label.center = CGPointMake(320+75,label.center.y);
    }else if(OldPage > pageNumber)
    {
        label.center = CGPointMake(-75,label.center.y);
    }
    
    label.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         label.center = CGPointMake(160,label.center.y);
         
     }completion:^(BOOL finished)
     {
         
     }];
    
    OldPage = pageNumber;
}

-(void)scrollViewdidend
{
    label.alpha = 1.0;
}

- (void)didScroll:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView point:(CGPoint)thePoint
{
    
    
    float point_x = (label.center.x - 1*(thePoint.x - oldPoint.x));
    
    label.center = CGPointMake(point_x,label.center.y);
    
    NSLog(@"000000   %f",point_x);
    if (label.center.x - (thePoint.x - oldPoint.x) -160 > 0)
    {
        label.alpha = fabs((double)((320-point_x)/160));
    }else
    {
        label.alpha = fabs((double)point_x/160);
    }
    oldPoint = thePoint;
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:pageNumber];
        label.text=[userdict objectForKey:@"USER_NICK"];
        
        
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:pageNumber];
            label.text=[userdict objectForKey:@"USER_NICK"];
            
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    if (mark==0) {
        return [self.creatUser count];
        
    }
    else{
        
        return [self.joinUser count];
        
    }
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    NSLog(@"index = %d",index);
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    
    NSURL *urlPic;
    int numberFloagShowFriend=0;
    if (!imageView)
    {
        imageView = [[UIImageView alloc] init];
        //imageView.layer.cornerRadius = 70;
        imageView.tag = index+1000;
        imageView.layer.masksToBounds = YES;
        
        imageView.userInteractionEnabled = YES;
        imageView.layer.borderColor=[[UIColor whiteColor] CGColor];
        NSLog(@"yyyyyyyyyyyyyyy%d",mark);
        
        [imageView setImageWithURL:urlPic refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];//[UIImage imageNamed:@"13.jpg"];
        imageView.layer.borderWidth=5;
        imageView.layer.shadowColor= [UIColor blackColor].CGColor;
        imageView.layer.shadowOpacity=20;
        imageView.layer.shadowOffset = CGSizeMake(0, 3);
        
        
    }
    imageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:index];
        urlPic=[NSURL URLWithString:[userdict objectForKey:@"USER_PIC"]];
        int i=0;
        for (NSDictionary *dicJion in [party objectForKey:@"creaters"])
        {
            NSString *stringInStatues=[dicJion objectForKey:@"IN_STATUS"];
            NSString *stringTakeStatues=[dicJion objectForKey:@"USER_STATUS"];
            if ([[stringInStatues substringToIndex:1]isEqualToString:@"Y"]&&[[stringTakeStatues substringToIndex:1]isEqualToString:@"W"])
            {
                if (i==index) {
                    imageView.layer.borderColor=[[UIColor blackColor] CGColor];
                    numberFloagShowFriend=1;
                }
            }
            i++;
        }
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:index];
            urlPic=[NSURL URLWithString:[userdict objectForKey:@"USER_PIC"]];
        }
    }
    if (numberFloagShowFriend==0) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView addGestureRecognizer:tap];
    }
    //    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index]];
    NSLog(@"%@",urlPic);
    [imageView setImageWithURL:urlPic refreshCache:YES placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    return imageView;
}

-(void)doTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"-----%d",sender.view.tag);
    NSString *string_userId;
    if (mark==0) {
        
        NSDictionary* userdict=[self.creatUser objectAtIndex:sender.view.tag-1000];
        string_userId=[userdict objectForKey:@"USER_ID"];
    }
    if (mark==1) {
        NSDictionary* userdict=[self.joinUser objectAtIndex:sender.view.tag-1000];
        string_userId =[userdict objectForKey:@"USER_ID"];
    }
    friendsViewController=[[friendinfoViewController alloc] init];
    friendsViewController.user_id=string_userId;
    NSLog(@"wqqqqqqqqqqqqqqqqq%@",friendsViewController.user_id);
    [self.navigationController pushViewController:friendsViewController animated:YES];
    
}

//================================设置隐藏tableBar====================================
-(void)JumpCollection
{
    if ([[party objectForKey:@"P_TYPE"]intValue]==3) {
        addrdetail=[[AddrDetailViewController alloc]init];
        addrdetail.C_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:addrdetail animated:YES];
    }
    
    if ([[party objectForKey:@"P_TYPE"]intValue]==2)
    {
        acdetail=[[DetailViewController alloc]init];
        acdetail.C_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:acdetail animated:YES];
    }
}
-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

@end
