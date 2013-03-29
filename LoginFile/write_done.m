//
//  write_done.m
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "write_done.h"

@implementation write_done
@synthesize field1,field2,button1,button2,button3,button4;
@synthesize imgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor=[UIColor colorWithRed:226.0/255 green:224.0/255 blue:219.0/255 alpha:1];
    if ([self superview]!=nil) {
        [[self superview] removeFromSuperview];
    }
    if (self) {
        
        UIImageView *imagenavView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
        imagenavView.image=[UIImage imageNamed:@"navigation"];
        [self addSubview:imagenavView];
        
        // Initialization code
        //*****************************标题*************************************
        labelName=[[UILabel alloc]initWithFrame:CGRectMake(118, 0, 100, 44)];
        labelName.text=@"填写资料";
        labelName.textColor=[UIColor whiteColor];
        labelName.font=[UIFont systemFontOfSize:20];
        labelName.backgroundColor=[UIColor clearColor];
        [self addSubview:labelName];
        //*****************************标题 end*************************************
        
        //*****************************用户头像*************************************
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(115, 53, 86, 86)];
        imgView.image=[UIImage imageNamed:@"resignphotogarph"];
        [self addSubview:imgView];
        
        //*****************************用户头像end*************************************
        
        
        
        //*****************************用户名*************************************
        field1=[[UITextField alloc]initWithFrame:CGRectMake(48, 150, 246, 39)];
        field1.placeholder=@"用户名";
        field1.font=[UIFont systemFontOfSize:14];
        field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field1.backgroundColor=[UIColor clearColor];
        //self.field1.background = [UIImage imageNamed:@"resignkuang"];
        [field1 becomeFirstResponder];
        field1.delegate = self;
        
        UITextField *mailFiled1=[[UITextField alloc]initWithFrame:CGRectMake(28, 150, 266, 39)];
        mailFiled1.backgroundColor=[UIColor clearColor];
        mailFiled1.userInteractionEnabled=NO;
        mailFiled1.background = [UIImage imageNamed:@"resignkuang"];//resignkuang
        [self addSubview:mailFiled1];
        [self addSubview:field1];
        //*****************************用户名 end*************************************
        
        //*****************************年龄*************************************
        field2=[[UITextField alloc]initWithFrame:CGRectMake(48, 200, 246, 39)];
        field2.placeholder=@"年龄";
        //self.field2.userInteractionEnabled=NO;
        field2.font=[UIFont systemFontOfSize:14];
        field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field2.backgroundColor=[UIColor clearColor];
        //self.field2.background = [UIImage imageNamed:@"resignkuang"];
        field2.delegate = self;
        field2.returnKeyType = UIReturnKeyGo;
        
        UITextField *mailFiled2=[[UITextField alloc]initWithFrame:CGRectMake(28, 200, 266, 39)];
        mailFiled2.backgroundColor=[UIColor clearColor];
        mailFiled2.userInteractionEnabled=NO;
        mailFiled2.background = [UIImage imageNamed:@"resignkuang"];
        [self addSubview:mailFiled2];        
        [self addSubview:field2];
        //*****************************年龄 end*************************************
        
        //*****************************男按钮*************************************
        button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(28, 250, 59, 39);
        button1.backgroundColor=[UIColor clearColor];
        [button1 setBackgroundImage:[UIImage imageNamed:@"resignmale"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"resignmaleChoies"] forState:UIControlStateSelected];
        button1.tag=102;
        [button1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button1.titleLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:button1];
        //*****************************男按钮 end*************************************
        
        //*****************************女按钮*************************************
        button2=[UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame=CGRectMake(96, 250, 59, 39);
        button2.backgroundColor=[UIColor clearColor];
        [button2 setBackgroundImage:[UIImage imageNamed:@"resignfemale"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"resignfemaleChoies"] forState:UIControlStateSelected];
        button2.tag=103;
        [button2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        //*****************************女按钮 end*************************************
        
        //*****************************确认按钮*************************************
        button3=[UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame=CGRectMake(168, 250, 125, 39);
        button3.backgroundColor=[UIColor clearColor];
        [button3 setBackgroundImage:[UIImage imageNamed:@"resigncheck"] forState:UIControlStateNormal];
        //[button3 setBackgroundImage:[UIImage imageNamed:@"loginyesing.png"] forState:UIControlStateSelected];
        [self addSubview:button3];
        //*****************************确认按钮 end*************************************
        
        //*****************************返回按钮*************************************
        button4=[UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame=CGRectMake(10, 3, 40, 35);
        self.button4.backgroundColor=[UIColor clearColor];
        [self.button4 setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        [self addSubview:button4];
        //*****************************返回按钮 end*************************************
    }
    return self;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 102)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self viewWithTag:103];
        otherButton.selected = NO;
    }
    if (btn.tag == 103)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self viewWithTag:102];
        otherButton.selected = NO;
    }
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
