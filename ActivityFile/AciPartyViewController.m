//
//  AciPartyViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-18.
//
//

#import "AciPartyViewController.h"
#import "SDImageView+SDWebCache.h"
@interface AciPartyViewController ()

@end

@implementation AciPartyViewController
@synthesize tableview;
@synthesize sumArray;
@synthesize stringPartyName;
@synthesize stringNamePID;
@synthesize userUUid;
@synthesize P_label;
@synthesize lat,lng;
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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSMutableArray* array=[[NSMutableArray alloc]init];
    self.sumArray=array;
    flag=0;
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    [self getUUidForthis];
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

	// Do any additional setup after loading the view.
    tableview=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:219.0/255 alpha:1];
    tableview.backgroundView=nil;
    self.title=@"派对浏览";
    
    [self.view addSubview:tableview];
}
//=============经纬度代理方法=========================================
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //    log.text=[NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
    //    lat.text=[NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
    lng=newLocation.coordinate.longitude;
    lat=newLocation.coordinate.latitude;
    NSLog(@"获取你的经纬度：：：：：：：：经度:%g      纬度:%g",lng,lat);
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00104?uuid=%@&&c_id=%@&&lat=%f&&lng=%f&&&&from=%d",userUUid,stringNamePID,self.lat,self.lng,1];
    NSString *stringName=globalURL(str);
    NSLog(@"活动中的party:接口104：网址:%@",stringName);
    NSURL* url=[NSURL URLWithString:stringName];
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
-(void)requestFinished:(ASIHTTPRequest *)request
{
    isLoading=NO;
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    total=[[bizDic objectForKey:@"c_pnum"]intValue];
    NSLog(@"%@",bizDic);
    NSArray *array=[bizDic objectForKey:@"partys"];
   
    if (flag==0) {
        [self.sumArray removeAllObjects];
    }
    [self.sumArray addObjectsFromArray:array];
    flag++;
    //stringNameArray=[sumArray o]
    [tableview reloadData];
}

-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
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
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.sumArray.count-1) {
        return 160;
    }
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
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
    cell.selectionStyle=UITableViewCellEditingStyleNone;
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

    imagePICView0=[[UIImageView alloc]initWithFrame:CGRectMake(252, 105, 40, 31)];
    //最小的一个
    imagePICView6=[[UIImageView alloc]initWithFrame:CGRectMake(126, -8, 39, 39)];
    imagePICView1=[[UIImageView alloc]initWithFrame:CGRectMake(103, -10, 41, 41)];
    imagePICView2=[[UIImageView alloc]initWithFrame:CGRectMake(78, -12, 43, 43)];
    imagePICView3=[[UIImageView alloc]initWithFrame:CGRectMake(45, -14, 45, 45)];
    imagePICView4=[[UIImageView alloc]initWithFrame:CGRectMake(9, -16, 47, 47)];
    
    imagePICView5=[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 8, 10)];//性别
    
    UIImageView* prImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 22, 300, 102)];//遮罩
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
    lable1.shadowOffset=CGSizeMake(0, -1);
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
    lable4.font=[UIFont systemFontOfSize:10.0];
    lable4.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable5=[[UILabel alloc]initWithFrame:CGRectMake(252, 95, 40, 37)];
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
    

    NSDictionary *dict=[self.sumArray objectAtIndex:section];
    NSLog(@"%@",dict);
    
    
    lable5.text=self.P_label;
    imagePICView0.image=[UIImage imageNamed:@"tagparty"];

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

    
    float distance=[[dict objectForKey:@"P_DISTANCE"]floatValue];
    NSString* str1=[NSString stringWithFormat:@"%.2f",distance];
    lable2.text=str1;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy,MM,dd  HH:mm"];
    NSInteger time=[[dict objectForKey:@"P_STIME"]integerValue];
    NSLog(@"%d",time);
    NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",date);
    NSString *confromTimespStr = [formatter stringFromDate:date];
    lable3.text=confromTimespStr;

    lable7.text=[dict objectForKey:@"P_TITLE"];
    
    
    NSDictionary *creater=[dict objectForKey:@"USER"];
    
    
    if ([[[creater objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"M"]) {
        imagePICView5.image=[UIImage imageNamed:@"PartyMale"];
    }
    if ([[[creater objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"F"]) {
        imagePICView5.image=[UIImage imageNamed:@"Partyfemale"];
    }
    lable4.text= [creater objectForKey:@"USER_NICK"];
    NSURL *url=[NSURL URLWithString:[creater objectForKey:@"USER_PIC"]];
    [imagePICView4 setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    imagePICView4.layer.borderColor=[[UIColor whiteColor] CGColor];
    imagePICView4.layer.borderWidth=2;
    imagePICView4.layer.shadowOffset = CGSizeMake(2, 2);
    imagePICView4.layer.shadowOpacity = 0.5;
    imagePICView4.layer.shadowRadius = 2.0;

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((self.tableview.contentOffset.y+mainscreenhight-self.tableview.contentSize.height>0)&&(self.tableview.contentSize.height>0)) {
        if (isLoading==NO) {
            [self PartyClickMore];
            isLoading=YES;
        }
    }

}
//加载更多
-(void)PartyClickMore
{
    NSLog(@"本次返回的数量:%d",total);
    if (total<mytotal) {
//        //返回的结果已经是所有的了，不需要在加载
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"全部加载完毕" message:@"所有的信息已全部返回" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alert show];
    }
    else{
        //加载更多，所有
        flag++;
        NSString* str=[NSString stringWithFormat:@"mac/party/IF00104?uuid=%@&&c_id=%@&&lat=%f&&lng=%f&&&&from=%d",userUUid,stringNamePID,self.lat,self.lng,[self.sumArray count]];
        NSString *stringUrl=globalURL(str);
        NSLog(@"接口104:%@",stringUrl);
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    partyDetialLastViewController=[[PartyDetialLastViewController alloc]init];
    NSDictionary *dict=[sumArray objectAtIndex:indexPath.section];
    partyDetialLastViewController.p_id=[dict objectForKey:@"P_ID"];
    partyDetialLastViewController.title=[dict objectForKey:@"P_TITLE"];
    [self.navigationController pushViewController:partyDetialLastViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
