//
//  resign.h
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resign : UIView<UITextFieldDelegate>{
    UITextField *field1;//注册，登陆
    UITextField *field2;//密码
    UIButton *button1; //已有账号转换
    UIImageView *imgeView; //新浪
    
    NSString *mail;
    NSString *pass;
}

@property (nonatomic,strong) NSString *mail;
@property (nonatomic,strong) NSString *pass;

@property (nonatomic,copy) UITextField *field1;//注册，登陆
@property (nonatomic) UITextField *field2;//密码
@property (nonatomic,copy) UIButton *button1; //已有账号转换
@property (nonatomic,copy) UIButton *button2; //新浪

@end
