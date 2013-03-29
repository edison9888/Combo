//
//  PartyViewController.m
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import "PartyViewController.h"

@interface PartyViewController ()

@end

@implementation PartyViewController
@synthesize tableViewParty;
@synthesize sumArray;
@synthesize userUUid;
@synthesize lat,lng;
int itttt=0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title=@"活动";
    }
    return self;
}

-(void)allButtonPressed
{
    [self.tableViewParty reloadData];
    self.tableViewParty.contentOffset=CGPointMake(0.0, 0.0);
    flag=0;
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    ChoseNum=1;
    [Allparty setSelected:YES];
    [ReliableParty setSelected:NO];
    [MyParty setSelected:NO];
    if (segmentNum==0) {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
        NSString* strURL=globalURL(str);
        NSLog(@"全部派对，按照附近距离排序：%@",strURL);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    else
    {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
        NSString* strURL=globalURL(str);
        NSLog(@"全部派对,按照最新时间排序:%@",strURL);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
}
-(void)realiButtonPressed
{
    [self.tableViewParty reloadData];
    self.tableViewParty.contentOffset=CGPointMake(0.0, 0.0);
    
    flag=0;
    ChoseNum=2;
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    [Allparty setSelected:NO];
    [ReliableParty setSelected:YES];
    [MyParty setSelected:NO];
    
    if (segmentNum==0) {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
        NSString* strURL=globalURL(str);
        NSLog(@"靠谱派对，距离排序:%@",strURL);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    else
    {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
        NSString* strURL=globalURL(str);
        NSLog(@"靠谱派对，时间排序:%@",strURL);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
}
-(void)myButtonPressed
{
    [self.tableViewParty reloadData];
    self.tableViewParty.contentOffset=CGPointMake(0.0, 0.0);
    
    flag=0;
    ChoseNum=3;
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    [Allparty setSelected:NO];
    [ReliableParty setSelected:NO];
    [MyParty setSelected:YES];
    if (segmentNum==0) {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
        NSString* strURL=globalURL(str);
        NSLog(@"我的派对，距离排序:%@",strURL);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    else
    {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
        NSString* strURL=globalURL(str);
        NSLog(@"我的派对，时间排序:%@",strURL);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [self getUUidForthis];
    [super viewWillAppear:animated];
    //========附近和最新=========================
    buttonNear=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonNear.frame=CGRectMake(8, 27, 46, 30);
    buttonNear.titleLabel.text=@"最新";
    buttonNear.tag=201;
    [buttonNear setBackgroundImage:[UIImage imageNamed:@"thenew"] forState:UIControlStateNormal];
    [buttonNear setBackgroundImage:[UIImage imageNamed:@"thenewai"] forState:UIControlStateSelected];
    [buttonNear addTarget:self action:@selector(mesActionbutt:) forControlEvents:UIControlEventTouchUpInside];
    [buttonNear setSelected:YES];
    buttonNew=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonNew.frame=CGRectMake(54, 27, 46, 30);
    buttonNew.titleLabel.text=@"附近";
    buttonNew.tag=202;
    [buttonNew setBackgroundImage:[UIImage imageNamed:@"nearby"] forState:UIControlStateNormal];
    [buttonNew setBackgroundImage:[UIImage imageNamed:@"nearbyai"] forState:UIControlStateSelected];
    [buttonNew addTarget:self action:@selector(mesActionbutton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonNew setSelected:NO];
    [self.navigationController.view addSubview:buttonNew];
    [self.navigationController.view addSubview:buttonNear];
    
    logoimage=[[UIImageView alloc]initWithFrame:CGRectMake(140, 5, 40, 34)];
    logoimage.backgroundColor=[UIColor clearColor];
    logoimage.image=[UIImage imageNamed:@"LOGO"];
    [self.navigationController.navigationBar addSubview:logoimage];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [buttonNew removeFromSuperview];
    [buttonNear removeFromSuperview];
    [logoimage removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //=========获取位置==============================
    locationMamager=[[CLLocationManager alloc]init];
    //设置委托
    locationMamager.delegate=self;
    //设置精度为最优
    locationMamager.desiredAccuracy=kCLLocationAccuracyBest;
    //设置距离筛选器
    locationMamager.distanceFilter=100.0f;
    locationMamager.headingFilter=0.1;
    //开始更新数据
    [locationMamager startUpdatingLocation];
    [locationMamager startUpdatingHeading];
    NSLog(@"获取你的经纬度：：：：：：：：经度:%g      纬度:%g",lng,lat);
    flag=0;
    sumArray =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    sumArray=[[NSMutableArray alloc]init];
    ChoseNum=1;
    segmentNum=0;
    flag=0;
    //=====================创建=========================================================
    UIButton* creatButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [creatButton setImage:[UIImage imageNamed:@"make"] forState:UIControlStateNormal];
    creatButton.frame=CGRectMake(0.0, 0.0, 44, 35);
    [creatButton addTarget:self action:@selector(CreateNewAct) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:creatButton];
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableViewParty=table;
    [self.view addSubview:self.tableViewParty];
    tableViewParty.backgroundView=nil;
    tableViewParty.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:219.0/255 alpha:1];
    self.tableViewParty.delegate=self;
    self.tableViewParty.dataSource=self;
    
    Allparty=[UIButton buttonWithType:UIButtonTypeCustom];
    Allparty.frame=CGRectMake(0, 0, 103, 31);
    [Allparty setImage:[UIImage imageNamed:@"1lable"] forState:UIControlStateNormal];
    [Allparty setImage:[UIImage imageNamed:@"11lable"] forState:UIControlStateSelected];
    [Allparty setSelected:YES];
    
    
    ReliableParty=[UIButton buttonWithType:UIButtonTypeCustom];
    ReliableParty.frame=CGRectMake(103, 0, 114, 31);
    [ReliableParty setImage:[UIImage imageNamed:@"2lable"] forState:UIControlStateNormal];
    [ReliableParty setImage:[UIImage imageNamed:@"22lable"] forState:UIControlStateSelected];
    [ReliableParty setSelected:NO];
    
    
    MyParty=[UIButton buttonWithType:UIButtonTypeCustom];
    MyParty.frame=CGRectMake(216, 0, 103, 31);
    [MyParty setImage:[UIImage imageNamed:@"3lable"] forState:UIControlStateNormal];
    [MyParty setImage:[UIImage imageNamed:@"33lable"] forState:UIControlStateSelected];
    [MyParty setSelected:NO];
    
    [self.view addSubview:Allparty];
    [self.view addSubview:ReliableParty];
    [self.view addSubview:MyParty];
    [Allparty addTarget:self action:@selector(allButtonPressed) forControlEvents:UIControlEventTouchDown];
    [ReliableParty addTarget:self action:@selector(realiButtonPressed) forControlEvents:UIControlEventTouchDown];
    [MyParty addTarget:self action:@selector(myButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    PreY=0.0;
    //========下拉刷新=============================
    _slimeView=[[SRRefreshView alloc] init];
    _slimeView.delegate=self;
    _slimeView.upInset=10;
    [tableViewParty addSubview:_slimeView];
    
    //==========================
    
}
-(void)mesActionbutton:(UIButton *)btn
{
    //=====附近========================
    NSLog(@"wwwwwwwwwwwwwww%f,%f",self.lat,self.lng);
    if (self.lat!=0||self.lng!=0) {
        self.tableViewParty.contentOffset=CGPointMake(0.0, 0.0);
        segmentNum=1;
        [self.tableViewParty reloadData];
        flag=0;
        if(ChoseNum==1)
        {
            NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
            NSString* strURL=globalURL(str);
            NSLog(@"全部派对,按照距离排序:%@",strURL);
            NSURL* url=[NSURL URLWithString:strURL];
            ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
            request.delegate = self;
            request.shouldAttemptPersistentConnection = NO;
            [request setValidatesSecureCertificate:NO];
            [request setDefaultResponseEncoding:NSUTF8StringEncoding];
            [request setDidFailSelector:@selector(requestDidFailed:)];
            [request startAsynchronous];
        }
        else
            if (ChoseNum==2) {
                NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                NSString* strURL=globalURL(str);
                NSLog(@"靠谱派对，距离排序:%@",strURL);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                request.shouldAttemptPersistentConnection = NO;
                [request setValidatesSecureCertificate:NO];
                [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                [request setDidFailSelector:@selector(requestDidFailed:)];
                [request startAsynchronous];
                
            }
            else
            {
                if (ChoseNum==3) {
                    NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                    NSString* strURL=globalURL(str);
                    NSLog(@"我的派对，距离排序:%@",strURL);
                    NSURL* url=[NSURL URLWithString:strURL];
                    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                    request.delegate = self;
                    request.shouldAttemptPersistentConnection = NO;
                    [request setValidatesSecureCertificate:NO];
                    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                    [request setDidFailSelector:@selector(requestDidFailed:)];
                    [request startAsynchronous];
                }
            }
        
    }
    [buttonNear setSelected:NO];
    [buttonNew setSelected:YES];
    NSLog(@"11111111");
}
-(void)mesActionbutt:(UIButton *)btn
{
    //======最新========================
    [buttonNear setSelected:YES];
    [buttonNew setSelected:NO];
    NSLog(@"2222222");
    if (self.lng!=0||self.lat!=0) {
        segmentNum=0;
        [self.tableViewParty reloadData];
        self.tableViewParty.contentOffset=CGPointMake(0.0, 0.0);
        if (ChoseNum==1) {
            NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
            NSString* strURL=globalURL(str);
            NSLog(@"全部派对，按照最新排序：%@",strURL);
            NSURL* url=[NSURL URLWithString:strURL];
            ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
            request.delegate = self;
            request.shouldAttemptPersistentConnection = NO;
            [request setValidatesSecureCertificate:NO];
            [request setDefaultResponseEncoding:NSUTF8StringEncoding];
            [request setDidFailSelector:@selector(requestDidFailed:)];
            [request startAsynchronous];
        }
        else
        {
            if (ChoseNum==2) {
                NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                NSString* strURL=globalURL(str);
                NSLog(@"靠谱派对，最新排序:%@",strURL);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                request.shouldAttemptPersistentConnection = NO;
                [request setValidatesSecureCertificate:NO];
                [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                [request setDidFailSelector:@selector(requestDidFailed:)];
                [request startAsynchronous];
                
            }
            else
            {
                NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                NSString* strURL=globalURL(str);
                NSLog(@"我的派对，最新排序:%@",strURL);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                request.shouldAttemptPersistentConnection = NO;
                [request setValidatesSecureCertificate:NO];
                [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                [request setDidFailSelector:@selector(requestDidFailed:)];
                [request startAsynchronous];
                
            }
        }
    }
}

//=============经纬度代理方法=========================================
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //    log.text=[NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
    //    lat.text=[NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
    lng=newLocation.coordinate.longitude;
    lat=newLocation.coordinate.latitude;
    NSLog(@"获取你的经纬度：：：：：：：：经度:%g      纬度:%g",lng,lat);
    [self requestDate];
}

//===========多线程==============================================
-(void)requestDate
{
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
    NSString *stringUrl=globalURL(str);
    NSLog(@"接口1：：：：%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
}
//==============获取用户的UUId===================================================
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
-(void)requestDidFailed:(ASIHTTPRequest *)request
{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"因为服务器或网络原因获取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    isLoading=NO;
    NSData* response=[request responseData];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"dataFile.txt"];
    
    //NSLog(@"wosds%@",content);
    NSMutableArray *dataMutablearray=[NSMutableArray arrayWithObject:response];
    //NSLog(@"sadafdasfas%@",uuidMutablearray);
    [dataMutablearray writeToFile:fileName atomically:YES];
    
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"111111111111111111111111111111%@",bizDic);
    NSArray* array=[bizDic objectForKey:@"partys"];
    
    total=[[bizDic objectForKey:@"total"]intValue];
    NSLog(@"本次返回的数量:%d",total);
    if (flag==0) {
        [sumArray removeAllObjects];
    }
    [sumArray addObjectsFromArray:array];
    //NSLog(@"%@",[array objectAtIndex:0]);
    NSLog(@"总共的数量::::::%d",sumArray.count);
    [self.tableViewParty reloadData];
}

-(void)CreateNewAct
{
    NSLog(@"跳到地图");
    mapControl=[[MapViewController alloc]init];
    mapControl.hidesBottomBarWhenPushed=YES;
    mapControl.title=@"创建派对地点";
    mapControl.type=@"1";
    mapControl.map_Temp=1;
    [self.navigationController pushViewController:mapControl animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sumArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[self.sumArray count]-1) {
        return 160;
    }
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 119;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section=[indexPath section];
    static NSString *cellIndentify=@"BaseCell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    UIImageView *imagePICView0;//类型
    UIImageView *imagePICView1;//其他创建人
    UIImageView *imagePICView2;
    UIImageView *imagePICView3;
    //显示的联合创建人增加一个
    UIImageView* imagePICView6;
    
    UIImageView *imagePICView4;//主创建人
    UIImageView *imagePICView5;//性别
    
    UILabel *lable1;//联合创建人
    UILabel *lable2;//地点距离
    UILabel *lable3;//时间
    UILabel *lable4;//主创建人的名字
    UILabel *lable5;//活动类型
    UILabel *lable7;//活动名称
    imagePICView0=[[UIImageView alloc]initWithFrame:CGRectMake(252, 97, 40, 31)];
    //最小的一个
    imagePICView6=[[UIImageView alloc]initWithFrame:CGRectMake(126, -8, 39, 39)];
    imagePICView1=[[UIImageView alloc]initWithFrame:CGRectMake(103, -10, 41, 41)];
    imagePICView2=[[UIImageView alloc]initWithFrame:CGRectMake(78, -12, 43, 43)];
    imagePICView3=[[UIImageView alloc]initWithFrame:CGRectMake(45, -14, 45, 45)];
    imagePICView4=[[UIImageView alloc]initWithFrame:CGRectMake(9, -16, 47, 47)];
    
    imagePICView5=[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 8, 10)];//性别
    
    UIImageView* prImage=[[UIImageView alloc]initWithFrame:CGRectMake(-1, 19, 302, 96)];//遮罩
    prImage.image=[UIImage imageNamed:@"partylabel"];
    UIImageView* peoImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 77, 15, 15)];
    UIImageView* timeImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 94, 15, 15)];
    peoImage.image=[UIImage imageNamed:@"Person"];
    timeImage.image=[UIImage imageNamed:@"clock"];
    [cell.contentView addSubview:imagePICView6];
    [cell.contentView addSubview:imagePICView1];
    [cell.contentView addSubview:imagePICView2];
    [cell.contentView addSubview:imagePICView3];
    [cell.contentView addSubview:prImage];
    [cell.contentView addSubview:peoImage];
    [cell.contentView addSubview:timeImage];
    
    [cell.contentView addSubview:imagePICView0];
    
    [cell.contentView addSubview:imagePICView4];
    [cell.contentView addSubview:imagePICView5];
    
    lable1=[[UILabel alloc]initWithFrame:CGRectMake(30, 71, 190, 27)];
    lable1.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable1.font=[UIFont systemFontOfSize:12];
    lable1.shadowColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable1.shadowOffset=CGSizeMake(0, -0.5);
    lable2=[[UILabel alloc]initWithFrame:CGRectMake(170, 17, 100, 43)];
    lable2.textColor=[UIColor colorWithRed:56.0/255 green:56.0/255 blue:56.0/255 alpha:1];
    lable2.textAlignment=NSTextAlignmentRight;
    
    lable2.font=[UIFont fontWithName:@"Helvetica-BoldOblique" size:21];
    UILabel* kmlabel=[[UILabel alloc]initWithFrame:CGRectMake(270, 31, 30, 20)];
    kmlabel.textAlignment=NSTextAlignmentLeft;
    kmlabel.textColor=[UIColor colorWithRed:56.0/255 green:56.0/255 blue:56.0/255 alpha:1];
    kmlabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    kmlabel.backgroundColor=[UIColor clearColor];
    kmlabel.text=@"km";
    lable3=[[UILabel alloc]initWithFrame:CGRectMake(30, 85, 244, 35)];
    lable3.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable3.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    lable4=[[UILabel alloc]initWithFrame:CGRectMake(23, 26, 120, 27)];
    lable4.font=[UIFont fontWithName:@"Helvetica-Bold" size:10.0];
    lable4.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable5=[[UILabel alloc]initWithFrame:CGRectMake(252, 87, 40, 37)];
    lable5.textAlignment=NSTextAlignmentCenter;
    lable5.textColor=[UIColor whiteColor];
    lable5.font=[UIFont systemFontOfSize:10.0];
    lable7=[[UILabel alloc]initWithFrame:CGRectMake(10, 42, 250, 35)];
    lable7.font=[UIFont fontWithName:@"Helvetica-Bold" size:19];
    lable7.textColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
    lable1.backgroundColor=[UIColor clearColor];
    lable2.backgroundColor=[UIColor clearColor];
    lable3.backgroundColor=[UIColor clearColor];
    lable4.backgroundColor=[UIColor clearColor];
    lable5.backgroundColor=[UIColor clearColor];
    lable7.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:lable1];
    [cell.contentView addSubview:lable2];
    [cell.contentView addSubview:lable3];
    [cell.contentView addSubview:lable4];
    [cell.contentView addSubview:lable5];
    [cell.contentView addSubview:lable7];
    [cell.contentView addSubview:kmlabel];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary* dict=[self.sumArray objectAtIndex:section];
    NSLog(@"%@",dict);
    
    NSString *stringType=[dict objectForKey:@"P_TYPE"];
    if (![[stringType substringToIndex:1] isEqualToString:@"1"]) {
        lable5.text=[dict objectForKey:@"P_LABLE"];
        imagePICView0.image=[UIImage imageNamed:@"tagparty"];
        //NSLog(@"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq%@",cell.lable5.text);
    }
    if ([[[dict objectForKey:@"P_STATUS"]substringToIndex:1]isEqualToString:@"N"]) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PartyLabelGrey"]];
    }
    else
    {
        if ([[[dict objectForKey:@"P_STATUS"]substringToIndex:1]isEqualToString:@"Y"]) {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"partylabelgreen"]];
        }
        else
        {
            
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"partylabelyellow"]];
            
            
        }
    }
    lable7.text=[dict objectForKey:@"P_TITLE"];
    
    
    NSString* str1=[NSString stringWithFormat:@"%@",[dict objectForKey:@"P_DISTANCE"]];
    int lengthstr=str1.length;
    NSString* str=[str1 substringWithRange:NSMakeRange(0,lengthstr-2)];
    NSMutableString *mutableStringLocal=[[NSMutableString alloc] initWithFormat:@"%@ ",str];
    lable2.text=mutableStringLocal;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
    NSInteger time=[[dict objectForKey:@"P_STIME"]integerValue];
    NSLog(@"%d",time);
    NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",date);
    NSString *confromTimespStr = [formatter stringFromDate:date];
    lable3.text=confromTimespStr;
    //更改过大写
    NSDictionary* user=[dict objectForKey:@"USER"];
    lable4.text=[user objectForKey:@"USER_NICK"];
    
    //================创建者图片=============================================
    NSString* picurl=[user objectForKey:@"USER_PIC"];
    //NSLog(@"创建者图片网址:::%@",picurl);
    [imagePICView4 setImageWithURL:[NSURL URLWithString:picurl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    //[imagePICView4 setImageWithURL:[NSURL URLWithString:[user objectForKey:@"USER_PIC"]]];
    imagePICView4.layer.borderColor=[[UIColor whiteColor] CGColor];
    imagePICView4.layer.borderWidth=2;
    imagePICView4.layer.shadowOffset = CGSizeMake(0, 0);
    imagePICView4.layer.shadowOpacity = 0.5;
    imagePICView4.layer.shadowRadius = 5;
    //NSLog(@"输出照片%@",[user objectForKey:@"USER_PIC"]);
    if ([[[user objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"M"]) {
        imagePICView5.image=[UIImage imageNamed:@"PartyMale"];
        //NSLog(@"wwwwwwwwwwwwww%@",cell.imagePICView5.image);
    }
    if ([[[user objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"F"]) {
        imagePICView5.image=[UIImage imageNamed:@"Partyfemale"];
    }
    //===============联合创建人名字和照片======================================
    NSDictionary * mutableArrayDic=[dict objectForKey:@"Users"];
    NSMutableString *stringNameAll=[[NSMutableString alloc]init];
    int i=0;
    for (NSDictionary *dic in mutableArrayDic) {
        NSString *stringNameUin=[dic objectForKey:@"USER_NICK"];
        [stringNameAll appendFormat:@"%@,",stringNameUin];
        
        if (i==0) {
            [imagePICView3 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
            imagePICView3.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView3.layer.borderWidth=2;
            imagePICView3.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView3.layer.shadowOpacity = 0.5;
            imagePICView3.layer.shadowRadius = 2.0;
            
        }
        if (i==1) {
            [imagePICView2 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
            imagePICView2.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView2.layer.borderWidth=2;
            imagePICView2.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView2.layer.shadowOpacity = 0.5;
            imagePICView2.layer.shadowRadius = 2.0;
            //NSLog(@"11111111111111%@",imagePICView2.image);
            
        }
        if (i==2) {
            [imagePICView1 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
            imagePICView1.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView1.layer.borderWidth=2;
            imagePICView1.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView1.layer.shadowOpacity = 0.5;
            imagePICView1.layer.shadowRadius = 2.0;
            
        }
        if (i==3) {
            [imagePICView6 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            imagePICView6.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView6.layer.borderWidth=2;
            imagePICView6.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView6.layer.shadowOpacity = 0.5;
            imagePICView6.layer.shadowRadius = 2.0;
        }
        //NSLog(@"11111111111111%@",cell.imagePICView3.image);
        i++;
    }
    NSMutableString *mutableStringPerson=[[NSMutableString alloc] initWithFormat:@"%@",stringNameAll];
    lable1.text=mutableStringPerson;
    
    return cell;
}

//加载更多
-(void)PartyClickMore
{
    flag=1;
    NSLog(@"本次返回的数量:%d",total);
    if (total<mytotal) {
        //返回的结果已经是所有的了，不需要在加载
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"加载完毕" message:@"所有数据已经加载完毕" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
    }
    else{
        if (segmentNum==0) {
            //加载更多,附近
            if (ChoseNum==1) {
                NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=1&&lat=%f&&lng=%f&&from=%d",userUUid,self.lat,self.lng,self.sumArray.count+1];
                NSString* strURL=globalURL(str);
                NSLog(@"全部派对，按照附近距离排序：%@",strURL);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                request.shouldAttemptPersistentConnection = NO;
                [request setValidatesSecureCertificate:NO];
                [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                [request setDidFailSelector:@selector(requestDidFailed:)];
                [request startAsynchronous];
                
            }
            else
            {
                if (ChoseNum==2) {
                    NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=1&&lat=%f&&lng=%f&&from=%d",userUUid,self.lat,self.lng,self.sumArray.count+1];
                    NSString* strURL=globalURL(str);
                    NSLog(@"靠谱派对，距离排序:%@",strURL);
                    NSURL* url=[NSURL URLWithString:strURL];
                    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                    request.delegate = self;
                    request.shouldAttemptPersistentConnection = NO;
                    [request setValidatesSecureCertificate:NO];
                    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                    [request setDidFailSelector:@selector(requestDidFailed:)];
                    [request startAsynchronous];
                    
                }
                else
                    if (ChoseNum==3) {
                        NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=1&&lat=%f&&lng=%f&&from=%d",userUUid,self.lat,self.lng,self.sumArray.count+1];
                        NSString* strURL=globalURL(str);
                        NSLog(@"我的派对，距离排序:%@",strURL);
                        NSURL* url=[NSURL URLWithString:strURL];
                        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                        request.delegate = self;
                        request.shouldAttemptPersistentConnection = NO;
                        [request setValidatesSecureCertificate:NO];
                        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                        [request setDidFailSelector:@selector(requestDidFailed:)];
                        [request startAsynchronous];
                    }
            }
        }
        else
        {
            //加载更多，所有
            
            //加载更多,附近
            if (ChoseNum==1) {
                NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=2&&lat=%f&&lng=%f&&from=%d",userUUid,self.lat,self.lng,self.sumArray.count+1];
                NSString* strURL=globalURL(str);
                NSLog(@"全部派对，按照附近距离排序：%@",strURL);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                request.shouldAttemptPersistentConnection = NO;
                [request setValidatesSecureCertificate:NO];
                [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                [request setDidFailSelector:@selector(requestDidFailed:)];
                [request startAsynchronous];
                
            }
            else
            {
                if (ChoseNum==2) {
                    NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=2&&lat=%f&&lng=%f&&from=%d",userUUid,self.lat,self.lng,self.sumArray.count+1];
                    NSString* strURL=globalURL(str);
                    NSLog(@"靠谱派对，距离排序:%@",strURL);
                    NSURL* url=[NSURL URLWithString:strURL];
                    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                    request.delegate = self;
                    request.shouldAttemptPersistentConnection = NO;
                    [request setValidatesSecureCertificate:NO];
                    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                    [request setDidFailSelector:@selector(requestDidFailed:)];
                    [request startAsynchronous];
                    
                }
                else
                    if (ChoseNum==3) {
                        NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=2&&lat=%f&&lng=%f&&from=%d",userUUid,self.lat,self.lng,self.sumArray.count+1];
                        NSString* strURL=globalURL(str);
                        NSLog(@"我的派对，距离排序:%@",strURL);
                        NSURL* url=[NSURL URLWithString:strURL];
                        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                        request.delegate = self;
                        request.shouldAttemptPersistentConnection = NO;
                        [request setValidatesSecureCertificate:NO];
                        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                        [request setDidFailSelector:@selector(requestDidFailed:)];
                        [request startAsynchronous];
                    }
            }
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    partyDetialViewController=[[PartyDetialViewController alloc]initWithNibName:nil bundle:nil];
    partyDetialViewController.hidesBottomBarWhenPushed=YES;
    NSDictionary* dict=[sumArray objectAtIndex:indexPath.section];
    
    partyDetialViewController.title=[dict objectForKey:@"P_TITLE"];
    partyDetialViewController.p_id=[dict objectForKey:@"P_ID"];
    //NSLog(@"pidqqqqqqqqqqqqqqqqqqqqqqq%@",partyViewController.p_id);
    [self.navigationController pushViewController:partyDetialViewController animated:YES];
    //
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//============下拉刷新代理方法======================================================
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    
    if ((self.tableViewParty.contentOffset.y+mainscreenhight-self.tableViewParty.contentSize.height>0)&&(self.tableViewParty.contentSize.height>0)) {
        if (isLoading==NO) {
            [self PartyClickMore];
            isLoading=YES;
        }
    }
    
}



#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    flag=0;
    //====================获取数据================================
    if (self.lng!=0||self.lat!=0) {
        if (segmentNum==0) {
            //加载更多,附近
            if (ChoseNum==1) {
                //
                NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                NSString* strURL=globalURL(str);
                NSLog(@"全部派对，按照附近距离排序：%@",strURL);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                request.shouldAttemptPersistentConnection = NO;
                [request setValidatesSecureCertificate:NO];
                [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                [request setDidFailSelector:@selector(requestDidFailed:)];
                [request startAsynchronous];
                
            }
            else
            {
                if (ChoseNum==2) {
                    NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                    NSString* strURL=globalURL(str);
                    NSLog(@"靠谱派对，距离排序:%@",strURL);
                    NSURL* url=[NSURL URLWithString:strURL];
                    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                    request.delegate = self;
                    request.shouldAttemptPersistentConnection = NO;
                    [request setValidatesSecureCertificate:NO];
                    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                    [request setDidFailSelector:@selector(requestDidFailed:)];
                    [request startAsynchronous];
                    
                }
                else
                    if (ChoseNum==3) {
                        NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                        NSString* strURL=globalURL(str);
                        NSLog(@"我的派对，距离排序:%@",strURL);
                        NSURL* url=[NSURL URLWithString:strURL];
                        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                        request.delegate = self;
                        request.shouldAttemptPersistentConnection = NO;
                        [request setValidatesSecureCertificate:NO];
                        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                        [request setDidFailSelector:@selector(requestDidFailed:)];
                        [request startAsynchronous];
                    }
            }
        }
        else
        {
            //加载更多，所有
            
            //加载更多,附近
            if (ChoseNum==1) {
                //
                NSString* str=[NSString stringWithFormat:@"mac/party/IF00101?uuid=%@&&sort=1&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                NSString* strURL=globalURL(str);
                NSLog(@"全部派对，按照附近距离排序：%@",strURL);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                request.shouldAttemptPersistentConnection = NO;
                [request setValidatesSecureCertificate:NO];
                [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                [request setDidFailSelector:@selector(requestDidFailed:)];
                [request startAsynchronous];
                
            }
            else
            {
                if (ChoseNum==2) {
                    NSString* str=[NSString stringWithFormat:@"mac/party/IF00102?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                    NSString* strURL=globalURL(str);
                    NSLog(@"靠谱派对，距离排序:%@",strURL);
                    NSURL* url=[NSURL URLWithString:strURL];
                    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                    request.delegate = self;
                    request.shouldAttemptPersistentConnection = NO;
                    [request setValidatesSecureCertificate:NO];
                    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                    [request setDidFailSelector:@selector(requestDidFailed:)];
                    [request startAsynchronous];
                    
                }
                else
                    if (ChoseNum==3) {
                        NSString* str=[NSString stringWithFormat:@"mac/party/IF00103?uuid=%@&&sort=2&&lat=%f&&lng=%f",userUUid,self.lat,self.lng];
                        NSString* strURL=globalURL(str);
                        NSLog(@"我的派对，距离排序:%@",strURL);
                        NSURL* url=[NSURL URLWithString:strURL];
                        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                        request.delegate = self;
                        request.shouldAttemptPersistentConnection = NO;
                        [request setValidatesSecureCertificate:NO];
                        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                        [request setDidFailSelector:@selector(requestDidFailed:)];
                        [request startAsynchronous];
                    }
            }
        }
    }
    else
    {
        UILabel *lableAlert=[[UILabel alloc]initWithFrame:CGRectMake(50, 100, 240, 100)];
        lableAlert.text=@"请开启位置服务";
        [self.tableViewParty addSubview:lableAlert];
    }
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:3
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
