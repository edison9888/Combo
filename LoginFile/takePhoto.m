//
//  takePhoto.m
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "takePhoto.h"

@implementation takePhoto
@synthesize imgView,button1,button2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor colorWithRed:226.0/255 green:224.0/255 blue:219.0/255 alpha:1];

    if (self) {
        // Initialization code
        
        
        UIImageView *imagenavView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
        imagenavView.image=[UIImage imageNamed:@"navigation"];
        [self addSubview:imagenavView];
        
        //*****************************标题*************************************
        labelName=[[UILabel alloc]initWithFrame:CGRectMake(118, 0, 100, 44)];
        labelName.text=@"上传照片";
        labelName.textColor=[UIColor whiteColor];
        labelName.font=[UIFont systemFontOfSize:20];
        labelName.backgroundColor=[UIColor clearColor];
        [self addSubview:labelName];
        //*****************************标题 end*************************************
        
        //*****************************照片*************************************
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(51, 75, 217, 217)];
        imgView.image=[UIImage imageNamed:@"resignphoto"];
        imgView.backgroundColor=[UIColor clearColor];
        [self addSubview:imgView];
        
        //*****************************照片 end**********************************
        
        //*****************************返回按钮*************************************
        button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(10, 3, 40, 35);
        button1.backgroundColor=[UIColor clearColor];
        [button1 setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
       
        [self addSubview:button1];
        //*****************************返回按钮 end*************************************
        
        //*****************************确定按钮*************************************
        button2=[UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame=CGRectMake(28, 356, 266.5, 39);
        button2.backgroundColor=[UIColor clearColor];
        [button2 setBackgroundImage:[UIImage imageNamed:@"resignOKey"] forState:UIControlStateNormal];
        [self addSubview:button2];
        //*****************************确定按钮 end*************************************
    }
    return self;
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
