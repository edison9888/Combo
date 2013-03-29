//
//  CreatBeforeViewController.m
//  party
//
//  Created by mac bookpro on 13-3-12.
//
//

#import "CreatBeforeViewController.h"
#import "CheckOneViewController.h"


@interface CreatBeforeViewController ()

@end

@implementation CreatBeforeViewController
@synthesize type;
@synthesize city;
@synthesize local;
@synthesize lat;
@synthesize lng;
@synthesize c_id;
@synthesize c_title;

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
    addrLabel.text=[NSString stringWithFormat:@"%@ %@",self.city,self.local];
    
    
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
	// Do any additional setup after loading the view.
    
    
    UITextField *field=[[UITextField alloc]initWithFrame:CGRectMake(10, 38, 186, 18)];
    field.background = [UIImage imageNamed:@"creatdidiankuang"];
    field.userInteractionEnabled=NO;
    [self.view addSubview:field];

    //**********************************地点*****************************************
    addrLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 38, 186, 18)];
    addrLabel.textColor=[UIColor colorWithRed:146.0/255 green:146.0/255 blue:146.0/255 alpha:1];
    addrLabel.backgroundColor=[UIColor clearColor];
    addrLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:11.0];
    //addrLabel.font=[UIFont systemFontOfSize:11.0];
    addrLabel.text=@"地点:";
    [self.view addSubview:addrLabel];
    //**********************************地点 end*****************************************

    
    //**********************************账号*****************************************
    UITextField *field1=[[UITextField alloc]initWithFrame:CGRectMake(10, 61, 299, 40)];
    field1.backgroundColor=[UIColor clearColor];
    field1.background = [UIImage imageNamed:@"creatkuangA"];
    field1.userInteractionEnabled=NO;
    [self.view addSubview:field1];
    
    //账号栏
    name =[[UITextField alloc]initWithFrame:CGRectMake(96, 61, 299, 40)];
    name.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.backgroundColor=[UIColor clearColor];
    name.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    [name becomeFirstResponder];
    name.delegate=self;
    NSLog(@"%@",self.c_title);
    if (![self.c_title isEqualToString:@"(null)"]) {
        name.text=self.c_title;
    }
    [name addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:name];
    
    UILabel *labelName=[[UILabel alloc]initWithFrame:CGRectMake(20, 61, 60, 40)];
    labelName.text=@"活动名称";
    labelName.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    labelName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    labelName.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelName];

    //**********************************账号 end*****************************************
    
    //**********************************手机号*****************************************
    UITextField *field3=[[UITextField alloc]initWithFrame:CGRectMake(10, 100, 299, 41)];
    field3.backgroundColor=[UIColor clearColor];
    field3.background = [UIImage imageNamed:@"creatkuangC2"];
    field3.userInteractionEnabled=NO;
    [self.view addSubview:field3];
    //手机号栏
    phone =[[UITextField alloc]initWithFrame:CGRectMake(96, 100, 220, 40)];
    phone.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phone.backgroundColor=[UIColor clearColor];
    phone.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
    [phone becomeFirstResponder];
    phone.delegate=self;
    phone.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:phone];
    
    UILabel *labelTime=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 80, 40)];
    labelTime.text=@"活动时间";
    labelTime.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
    labelTime.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    labelTime.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelTime];

    //**********************************手机号end*****************************************
    
    //*******************************时间选择器*******************************
    if (DatePicker==nil) {
        DatePicker = [[UIDatePicker alloc] init];
        [DatePicker setLocale: [[NSLocale alloc] initWithLocaleIdentifier: @"zh_CN"]];//设置时间选择器语言环境为中文
        
        [DatePicker addTarget:self action:@selector(DatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        DatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        NSDate *mindate=[[NSDate alloc]initWithTimeInterval:1800 sinceDate:[NSDate date]];
        DatePicker.minimumDate = mindate;
        DatePicker.minuteInterval = 10;
    }
    
    // Keyboard toolbar
    if (keyboardToolbar == nil) {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
        
        phone.inputAccessoryView = keyboardToolbar;
        phone.inputView = DatePicker;
        
        //*******************************时间选择器 end*******************************
    }
    
    //*******************************隐藏键盘*******************************
    //点击空白区域隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    //*******************************隐藏键盘 end*******************************
}

#pragma mark -datePicker

- (void)resignKeyboard:(id)sender
{
    time = DatePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
    phone.text  =[formatter stringFromDate:time];
    
    id firstResponder = phone;
    [firstResponder resignFirstResponder];
    
    NSLog(@"name===%@",name.text);
    
    if (name.text==nil||[name.text isEqualToString:@""]) {
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
    }
    else{
        
        NSLog(@"传值。。。。。====%@,%@",phone.text,name.text);
        friendList=[[CheckOneViewController alloc]init];
        friendList.type=self.type;
        friendList.spot=1;
        friendList.check_time=phone.text;
        friendList.check_name=name.text;
        friendList.check_city=self.city;
        friendList.check_local=self.local;
        friendList.lng=self.lng;
        friendList.lat=self.lat;
        friendList.time=time;
        friendList.from_c_id=self.c_id;
        NSLog(@"传值。。。。。====%@",friendList.time);

         NSLog(@"传值。。。。。====%@,%@",friendList.check_name,friendList.check_time);
        
        [self.navigationController pushViewController:friendList animated:YES];
        
        NSLog(@"传值。。。。。====%@",friendList.time);

        
        NSLog(@"传值。。。。。====%@,%@",friendList.check_name,friendList.check_time);

    }
}

//*******************************选择时间*******************************
- (void)DatePickerChanged:(id)sender
{
    time = DatePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
    phone.text  =[formatter stringFromDate:time];
}
//*******************************选择时间 end*******************************

#pragma mark -textField

//*******************************隐藏键盘操作*******************************
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [name resignFirstResponder];
    //[activityPlace resignFirstResponder];
    [phone resignFirstResponder];
    //[creat resignFirstResponder];
}
//*******************************隐藏键盘操作 end*******************************

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([phone isFirstResponder]){
        ;
    }
    else if ([name isFirstResponder]) {
        [phone becomeFirstResponder];
    }
    return YES;
}

- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSLog(@"%@",[_field text]);
}

#pragma mark -others


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
