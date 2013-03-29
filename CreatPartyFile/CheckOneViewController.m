//
//  CheckOneViewController.m
//  NavaddTab
//
//  Created by ldci 尹 on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CheckOneViewController.h"
#import "infoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SDImageView+SDWebCache.h"
#import "CreatPartyViewController.h"
#import "WeiboAccount.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
NSInteger prerow=-1;
@interface CheckOneViewController ()

@end

@implementation CheckOneViewController
@synthesize time;
@synthesize type;
@synthesize check_city;
@synthesize check_local;
@synthesize check_name;
@synthesize check_time;

@synthesize userUUid;
@synthesize from_c_id;
@synthesize from_p_id;
@synthesize playList;
@synthesize spot;

@synthesize list;
@synthesize lastIndexPath;
//@synthesize Cell;
@synthesize delegateFriend;
@synthesize lng;
@synthesize lat;


-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 40, 35);
    [backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    stateDictionary=[[NSMutableDictionary alloc]init];
    temp=0;
    
    [super viewDidLoad];
    [self getUUidForthis];
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
    self.tableView.backgroundView=nil;
    self.tableView.delegate=self;
    self.title=@"好友列表";
    //******************************右侧确认按钮************************************
    //确定
    
    if(self.spot!=3){
        [self done];
    }
    choiceFriends=[[NSMutableArray alloc]init];
    sinaFriends=[[NSMutableArray alloc]init];
    sinaList=[[NSMutableArray alloc]init];
    if(self.spot==2)
        [self loadPartydetail];
    else{
        [self loadFridetail];
        //[self loadXinDetail];
    }

    //******************************右侧确认按钮 end************************************
}

-(void)done{
    UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    donebutton.frame=CGRectMake(0.0, 0.0, 47, 35);
    [donebutton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [donebutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
    if(temp!=0||self.from_p_id!=0){
        self.navigationItem.rightBarButtonItem=Makedone;
    }else
    {
        self.navigationItem.rightBarButtonItem=nil;
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
    self.userUUid=stringUUID;
}

//从服务器获取好友数据
-(void)loadFridetail{
    dataFlag=1;
    NSString* str=[NSString stringWithFormat:@"mac/user/IF00009?uuid=%@",userUUid];
    NSString *stringUrl=globalURL(str);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

//从服务器获取玩伴数据

-(void)loadPartydetail{
    dataFlag=2;
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00007?uuid=%@&&c_id=%@",userUUid,self.from_c_id];
    NSString *stringUrl=globalURL(str);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}
//从服务器获取新浪互粉好友
-(void)loadXinDetail{
    dataFlag=3;
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"mySinaId.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *userId=[stringmutable objectAtIndex:0];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirs=[paths objectAtIndex:0];
    NSString *imagePaths=[docDirs stringByAppendingPathComponent:@"mySinaAccesstoken.txt"];
    NSMutableArray *stringmutables=[NSMutableArray arrayWithContentsOfFile:imagePaths];
    NSString *accessToken=[stringmutables objectAtIndex:0];
    NSLog(@"输出新浪的id===%@和token===%@",userId,accessToken);
    
    NSString *stringUrl=[NSString stringWithFormat:@"https://api.weibo.com/2/friendships/friends/bilateral.json?uid=%@&access_token=%@",userId,accessToken];
    NSLog(@"接口1：：：：%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    //[request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];

}


//******************************ASIHttp 代理方法************************************
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (dataFlag==3) {//新浪好友
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        sinaList=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        NSLog(@"%@",bizDic);
        NSLog(@"新浪列表finish=============%@",sinaList);
    }
    else if (dataFlag==2) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        playList=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        [self loadFridetail];
        NSLog(@"玩伴列表finish=============%@",self.list);
    }
    
    if(dataFlag==1){
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        list=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        NSLog(@"好友列表finish=============%@",self.list);
        [self loadXinDetail];
    }
    NSLog(@"好友列表finish=============%@",self.list);
    [self.tableView reloadData];
}

//请求失败
- ( void )requestFailed:( ASIHTTPRequest *)request
{
    NSError *error = [request error ];
    NSLog ( @"%@" ,error. userInfo );
}
//******************************ASIHttp 代理方法 end************************************

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.spot==2) {
        return 3;
    }
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回好友数据
    if(section==0)
        return [self.list count];
    else if(section==1)
        return [sinaList count];
    else
        return [self.playList count];//返回玩伴数据
}

//******************************section标题************************************
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *image= [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320, 20)];
    image.backgroundColor=[UIColor clearColor];
    if(section==0)
        [image setImage:[UIImage imageNamed:@"there"]];
    if(section==1)
        [image setImage:[UIImage imageNamed:@"sinafirengds"]];
    if(section==2)
        [image setImage:[UIImage imageNamed:@"gather"]];
    return image;
}
//******************************section标题 end************************************

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    NSUInteger row=[indexPath row];
    NSDictionary *dic=[NSDictionary dictionary];
    if(indexPath.section==0){
        dic=[self.list objectAtIndex:row];
        NSLog(@"好友列表=============%@",self.list);
    }
    else if(indexPath.section==1){
        dic=[sinaList objectAtIndex:row];
        //NSLog(@"新浪互粉=============%@",sinaList);
    }
    else if(indexPath.section==2){
        dic=[self.playList objectAtIndex:row];
        NSLog(@"玩伴列表=============%@",self.playList);
    }
    
    
//*****************************头像**************************************
    UIImageView* imgView=[[UIImageView alloc]initWithFrame:CGRectMake(9, 8, 40, 40)];
    imgView.layer.borderColor=[[UIColor colorWithRed:130.0/255 green:119.0/255 blue:114.0/255 alpha:1] CGColor];
    imgView.layer.borderWidth=1;
    //圆角设置
    imgView.layer.cornerRadius = 6;
    imgView.layer.masksToBounds = YES;

    
    NSURL* imageurl;
    if(indexPath.section==1) imageurl=[NSURL URLWithString:[dic objectForKey:@"avatar_large"]];
    else
        imageurl=[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]];
    [imgView setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [cell.contentView addSubview:imgView];
    //*****************************头像 end**************************************
    
    //*****************************性别***********************************
    UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(58, 12, 12, 16)];
    if(indexPath.section==1){
        if([[[dic objectForKey:@"gender"]substringToIndex:1] isEqualToString:@"m"])
            seximage.image=[UIImage imageNamed:@"FIRENDSmale"];
        else
            seximage.image=[UIImage imageNamed:@"FIRENDSfemale"];
    }else{
        if([[[dic objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"M"])
            seximage.image=[UIImage imageNamed:@"FIRENDSmale"];
        else
            seximage.image=[UIImage imageNamed:@"FIRENDSfemale"];
    }
    [cell.contentView addSubview:seximage];
    //*****************************性别 end***********************************
    
    //*****************************姓名***********************************
    UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 9, 200, 20)];
    namelabel.font=[UIFont systemFontOfSize:14];
    if(indexPath.section==1) namelabel.text=[dic objectForKey:@"name"];
    else
        namelabel.text=[dic objectForKey:@"USER_NICK"];
    namelabel.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
    namelabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:namelabel];
    //*****************************姓名 end***********************************
    
    //*****************************年龄***********************************
    UILabel* agelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25 , 25, 30)];
    agelabel.font=[UIFont systemFontOfSize:13];
    agelabel.backgroundColor=[UIColor clearColor];
    agelabel.textColor=[UIColor grayColor];
    if(indexPath.section!=1) agelabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"USER_AGE"]];
    [cell.contentView addSubview:agelabel];
    //*****************************年龄 end***********************************
    if (indexPath.section==1) {
        //*****************************城市 地区***********************************
        UILabel* citylabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25, 100, 30)];
        citylabel.font=[UIFont systemFontOfSize:13];
        citylabel.backgroundColor=[UIColor clearColor];
        citylabel.textColor=[UIColor grayColor];
        if (![[dic objectForKey:@"location"] isEqualToString:@"(null)"]) {
            citylabel.text=[dic objectForKey:@"location"];
        }
        [cell.contentView addSubview:citylabel];
        //*****************************城市 地区 end**********************************
    }else{
        //*****************************城市 地区***********************************
        UILabel* citylabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 25, 40, 30)];
        citylabel.font=[UIFont systemFontOfSize:13];
        citylabel.backgroundColor=[UIColor clearColor];
        citylabel.textColor=[UIColor grayColor];
        if (![[dic objectForKey:@"USER_CITY"] isEqualToString:@"(null)"]) {
            citylabel.text=[dic objectForKey:@"USER_CITY"];
        }
        
        UILabel* locallabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 25, 100, 30)];
        locallabel.font=[UIFont systemFontOfSize:13];
        locallabel.backgroundColor=[UIColor clearColor];
        locallabel.textColor=[UIColor grayColor];
        if (![[dic objectForKey:@"USER_LOCAL"] isEqualToString:@"(null)"]) {
            locallabel.text=[dic objectForKey:@"USER_LOCAL"];
        }
        [cell.contentView addSubview:citylabel];
        [cell.contentView addSubview:locallabel];
    }
    //*****************************城市 地区 end**********************************
    if (self.spot!=3) {
        UIImageView *imagView=[[UIImageView alloc]initWithFrame:CGRectMake(287,19,21,21)];
        imagView.image=[UIImage imageNamed:@"creatframe"];
        imagView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:imagView];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Set cell label
    NSString *key = [@"Row " stringByAppendingFormat:@"%d,%d",indexPath.section,indexPath.row];
    //cell.textLabel.text = key;
    
    // Set cell checkmark
    NSNumber *checked = [stateDictionary objectForKey:key];
    if (!checked) [stateDictionary setObject:(checked = [NSNumber numberWithBool:NO]) forKey:key];
    cell.accessoryType = checked.boolValue ? UITableViewCellAccessoryCheckmark :  UITableViewCellAccessoryNone;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self.spot!=3){
        if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
            //************************添加对勾************************************
            UIImage *image= [UIImage imageNamed:@"creatcancel"];
            CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
            button.frame = frame;
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            cell.accessoryView=button;
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Recover the cell and key
	UITableViewCell *newcell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *key = [@"Row " stringByAppendingFormat:@"%d,%d",indexPath.section,indexPath.row];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
	    
    
    //******************************查看好友详细信息************************************
    if (spot==3) {
        if(indexPath.section!=1){
            newcell.accessoryType=UITableViewCellAccessoryNone;
            self.hidesBottomBarWhenPushed=YES;
            infoViewController *info=[[infoViewController alloc]init];
            info.user_id=[[self.list objectAtIndex:indexPath.row] objectForKey:@"USER_ID"];
            [self.navigationController pushViewController:info animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        else{
            newcell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    //******************************查看好友详细信息 end************************************
    else{
        // Created an inverted value and store it
        BOOL isChecked = !([[stateDictionary objectForKey:key] boolValue]);
        
        
        NSNumber *checked = [NSNumber numberWithBool:isChecked];
        
        
        [stateDictionary setObject:checked forKey:key];
        
        
        // Update the cell accessory checkmark
        newcell.accessoryType = isChecked ? UITableViewCellAccessoryCheckmark :  UITableViewCellAccessoryNone;

        if(newcell.accessoryType==UITableViewCellAccessoryCheckmark){
            if (temp<4) {
                //if(newcell.accessoryType=UITableViewCellAccessoryCheckmark){
                //************************添加对勾************************************
                UIImage *image= [UIImage   imageNamed:@"creatcancel"];
                CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
                button.frame = frame;
                [button setBackgroundImage:image forState:UIControlStateNormal];
                button.backgroundColor = [UIColor clearColor];
                newcell.accessoryView=button;
                //[newcell.contentView addSubview:button];
                //************************添加对勾 end************************************
                if(indexPath.section==0)
                    [choiceFriends addObject:[self.list objectAtIndex:indexPath.row]];
                else if (indexPath.section==1)
                    [sinaFriends addObject:[sinaList objectAtIndex:indexPath.row]];
                else
                    [choiceFriends addObject:[self.playList objectAtIndex:indexPath.row]];
                if(self.spot==1) temp++;
                //}
            }else{
                [stateDictionary setObject:[NSNumber numberWithBool:NO] forKey:key];
                newcell.accessoryType=UITableViewCellAccessoryNone;//超过5人不能继续添加
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"人数不能超过4人" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor= [UIColor clearColor];
            newcell.accessoryView= button;
            [stateDictionary setObject:[NSNumber numberWithBool:NO] forKey:key];
            newcell.accessoryType=UITableViewCellAccessoryNone;//超过4人不能继续添加
            if(indexPath.section==0)
                [choiceFriends removeObject:[self.list objectAtIndex:indexPath.row]];
            else if(indexPath.section==1)
                [sinaFriends removeObject:[sinaList objectAtIndex:indexPath.row]];
            if(self.spot==1) temp--;
        }
        //lastIndexPath=indexPath;
    }
    [self done];
}

//******************************上传邀请好友信息************************************
-(void)rightAction{
    
    if (self.from_p_id!=0) {
        NSString* str=@"mac/party/IF00023";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        for (int i=0; i<[choiceFriends count]; i++) {
            ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
            [request setPostValue:self.userUUid forKey: @"uuid"];
            [request setPostValue:[[choiceFriends objectAtIndex:i] objectForKey:@"USER_ID"] forKey:@"user_id"];
            [request setPostValue:self.from_p_id forKey:@"p_id"];
            //[request setDelegate:self];
            [request startSynchronous];
        }
        NSString *stringnameShare=@"我的新浪微博";
        NSLog(@"friendid 数组%@",sinaFriends);
        for (int i=0; i<[sinaFriends count]; i++) {
            NSString *suid=[[sinaFriends objectAtIndex:i] objectForKey:@"id"];
            NSString *nick=[[sinaFriends objectAtIndex:i] objectForKey:@"name"];
            NSString *pic=[[sinaFriends objectAtIndex:i] objectForKey:@"avatar_large"];
            NSString *sex=[[sinaFriends objectAtIndex:i] objectForKey:@"gender"];
            NSString *location=[[sinaFriends objectAtIndex:i] objectForKey:@"location"];
            
            NSString *tempString=[NSString stringWithFormat:@"@%@",nick];
            stringnameShare=[stringnameShare stringByAppendingString:tempString];
            NSLog(@"suid==%@,nick==%@,pic=%@,sex=%@,location==%@",suid,nick,pic,sex,location);
            
        }
        NSLog(@"friendid 数组%@",choiceFriends);
        for (int i=0; i<[choiceFriends count]; i++) {
            
            NSString *tempString=[NSString stringWithFormat:@"@%@",[[choiceFriends objectAtIndex:i] objectForKey:@"USER_NICK"]];
            stringnameShare=[stringnameShare stringByAppendingString:tempString];
            
        }
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        //NSFileManager *fm=[NSFileManager defaultManager];
        NSString *imagePath=[docDir stringByAppendingPathComponent:@"mySinaShare.txt"];
        NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
        NSString *shareSina=[stringmutable objectAtIndex:0];
        NSLog(@"wwwwwwwwwwwwwwwwwwww%@",shareSina);
        if ([shareSina isEqualToString:@"YES"]) {
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDirs=[paths objectAtIndex:0];
            NSString *imagePaths=[docDirs stringByAppendingPathComponent:@"mySinaAccesstoken.txt"];
            NSMutableArray *stringmutables=[NSMutableArray arrayWithContentsOfFile:imagePaths];
            NSString *accessToken=[stringmutables objectAtIndex:0];
            NSLog(@"输出新浪的token===%@",accessToken);
            NSString *stringUrl=@"https://api.weibo.com/2/statuses/update.json";
            NSLog(@"接口1：：：：%@",stringUrl);
            NSURL* url=[NSURL URLWithString:stringUrl];
            ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
            [request setPostValue:stringnameShare forKey: @"status"];
            [request setPostValue:accessToken forKey: @"access_token"];
            //[request setDelegate:self];
            [request startAsynchronous];
        }
        [SVProgressHUD show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(show) userInfo:nil repeats:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        NSLog(@"self.choiceFriends=======%@",choiceFriends);
        NSLog(@"self.choiceFriends=======%@",sinaFriends);
        
        NSLog(@"传值。。。。。。%@,%@",self.check_time,self.check_name);
        party=[[CreatPartyViewController alloc]init];
        party.from_P_type=self.type;
        party.P_title=self.check_name;
        party.P_time=self.check_time;
        party.map_city=self.check_city;
        party.map_local=self.check_local;
        party.friengArr=choiceFriends;
        party.sinaArr=sinaFriends;
        party.lat=self.lat;
        party.lng=self.lng;
        party.time=self.time;
        party.from_C_id=self.from_c_id;
        
        NSLog(@"self.choiceFriends=======%@",choiceFriends);
        NSLog(@"self.choiceFriends=======%@",sinaFriends);
        
        NSLog(@"传值。。。。。====%@",self.time);
        
        NSLog(@"self.choiceFriends=======%@",party.friengArr);
        
        NSLog(@"传值。。。。。。%@,%@",party.P_title,party.P_time);
        
        [self.navigationController pushViewController:party animated:YES];
        
        NSLog(@"传值。。。。。====%@",party.time);

        
        NSLog(@"传值。。。。。。%@,%@",party.P_title,party.P_time);

        NSLog(@"self.choiceFriends=======%@",party.friengArr);
    }
//    
//    if(self.spot==1){
//        if (self.from_p_id==0)
//            [delegateFriend CallBack:choiceFriends];
//        //[self.choiceFriends removeAllObjects];
//    }
}
//******************************上传邀请好友信息 end************************************

-(void)show{
    [SVProgressHUD dismissWithSuccess:@"成功发送邀请！"];
}

//******************************删除好友************************************


- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.spot==3) {
        if(indexPath.section!=1)
            return UITableViewCellEditingStyleDelete;
        else{
            return UITableViewCellAccessoryNone;
        }
    }else
        return UITableViewCellEditingStyleNone;
	//不能是UITableViewCellEditingStyleNone
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.spot==3) {
        NSString* str=@"mac/user/IF00022";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey:@"uuid"];
        [rrequest setPostValue:[[self.list objectAtIndex:indexPath.row] objectForKey:@"USER_ID"] forKey:@"user_id"];
        NSLog(@"user_id====%@",[self.list objectAtIndex:indexPath.row]);
        [rrequest startSynchronous];
        
        [self.list removeObjectAtIndex:indexPath.row];
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        [self.tableView reloadData];
    }
}
//******************************删除好友 end************************************


-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

@end
