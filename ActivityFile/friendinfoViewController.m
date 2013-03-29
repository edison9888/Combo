//
//  friendinfoViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-23.
//
//

#import "friendinfoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "SDImageView+SDWebCache.h"
@interface friendinfoViewController ()

@end

@implementation friendinfoViewController
@synthesize picimage;
@synthesize user_id;
@synthesize flag;
@synthesize dict;
@synthesize userUUid;

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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
	// Do any additional setup after loading the view.

    changePicview=[[UIImageView alloc]init];

    tableview=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:226.0/255 green:224.0/255 blue:219.0/255 alpha:1];
    [self.view addSubview:tableview];
    NSString* str=[NSString stringWithFormat:@"mac/user/IF00003?uuid=%@&&user_id=%@",userUUid,self.user_id];
    NSString *stringUrl=globalURL(str);
    NSLog(@"%@",stringUrl);
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
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"进入好友资料，接口3");
    NSLog(@"%@",bizDic);
    self.dict=bizDic;
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
    //NSLog(@"::::::%@",self.dict);
    if (indexPath.section!=2) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        if (indexPath.section==0) {
            picimage=[[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 41, 41)];
            //圆角设置
            picimage.layer.cornerRadius = 6;
            picimage.layer.masksToBounds = YES;
            
            [picimage setImageWithURL:[NSURL URLWithString:[self.dict objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            picimage.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [picimage addGestureRecognizer:singleTap];
            
            UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, 140, 20)];
            namelabel.backgroundColor=[UIColor clearColor];
            if ([self.dict objectForKey:@"USER_NICK"]) {
                namelabel.text=[self.dict objectForKey:@"USER_NICK"];
            }
            
            namelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            namelabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
            [cell.contentView addSubview:picimage];
            [cell.contentView addSubview:namelabel];
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"creatkuang2"]];
            
        }
        if (indexPath.section==1) {
            if(indexPath.row==0){
                cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"creatkuangA"]];
                cell.textLabel.text=@"性别 ";
                cell.textLabel.backgroundColor=[UIColor clearColor];
                cell.textLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                UILabel* agelabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 50, 20)];
                agelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                agelabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                agelabel.backgroundColor=[UIColor clearColor];
                NSString* sexstr=[self.dict objectForKey:@"USER_SEX"];
                NSLog(@"性别:%@",sexstr);
                if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
                    agelabel.text=@"男";
                }
                else
                {
                    agelabel.text=@"女";
                }
                [cell.contentView addSubview:agelabel];
            }
            if (indexPath.row==1) {
                cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang2"]];
                cell.textLabel.text=@"年龄 ";
                cell.textLabel.backgroundColor=[UIColor clearColor];
                cell.textLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                UILabel* agelabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10 , 50, 20)];
                agelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                agelabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                agelabel.backgroundColor=[UIColor clearColor];
                if ([dict objectForKey:@"USER_AGE"]) {
                    agelabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"USER_AGE"]];
                }
                [cell.contentView addSubview:agelabel];
            }
            if (indexPath.row==2) {
                cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang3"]];
                cell.textLabel.text=@"地区 ";
                cell.textLabel.backgroundColor=[UIColor clearColor];
                cell.textLabel.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
                cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                cell.textLabel.backgroundColor=[UIColor clearColor];
                UILabel* locallabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 11, 150, 20)];
                locallabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                locallabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
                locallabel.backgroundColor=[UIColor clearColor];
                NSMutableString* localStr=[[NSMutableString alloc]init];
                if (([dict objectForKey:@"USER_CITY"])&&(![[dict objectForKey:@"USER_CITY"] isEqualToString:@"null"])) {
                    [localStr appendFormat:@"%@ ",[dict objectForKey:@"USER_CITY"]];
                }
                if (([dict objectForKey:@"USER_LOCAL"])&&(![[dict objectForKey:@"USER_LOCAL"] isEqualToString:@"(null)"])) {
                    [localStr appendFormat:@"%@",[dict objectForKey:@"USER_LOCAL"]];
                }
                locallabel.text=localStr;
                [cell.contentView addSubview:locallabel];
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        if (indexPath.row==0) {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GRZL1"]];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            
        }
        if(indexPath.row==1)
        {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GRZL2"]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.numberOfLines = 0;
            label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
            [cell.contentView addSubview:label];
            
            CGRect cellFrame = CGRectMake(12, 10.0, 280, 30);
            if([dict objectForKey:@"USER_DES"]) label.text=[dict objectForKey:@"USER_DES"];
            else label.text=@"这家伙很懒，什么都没写！";
            CGRect rect = cellFrame;
            label.frame = rect;
            [label sizeToFit];
            cellFrame.size.height = label.frame.size.height+20;
            [cell setFrame:cellFrame];
        }
        if(indexPath.row==2){
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GRZL3"]];
            cell.textLabel.backgroundColor=[UIColor clearColor];
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        //NSString* userid=[dict objectForKey:@"USER_ID"];
        if ([user_id intValue]==[userUUid intValue]) {
            //NSLog(@"自己");
        }

        else
        {
            if (![[[dict objectForKey:@"USER_STATUS"]substringToIndex:1]isEqualToString:@"Y"])
            {
                UIView* footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
                UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(20, 20, 280, 40);
                [button setImage:[UIImage imageNamed:@"settingadd"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(makeFriend:) forControlEvents:UIControlEventTouchDown];
                [footview addSubview:button];
                return footview;
            }
            else
                return nil;
        }
    }
    return nil;
}

-(void)makeFriend:(id)sender
{
    //申请添加好友的界面
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认添加好友?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    NSLog(@"添加好友,需要申请添加好友的接口12:::%@,%@",self.userUUid,user_id);
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSLog(@"确认");
        NSLog(@"添加好友，接口12+++自己id:%@好友id:%@",self.userUUid,user_id);
        NSString* str=@"mac/user/IF00012";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:user_id forKey:@"user_id"];
        [rrequest startSynchronous];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section==2)&&(indexPath.row==1)) {
        UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    if ((indexPath.section==2)&&(indexPath.row==0)){
        return 5;
    }
    if ((indexPath.section==2)&&(indexPath.row==2)){
        return 10;
    }
    if (indexPath.section==0) {
        return 59;
    }
    return 42;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    return 2.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 200;
    }
    return 10.0f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 3;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.navigationController.navigationBarHidden=YES;
    changePicview.userInteractionEnabled=YES;
    changePicview.backgroundColor=[UIColor blackColor];
    changePicview.frame=mainscreen;
    UIImageView* picima=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 320, 320)];//不需要适配
    picima.image=picimage.image;
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

@end
