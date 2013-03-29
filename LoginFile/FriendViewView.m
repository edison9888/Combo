//
//  FriendViewView.m
//  party
//
//  Created by yilinlin on 13-2-3.
//
//

#import "FriendViewView.h"
#import "SDImageView+SDWebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@implementation FriendViewView
@synthesize buttonAffirm,buttonCancel;
@synthesize tableViewFri;
@synthesize sumArray;
@synthesize userUUid;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getUUidForthis];
        self.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
        //Initialization code
        sumArray=[[NSMutableArray alloc]init];
        
        UIImageView *imagenavView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        imagenavView.image=[UIImage imageNamed:@"navigation"];
        [self addSubview:imagenavView];
        
        UILabel *namenav=[[UILabel alloc]initWithFrame:CGRectMake(120, 6, 80, 31)];
        namenav.text=@"推荐好友";
        namenav.textColor=[UIColor whiteColor];
        namenav.backgroundColor=[UIColor clearColor];
        [self addSubview:namenav];
        
        //==========UItableView=============================================
        self.tableViewFri=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, mainscreenhight-44) style:UITableViewStylePlain];
        self.tableViewFri.backgroundColor=[UIColor clearColor];
        self.tableViewFri.delegate=self;
        self.tableViewFri.dataSource=self;
        [self addSubview:tableViewFri];
        //******************************右侧确认按钮 end************************************
        buttonAffirm=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonAffirm.frame= CGRectMake(10, 4, 47, 35);
        buttonAffirm.backgroundColor=[UIColor clearColor];
        [buttonAffirm setBackgroundImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
        [self addSubview:buttonAffirm];
        //========================================
        buttonCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancel.frame= CGRectMake(263, 4, 47, 35);
        buttonCancel.backgroundColor=[UIColor clearColor];
        [buttonCancel setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        [self addSubview:buttonCancel];
        //===========获取系统给的数据=============================
        NSString* str=@"mac/user/IF00037";
        NSString* strURL=globalURL(str);
        NSURL *url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:@"北京" forKey: @"city"];
        [rrequest setDelegate:self];
        [rrequest startAsynchronous];
        
    }
    return self;
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
    //self.uuid=[NSNumber numberWithInt:[stringUUID intValue]];
    //self.userUUid=@"10001";
    self.userUUid=stringUUID;
}
-(void)requestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"wang luo bu gei li");
//    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力，没有获取到数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [soundAlert show];
//    [soundAlert release];
}

//******************************ASIHttp 代理方法************************************
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    self.sumArray=[bizDic objectForKey:@"userList"];
    NSLog(@"注册页面好友信息%@",bizDic);
    [self.tableViewFri reloadData];
}
#pragma mark - Table view data source

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    UIImageView* picimage=[[UIImageView alloc] initWithFrame:CGRectMake(9, 8, 40, 40)];
    
    UIImageView* seximage;
    
    UILabel* namelabel;
    UILabel* citylabel;
    UILabel* agelabel;
    UILabel* locallabel;
    picimage.tag=1001;
    NSDictionary* dict=[self.sumArray objectAtIndex:indexPath.row];
    NSLog(@"%d++++++++++++%@",indexPath.row,dict);
    
    [picimage setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    picimage.layer.borderWidth=1;
    //圆角设置
    picimage.layer.cornerRadius = 6;
    picimage.layer.masksToBounds = YES; 
    seximage=[[UIImageView alloc]initWithFrame:CGRectMake(58, 12, 11, 13)];
    NSString* sexstr=[dict objectForKey:@"USER_SEX"];
    if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
        seximage.image=[UIImage imageNamed:@"FIRENDSmale"];
    }
    else
    {
        seximage.image=[UIImage imageNamed:@"FIRENDSfemale"];
    }
    
    namelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 9, 100, 20)];
    namelabel.font=[UIFont systemFontOfSize:14];
    namelabel.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
    namelabel.backgroundColor=[UIColor clearColor];
    namelabel.text=[dict objectForKey:@"USER_NICK"];
    
    agelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25 , 25, 30)];
    agelabel.font=[UIFont systemFontOfSize:13];
    agelabel.textColor=[UIColor lightGrayColor];
    agelabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"USER_AGE"]];
    agelabel.backgroundColor=[UIColor clearColor];
    
    citylabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 25, 40, 30)];
    citylabel.font=[UIFont systemFontOfSize:13];
    citylabel.textColor=[UIColor lightGrayColor];
    citylabel.backgroundColor=[UIColor clearColor];

    locallabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 25, 40, 30)];
    locallabel.font=[UIFont systemFontOfSize:13];
    locallabel.textColor=[UIColor lightGrayColor];
    locallabel.backgroundColor=[UIColor clearColor];

    if (([[dict objectForKey:@"USER_CITY"] isEqualToString:@"(null)"])||([[dict objectForKey:@"USERE_LOCAL"] isEqualToString:@"(null)"])) {
        citylabel.text=@"";
        locallabel.text=@"";
    }
    else
    {
        citylabel.text=[dict objectForKey:@"USER_CITY"];
        locallabel.text=[dict objectForKey:@"USER_LOCAL"];
    }
    
    [cell.contentView addSubview:picimage];
    [cell.contentView addSubview:seximage];
    [cell.contentView addSubview:namelabel];
    [cell.contentView addSubview:agelabel];
    [cell.contentView addSubview:citylabel];
    [cell.contentView addSubview:locallabel];
    seximage.tag=1002;
    namelabel.tag=1003;
    agelabel.tag=1004;
    citylabel.tag=1005;
    locallabel.tag=1006;

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(280,17,24,25);
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:@"friendadd"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    
    //[button addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
//- (void)btnClicked:(id)sender event:(id)event
//{
//    NSSet *touches = [event allTouches];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:self.tableViewFri];
//    NSIndexPath *indexPath = [self.tableViewFri indexPathForRowAtPoint:currentTouchPosition];
//    if(indexPath != nil)
//    {
//        [self tableView:self.tableViewFri accessoryButtonTappedForRowWithIndexPath:indexPath];
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tableView:self.tableViewFri accessoryButtonTappedForRowWithIndexPath:indexPath];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSLog(@"确认");
        NSDictionary* dict=[self.sumArray objectAtIndex:selectRow];
        NSLog(@"%@",dict);
        NSString* userid=[dict objectForKey:@"USER_ID"];
        NSLog(@"添加好友，接口12+++自己id:%@好友id:%@",self.userUUid,userid);
        NSString* str=@"mac/user/IF00012";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:userid forKey:@"user_id"];
        [rrequest startSynchronous];
    }
}

//申请添加好友的快捷键
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    int  idx = indexPath.row;
    selectRow=indexPath.row;
    //这里加入自己的逻辑
    NSLog(@"%d",idx);
    NSLog(@"快捷键，申请添加好友");
    NSLog(@"申请添加好友,接口IF00012");
    [SVProgressHUD show];
}

-(void)show{
    [SVProgressHUD dismissWithSuccess:@"发送好友申请" afterDelay:1.1];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sumArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;//不需要适应
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
