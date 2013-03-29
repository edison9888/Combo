//
//  passwordViewController.m
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import "passwordViewController.h"
#import "ASIFormDataRequest.h"

@interface passwordViewController ()

@end

@implementation passwordViewController
@synthesize userUUid;
@synthesize mail,mail_pass;
@synthesize mynewPass,mynewPassDone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"修改密码";
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:226.0/255 green:224.0/255 blue:219.0/255 alpha:1];
    //旧密码：
    UITextField *field1=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, 299, 42)];
    field1.text=@"  旧密码";
    field1.background = [UIImage imageNamed:@"creatkuangA"];
    field1.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    field1.userInteractionEnabled=NO;
    field1.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:field1];
    
    //    name.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    //    name.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    
    oldPass =[[UITextField alloc]initWithFrame:CGRectMake(96, 40, 299, 42)];
    oldPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //oldPass.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    oldPass.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    oldPass.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    oldPass.delegate=self;
    oldPass.tag=101;
    oldPass.backgroundColor=[UIColor clearColor];
    [self.view addSubview:oldPass];
    
//    //新密码栏
    UITextField *field2=[[UITextField alloc]initWithFrame:CGRectMake(10, 81, 299, 42)];
    field2.text=@"  新密码";
    field2.background = [UIImage imageNamed:@"settingkuang2"];
    field2.userInteractionEnabled=NO;
    field2.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    field2.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:field2];
    
    newPass =[[UITextField alloc]initWithFrame:CGRectMake(96, 81, 299, 42)];
    newPass.backgroundColor=[UIColor clearColor];
    newPass.tag=102;
    newPass.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    newPass.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    newPass.delegate=self;
    newPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:newPass];
    
    //密码确认
    UITextField *field3=[[UITextField alloc]initWithFrame:CGRectMake(10, 122, 299, 42)];
    field3.text=@"  密码确认";
    field3.background = [UIImage imageNamed:@"settingkuang3"];
    field3.userInteractionEnabled=NO;
    field3.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    field3.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:field3];
    
    
    passAgan=[[UITextField alloc]initWithFrame:CGRectMake(96, 122, 299, 42)];
    passAgan.delegate=self;
    passAgan.backgroundColor=[UIColor clearColor];
    passAgan.tag=103;
    passAgan.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    passAgan.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    passAgan.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:passAgan];
    
    
    
    //**********************************按钮操作*****************************************
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= CGRectMake(20, 280, 281, 37);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"settingDONE"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    //**********************************按钮操作 end*****************************************
    
    [self getUUidForthis];
    [self getUUidfromthis];
}

-(void)getUUidForthis
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"Guo.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *getmail=[stringmutable objectAtIndex:0];
    NSString *getmail_pass=[stringmutable objectAtIndex:1];
    self.mail=getmail;
    self.mail_pass=getmail_pass;
}

-(void)getUUidfromthis
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag==102) {
        //[textField endEditing:YES];
        self.mynewPass=textField.text;
    }
    if (textField.tag==103) {
        //[textField endEditing:YES];
        self.mynewPassDone=textField.text;
    }
}

-(void)buttonAction{
   
    NSLog(@"newPass=========%@",mynewPass);
    NSLog(@"passAgan=========%@",mynewPassDone);
    
    if ([oldPass.text isEqualToString:self.mail_pass]) {
        if(self.mynewPass.length!=0&&self.mynewPassDone.length!=0){
            if ([self.mynewPassDone isEqualToString:self.mynewPass]) {
                NSString* str=@"mac/user/IF00038";
                NSString* strURL=globalURL(str);
                NSURL* url=[NSURL URLWithString:strURL];
                ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
                    //[request setPostValue:[self.senderDic objectForKey:@"SENDER_ID"] forKey: @"user_id"];
                    NSLog(@"38接口用户uuid=======%@",self.userUUid);
                    NSLog(@"38接口用户新密码=======%@",self.mynewPass);
                    
                    [request setPostValue:self.userUUid forKey:@"uuid"];
                    [request setPostValue:self.mynewPass forKey:@"user_mail_pass"];
                    [request startSynchronous];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    //更换本地数据
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
                    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
                    NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObjects:self.mail, self.mynewPass,nil];
                    NSLog(@"sadafdasfas%@",uuidMutablearray);
                    [uuidMutablearray writeToFile:fileName atomically:YES];
                    [self.view removeFromSuperview];
            }else{
                UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不对应" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [soundAlert show];
            }
        }
        else{
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
        }
    }
    else{
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"旧密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
