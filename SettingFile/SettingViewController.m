//
//  SettingViewController.m
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import "SettingViewController.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize tableV;
@synthesize keys;
@synthesize words;
@synthesize userUUid;
@synthesize dictory;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sinaFlag=1;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getUUidForthis];
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"mySinaShare.txt"];
    NSString *content=@"YES";
    //NSLog(@"wosds%@",content);
    NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObject:content];
    //NSLog(@"sadafdasfas%@",uuidMutablearray);
    [uuidMutablearray writeToFile:fileName atomically:YES];
    switchView = [[RESwitch alloc] initWithFrame:CGRectMake(220, 10, 76, 28)];
    //========新浪登陆初始化=================
    tableV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, mainscreenhight-44-44) style:UITableViewStyleGrouped];
    tableV.dataSource=self;
    tableV.delegate=self;
    tableV.backgroundView=nil;
    tableV.backgroundColor=[UIColor colorWithRed:226.0/255 green:224.0/255 blue:219.0/255 alpha:1];
    [self.view addSubview:tableV];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%f %f",self.view.frame.size.height,self.view.bounds.size.width);
    
}
-(void)requestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"wang luo bu gei li");
    //    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力，没有获取到数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [soundAlert show];
    //    [soundAlert release];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (sinaFlag==10) {
        NSData* response=[request responseData];
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"1111111111111111guojiangwei %@",bizDic);
        if ([[bizDic objectForKey:@"status"] isEqualToString:@"bangding"])  {
            sinaFlag=1;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该新浪微博已经被绑定过" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            sinaFlag=1;
            [tableV reloadData];
        }
    }
    else{
        NSData* response=[request responseData];
        NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"guojiangwei %@",bizDic);
        self.dictory=bizDic;
        name=[[NSString alloc] initWithFormat:@"%@",[[self.dictory objectForKey:@"root"] objectForKey:@"USER_NICK"]];
        [tableV reloadData];
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
    if (userUUid==nil) {
        self.userUUid=@"10002";
        NSLog(@"wwwwwwwwwwwwwwwwwwww%@",self.userUUid);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2)
        return 3;
    if(section==3)
        return 2;
    else
        return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section=[indexPath section];
    NSUInteger row=[indexPath row];
    static NSString *simpleTableIdentifer=@"simpleTableIdentifer";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifer];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    if (section==2) {
        if (row==0) {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang1"]];
        }
        if(row==1)
        {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang2"]];
        }
        if (row==2) {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang3"]];
        }
    }
    else if(section==3){
        if(row==0)
        {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"creatkuangA"]];
        }
        if (row==1) {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang3"]];
        }
    }
    else{
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang4"]];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (section==0) {
        cell.textLabel.text=@"新浪微博";
        if (sinaFlag==10) {
            [button setBackgroundImage:[UIImage imageNamed:@"settingyibangding"] forState:UIControlStateSelected];
            [cell.contentView addSubview:button];
            button.userInteractionEnabled=NO;
        }
        else{
            button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(242, 7, 51, 29);
          
            NSString *xinLang=[[self.dictory objectForKey:@"user_bounndid"] objectForKey:@"BOUND_XIN"];
            
            NSLog(@"%@",xinLang);
            if ([xinLang isEqualToString:@"0"]||[xinLang isEqualToString:@"1"]) {
                [button setBackgroundImage:[UIImage imageNamed:@"settingbangding"] forState:UIControlStateNormal];
                
                [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [button setBackgroundImage:[UIImage imageNamed:@"settingyibangding"] forState:UIControlStateNormal];
            }
            [button setAlpha:1];
            
            [cell.contentView addSubview:button];
        }
    }
    if (section==1) {
        cell.textLabel.text=@"我的好友";
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(282, 13, 10, 15)];
        takeimage.image=[UIImage imageNamed:@"settinggo"];
        [cell.contentView addSubview:takeimage];
    }
    if (section==2){
        if(indexPath.row==0){
            UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(282, 18, 10, 15)];
            takeimage.image=[UIImage imageNamed:@"settinggo"];
            [cell.contentView addSubview:takeimage];
            
            cell.textLabel.text=name;
            UIImageView* imgView=[[UIImageView alloc]initWithFrame:CGRectMake(230, 6, 41, 41)];
            imgView.layer.borderColor=[[UIColor whiteColor] CGColor];
            imgView.layer.borderWidth=1;
            //圆角设置
            imgView.layer.cornerRadius = 6;
            imgView.layer.masksToBounds = YES;
            
            NSURL* imageurl=[NSURL URLWithString:[[self.dictory objectForKey:@"root"] objectForKey:@"USER_PIC"]];
            [imgView setImageWithURL:imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            [cell.contentView addSubview:imgView];
        }
        else if(indexPath.row==1){
            
            UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(282, 13, 10, 15)];
            takeimage.image=[UIImage imageNamed:@"settinggo"];
            [cell.contentView addSubview:takeimage];
        }
        else if(indexPath.row==2){
            
            [switchView setBackgroundImage:[UIImage imageNamed:@"backgrey"]];
            [switchView setKnobImage:[UIImage imageNamed:@"anniu"]];
            [switchView setOverlayImage:nil];
            [switchView setHighlightedKnobImage:nil];
            [switchView setCornerRadius:4];
            [switchView setKnobOffset:CGSizeMake(0, 0)];
            
            switchView.layer.cornerRadius = 4;
            switchView.layer.borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1].CGColor;
            switchView.layer.borderWidth = 1;
            switchView.layer.masksToBounds = YES;
            [switchView addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
            switchView.on = YES;
            [cell.contentView addSubview:switchView];
        }
        if(indexPath.row==1){
            cell.textLabel.text=@"我的账号";
        }if(indexPath.row==2){
            cell.textLabel.text=@"同步新浪微博";
        }
    }
    if(section==3){
        if(row==0){
            cell.textLabel.text=@"关于Combo";
            UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(282, 13, 10, 15)];
            takeimage.image=[UIImage imageNamed:@"settinggo"];
            [cell.contentView addSubview:takeimage];
        }
        if(row==1)
        {
            cell.textLabel.text=@"支持我们投一票";
            button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(242, 7, 40, 27);
            [button setBackgroundImage:[UIImage imageNamed:@"settingtoupiao"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(toupiao:) forControlEvents:UIControlEventTouchUpInside];
            [button setAlpha:1];
            
            [cell.contentView addSubview:button];
        }
    }
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    cell.textLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    cell.backgroundColor=[UIColor clearColor];
//    cell.textLabel.font=[UIFont systemFontOfSize:14];
//    cell.textLabel.textColor=[UIColor lightGrayColor];
    //新浪标志位
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    //headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    if (section == 0) {
        headerLabel.text =  @"   授权设置";
    }
    if(section==1)
    {
        headerLabel.text=@"   好友管理";
    }
    if (section == 2){
        headerLabel.text = @"   账号设置";
    }
    if(section==3) headerLabel.text = @"   其他设置";
    [customView addSubview:headerLabel];
    return customView;
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    if (sinaFlag==10) {
        
    }
    else{
        [self getUUidForthis];
        NSString* str=[NSString stringWithFormat:@"mac/user/IF00030?uuid=%@",self.userUUid];
        NSString *stringUrl=globalURL(str);
        
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
        [super viewDidAppear:animated];
        //[self.tableV reloadData];
    }
}
//索引表
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return NULL;
}

-(void)toupiao:(UIButton *)btn{
    ;
}
-(void)ButtonClick:(UIButton *)btn
{
    if (btn.selected==NO) {
        btn.selected=YES;
        _weiboSignIn = [[WeiboSignIn alloc] init];
        _weiboSignIn.delegate = self;
        //button.userInteractionEnabled=NO;
        sinaFlag=10;
        button.frame=CGRectMake(244, 10, 46, 28);
        [_weiboSignIn signInOnViewController:self];
        
    }
    else{
        btn.selected=NO;
        button.frame=CGRectMake(247, 10, 43, 28);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            return 54;
        }
        else
            return 41;
    }
    else
    {
        return 42;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3) {
        return 40;
    }
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=3;
        friend.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:friend animated:YES];
    }
    else if (indexPath.section==2){
        if (indexPath.row==0) {
            person=[[MyDetailViewController alloc]init];
            person.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:person animated:YES];
        }
        else if (indexPath.row==1) {
            idViewController=[[IDViewController alloc]init];
            idViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:idViewController animated:YES];
            
        }
    }
    else if(indexPath.section==3){
        if(indexPath.row==0){
            aboutVC=[[AboutViewController alloc]init];
            aboutVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
}
#pragma mark - SinaWeibo Delegate
- (void)finishedWithAuth:(WeiboAuthentication *)auth error:(NSError *)error {
    if (error) {
        NSLog(@"failed to auth: %@", error);
    }
    else {
        NSLog(@"Success to auth: %@", auth.userId);
        sinaFlag=10;
        NSString* str=[NSString stringWithFormat:@"mac/user/IF00107?suid=%@",auth.userId];
        NSString* strURL=globalURL(str);
        NSURL *url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setDelegate:self];
        [rrequest startAsynchronous];
        [[WeiboAccounts shared]addAccountWithAuthentication:auth];
    }
}
- (void)switchViewChanged:(RESwitch *)switchView
{
    NSLog(@"Value: %i", switchView.on);
    if (switchView.on==0) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
        NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"mySinaShare.txt"];
        NSString *content=@"NO";
        //NSLog(@"wosds%@",content);
        NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObject:content];
        //NSLog(@"sadafdasfas%@",uuidMutablearray);
        [uuidMutablearray writeToFile:fileName atomically:YES];

    }
    if (switchView.on==1) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
        NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"mySinaShare.txt"];
        NSString *content=@"YES";
        //NSLog(@"wosds%@",content);
        NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObject:content];
        //NSLog(@"sadafdasfas%@",uuidMutablearray);
        [uuidMutablearray writeToFile:fileName atomically:YES];
 
    }
}


@end
