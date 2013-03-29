//
//  DetailViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-18.
//
//

#import "DetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MapViewController.h"
#import "SVProgressHUD.h"
static NSString* P_type=@"activity";

@interface DetailViewController (){
    MapViewController *mapControl;
}

@end

@implementation DetailViewController
@synthesize dict;
@synthesize tableview;
@synthesize C_id;
@synthesize C_title;
@synthesize userUUid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getUUidForthis];
    
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 40, 35);
    [backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=back;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"活动详细信息:self.c_id=%@",self.C_id);
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //NSLog(@"%@",bizDic);
    NSArray* array=[bizDic objectForKey:@"activity"];
    if ([array count]>0) {
        [self.dict setDictionary:nil];
        [self.dict addEntriesFromDictionary:[array objectAtIndex:0]];
    }
    NSLog(@"接口四::::%@",self.dict);
    self.C_title=[dict objectForKey:@"C_TITLE"];
    NSLog(@"C_title:%@",self.C_title);
    NSString* joinorno=[self.dict objectForKey:@"C_STATUS"];
    NSLog(@"判断是否已经加入活动%@",joinorno);
    
    //================加入/退出活动按钮======================
    
    if ([[joinorno substringToIndex:1] isEqualToString:@"Y"])
    {
        [joinParty setImage:[UIImage imageNamed:@"LOCOUT"] forState:UIControlStateNormal];
        joinParty.tag=002;
    }
    else
    {
        [joinParty setImage:[UIImage imageNamed:@"LOCJOIN"] forState:UIControlStateNormal];
        joinParty.tag=001;
    }
    
  
    [tableview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    self.title=@"活动信息";
    tableview =[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStylePlain];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:219.0/255 alpha:1];
    [self.view addSubview:tableview];
    dict=[[NSMutableDictionary alloc]init];
    changePicview=[[UIImageView alloc]init];
    
    
    joinParty = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinParty setImage:[UIImage imageNamed:@"LOCJOIN"] forState:UIControlStateNormal];
    [joinParty setFrame:CGRectMake(0,mainscreenhight-109, 160, 46)];
    [joinParty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:joinParty];
    //====================创建party按钮=====================
    UIButton *join = [UIButton buttonWithType:UIButtonTypeCustom];
    [join setImage:[UIImage imageNamed:@"LOCmake"] forState:UIControlStateNormal];
    [join addTarget:self action:@selector(buttonClickTwo:) forControlEvents:UIControlEventTouchUpInside];
    [join setFrame:CGRectMake(160,mainscreenhight-109, 160, 46)];
    [self.view addSubview:join];

	// Do any additional setup after loading the view.
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00004?uuid=%@&&c_id=%@",userUUid,self.C_id];
    NSString *stringUrl=globalURL(str);
    NSLog(@"活动信息网址%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    
}
-(void)requestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"wang luo bu gei li");
//    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力，没有获取到数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [soundAlert show];
//    [soundAlert release];
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
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==001) {
        [SVProgressHUD show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showJoin) userInfo:nil repeats:NO];
        NSLog(@"加入活动，需要上传,接口IF00026");
        NSString* str=@"mac/party/IF00026";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.C_id forKey:@"c_id"];
        [rrequest startSynchronous];
        btn.tag=002;
        [btn setImage:[UIImage imageNamed:@"LOCOUT"] forState:UIControlStateNormal];
        str=[NSString stringWithFormat:@"mac/party/IF00004?uuid=%@&&c_id=%@",userUUid,self.C_id];
        NSString *stringUrl=globalURL(str);
        NSLog(@"活动信息网址%@",stringUrl);
        NSURL* reurl=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:reurl];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    else
    {
        [SVProgressHUD show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showback) userInfo:nil repeats:NO];
        NSLog(@"退出已加入的活动，需要上传数据，接口IF00027");
        NSString* str=@"mac/party/IF00027";
       
        NSString* url27=globalURL(str);
        NSURL* url=[NSURL URLWithString:url27];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.C_id forKey:@"c_id"];
        [rrequest startSynchronous];
        btn.tag=001;
        [btn setImage:[UIImage imageNamed:@"LOCJOIN"] forState:UIControlStateNormal];
        str=[NSString stringWithFormat:@"mac/party/IF00004?uuid=%@&&c_id=%@",userUUid,self.C_id];
        NSString *stringUrl=globalURL(str);
        NSLog(@"活动信息网址%@",stringUrl);
        NSURL* reurl=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:reurl];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    
}

-(void)showJoin{
    [SVProgressHUD dismissWithSuccess:@"成功加入"];
}
-(void)showback{
    [SVProgressHUD dismissWithSuccess:@"已退出活动"];
}


-(void)buttonClickTwo:(UIButton *)btB
{
    btB.selected=!btB.selected;
    //*******************************创建 party********************************
    
    NSLog(@"C_title:%@",self.C_title);
    NSLog(@"C_id:%@",self.C_id);
    NSLog(@"P_type:%@",P_type);
    
    NSLog(@"跳到地图");
    //从集合跳入地图，直接定位到地图
    mapControl=[[MapViewController alloc]init];
    double lat=[[dict objectForKey:@"C_LAT"]doubleValue];
    double lng=[[dict objectForKey:@"C_LNG"]doubleValue];
    NSLog(@"%lf,%lf",lat,lng);
    if ((lat>-90)&&(lat<90)) {
        [mapControl initWithlat:lat andlng:lng];
    }
    mapControl.title=@"创建派对地点";
    mapControl.type=@"2";

    mapControl.map_Temp=1;
    mapControl.c_id=self.C_id;
    mapControl.c_title=self.C_title;
    [self.navigationController pushViewController:mapControl animated:YES];
    
    //*******************************创建 party end********************************
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    view.backgroundColor=[UIColor clearColor];
    return view;
   
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 7)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row=[indexPath row];
    
    if (row==0) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
        }
        
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACT1"]];
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 4, 109, 154)];
        imageview.layer.cornerRadius=3;
        imageview.clipsToBounds=YES;
        imageview.layer.masksToBounds=YES;
        
        Actitle=[[UILabel alloc]initWithFrame:CGRectMake(139, 27, 160, 16)];
        Actitle.textColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
        Actitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:19];
        Actitle.shadowColor=[UIColor colorWithRed:115.0/255 green:151.0/255 blue:155.0/255 alpha:1];
        Actitle.shadowOffset=CGSizeMake(2.0, 2.0);
        Actitle.backgroundColor=[UIColor clearColor];
        
        
        Achost=[[UILabel alloc]initWithFrame:CGRectMake(153, 70, 120, 20)];
    
        Achost.backgroundColor=[UIColor clearColor];
        Achost.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        Achost.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    
        //标签
        Aclabel=[[UILabel alloc]initWithFrame:CGRectMake(256, -14, 40, 37)];
        Aclabel.text=@"大趴";
        Aclabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:10];
        Aclabel.backgroundColor=[UIColor clearColor];
        Aclabel.textColor=[UIColor whiteColor];
        Aclabel.textAlignment=NSTextAlignmentCenter;
        UIImageView* labelimage=[[UIImageView alloc]initWithFrame:CGRectMake(256, -6, 40, 27)];
        labelimage.image=[UIImage imageNamed:@"AOTag@2x.png"];
        [cell.contentView addSubview:labelimage];
        [cell.contentView addSubview:imageview];
        [cell.contentView addSubview:Actitle];
        [cell.contentView addSubview:Achost];
        
        [cell.contentView addSubview:Aclabel];
        UITextView* Actime=[[UITextView alloc]initWithFrame:CGRectMake(145, 98,170, 60)];
        Actime.backgroundColor=[UIColor clearColor];
        Actime.userInteractionEnabled=NO;
        Actime.multipleTouchEnabled=NO;
        Actime.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        Actime.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
        [cell.contentView addSubview:Actime];
        Actime.text=[dict objectForKey:@"C_STIME"];
        Actitle.text=[dict objectForKey:@"C_TITLE"];
        Achost.text=[dict objectForKey:@"C_HOST"];
        Aclabel.text=[dict objectForKey:@"C_LABEL"];
        NSURL* url=[NSURL URLWithString:[dict objectForKey:@"C_PIC"]];
        [imageview setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"huodong"]];
        imageview.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageview addGestureRecognizer:singleTap];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (row==1) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACT2"]];
        Acaddr=[[UITextView alloc]initWithFrame:CGRectMake(25, 11,100, 56)];
        Acaddr.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        Acaddr.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        Acaddr.backgroundColor=[UIColor clearColor];
        Acaddr.userInteractionEnabled=NO;
        Acaddr.multipleTouchEnabled=NO;
        [cell.contentView addSubview:Acaddr];
        Acaddr.text=[dict objectForKey:@"C_LOCAL"];
       
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (row==2) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACT3"]];
        UILabel* PnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(117, 5, 120, 20)];
        
        PnumLabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        PnumLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        PnumLabel.backgroundColor=[UIColor clearColor];
    
        PnumLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_PNUM"]];
        
        [cell.contentView addSubview:PnumLabel];
        return cell;
    }
    if (row==3) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACT4"]];
        UILabel* FnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(117, 5, 120, 20)];
        
        FnumLabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        FnumLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        FnumLabel.backgroundColor=[UIColor clearColor];
        
        FnumLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_FNUM"]];
        
        [cell.contentView addSubview:FnumLabel];

        image1=[[UIImageView alloc]initWithFrame:CGRectMake(34, 37, 33, 33)];
        image2=[[UIImageView alloc]initWithFrame:CGRectMake(81, 37, 33, 33)];

        image3=[[UIImageView alloc]initWithFrame:CGRectMake(128, 37, 33, 33)];

        image4=[[UIImageView alloc]initWithFrame:CGRectMake(175, 37, 33, 33)];

        image5=[[UIImageView alloc]initWithFrame:CGRectMake(222, 37, 33, 33)];

        image6=[[UIImageView alloc]initWithFrame:CGRectMake(269, 37, 33, 33)];

        image1.tag=1001;
        image2.tag=1002;
        image3.tag=1003;
        image4.tag=1004;
        image5.tag=1005;
        image6.tag=1006;
     

        [cell.contentView addSubview:image1];
        [cell.contentView addSubview:image2];
        [cell.contentView addSubview:image3];
        [cell.contentView addSubview:image4];
        [cell.contentView addSubview:image5];
        [cell.contentView addSubview:image6];
        //结构有问题
        NSArray* picarray=[dict objectForKey:@"c_fpics"];
        int num=[picarray count];
        for (int a=1; a<=num; a++)
        {
            NSLog(@"%d",a);
            NSDictionary* imagedic=[picarray objectAtIndex:a-1];
            NSString* urlstr=[imagedic objectForKey:@"C_FPIC"];
            NSLog(@"%@",urlstr);
            NSURL* url=[NSURL URLWithString:urlstr];
            int flag=1000+a;
            UIImageView* currimage=(UIImageView*)[cell viewWithTag:flag];
            currimage.layer.cornerRadius=3;
            currimage.clipsToBounds=YES;
            currimage.layer.masksToBounds=YES;
            [currimage setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }

         return cell;
    }
    if (row==4) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACT5"]];
         return cell;
    }
    if (row==5) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell5"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACT6"]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        [cell.contentView addSubview:label];
        
        CGRect cellFrame = CGRectMake(32, 10.0, 280, 10);
        label.text=[dict objectForKey:@"C_INFO"];
        CGRect rect = cellFrame;
        label.frame = rect;
        [label sizeToFit];
        cellFrame.size.height = label.frame.size.height+60;
        [cell setFrame:cellFrame];
         return cell;

    }
    if (row==6) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell6"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell6"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACT7"]];
        return cell;

    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row=[indexPath row];
    if (row==0) {
        return 193;
    }
    if (row==1) {
        return 56;
    }
    if (row==2) {
        return 36;
    }
    if (row==3) {
        return 83;
        
    }
    if (row==4)
    {
        
        return 27;
    }
    if (row==5) {
        UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }

    return 31;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        
        actParty=[[AciPartyViewController alloc]init];
        actParty.stringNamePID=self.C_id;
        actParty.P_label=[dict objectForKey:@"C_LABEL"];
        [self.navigationController pushViewController:actParty animated:YES];
        
        
    }
    if (indexPath.row==3) {
        friends=[[CollectfriendViewController alloc]init];
        friends.C_id=self.C_id;
        [self.navigationController pushViewController:friends animated:YES];
        
    }
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.navigationController.navigationBarHidden=YES;
    changePicview.userInteractionEnabled=YES;
    changePicview.image=imageview.image;
    changePicview.frame=self.view.bounds;
    [self.view addSubview:changePicview];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapRe:)];
    [changePicview addGestureRecognizer:singleTap];
    
}
- (void)handleSingleTapRe:(UIGestureRecognizer *)gestureRecognizer
{
    self.navigationController.navigationBarHidden=NO;
    [changePicview removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
