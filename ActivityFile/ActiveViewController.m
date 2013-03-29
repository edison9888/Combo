//
//  ActiveViewController.m
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import "ActiveViewController.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
#define returntotal 5

@interface ActiveViewController ()

@end

@implementation ActiveViewController


@synthesize tableview;
@synthesize actsumarray;
@synthesize userUUid;
@synthesize addrarray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title=@"事件";
    }
    return self;
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
    buttonNear.titleLabel.text=@"活动";
    buttonNear.tag=201;
    [buttonNear setBackgroundImage:[UIImage imageNamed:@"activity"] forState:UIControlStateNormal];
    [buttonNear setBackgroundImage:[UIImage imageNamed:@"activityai"] forState:UIControlStateSelected];
    [buttonNear addTarget:self action:@selector(mesActionbutt:) forControlEvents:UIControlEventTouchUpInside];
    [buttonNear setSelected:YES];
    buttonNew=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonNew.frame=CGRectMake(54, 27, 46, 30);
    buttonNew.titleLabel.text=@"地点";
    buttonNew.tag=202;
    [buttonNew setBackgroundImage:[UIImage imageNamed:@"locale"] forState:UIControlStateNormal];
    [buttonNew setBackgroundImage:[UIImage imageNamed:@"localeai"] forState:UIControlStateSelected];
    [buttonNew addTarget:self action:@selector(mesActionbutton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonNew setSelected:NO];
    [self.tabBarController.view addSubview:buttonNew];
    [self.tabBarController.view addSubview:buttonNear];
    
    logoimage=[[UIImageView alloc]initWithFrame:CGRectMake(140, 5, 40, 34)];
    logoimage.backgroundColor=[UIColor clearColor];
    logoimage.image=[UIImage imageNamed:@"LOGO"];
    [self.navigationController.navigationBar addSubview:logoimage];
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
    total=0;
    // Do any additional setup after loading the view from its nib.
    [self getUUidForthis];
    segment=0;
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableview=table;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundView=nil;
    self.tableview.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:219.0/255 alpha:1];
    
    [self.view addSubview:self.tableview];
    NSMutableArray* list=[[NSMutableArray alloc]init];
    self.actsumarray=list;
    
    NSMutableArray* addrlist=[[NSMutableArray alloc]init];
    self.addrarray=addrlist;
    
    
    
    segment=0;
    flag=0;
    
    acview=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    acview.frame=CGRectMake(150, mainscreenhight/2.0, 20, 20);
    [self.view addSubview:acview];
    [acview startAnimating];
    //接口IF00028
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00028?uuid=%@&&from=1&&to=5",userUUid];
    NSString *stringUrl=globalURL(str);
    NSLog(@"获取活动列表,接口28:%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    
    
    
    //==========================刷新===============================
    _slimeView=[[SRRefreshView alloc] init];
    _slimeView.delegate=self;
    _slimeView.upInset=20;
    [tableview addSubview:_slimeView];
}
-(void)mesActionbutton:(UIButton *)btn
{
    //=====地点====================
    [buttonNear setSelected:NO];
    [buttonNew setSelected:YES];
    NSLog(@"11111111");
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    flag=0;
    segment=1;
    flag=0;
    [self.tableview reloadData];
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00029?uuid=%@&&from=1&&to=5",userUUid];
    NSString *stringUrl=globalURL(str);
    NSLog(@"获取热门地点列表,接口29:%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    
}
-(void)mesActionbutt:(UIButton *)btn
{
    //======活动====================
    [buttonNear setSelected:YES];
    [buttonNew setSelected:NO];
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    flag=0;
    segment=0;
    [self.tableview reloadData];
    flag=0;
    //接口IF00028
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00028?uuid=%@&&from=1&&to=5",userUUid];
    NSString *stringUrl=globalURL(str);
    NSLog(@"获取活动列表,接口28:%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
}

-(void)valueChanged:(id)sender
{
    NSLog(@"switch state: %d",((SimpleSwitch*)sender).on);
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    flag=0;
    self.tableview.contentOffset=CGPointMake(0.0, 0.0);
    if (((SimpleSwitch*)sender).on==1) {
        
    }
    if (((SimpleSwitch*)sender).on==0) {
        
    }
    
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
    isLoading=NO;
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"接口28、29共用一个页面，根据segment判断是哪一个页面:segment:%d",segment );
    NSLog(@"%@",bizDic);
    total=[[bizDic objectForKey:@"total"]intValue];
    //选择的是活动列表，segment=0
    if (segment==0) {
        if (flag==0) {
            [self.actsumarray removeAllObjects];
        }
        [self.actsumarray addObjectsFromArray:[bizDic objectForKey:@"collects"]];
        NSLog(@"%@",self.actsumarray);
    }
    //选择的是地点列表，segment=1
    else
    {
        if (flag==0) {
            [self.addrarray removeAllObjects];
        }
        
        [self.addrarray addObjectsFromArray:[bizDic objectForKey:@"collects"]];
        NSLog(@"%@",self.addrarray);
    }
    [acview stopAnimating];
    [tableview reloadData];
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
//- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
//    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
//    //中断之前的网络请求
//	NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedIndex);
//    flag=0;
//    self.tableview.contentOffset=CGPointMake(0.0, 0.0);
//    if (segmentedControl.selectedIndex==1) {
//        segment=1;
//        flag=0;
//        [self.tableview reloadData];
//        NSString* str=[NSString stringWithFormat:@"mac/party/IF00029?uuid=%@&&from=1&&to=5",userUUid];
//        NSString *stringUrl=globalURL(str);
//        NSLog(@"获取热门地点列表,接口29:%@",stringUrl);
//        NSURL* url=[NSURL URLWithString:stringUrl];
//
//        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
//        request.delegate = self;
//        request.shouldAttemptPersistentConnection = NO;
//        [request setValidatesSecureCertificate:NO];
//        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
//        [request setDidFailSelector:@selector(requestDidFailed:)];
//        [request startAsynchronous];
//
//    }
//    if (segmentedControl.selectedIndex==0) {
//        segment=0;
//        [self.tableview reloadData];
//        flag=0;
//        //接口IF00028
//        NSString* str=[NSString stringWithFormat:@"mac/party/IF00028?uuid=%@&&from=1&&to=5",userUUid];
//        NSString *stringUrl=globalURL(str);
//        NSLog(@"获取活动列表,接口28:%@",stringUrl);
//        NSURL* url=[NSURL URLWithString:stringUrl];
//
//        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
//        request.delegate = self;
//        request.shouldAttemptPersistentConnection = NO;
//        [request setValidatesSecureCertificate:NO];
//        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
//        [request setDidFailSelector:@selector(requestDidFailed:)];
//        [request startAsynchronous];
//
//    }
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment==0){
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activityBack"]];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UITextView* addr;
        UITextView* time;
        UILabel* title;
        
        
        UILabel* host;
        UIImageView* imageview;
        UILabel* fnum;
        UILabel* pnum;
        UILabel* label;
        
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(6, -4, 109, 154)];
        [cell.contentView addSubview:imageview];
        
        UIImageView* labelpic=[[UIImageView alloc]initWithFrame:CGRectMake(14, -4, 40, 27)];
        labelpic.image=[UIImage imageNamed:@"Tag@2x.png"];
        [cell.contentView addSubview:labelpic];
        
        label=[[UILabel alloc]initWithFrame:CGRectMake(14, -13, 40, 37)];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:10.0];
        label.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        
        fnum=[[UILabel alloc]initWithFrame:CGRectMake(187, 139, 50, 21)];
        fnum.backgroundColor=[UIColor clearColor];
        fnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
        fnum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        [cell.contentView addSubview:fnum];
        
        pnum=[[UILabel alloc]initWithFrame:CGRectMake(259, 139, 51, 21)];
        pnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
        pnum.backgroundColor=[UIColor clearColor];
        pnum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        [cell.contentView addSubview:pnum];
        
        addr=[[UITextView alloc]initWithFrame:CGRectMake(137, 101, 150, 48)];
        addr.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        addr.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
        addr.backgroundColor=[UIColor clearColor];
        addr.userInteractionEnabled=NO;
        addr.multipleTouchEnabled=NO;
        
        [cell.contentView addSubview:addr];
        
        time=[[UITextView alloc]initWithFrame:CGRectMake(137, 66, 150, 60)];
        time.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        time.backgroundColor=[UIColor clearColor];
        time.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
        time.multipleTouchEnabled=NO;
        time.userInteractionEnabled=NO;
        [cell.contentView addSubview:time];
        
        host=[[UILabel alloc]initWithFrame:CGRectMake(142, 51, 80, 21)];
        host.backgroundColor=[UIColor clearColor];
        host.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        host.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
        [cell.contentView addSubview:host];
        title=[[UILabel alloc]initWithFrame:CGRectMake(120, 12, 144, 34)];
        title.textAlignment=NSTextAlignmentCenter;
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
        title.font=[UIFont fontWithName:@"Helvetica-Bold" size:19];//活动字体
        title.shadowColor=[UIColor colorWithRed:115.0/255 green:151.0/255 blue:155.0/255 alpha:1];
        title.shadowOffset=CGSizeMake(2.0, 2.0);
        [cell.contentView addSubview:title];
        
        
        
        NSDictionary* dict=[self.actsumarray objectAtIndex:indexPath.section];
        NSLog(@"%@",dict);
        pnum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_PNUM"]];
        title.text=[dict objectForKey:@"C_TITLE"];
        label.text=[dict objectForKey:@"C_LABEL"];
        host.text=[dict objectForKey:@"C_HOST"];
        addr.text=[dict objectForKey:@"C_LOCAL"];
        
        NSURL* url=[NSURL URLWithString:[dict objectForKey:@"C_PIC"]];
        
        //cell.imageview.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        imageview.layer.cornerRadius=3;
        imageview.clipsToBounds=YES;
        imageview.layer.masksToBounds=YES;
        [imageview setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"huodong"]];
        time.text=[dict objectForKey:@"C_STIME"];
        fnum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_FNUM"]];
        return cell;
        
    }
    else
    {
        
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"didianzhen"]];
        
        NSDictionary* dict=[self.addrarray objectAtIndex:indexPath.section];
        UIImageView* imageview;
        UILabel* addrlabel;
        UILabel* peoplenum;
        UILabel* partynum;
        UILabel* title;
        UILabel* label;
        //[UIFont fontWithName:@"Helvetica-Bold" size:12]
        addrlabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 171, 250, 21)];
        addrlabel.backgroundColor=[UIColor clearColor];
        addrlabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
        addrlabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        addrlabel.text=[dict objectForKey:@"C_LOCAL"];
        [cell.contentView addSubview:addrlabel];
        
        peoplenum=[[UILabel alloc]initWithFrame:CGRectMake(191, 188, 50, 21)];
        peoplenum.backgroundColor=[UIColor clearColor];
        peoplenum.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        peoplenum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        peoplenum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_FNUM"]];
        [cell.contentView addSubview:peoplenum];
        
        partynum=[[UILabel alloc]initWithFrame:CGRectMake(264, 188, 44, 21)];
        partynum.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        partynum.backgroundColor=[UIColor clearColor];
        partynum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        partynum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_PNUM"]];
        [cell.contentView addSubview:partynum];
        
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(2,23, 296, 143)];
        NSURL* url=[NSURL URLWithString:[dict objectForKey:@"C_PIC"]];
        [imageview setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"didian"]];
        [cell.contentView addSubview:imageview];
        
        UIImageView* shadeImage=[[UIImageView alloc]initWithFrame:CGRectMake(2, 23, 296, 143)];
        shadeImage.image=[UIImage imageNamed:@"didianzao"];
        [cell.contentView addSubview:shadeImage];
        
        title=[[UILabel alloc]initWithFrame:CGRectMake(10, -2, 222, 25)];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
        title.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        title.text=[dict objectForKey:@"C_TITLE"];
        [cell.contentView addSubview:title];
        UIImageView* labelpic=[[UIImageView alloc]initWithFrame:CGRectMake(250, 4, 40, 32)];
        labelpic.image=[UIImage imageNamed:@"ACTlabel"];
        [cell.contentView addSubview:labelpic];
        
        label=[[UILabel alloc]initWithFrame:CGRectMake(250, 3, 40, 20)];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont fontWithName:@"Helvetica-Bold" size:10];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=[dict objectForKey:@"C_LABEL"];
        [cell.contentView addSubview:label];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment==0) {
        NSDictionary* dict=[self.actsumarray objectAtIndex:indexPath.section];
        detail=[[DetailViewController alloc]init];
        detail.hidesBottomBarWhenPushed=YES;
        detail.C_id=[dict objectForKey:@"C_ID"];
        [self.navigationController pushViewController:detail animated:YES];
        detail=nil;
        
    }
    else
    {
        NSDictionary* dict=[self.addrarray objectAtIndex:indexPath.section];
        addrdetail=[[AddrDetailViewController alloc]init];
        addrdetail.C_id=[dict objectForKey:@"C_ID"];
        addrdetail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:addrdetail animated:YES];
        addrdetail=nil;
        
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment==0) {
        return 172;
    }
    else
        return 217;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (segment==0) {
        if (section==self.actsumarray.count-1) {
            return 160;
        }
    }
    if (segment==1) {
        if (section==self.addrarray.count-1) {
            return 160;
        }
    }
    return 3;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view=[tableView dequeueReusableCellWithIdentifier:@"header"];
    if (!view) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        //view.backgroundColor=[UIColor redColor];
    }
    return view;
}


//活动列表加载更多
-(void)ACTclickmore
{
    //接口28，需要from and to
    flag=1;
    if (total<returntotal) {
//        NSLog(@"已经是全部");
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"加载完毕" message:@"所有数据已经加载完毕" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
//        
    }
    else
    {
        int from=[self.actsumarray count]+1;
        int to=from+4;
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00028?uuid=%@&&from=%d&&to=%d",userUUid,from,to];
        NSString *stringUrl=globalURL(str);
        NSLog(@"获取活动列表,接口28:%@",stringUrl);
        NSLog(@"加载更多:");
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    
    
}

//地点列表加载更多
-(void)ADDRclickmore
{
    flag=1;
    if (total<returntotal) {
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"加载完毕" message:@"所有数据已经加载完毕" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
//        
        
    }
    else
    {
        int from=[self.actsumarray count]+1;
        int to=from+4;
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00029?uuid=%@&&from=%d&&to=%d",userUUid,from,to];
        NSString *stringUrl=globalURL(str);
        NSLog(@"获取地点列表,接口29:%@",stringUrl);
        NSLog(@"加载更多:");
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 3;
    if (segment==0) {
        return [self.actsumarray count];
    }
    else
    {
        return [self.addrarray count];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (segment==0) {
        return 7;
    }
    else
    {
        return 1.0f;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//============下拉刷新代理方法======================================================
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    //NSLog(@"%f,%f",self.tableview.contentOffset.y+mainscreenhight,self.tableview.contentSize.height);
    if ((self.tableview.contentOffset.y+mainscreenhight-self.tableview.contentSize.height>0)&&(self.tableview.contentSize.height>0)) {
        if (segment==0) {
            if (isLoading==NO) {
                //NSLog(@"scrollView.contentOffset.y-mainscreenhight-scrollView.bounds.size.height>0加载更多");
                [self ACTclickmore];
                isLoading=YES;
            }
            
        }
        else
        {
            if (isLoading==NO) {
                //NSLog(@"scrollView.contentOffset.y-mainscreenhight-scrollView.bounds.size.height>0加载更多");
                [self ADDRclickmore];
                isLoading=YES;
            }
            
        }
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}


#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    flag=0;
    //====================获取数据================================
    if (segment==1) {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00029?uuid=%@&&from=1&&to=5",userUUid];
        NSString *stringUrl=globalURL(str);
        NSLog(@"接口29网址:::%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    if (segment==0) {
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00028?uuid=%@&&from=1&&to=5",userUUid];
        NSString *stringUrl=globalURL(str);
        NSLog(@"获取活动列表,接口28:%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:3
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
