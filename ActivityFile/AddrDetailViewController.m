//
//  AddrDetailViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-19.
//
//

#import "AddrDetailViewController.h"
#import "ASIFormDataRequest.h"
#import "SDImageView+SDWebCache.h"
#import "MapViewController.h"

@interface AddrDetailViewController (){
    MapViewController *mapControl;
}

@end

@implementation AddrDetailViewController
@synthesize tableview;
@synthesize C_id;
@synthesize dict;
@synthesize userUUid;
@synthesize C_title;
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
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    changePicview=[[UIImageView alloc]init];
    changePicview.backgroundColor=[UIColor blackColor];
	self.title=@"地点信息";
    tableview =[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
  
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:219.0/255 alpha:1];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableview];
    
    //================加入/退出活动按钮======================
    joinParty = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinParty setImage:[UIImage imageNamed:@"LOCOUT"] forState:UIControlStateNormal];
    [joinParty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [joinParty setFrame:CGRectMake(0,mainscreenhight-109, 160, 46)];
    [self.view addSubview:joinParty];
    
    
    //====================创建party按钮=====================
    UIButton *join = [UIButton buttonWithType:UIButtonTypeCustom];
    [join setImage:[UIImage imageNamed:@"LOCmake"] forState:UIControlStateNormal];
    [join addTarget:self action:@selector(buttonClickTwo:) forControlEvents:UIControlEventTouchUpInside];
    [join setFrame:CGRectMake(160,mainscreenhight-109, 160, 46)];
    [self.view addSubview:join];
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00005?uuid=%@&&c_id=%@",userUUid,self.C_id];
    NSString *stringUrl=globalURL(str);
    NSURL* url=[NSURL URLWithString:stringUrl];
    NSLog(@"地点信息;接口5:网址:%@",stringUrl);
    
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
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",bizDic);
    NSArray* list=[bizDic objectForKey:@"hot"];
    if ([list count]>0) {
        self.dict=[list objectAtIndex:0];
    }
    NSLog(@"%@",self.dict);
    self.C_title=[dict objectForKey:@"C_TITLE"];
    NSString* joinorno=[self.dict objectForKey:@"C_STATUS"];
    NSLog(@"%@",joinorno);
    
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row=[indexPath row];
    NSLog(@"row------%d",row);
    if (row==0) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
        }
        
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC6"]];
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 156)];
        UIImageView* shadow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC1"]];
        shadow.frame=CGRectMake(0, 121, 320, 35);
        [imageview addSubview:shadow];
        
        Actitle=[[UILabel alloc]initWithFrame:CGRectMake(12, 121, 220, 35)];
        Actitle.backgroundColor=[UIColor clearColor];
        Actitle.textColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
        Actitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        Actitle.shadowColor=[UIColor colorWithRed:115.0/255 green:151.0/255 blue:155.0/255 alpha:1];
        [cell.contentView addSubview:imageview];
        [cell.contentView addSubview:Actitle];
        
        [imageview setImageWithURL:[NSURL URLWithString:[self.dict objectForKey:@"C_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"didian"]];
        imageview.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageview addGestureRecognizer:singleTap];
        Actitle.text=[dict objectForKey:@"C_TITLE"];
       
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
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC2"]];
        Acaddr=[[UITextView alloc]initWithFrame:CGRectMake(25, -4,100, 50)];
        Acaddr.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        Acaddr.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
       
        Acaddr.backgroundColor=[UIColor clearColor];
        Acaddr.userInteractionEnabled=NO;
        Acaddr.multipleTouchEnabled=NO;
        Acaddr.text=[self.dict objectForKey:@"C_LOCAL"];
        [cell.contentView addSubview:Acaddr];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (row==2) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC3"]];
        UILabel* Acpnum=[[UILabel alloc]initWithFrame:CGRectMake(117, 4, 120, 20)];
        Acpnum.backgroundColor=[UIColor clearColor];
        Acpnum.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        Acpnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        Acpnum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_PNUM"]];
        [cell.contentView addSubview:Acpnum];
        return cell;
    }
    
    if (row==3) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell3"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC4"]];
        Acfnum=[[UILabel alloc]initWithFrame:CGRectMake(117, 4, 120, 20)];
        Acfnum.backgroundColor=[UIColor clearColor];
        Acfnum.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        Acfnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        NSString* fnumstr=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_FNUM"]];
        Acfnum.text=fnumstr;
        [cell.contentView addSubview:Acfnum];
        image1=[[UIImageView alloc]initWithFrame:CGRectMake(34, 37, 33, 33)];
        
        image1.backgroundColor=[UIColor blackColor];
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
       
        NSArray* picarray=[dict objectForKey:@"c_fpics"];
        int num=[picarray count];
        for (int a=1; a<=num; a++) {
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
            [currimage setImageWithURL:url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
        return cell;
    }
    if (row==4)
        
    
    {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC5"]];
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
            

            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC6"]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.numberOfLines = 0;
            label.font=[UIFont systemFontOfSize:14];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
            [cell.contentView addSubview:label];
            
            CGRect cellFrame = CGRectMake(32, 10.0, 280, 30);
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
            

            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOC7"]];
            return cell;
        }
        

    return nil;
}


-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==001) {
        NSLog(@"加入活动，需要上传,接口IF00026");
        NSString* str=@"mac/party/IF00026";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.C_id forKey:@"c_id"];
        NSLog(@"%@:::::%@",userUUid,self.C_id);
        [rrequest startSynchronous];
        btn.tag=002;
        
        str=[NSString stringWithFormat:@"mac/party/IF00005?uuid=%@&&c_id=%@",userUUid,self.C_id];
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
        NSLog(@"退出已加入的活动，需要上传数据，接口IF00027");
        NSString* str=@"mac/party/IF00027";
        NSString* url27=globalURL(str);
        NSURL* url=[NSURL URLWithString:url27];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.C_id forKey:@"c_id"];
        [rrequest startSynchronous];
        btn.tag=001;
       
        str=[NSString stringWithFormat:@"mac/party/IF00005?uuid=%@&&c_id=%@",userUUid,self.C_id];
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

-(void)buttonClickTwo:(UIButton *)btB
{
    btB.selected=!btB.selected;
    //*******************************创建 party********************************
//    NSLog(@"C_title:%@",C_title);
//    NSLog(@"C_id:%@",self.C_id);
//    creatParty=[[CreatPartyViewController alloc]init];
//    creatParty.title=@"创建party";
//    creatParty.from_C_title=C_title;
//    creatParty.from_C_id=C_id;
//    creatParty.from_P_type=@"3";
//    self.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:creatParty animated:YES];
    
    NSLog(@"跳到地图");
    mapControl=[[MapViewController alloc]init];
    mapControl.title=@"创建派对地点";
    mapControl.type=@"1";
    mapControl.map_Temp=1;
    mapControl.c_id=self.C_id;
    mapControl.c_title=self.C_title;
    [self.navigationController pushViewController:mapControl animated:YES];
    //*******************************创建 party end********************************
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row=[indexPath row];
    if (row==0) {
        return 156;
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
        
        return 26;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.navigationController.navigationBarHidden=YES;
    changePicview.userInteractionEnabled=YES;
    
    //changePicview.image=imageview.image;
    changePicview.frame=self.view.bounds;
    UIImageView* picima=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 320, 300)];
    picima.image=imageview.image;
    [changePicview addSubview:picima];
    [self.view addSubview:changePicview];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapRe:)];
    [changePicview addGestureRecognizer:singleTap];
    
}
- (void)handleSingleTapRe:(UIGestureRecognizer *)gestureRecognizer
{
    self.navigationController.navigationBarHidden=NO;
    [changePicview removeFromSuperview];
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


-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}
@end
