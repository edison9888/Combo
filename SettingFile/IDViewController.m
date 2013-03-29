//
//  IDViewController.m
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import "IDViewController.h"
#import "passwordViewController.h"
#import "LogInViewController.h"

@interface IDViewController ()

@end

@implementation IDViewController
@synthesize mail,mail_pass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"我的账号";
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
    [self getUUidForthis];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:226.0/255 green:224.0/255 blue:219.0/255 alpha:1];
	// Do any additional setup after loading the view.
    
    UILabel *intro=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 290, 40)];
    intro.text=@"管理我的账号";
    intro.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    intro.textColor=[UIColor colorWithRed:146.0/255 green:146.0/255 blue:146.0/255 alpha:1];
    intro.backgroundColor=[UIColor clearColor];
    [self.view addSubview:intro];
    
    
    //**********************************账号*****************************************
    UITextField *field1=[[UITextField alloc]initWithFrame:CGRectMake(10, 61, 299, 42)];
    field1.background = [UIImage imageNamed:@"creatkuangA"];
    field1.userInteractionEnabled=NO;
    [self.view addSubview:field1];
    
    //账号栏
    name =[[UITextField alloc]initWithFrame:CGRectMake(58, 61, 220, 40)];
    name.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.backgroundColor=[UIColor clearColor];
    name.tag=100;
    name.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    name.userInteractionEnabled=NO;
    name.delegate=self;
    [self.view addSubview:name];
    
    UILabel *labelName=[[UILabel alloc]initWithFrame:CGRectMake(20, 61, 60, 40)];
    labelName.text=@"账号";
    labelName.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    labelName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    labelName.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelName];
    //**********************************账号 end*****************************************
    
    //**********************************密码*****************************************
    
    
    
    passWordButton =[UIButton buttonWithType:UIButtonTypeCustom];
    passWordButton.frame= CGRectMake(10, 100, 299,42);
    [passWordButton setImage:[UIImage imageNamed:@"xiugaimima.png"] forState:UIControlStateNormal];
    [passWordButton setImage:[UIImage imageNamed:@"xiugaimima.png"] forState:UIControlStateSelected];
    
    [passWordButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    passWordButton.backgroundColor=[UIColor clearColor];
    
    button.titleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:passWordButton];
    
    UILabel *passName=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 60, 42)];
    //passName.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"xiugaimima.png"]];
    passName.text=@"密码";
    passName.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    passName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    passName.backgroundColor=[UIColor clearColor];
    [self.view addSubview:passName];
    UITextField *field2=[[UITextField alloc]initWithFrame:CGRectMake(10, 100, 299, 42)];
    //field2.background = [UIImage imageNamed:@"creatkuangC2"];
    field2.userInteractionEnabled=NO;
    [self.view addSubview:field2];
    //密码栏
    password =[[UITextField alloc]initWithFrame:CGRectMake(58, 100, 100, 42)];
    password.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    password.secureTextEntry=YES;
    password.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //password.backgroundColor=[UIColor clearColor];
    [self.view addSubview:password];
    
    
    //**********************************按钮操作*****************************************
    button =[[UIButton alloc]initWithFrame:CGRectMake(20, 280, 281, 37)];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"settingOUT"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    //**********************************按钮操作 end*****************************************

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
    name.text=self.mail;
    password.text=self.mail_pass;
}

-(void) action
{
    passwordViewController *passVC=[[passwordViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:passVC animated:YES];
}

-(void)buttonAction{
    NSLog(@"退出！");
   
    //=========将用户的UUid放入本地=============================================
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:fileName];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:fileName error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }

    LogInViewController *lvController=[[LogInViewController alloc]init];
    //[self presentViewController:lvController animated:YES completion:nil];
    [self.tabBarController.view addSubview:lvController.view];
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popViewControllerAnimated:YES];
    //[lvController release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击done隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
