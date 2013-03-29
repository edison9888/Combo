//
//  MyDetailViewController.m
//  Mydetail
//
//  Created by 李 萌萌 on 13-1-20.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "MyDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "areaPicker.h"
#import "sexPicker.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
#import "ASIFormDataRequest.h"

static int flag=0;//标志位，标志所选择的选择器是哪一个

@interface MyDetailViewController ()

@end

@implementation MyDetailViewController
@synthesize mylocal,mycity;
@synthesize tableview;
@synthesize mylist;
@synthesize mydetailstring;
@synthesize dict;
@synthesize userUUid;
@synthesize Changeinfo,ChangePic;
-(void)viewWillAppear:(BOOL)animated
{
    self.title=@"个人资料";
    
    [self getUUidForthis];
    [super viewWillAppear:animated];
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
    
	// Do any additional setup after loading the view.

    ChangePic=0;
    Changeinfo=0;
    [self getUUidForthis];
    
    datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, mainscreenhight,320, 216)];
    [datepicker setLocale: [[NSLocale alloc] initWithLocaleIdentifier: @"zh_CN"]];//设置时间选择器语言环境为中文
    datepicker.datePickerMode=UIDatePickerModeDate;
    [self.view addSubview:datepicker];
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 40, 35);
    [backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=back;
    
    if (areapic==nil) {
        areapic = [[areaPicker alloc] initWithFrame:CGRectMake(0, mainscreenhight, 320, 216)];
        [self.view addSubview:areapic];
    }
    if (sexpic==nil) {
        sexpic = [[sexPicker alloc] initWithFrame:CGRectMake(0, mainscreenhight, 320, 216)];
        [self.view addSubview:sexpic];
    }
    if (areaboardToolbar == nil) {
        areaboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        areaboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(AreapickerHide)];
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(resignAreaboard:)];
        
        [areaboardToolbar setItems:[NSArray arrayWithObjects:cancelBtn,spaceBarItem,doneBarItem, nil]];
        }
    changePicview=[[UIImageView alloc]init];
    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(223, 8, 41, 41) ];
    picture=nil;
    mylist=[[NSArray alloc]initWithObjects:@"姓名 ",@"性别 ",@"年龄 ",@"地区 ", nil];
   
    NSString* str=[NSString stringWithFormat:@"mac/user/IF00008?uuid=%@",userUUid];
    NSString *stringUrl=globalURL(str);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:226.0/255 green:226.0/255 blue:219.0/255 alpha:1];
    [self.view addSubview:tableview];
   
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
    //请求数据
    NSData* response=[request responseData];
    NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",bizDic);
    self.dict=bizDic;
    [tableview reloadData];    
}

-(void)back
{

    //用户的图像更改了，调用接口11
    if (ChangePic==1) {
        NSLog(@"更新个人数据，包括个人图片,需要上传接口11");
        NSLog(@"%@",namefield.text);
        NSLog(@"%@",sexfield.text);

        if ([sexfield.text isEqualToString:@"女"]) {
            NSLog(@"F");
        }
        if ([sexfield.text isEqualToString:@"男"]) {
            NSLog(@"M");
        }
        NSLog(@"%@",agefield.text);
        NSLog(@"%@",self.mycity);
        NSLog(@"%@",self.mylocal);
        NSLog(@"%@",detail.text);
        
    
        NSString* str=@"servlet/Upload";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];//注册和更新个人资料
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        NSMutableString* sexstr=[[NSMutableString alloc]init];
        if ([sexfield.text isEqualToString:@"女"]) {
            NSLog(@"F");
            [sexstr setString:@""];
            [sexstr appendString:@"F"];
        }
        if ([sexfield.text isEqualToString:@"男"]) {
            NSLog(@"M");
            [sexstr setString:@""];
            [sexstr appendString:@"M"];
        }
        NSLog(@"sexstr::::%@",sexstr);
        NSMutableString* filename=[[NSMutableString alloc]init];
        [filename appendFormat:@"a___%@",userUUid];
        [filename appendFormat:@"b___%@",namefield.text];
        [filename appendFormat:@"c___%@",agefield.text];
        [filename appendFormat:@"d___%@",sexstr];
        [filename appendFormat:@"e___%@",self.mycity];
        [filename appendFormat:@"f___%@",self.mylocal];
        [filename appendFormat:@"g___%@h___.jpg",detail.text];
        NSLog(@"%@",filename);
        UIImage* image=imageview.image;
        NSData *imageData=UIImageJPEGRepresentation(image, 0.1);
        //压缩
        [rrequest  addData:imageData withFileName:filename andContentType:@"image/jpeg" forKey:@"user_pic"];
        [rrequest startSynchronous];
        

    }
    else
    {
        //只是更改了个人资料，图片未更改
        if (Changeinfo==1) {
            //调用接口：未定
            NSLog(@"更新个人数据，不包括个人图片,需要上传接口未定");
            NSString* str=@"mac/user/IF00066";
            NSString* strURL=globalURL(str);
            NSURL* url=[NSURL URLWithString:strURL];
            
            ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
            NSMutableString* sexstr=[[NSMutableString alloc]init];
            if ([sexfield.text isEqualToString:@"女"]) {
                NSLog(@"F");
                [sexstr setString:@""];
                [sexstr appendString:@"F"];
            }
            if ([sexfield.text isEqualToString:@"男"]) {
                NSLog(@"M");
                [sexstr setString:@""];
                [sexstr appendString:@"M"];
            }
            NSLog(@"接口66::::%@ %@ %@ %@ %@",sexstr,namefield.text,agefield.text,self.mycity,self.mylocal);
            [rrequest setPostValue:self.userUUid forKey: @"uuid"];
            
            [rrequest setPostValue:namefield.text forKey:@"user_nick"];
            [rrequest setPostValue:agefield.text forKey:@"user_age"];
            [rrequest setPostValue:sexstr forKey:@"user_sex"];
            [rrequest setPostValue:self.mycity forKey:@"user_city"];
            [rrequest setPostValue:self.mylocal forKey:@"user_local"];
            [rrequest setPostValue:detail.text forKey:@"user_des"];
            [rrequest startSynchronous];
            
        }
        else
        {
             NSLog(@"不需要上传,直接返回");
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }

    if (indexPath.section==0) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"creatkuang2"]];
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        label.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        label.text=@"头像";
        label.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:label];
       
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(282, 20, 10, 15)];//CGRectMake(272, 26, 10, 15)];
        takeimage.image=[UIImage imageNamed:@"settinggo"];
        [cell.contentView addSubview:takeimage];
        
        imageview.layer.cornerRadius=6;
        imageview.layer.masksToBounds = YES;
        if (picture!=nil) {
            imageview.image=picture;
        }
        else
        [imageview setImageWithURL:[NSURL URLWithString:[self.dict objectForKey:@"PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        imageview.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageview addGestureRecognizer:singleTap];
        
        [cell addSubview:imageview];

    }
    if (indexPath.section==1) {
        if (indexPath.row==3) {
            cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang3"]];
        }
        else
        {
            if (indexPath.row==0) {
                cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"creatkuangA"]];
            }
            else
                cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang2"]];
        }
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 8, 60, 25)];
        label.text=[mylist objectAtIndex:indexPath.row];
        
        label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        label.textColor=[UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
        label.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:label];
       
        UITextField* textfield=[[UITextField alloc]initWithFrame:CGRectMake(60, 13, 230, 25)];
        textfield.delegate=self;
        textfield.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        textfield.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        if (indexPath.row==0) {
            namefield=textfield;
            namefield.delegate=self;
            namefield.keyboardType=UIKeyboardTypeAlphabet;
            if ([self.dict objectForKey:@"NICK"]!=nil) {
                namefield.text=[self.dict objectForKey:@"NICK"];
            }
            
        }
        if (indexPath.row==1) {
            sexfield=textfield;
            sexfield.tag=1002;
            if ([[[self.dict objectForKey:@"SEX"]substringToIndex:1] isEqualToString:@"F"]) {
                sexfield.text=@"女";

            }
            else
            {
                
                sexfield.text=@"男";
                
            }
        
            sexfield.inputAccessoryView=areaboardToolbar;
            sexfield.inputView=sexpic;
        }
        if (indexPath.row==2) {
            agefield=textfield;
            agefield.tag=1003;
            if ([self.dict objectForKey:@"AGE"]!=nil) {
                agefield.text=[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"AGE"]];
            }
            else
            {
                agefield.text=@"未填写";
            }
            
            agefield.inputView=datepicker;
            agefield.inputAccessoryView=areaboardToolbar;
        }
        if (indexPath.row==3) {
            localfield=textfield;
            localfield.tag=1001;
            NSMutableString* localstr=[[NSMutableString alloc]init];
            if ([[self.dict objectForKey:@"USER_CITY"]isEqualToString:@"(null)"]) {
                localfield.text=@"未填写";
            }
            else
            {
                if ([self.dict objectForKey:@"USER_CITY"]!=nil) {
                    self.mycity=[self.dict objectForKey:@"USER_CITY"];
                    [localstr appendString:self.mycity];
                    [localstr appendString:@"  "];
                    
                }
                if ([self.dict objectForKey:@"USER_LOCAL"]!=nil) {
                    self.mylocal=[self.dict objectForKey:@"USER_LOCAL"];
                    [localstr appendString:self.mylocal];
                }
                localfield.text=localstr;
            }
            NSLog(@"++++%@+++++++%@++++",self.mycity,self.mylocal);
            localfield.inputView = areapic;
            localfield.inputAccessoryView=areaboardToolbar;
        }
        [cell.contentView addSubview:textfield];
        }
    if (indexPath.section==2) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingkuang"]];
        
        detail=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, 280, 130)];
        detail.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        detail.tag=1;
        if ([dict objectForKey:@"DES"]) {
            detail.text=[dict objectForKey:@"DES"];
        }
        else
        {
            detail.text=@"填写个人信息";
        }
        detail.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        detail.delegate=self;
        detail.keyboardType=UIKeyboardTypeDefault;
        detail.returnKeyType=UIReturnKeyDefault;
        //detail.userInteractionEnabled=NO;
        //detail.multipleTouchEnabled=NO;
        [cell.contentView addSubview:detail];
    }

    cell.selectionStyle=UITableViewCellEditingStyleNone;

        return cell;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    Changeinfo=1;
    [self animateTextView:textView up: YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:textView up:NO];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    Changeinfo=1;
    flag=textField.tag-1000;
    NSLog(@"%d",textField.tag);
    [self animateTextField: textField up: YES];
    
}

- (void)AreapickerHide
{
    [agefield endEditing:YES];
    [sexfield endEditing:YES];
    [localfield endEditing:YES];
}

-(void)resignAreaboard:(id)sender {
    Changeinfo=1;
    if (flag==1) {
        localfield.text=[NSString stringWithFormat:@"%@ %@",areapic.state,areapic.city];
        self.mycity=areapic.state;
        self.mylocal=areapic.city;
        [localfield endEditing:YES];
    }
    if (flag==2) {
        sexfield.text=sexpic.sex;
        [sexfield endEditing:YES];
    }
    if (flag==3) {
        NSDate *myDate = [NSDate date];//获取系统时间
        NSLog(@"myDate = %@",myDate);
        NSDate* date2=datepicker.date;//时间选择器的时间
        
        //计算两个事件之间的时间差，可以用来计算年龄
        NSCalendar *userCalendar = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit;
        NSDateComponents *components = [userCalendar components:unitFlags fromDate:date2 toDate:myDate options:0];
        int years = [components year];
        NSLog(@"%d",years);

        agefield.text=[NSString stringWithFormat:@"%d",years];
        [agefield endEditing:YES];
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.navigationController.navigationBarHidden=YES;
    changePicview.userInteractionEnabled=YES;
    changePicview.backgroundColor=[UIColor blackColor];
    changePicview.frame=mainscreen;
    UIImageView* picima=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 320, 320)];//不需要适配
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UIActionSheet* myaction=[[UIActionSheet alloc]initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"本地照片" otherButtonTitles:@"拍照", nil];
        [myaction showInView:self.view];
      
        //[self choosePhoto];
    }
    if (indexPath.section==1) {
        if (indexPath.row==3) {
            NSLog(@"33333");
        }
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self choosePhoto];
        
    }
    if (buttonIndex==1) {
        [self takePhoto];
    }
}


//编辑完之后键盘返回
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%d",textField.tag);
     [textField resignFirstResponder];
     return YES;
}

//调用照相功能
-(void)takePhoto
{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"调用照相功能");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }

}


//从本地选择图片
- (void)choosePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
   

}




#pragma mark delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo
{
    picture=aImage;
    imageview.image = picture;
    ChangePic=1;
    [picker dismissModalViewControllerAnimated:YES];
    
}


#pragma mark tableview-delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 59;
    }
    else
        if (indexPath.section==2) {
            return 150;
        }
        else
            return 42;
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 44;
    }
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 120;
    }
    return 5.0f;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    const float movementDuration = 0.3f; // tweak as needed
    int movement=0;
    if (up) {
        movement=-100;
    }
    else
    {
        movement=100;
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void) animateTextView: (UITextView*) textView up: (BOOL) up

{
    const float movementDuration = 0.3f; // tweak as needed
    int movement=0;
    if (up) {
        movement=-150;
    }
    else
    {
        movement=150;
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder]; return NO;
    }
    return YES; 
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if (number > 150) {
        textView.text = [textView.text substringToIndex:150];
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView* headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        headView.backgroundColor=[UIColor clearColor];
        UILabel* promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 44)];
        promptLabel.backgroundColor=[UIColor clearColor];
        promptLabel.text=@"完善或修改你的个人资料";
        promptLabel.textColor=[UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        promptLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        [headView addSubview:promptLabel];
        return headView;
    }
    return nil;
}

@end
