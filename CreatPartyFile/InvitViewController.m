//
//  InvitViewController.m
//  Invit
//
//  Created by mac bookpro on 1/20/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "InvitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ModalAlert.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PartyDetialLastViewController.h"
#import "SVProgressHUD.h"
@interface InvitViewController ()

@end

@implementation InvitViewController
@synthesize dic;
@synthesize lat,lng;
@synthesize map_city,map_local;
@synthesize from_time;
@synthesize from_p_id;
@synthesize invite;
@synthesize temp;
@synthesize txtView;
@synthesize examineText;
@synthesize stitle,info,local,time,friendId,phone;
@synthesize from_Creat_C_id,from_Creat_p_type;
@synthesize userUUid;
@synthesize sinaArray;

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

- (void)viewDidLoad
{
    
    stringFriId=[[NSMutableString alloc]init];
    for (int i=0; i<[self.friendId count]; i++) {
        if(i==0)
            [stringFriId appendFormat:@"%@",[[self.friendId objectAtIndex:i] objectForKey:@"USER_ID"]];
        else
            [stringFriId appendFormat:@",%@",[[self.friendId objectAtIndex:i] objectForKey:@"USER_ID"]];
    }

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self getUUidForthis];
    //self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
    self.view.backgroundColor=[UIColor colorWithRed:252.0/255 green:244.0/255 blue:227.0/255 alpha:1];
    
    
    //******************************确定按钮************************************
    if(temp==1){
        UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
        donebutton.frame=CGRectMake(0.0, 0.0, 44, 35);
        [donebutton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        [donebutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
        self.navigationItem.rightBarButtonItem=Makedone;
    }
    else if(temp==2){
        UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
        donebutton.frame=CGRectMake(0.0, 0.0, 44, 35);
        [donebutton setImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
        [donebutton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
        self.navigationItem.rightBarButtonItem=Makedone;
        
    }
    //******************************确定按钮 end************************************
    
    UITextView *textView1=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 129)];
    textView1.userInteractionEnabled=NO;
    textView1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:textView1];
    //******************************textView 邀请函************************************
    txtView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300 , 119 )];
    self.txtView.delegate=self;
    self.txtView.backgroundColor=[UIColor whiteColor];
    self.txtView.scrollEnabled = YES;//是否可以拖动
    [self.txtView becomeFirstResponder];
    self.txtView.tag=100;
    [self.txtView setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.txtView];
    
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    uilabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 6, 100, 20 )];
    if(temp==1){
        uilabel.text = @"碰头地点？";
        uilabel.font=[UIFont systemFontOfSize:14];
        UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock"]];//129
        imgView.frame=CGRectMake(0, 129, 320, 37);
        [self.view addSubview:imgView];

    }
    else if(temp==2){
        uilabel.text=@"申请理由...";
        uilabel.font=[UIFont systemFontOfSize:14];
        
        UILabel *intro=[[UILabel alloc]initWithFrame:CGRectMake(35, 129, 290, 40)];
        intro.text=@"加入请求会在30分钟内得到组织者的回复";
        intro.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        intro.textColor=[UIColor colorWithRed:146.0/255 green:146.0/255 blue:146.0/255 alpha:1];
        intro.backgroundColor=[UIColor clearColor];
        [self.view addSubview:intro];
    }
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    [self.txtView addSubview:uilabel];
    
    if(self.temp==1){
        label=[[UILabel alloc]initWithFrame:CGRectMake(20 ,89 , 60 , 40 )];
    }else{
        label=[[UILabel alloc]initWithFrame:CGRectMake(20 ,89 , 60 , 40 )];
    }
    label.text=@"40";
    label.font=[UIFont systemFontOfSize:14];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor grayColor];
    label.tag=101;
    [self.view addSubview:label];
    //******************************textView 邀请函************************************
    
    //******************************填写联系方式************************************
    if (self.temp==1) {
        button =[[UIButton alloc]initWithFrame:CGRectMake(218 , 102 , 85 , 17 )];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"mobilenuber"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:@"你的联系方式" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 10];
        
        [self.view addSubview:button];
        //******************************填写联系方式 end************************************
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
//*****************************textViewdelegate*****************************
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==100) {
        self.examineText =  textView.text;
        if (textView.text.length == 0) {
            if(temp==1)
                uilabel.text = @"碰头地点？";
            else if(temp==2)
                uilabel.text=@"申请理由...";
        }else{
            uilabel.text = @"";
        }
    }
    NSString *num=[NSString stringWithFormat:@"%d",40-[self.examineText length]];
    UILabel *numLabel=(UILabel *)[self.view viewWithTag:101];
    numLabel.text=num;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=40)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}
//*****************************textViewdelegate end*****************************

//*****************************给服务器上传申请理由************************************
-(void)sendAction{
    NSLog(@"send======%@",self.from_p_id);
    NSLog(@"申请理由========%@",self.examineText);
    if (self.examineText==nil||[self.examineText isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不填写任何申请理由？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        [alert show];
    }
    else{
        [self sendReason];
        [SVProgressHUD show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(show) userInfo:nil repeats:NO];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0&&temp==1) {
        [self sendData];
    }
}
//******************************给服务器上传申请理由 end************************************

-(void)show{
    [SVProgressHUD dismissWithSuccess:@"发送成功！"];
}

-(void)sendReason{
    NSLog(@"self.userUUid==%@",self.userUUid);
    NSLog(@"self.from_p_id==%@",self.from_p_id);
    NSLog(@"self.examineText==%@",self.examineText);
    
    
    NSString* str=@"mac/party/IF00052";
    NSString* strURL=globalURL(str);
    NSURL* url=[NSURL URLWithString:strURL];
    ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
    [rrequest setPostValue:self.userUUid forKey: @"uuid"];
    [rrequest setPostValue:self.from_p_id forKey:@"p_id"];
    [rrequest setPostValue:self.examineText forKey: @"m_msg"];
    
    //[rrequest setDelegate:self];
    [rrequest startAsynchronous];
    [self.navigationController popViewControllerAnimated:YES];
}

//******************************上传派对详细信息************************************
-(void)rightAction{
    NSLog(@"确定");
    
    if (self.examineText==nil||self.phone==nil||[self.examineText isEqualToString:@""]||[self.phone isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"派对创建成功！" message:@"处于“筹备”中的派对会存在3个小时，快去召集你的伙伴加入让派对 顺利成行吧！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)sendData{
    
    for (int i=0; i<[sinaArray count]; i++) {
        sinaTemp=i;
        NSString *suid=[[self.sinaArray objectAtIndex:i] objectForKey:@"id"];
        NSString *nick=[[self.sinaArray objectAtIndex:i] objectForKey:@"name"];
        NSString *pic=[[self.sinaArray objectAtIndex:i] objectForKey:@"avatar_large"];
        NSString *sex=[[self.sinaArray objectAtIndex:i] objectForKey:@"gender"];
        NSString *location=[[self.sinaArray objectAtIndex:i] objectForKey:@"location"];
        NSString *age=@"0";
        NSLog(@"suid==%@,nick==%@,pic=%@,sex=%@,location==%@",suid,nick,pic,sex,location);
        
        NSString* strSina=@"mac/user/IF00106";
        NSString* strURLSina=globalURL(strSina);
        NSURL* urlBangSina=[NSURL URLWithString:strURLSina];
        //NSLog(@"sina资料stringUuid===%@  stringName===%@  sex====%@  stringLocal====%@",stringUuidSina,stringNameSina,sexSina,stringLocalSina);
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:urlBangSina];
        [rrequest setPostValue:userUUid forKey: @"uuid"];
        [rrequest setPostValue:suid forKey: @"suid"];
        [rrequest setPostValue:nick forKey:@"user_nick"];
        [rrequest setPostValue:pic forKey:@"user_pic"];
        [rrequest setPostValue:sex forKey:@"user_sex"];
        [rrequest setPostValue:location forKey:@"user_local"];
        [rrequest setPostValue:age forKey:@"user_age"];
        [rrequest setDelegate:self];
        [rrequest startSynchronous];
    }

    [self sendCreatDate];
}
-(void)sendCreatDate{
    //上传派对相关信息
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       NSString* str=@"mac/party/IF00051";
                       NSString* strURL=globalURL(str);
                       NSURL* url=[NSURL URLWithString:strURL];
                       ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
                       
                       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                       [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                       self.from_time=[formatter stringFromDate:self.time];
                       //*********************判断普通派对*****************************
                       [rrequest setPostValue:userUUid forKey: @"uuid"];
                       if (self.from_Creat_C_id) {
                           [rrequest setPostValue:self.from_Creat_C_id forKey:@"c_id"];
                           NSLog(@"self.from_Creat_C_id=======%@",self.from_Creat_C_id);
                       }
                       [rrequest setPostValue:self.from_Creat_p_type forKey:@"p_type"];
                       [rrequest setPostValue:self.stitle forKey: @"p_title"];
                       [rrequest setPostValue:self.from_time forKey:@"p_stime"];
                       [rrequest setPostValue:self.map_local forKey: @"p_local"];
                       [rrequest setPostValue:self.info forKey: @"p_info"];
                       [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lng] forKey:@"lng"];
                       [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lat] forKey:@"lat"];
                       [rrequest setPostValue:self.map_city forKey: @"p_city"];
                       [rrequest setPostValue:stringFriId forKey: @"users"];
                       //[rrequest setPostValue:sinaFriId forKey:@"xin_users"];
                       [rrequest setPostValue:self.examineText forKey: @"p_invite"];
                       [rrequest setPostValue:self.phone forKey: @"p_phone"];
                       
                       NSLog(@"userUUid=======%@",userUUid);
                       NSLog(@"self.from_Creat_p_type=======%@",self.from_Creat_p_type);
                       NSLog(@"self.stitle=======%@",self.stitle);
                       NSLog(@"self.from_time=======%@",self.from_time);
                       NSLog(@"self.map_local=======%@",self.map_local);
                       NSLog(@"self.info=======%@",self.info);
                       NSLog(@"self.lng=======%@",[NSString stringWithFormat:@"%f",self.lng]);
                       NSLog(@"useself.lat=======%@",[NSString stringWithFormat:@"%f",self.lat]);
                       NSLog(@"self.map_city=======%@",self.map_city);
                       NSLog(@"stringFriId=======%@",stringFriId);
                       NSLog(@"self.examineText=======%@",self.examineText);
                       NSLog(@"self.phone=======%@",self.phone);
                       NSLog(@"stringFriId====%@",stringFriId);
                       //rrequest.delegate=self;
                       [rrequest startSynchronous];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           NSData* response=[rrequest responseData];
                           NSLog(@"%@",response);
                           NSError* error;
                           if (response!=nil) {
                               NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                               NSLog(@"%@",bizDic);
                               NSString *stringPid=[bizDic objectForKey:@"p_id"];
                               PartyDetialLastViewController *partyDetail=[[PartyDetialLastViewController  alloc]init];
                               partyDetail.partyTemp=1;
                               partyDetail.p_id=stringPid;
                               [self.navigationController pushViewController:partyDetail animated:YES];
                               NSString *stringnameShare=@"我的新浪微博";
                               
                               for (int i=0; i<[sinaArray count]; i++) {
                                   sinaTemp=i;
                                   NSString *suid=[[self.sinaArray objectAtIndex:i] objectForKey:@"id"];
                                   NSString *nick=[[self.sinaArray objectAtIndex:i] objectForKey:@"name"];
                                   NSString *pic=[[self.sinaArray objectAtIndex:i] objectForKey:@"avatar_large"];
                                   NSString *sex=[[self.sinaArray objectAtIndex:i] objectForKey:@"gender"];
                                   NSString *location=[[self.sinaArray objectAtIndex:i] objectForKey:@"location"];
                                   
                                   NSString *tempString=[NSString stringWithFormat:@"@%@",nick];
                                   stringnameShare=[stringnameShare stringByAppendingString:tempString];
                                   NSLog(@"suid==%@,nick==%@,pic=%@,sex=%@,location==%@",suid,nick,pic,sex,location);
                                   
                               }
                               NSLog(@"friendid 数组%@",friendId);
                               for (int i=0; i<[self.friendId count]; i++) {
                                   
                                   NSString *tempString=[NSString stringWithFormat:@"@%@",[[self.friendId objectAtIndex:i] objectForKey:@"USER_NICK"]];
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
                           }
                       });
                   });
}

//******************************上传派对详细信息 end************************************

-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    if(sinaTemp==0)
    {
        NSData* response=[request responseData];
        NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"guojiangwei %@",bizDic);
        self.dic=bizDic;
        
        if(self.friendId.count==0) [stringFriId appendFormat:@"%@",[self.dic objectForKey:@"uuid"]];
        else [stringFriId appendFormat:@",%@",[self.dic objectForKey:@"uuid"]];
    }
    if(sinaTemp==1)
    {
        NSData* response=[request responseData];
        NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"guojiangwei %@",bizDic);
        self.dic=bizDic;
        
        [stringFriId appendFormat:@",%@",[self.dic objectForKey:@"uuid"]];
    }
    
    if(sinaTemp==2)
    {
        NSData* response=[request responseData];
        NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"guojiangwei %@",bizDic);
        self.dic=bizDic;
        [stringFriId appendFormat:@",%@",[self.dic objectForKey:@"uuid"]];
    }
    
    if(sinaTemp==3)
    {
        NSData* response=[request responseData];
        NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"guojiangwei %@",bizDic);
        self.dic=bizDic;
        
        [stringFriId appendFormat:@",%@",[self.dic objectForKey:@"uuid"]];
    }
    if (sinaTemp==4) {
        NSData* response=[request responseData];
        NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"guojiangwei %@",bizDic);
    }
    
}
//*****************************给服务器上传数据end************************************

//******************************填写联系信息************************************
-(void)buttonAction{
    NSString *answer = [ModalAlert ask:@"你的联系方式?" withTextPrompt:@"telePhone"];
    if (answer==nil)
        [button setTitle:@"你的联系方式" forState:UIControlStateNormal];
    else{
        [button setTitle:answer forState:UIControlStateNormal];
        self.phone=answer;
    }
}
//******************************填写联系信息 end************************************
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
